#!/bin/bash

resolve_github_repository() {
    if [[ -n "$GITHUB_REPOSITORY" ]]; then
        echo "$GITHUB_REPOSITORY"
        return 0
    fi

    local remote_url
    remote_url="$(git config --get remote.origin.url 2>/dev/null || true)"
    if [[ -z "$remote_url" ]]; then
        return 1
    fi

    # Support both https://github.com/owner/repo(.git) and git@github.com:owner/repo(.git)
    local repo
    repo="$(echo "$remote_url" | sed -E 's#^.*github\.com[:/]([^/]+/[^/.]+)(\.git)?$#\1#')"
    if [[ "$repo" == "$remote_url" || -z "$repo" ]]; then
        return 1
    fi

    echo "$repo"
}

deregister_repo_runners_for_cluster() {
    local cluster_name="$1"
    local github_token="${ARC_TOKEN:-${GITHUB_TOKEN:-}}"

    if [[ -z "$cluster_name" ]]; then
        echo "Usage: $0 <cluster-name>"
        return 1
    fi

    if [[ -z "$github_token" ]]; then
        echo "Skipping GitHub runner de-registration for '$cluster_name': ARC_TOKEN (or GITHUB_TOKEN) is not set."
        return 0
    fi

    local repository
    repository="$(resolve_github_repository || true)"
    if [[ -z "$repository" ]]; then
        echo "Skipping GitHub runner de-registration for '$cluster_name': unable to resolve repository."
        return 0
    fi

    echo "Looking up GitHub self-hosted runners for '$repository' (cluster label '$cluster_name')..."

    local page=1
    local runner_ids=()

    while true; do
        local response
        response="$(curl -fsS \
            -H "Accept: application/vnd.github+json" \
            -H "Authorization: Bearer $github_token" \
            -H "X-GitHub-Api-Version: 2022-11-28" \
            "https://api.github.com/repos/$repository/actions/runners?per_page=100&page=$page")" || {
                echo "Warning: failed to query runners from GitHub API; skipping de-registration."
                return 0
            }

        local total_on_page
        total_on_page="$(echo "$response" | jq '.runners | length')"
        if [[ "$total_on_page" -eq 0 ]]; then
            break
        fi

        while IFS= read -r id; do
            [[ -n "$id" ]] && runner_ids+=("$id")
        done < <(
            echo "$response" | jq -r --arg cluster "$cluster_name" '
                .runners[]?
                | select((.labels | map(.name) | index("self-hosted")) != null)
                | select((.labels | map(.name) | index("arc")) != null)
                | select((.labels | map(.name) | index($cluster)) != null)
                | .id
            '
        )

        page=$((page + 1))
    done

    if [[ "${#runner_ids[@]}" -eq 0 ]]; then
        echo "No matching GitHub runners found for cluster '$cluster_name'."
        return 0
    fi

    echo "De-registering ${#runner_ids[@]} GitHub runner(s) for cluster '$cluster_name'..."
    local runner_id
    for runner_id in "${runner_ids[@]}"; do
        local status
        status="$(curl -sS -o /dev/null -w "%{http_code}" \
            -X DELETE \
            -H "Accept: application/vnd.github+json" \
            -H "Authorization: Bearer $github_token" \
            -H "X-GitHub-Api-Version: 2022-11-28" \
            "https://api.github.com/repos/$repository/actions/runners/$runner_id")"

        if [[ "$status" == "204" || "$status" == "404" ]]; then
            echo "Runner $runner_id de-registered."
        else
            echo "Warning: failed to de-register runner $runner_id (HTTP $status)."
        fi
    done
}

deregister_repo_runners_for_cluster "$1"
