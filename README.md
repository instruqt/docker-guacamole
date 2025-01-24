# Guacamole

A self-contained guacamole docker container:

* Based on [jwetzell/guacamole](https://github.com/jwetzell/docker-guacamole)
* Added [guacamole-legacy-urls](https://github.com/mike-jumper/guacamole-legacy-urls) for easier deeplinking to specific connection

## Usage

### Add `gcr.io/instruqt/guacamole` container to `config.yml`

```yaml
version: "2"
containers:
- name: guac
  image: gcr.io/instruqt/guacamole
  shell: /bin/bash
  ports:
  - 8080
  memory: 512
virtualmachines:
- name: srv01
  image: instruqt/windows-server
  machine_type: n1-standard-2
```

### Inject Guacamole connection config

Write [connection configuration](https://guacamole.apache.org/doc/gug/configuring-guacamole.html#user-mapping) to `/config/guacamole/user-mapping.xml` (Guacamole will automatically reload file on changes, no restart required).

Example challenge setup script, `setup-guac`:

```bash
#!/bin/bash

cat <<'EOF' > /config/guacamole/user-mapping.xml
<user-mapping>
    <authorize
        username="guac_user"
        password="guac_password">
        <connection name="srv01">
            <protocol>rdp</protocol>
            <!-- hostname as defined in instruqt config.yml -->
            <param name="hostname">srv01</param>
            <param name="port">3389</param>
            <!-- domain/username/password must be valid for the target host -->
            <param name="domain">instruqt.local</param>
            <param name="username">windows_user</param>
            <param name="password">windows_password</param>
            <param name="ignore-cert">true</param>
        </connection>
    </authorize>
</user-mapping>
EOF
```

### Add tab configuration

Add one or more tabs to the guacamole service:

```yaml
slug: guac-example
title: Guacamole Example
...
challenges:
- slug: rdp-tab
  ...
  tabs:
  - title: RDP SRV01
    type: service
    hostname: guac
    path: /#/client/c/srv01?username=guac_user&password=guac_password
    port: 8080
```

Note: in the `path` parameter of the tab, make sure to use the same connection name (`srv01`), username (`guac_user`) and password (`guac_password`) as you've defined in the `user-mapping.xml` file.
