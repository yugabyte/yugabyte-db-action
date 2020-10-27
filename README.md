# YugabyteDB GitHub Action

![Test yugabyte-db-action](https://github.com/yugabyte/yugabyte-db-action/workflows/Test%20yugabyte-db-action/badge.svg)

Github action to setup a YugabyteDB database

## Inputs

### `yb_image_tag`

* Docker yugabytedb image tag. For available image tags please follow
[https://hub.docker.com/r/yugabytedb/yugabyte](https://hub.docker.com/r/yugabytedb/yugabyte)
* Default value:  `latest`
* Optional

### `yb_master_ui_port`

* YB Master UI
* Default value: `7000`
* Optional

### `yb_tserver_ui_port`

* YB Tserver UI
* Default value: `9000`
* Optional

### `ysql_port`

* YSQL API Port
* Default value: `5433`
* Optional

### `ycql_port`

* YCQL API Port
* Default value: `9042`
* Optional

## Authentication related inputs

### `ysql_user`

* YSQL User
* Optional

### `ysql_password`

* YSQL Password, Setting this will enable the authentication mode.
* Optional

### `ysql_db`

* YSQL DB
* Optional

### `ycql_user`

* YCQL User, Setting this will enable the authentication mode.
* Optional

### `ycql_password`

* YCQL Password, Setting this will enable the authentication mode.
* Optional

### `ycql_keyspace`

* YCQL Keyspace
* Optional

**Note:**
For more information about different combinations and their effects of authentication related inputs,
please take a look at https://docs.yugabyte.com/latest/reference/configuration/yugabyted/#environment-variables

## Example usage

1. Default

```yaml
- name: Setup YugabyteDB cluster
  uses: yugabyte/yugabyte-db-action@master
```

2. Customized

```yaml
- name: Setup YugabyteDB cluster
  uses: yugabyte/yugabyte-db-action@master
  with:
    yb_image_tag: 2.2.0.0-b80
    yb_master_ui_port: 7000
    yb_tserver_ui_port: 9000
    ysql_port: 5433
    ycql_port: 9042
```

3. Custom Credentials

```yaml
- name: Setup YugabyteDB cluster
  uses: yugabyte/yugabyte-db-action@master
  with:
    yb_image_tag: 2.3.2.0-b37
    ysql_user: testsqluser
    ysql_password: testsqlpass
    ysql_db: testdb
    ycql_user: testcqluser
    ycql_password: testcqlpass
    ycql_keyspace: testks
```
