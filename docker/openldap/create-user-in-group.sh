#!/bin/bash
export FIRSTNAME=$1
export LASTNAME=$2
export USERNAME=$(echo "$FIRSTNAME.$LASTNAME" | tr '[:upper:]' '[:lower:]')

echo "member: cn=$USERNAME,ou=users,dc=global-sales,dc=flowable,dc=com"
