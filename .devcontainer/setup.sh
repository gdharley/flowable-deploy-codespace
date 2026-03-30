#!/bin/bash

git remote add origin "https://github.com/${GITHUB_REPOSITORY}.git"
git fetch
git checkout dev

git submodule sync --recursive && git submodule update --init --recursive

chmod +x scripts/*

