FROM osixia/openldap:1.5.0

## copy all .sh files
COPY *.sh /tmp/ 
COPY users.txt /tmp/
RUN cd /tmp && /bin/bash create-all-users.sh >> /container/service/slapd/assets/config/bootstrap/ldif/users.ldif
