#!/bin/bash
echo "Customize hostname to $CUSTOM_REALM_KEYCLOAK_HOSTNAME"
cat /tmp/oauth2-stack-realm-original.json \
    | sed "s/http:\/\/localhost:9095/$(echo $CUSTOM_REALM_KEYCLOAK_HOSTNAME | sed "s/\//\\\\\//g")/" \
    | sed "s/ldap:\/\/openldap:389/$(echo $CUSTOM_REALM_LDAP_URI | sed "s/\//\\\\\//g")/" \
    > /tmp/oauth2-stack-realm.json
/opt/keycloak/bin/kc.sh "start"