```
#
# Copyright 2025, Flowable Licences AG.
# This license is based on the software license agreement and terms and conditions in effect between the parties
# at the time of purchase of the Flowable software product.
# Your agreement to these terms and conditions is required to install or use the Flowable software product and/or this file.
# Flowable is a trademark of Flowable AG registered in several countries.
#

# General server settings
server.port=8090
server.servlet.context-path=/flowable-engage

spring.application.name=flowable_engage

# Expose all actuators by default
management.endpoints.web.exposure.include=*
management.endpoint.health.show-details=when_authorized

# Logging
# If this property is set it will create strange SYSLOG folders in the folder structure with app log.gz files
#logging.file=flowable-work.log
#logging.level.org.flowable=DEBUG
#logging.level.com.flowable=DEBUG

#logging.level.org.springframework.boot.web.servlet.filter=INFO
#logging.level.org.springframework.boot.actuate.endpoint.web=INFO
#logging.level.com.flowable.autoconfigure.rest.FlowableRequestLoggingFilter=DEBUG

# Datasource
spring.datasource.url=jdbc:h2:~/flowable-db/db;AUTO_SERVER=TRUE;AUTO_SERVER_PORT=9091;DB_CLOSE_DELAY=-1
spring.datasource.username=flowable
spring.datasource.password=flowable

# Example datasource config for postgres
#spring.datasource.url=jdbc:postgresql://localhost:5432/flowable-engage
#spring.datasource.username=flowable
#spring.datasource.password=flowable

# Example datasource config for oracle
#spring.datasource.url=jdbc:oracle:thin:@localhost:1521:XE
#spring.datasource.username=flowable
#spring.datasource.password=flowable
#flowable.database-schema=flowable

# Uncomment these for a clean setup (use it together with a clean database)
#flowable.example.deploy-apps=false
#flowable.platform.idm.minimal-setup=true

flowable.message.process-deliverer.enabled=false
# Uncomment to configure a process to be triggered if a user cannot receive a message
# flowable.message.process-deliverer.process-definition-key=FLW_SYSTEM_P001_User_email_notification

# External messaging system configuration
flowable.engage.external.onboarding.processes.wechat=P004-clientOnboarding
flowable.engage.external.onboarding.processes.whatsapp=P004-clientOnboarding

flowable.external-system.line.enabled-message-types.audio=true
flowable.external-system.line.enabled-message-types.image=true
flowable.external-system.line.enabled-message-types.text=true
flowable.external-system.line.enabled-message-types.video=true
flowable.external-system.wechat.timeout.enabled=false
flowable.external-system.wechat.enabled-message-types.text=true
flowable.external-system.wechat.enabled-message-types.image=true
flowable.external-system.wechat.enabled-message-types.video=true
flowable.external-system.wechat.enabled-message-types.voice=false
flowable.external-system.whatsapp.timeout.enabled=false
flowable.external-system.whatsapp.enabled-message-types.audio=true
flowable.external-system.whatsapp.enabled-message-types.document=true
flowable.external-system.whatsapp.enabled-message-types.image=true
flowable.external-system.whatsapp.enabled-message-types.text=true
flowable.external-system.whatsapp.enabled-message-types.video=true
flowable.external-system.whatsapp.enabled-message-types.voice=true

flowable.external.on-boarding.default-on-boarding-case-key=C02_defaultUserAccountLifecycle

spring.artemis.broker-url=tcp://localhost:61616

flowable.frontend.title=Flowable Engage

flowable.http.client-type=apacheHttpClient5

# Configuration for APNs (Apple Push Notification) push notifications
#flowable.apns.enabled=true
#flowable.apns.host-name=api.development.push.apple.com
#flowable.apns.authentication-type=certificate
#flowable.apns.authentication-certificate=<Spring file location>
#flowable.apns.authentication-certificate-password=<password>
#flowable.apns.notification.title-enabled=true
#flowable.apns.notification.title-add-sender=true
#flowable.apns.notification.title-add-conversation=true

# Flowable License
# Uncomment to load license from database (instead of filesystem)
# flowable.license.db-store-enabled=true

# Uncomment to overwrite the default license location
# flowable.license.location=file:${user.home}/.flowable/flowable.license

# WebDav (disable it by default for the Engage Application)
flowable.webdav.enabled=false
# WebDav authentication mode. By default it is basic, set to none for localhost development
#flowable.webdav.authentication-mode=none

# LDAP Configuration properties
#spring.ldap.base=<dc=example,dc=com>
#spring.ldap.urls=<ldap location>
#spring.ldap.username=<username>
#spring.ldap.password=<password>

#flowable.platform.idm.service-type=ldap

# The base is applied on top of the spring.ldap.base
# Group specific LDAP properties
#flowable.ldap.group.query.base=<ou=group>
#flowable.ldap.group.query.default-filter=(objectClass=group)
#flowable.ldap.group.mappings.distinguished-name=distinguishedName
#flowable.ldap.group.mappings.member=member:1.2.840.113556.1.4.1941:
#flowable.ldap.group.mappings.id=sAMAccountName
#flowable.ldap.group.mappings.key=cn
#flowable.ldap.group.mappings.name=name

# User specific LDAP properties
#flowable.ldap.user.query.base=<ou=person>
#flowable.ldap.user.query.default-filter=(objectClass=user)
#flowable.ldap.user.mappings.distinguished-name=distinguishedName
#flowable.ldap.user.mappings.member-of=memberOf:1.2.840.113556.1.4.1941:
#flowable.ldap.user.mappings.id=sAMAccountName
#flowable.ldap.user.mappings.first-name=givenName
#flowable.ldap.user.mappings.last-name=sn
#flowable.ldap.user.mappings.display-name=displayName,name
#flowable.ldap.user.mappings.email=mail

# User definition from LDAP
#flowable.ldap.user.mappings.default-user-definition-key=user-default
#flowable.ldap.user.mappings.user-definition-key=role
#flowable.ldap.user.mappings.value-user-definition-key.admin=user-admin
#flowable.ldap.user.mappings.value-user-definition-key.reporter=user-reporter

# User definition based on User groups from LDAP
#flowable.ldap.user.mappings.default-user-definition-key=user-default
#flowable.ldap.user.mappings.user-definition-key-mapping-type=groups
#flowable.ldap.user.mappings.user-definition-group-mappings[0].group-key=Admin
#flowable.ldap.user.mappings.user-definition-group-mappings[0].user-definition-key=user-admin
#flowable.ldap.user.mappings.user-definition-group-mappings[1].group-key=Reporter
#flowable.ldap.user.mappings.user-definition-group-mappings[1].user-definition-key=user-reporting

# Tenant mappings for user from LDAP
#flowable.ldap.user.mappings.default-tenant-id=Switzerland
#flowable.ldap.user.mappings.tenant-id=location
#flowable.ldap.user.mappings.value-tenant-id.BRN=Switzerland
#flowable.ldap.user.mappings.value-tenant-id.ZRH=Switzerland
#flowable.ldap.user.mappings.value-tenant-id.VLC=Spain
#flowable.ldap.user.mappings.value-tenant-id.MAD=Spain

# Tenant mappings for group from LDAP
#flowable.ldap.group.mappings.default-tenant-id=Switzerland
#flowable.ldap.group.mappings.tenant-id=loc
#flowable.ldap.group.mappings.value-tenant-id.BERN=Switzerland
#flowable.ldap.group.mappings.value-tenant-id.ZURICH=Switzerland
#flowable.ldap.group.mappings.value-tenant-id.VALENCIA=Spain
#flowable.ldap.group.mappings.value-tenant-id.MADRID=Spain

# IDM Microsoft Graph Configuration properties
#flowable.platform.idm.service-type=microsoft-graph
#flowable.idm.microsoft-graph.client.registration-id=ms-graph
#spring.security.oauth2.client.registration.ms-graph.client-id=<clientId>
#spring.security.oauth2.client.registration.ms-graph.client-secret=<clientSecret>
#spring.security.oauth2.client.registration.ms-graph.scope=https://graph.microsoft.com/.default
#spring.security.oauth2.client.registration.ms-graph.authorization-grant-type=client_credentials
#spring.security.oauth2.client.provider.ms-graph.issuer-uri=https://login.microsoftonline.com/<tenantId>/v2.0


# Group specific Microsoft Graph properties
#flowable.idm.microsoft-graph.group.query.default-filter=(displayName in ['Group 1', 'Group 2'])
#flowable.idm.microsoft-graph.group.mappings.distinguished-name=distinguishedName

# User-specific Microsoft Graph properties
#flowable.idm.microsoft-graph.user.query.base-group=<baseGroupId>
#flowable.idm.microsoft-graph.user.query.default-filter=(type eq 'Test')
#flowable.idm.microsoft-graph.user.mappings.id=id
#flowable.idm.microsoft-graph.user.mappings.first-name=givenName
#flowable.idm.microsoft-graph.user.mappings.last-name=surname
#flowable.idm.microsoft-graph.user.mappings.display-name=displayName
#flowable.idm.microsoft-graph.user.mappings.email=mail
#flowable.idm.microsoft-graph.user.mappings.language=preferredLanguage

# User definition from Microsoft Graph
#flowable.idm.microsoft-graph.user.mappings.default-user-definition-key=user-default
#flowable.idm.microsoft-graph.user.mappings.user-definition-key=role
#flowable.idm.microsoft-graph.user.mappings.value-user-definition-key.admin=user-admin
#flowable.idm.microsoft-graph.user.mappings.value-user-definition-key.reporter=user-reporter

# User definition based on User groups from Microsoft Graph
#flowable.idm.microsoft-graph.user.mappings.default-user-definition-key=user-default
#flowable.idm.microsoft-graph.user.mappings.user-definition-key-mapping-type=groups
#flowable.idm.microsoft-graph.user.mappings.user-definition-group-mappings[0].group-key=Admin
#flowable.idm.microsoft-graph.user.mappings.user-definition-group-mappings[0].user-definition-key=user-admin
#flowable.idm.microsoft-graph.user.mappings.user-definition-group-mappings[1].group-key=Reporter
#flowable.idm.microsoft-graph.user.mappings.user-definition-group-mappings[1].user-definition-key=user-reporting

# OAuth 2 Client Security properties
## Azure Active Directory
#spring.security.oauth2.client.registration.azure.client-id=<The client id of your application>
#spring.security.oauth2.client.registration.azure.client-secret=<The client secret of your application>
#spring.security.oauth2.client.registration.azure.client-name=Azure SSO
#spring.security.oauth2.client.registration.azure.authorization-grant-type=authorization_code
#spring.security.oauth2.client.registration.azure.scope=openid,profile
#spring.security.oauth2.client.provider.azure.issuer-uri=https://login.microsoftonline.com/<tenantId>/v2.0
#spring.security.oauth2.client.provider.azure.user-name-attribute=email

## Keycloak
#spring.security.oauth2.client.registration.keycloak.client-id=<The client id of your application>
#spring.security.oauth2.client.registration.keycloak.client-secret=<The client secret of your application>
#spring.security.oauth2.client.registration.keycloak.client-name=Keycloak
#spring.security.oauth2.client.registration.keycloak.authorization-grant-type=authorization_code
#spring.security.oauth2.client.registration.keycloak.scope=openid,profile
#spring.security.oauth2.client.provider.keycloak.issuer-uri=<keycloakLocation>/auth/realms/<realmName>
#spring.security.oauth2.client.provider.keycloak.user-name-attribute=preferred_username

## Configure the OAuth2 Client mapper
#flowable.security.oauth2.client.mapper.authorities-attributes=<The token attribute / claim in which the user authorities are located>
#flowable.security.oauth2.client.mapper.groups-attributes=<The token attribute / claim in which the user groups are located>
#flowable.security.oauth2.client.mapper.tenant-attribute=<The token attribute / claim in which the user tenant is located>
#flowable.security.oauth2.client.mapper.user-definition-key-attribute=<The token attribute / claim in which the user definition key is located>

# OAuth 2 Resource Server Security properties
## Azure Active Directory
#spring.security.oauth2.resourceserver.jwt.issuer-uri=https://login.microsoftonline.com/<tenantId>/v2.0

## Keycloak
#spring.security.oauth2.resourceserver.jwt.issuer-uri=<keycloakLocation>/auth/realms/<realmName>

## Configure the OAuth2 resource server mapper and jwt
#flowable.security.oauth2.resourceserver.jwt.principal-claim-name=preferred_username
#flowable.security.oauth2.resourceserver.mapper.authorities-attributes=roles
#flowable.security.oauth2.resourceserver.mapper.groups-attributes=groups
#flowable.security.oauth2.resourceserver.mapper.tenant-attribute=
#flowable.security.oauth2.resourceserver.mapper.user-definition-key-attribute=

# The base URL if communication between Work and Design is needed.
# If this is enabled then the token encryption property should be appropriately configuration
#flowable.platform.design.base-url=http://localhost:8888/flowable-design/design-api
# The user design access tokens are stored encrypted in the database using AES/CBC/PKCS5PADDING
# It needs a 128-bit initialization vector (https://en.wikipedia.org/wiki/Initialization_vector)
# and a 128-bit secret key represented as 16 ascii characters below
#
# Do note that if these properties are changed after tokens have been saved, all existing tokens
# will not be able to be decrypted and the token would need to be reset in the UI.
#flowable.platform.design.token-encryption.secret=
#flowable.platform.design.token-encryption.initialization-vector=

#flowable.platform.protected-variable-encryption.initialization-vector=testVectorSecret
#flowable.platform.protected-variable-encryption.secret=testSecretSecret

# Enable and configure RabbitMQ
#application.rabbit-enabled=true
#spring.rabbitmq.addresses=localhost:5672
#spring.rabbitmq.username=guest
#spring.rabbitmq.password=guest

# Enable and configure Kafka
#application.kafka-enabled=true
#spring.kafka.bootstrap-servers=localhost:9092

# Enable and configure AWS SQS
#application.aws-sqs-enabled=true
# Enable and configure AWS SNS
#application.aws-sns-enabled=true
# The endpoint override property can be set when using Localstack, when using the real AWS services it shouldn't be modified
#flowable.aws.endpoint-override=http://localhost:4566
#flowable.aws.region=us-east-1

#Bulk insert config
#flowable.bulkInsertEnabled=false
#flowable.process.bulkInsertEnabled=false
#flowable.cmmn.bulkInsertEnabled=false

# Definition cache limits, these are defaults and can be overridden, but the default values should be fine for most use cases
# apps and pages definitions
flowable.app.definition-cache-limit=50
# case definitions
flowable.cmmn.definition-cache-limit=100
# process definitions
flowable.process.definition-cache-limit=200
# form definitions
flowable.form.definition-cache-limit=1000
# dmn definitions
flowable.dmn.definition-cache-limit=200
# content definitions
flowable.content.definition-cache-limit=500
# event definitions
flowable.eventregistry.definition-cache-limit=200
# user and user account definitions
flowable.platform.idm.definition-cache-limit=100
# action definitions
flowable.action.definition-cache-limit=200
# data object definitions
flowable.dataobject.definition-cache-limit=500
# data dictionary, query, sequence and variable extractor definitions
flowable.platform.definition-cache-limit=500
# policy definitions
flowable.policy.definition-cache-limit=100
# service registry definitions
flowable.service-registry.definition-cache-limit=200
# template and template variation definitions
flowable.template.definition-cache-limit=1000

#Enable Flowable Inspect
flowable.inspect.enabled=false

#Available applications
#flowable.platform.available-application.work.name=Work
#flowable.platform.available-application.work.type=work
#flowable.platform.available-application.work.url=http://localhost:9000
#flowable.platform.available-application.design.name=Design
#flowable.platform.available-application.design.type=design
#flowable.platform.available-application.design.url=http://localhost:9002

#Disable Elastic Search Indexing
#flowable.indexing.enabled=false

#Enable Elastic Search Metrics
management.elastic.metrics.export.enabled=false
#Enable Prometheus Metrics
management.prometheus.metrics.export.enabled=false

management.endpoint.localhost.access=none
flowable.sharepoint.enabled=false
#flowable.sharepoint.api-base-url=https://graph.microsoft.com/v1.0/
#flowable.sharepoint.authentication-mode=client-secret-auth
#flowable.sharepoint.login-url=https://login.microsoftonline.com/<tenantId>/oauth2/v2.0/token
#flowable.sharepoint.client-secret=
#flowable.sharepoint.client-id=

# Enable ABBYY integration
#flowable.abbyy.registration-id=abbyy
#flowable.abbyy.api-base-url= https://vantage-eu.abbyy.com/api/publicapi/v1/
#167 hours is one hour less than the time ABBYY keeps a link valid.
#flowable.abbyy.manual-review-link-expire-period=167h
#flowable.abbyy.poll-job-retries=10
#flowable.abbyy.poll-job-initial-retry-timeout=20s

#spring.security.oauth2.client.registration.abbyy.client-id=
#spring.security.oauth2.client.registration.abbyy.client-secret=
#spring.security.oauth2.client.registration.abbyy.scope=openid,permissions,global.wildcard
#spring.security.oauth2.client.registration.abbyy.authorization-grant-type=client_credentials
#spring.security.oauth2.client.provider.abbyy.token-uri=https://vantage-eu.abbyy.com/auth2/connect/token

# Enable Power Automate integration
#flowable.power-automate.registration-id=power-automate
#flowable.power-automate.api-base-url=https://orgXXXXXXXX.crmX.dynamics.com
#flowable.power-automate.poll-job-retries=10
#flowable.power-automate.poll-job-initial-retry-timeout=20s
#flowable.power-automate.default-connection-name=

#spring.security.oauth2.client.registration.power-automate.client-id=
#spring.security.oauth2.client.registration.power-automate.client-secret=
#spring.security.oauth2.client.registration.power-automate.scope=${flowable.power-automate.api-base-url}/.default
#spring.security.oauth2.client.registration.power-automate.authorization-grant-type=client_credentials
#spring.security.oauth2.client.provider.power-automate.token-uri=https://login.microsoftonline.com/{tenant-id}/oauth2/v2.0/token

#application.ai.type=openai
spring.ai.openai.chat.options.temperature=0.3
spring.ai.openai.chat.options.model=gpt-4o

spring.ai.retry.max-attempts=3
spring.ai.retry.exclude-on-http-codes=429

# Flowable Tutorial
flowable.tutorial.enabled=false
```
