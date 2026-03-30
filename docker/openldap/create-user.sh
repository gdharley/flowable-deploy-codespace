#!/bin/bash
export FIRSTNAME=$1
export LASTNAME=$2
export USERNAME=$(echo "$FIRSTNAME.$LASTNAME" | tr '[:upper:]' '[:lower:]')
export TENANT=$(echo "$FIRSTNAME-$LASTNAME" | tr '[:upper:]' '[:lower:]')

if [[ "$TENANT" = "flowable-administrator" ]]; then
  export TENANT=default
fi

echo "dn: cn=$USERNAME,ou=users,dc=global-sales,dc=flowable,dc=com
objectClass: inetOrgPerson
objectClass: organizationalPerson
cn: $USERNAME
sn: $LASTNAME
givenName: $FIRSTNAME
displayName: $FIRSTNAME $LASTNAME
employeeType: user-admin
mail: $USERNAME@flowable.com
ou: $TENANT
userPassword:: dGVzdAo=
memberOf: cn=flowableAdministrator,ou=groups,dc=global-sales,dc=flowable,dc=com
memberOf: cn=flowableUser,ou=groups,dc=global-sales,dc=flowable,dc=com
"
