#!/bin/bash
echo "version: 1

dn: ou=users,dc=global-sales,dc=flowable,dc=com
objectClass: organizationalUnit
objectClass: top
ou: users

dn: ou=groups,dc=global-sales,dc=flowable,dc=com
objectClass: organizationalUnit
objectClass: top
ou: groups
"

cat users.txt | while read person
do
  ./create-user.sh $person
done

echo "dn: cn=flowableAdministrator,ou=groups,dc=global-sales,dc=flowable,dc=com
objectClass: groupOfNames
objectClass: top
cn: flowableAdministrator"
cat users.txt | while read person
do
  ./create-user-in-group.sh $person
done

echo "
dn: cn=flowableUser,ou=groups,dc=global-sales,dc=flowable,dc=com
objectClass: groupOfNames
objectClass: top
cn: flowableUser"
cat users.txt | while read person
do
  ./create-user-in-group.sh $person
done
