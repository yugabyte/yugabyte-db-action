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

* YB Master UI Port
* Default value: `7000`
* Optional

### `yb_tserver_ui_port`

* YB Tserver UI Port
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

## Outputs

* `container_id` - Docker container ID
* `yb_master_ui_port` - YB Master UI port
* `yb_tserver_ui_port` - YB Tserver UI port
* `ysql_port` - YSQL API Port
* `ycql_port` - YCQL API Port

## Example usage

1. Default with no custom credentials:

```yaml
- name: Setup YugabyteDB cluster
  uses: yugabyte/yugabyte-db-action@master
  id: server

# Sample usage:
- name: Test YSQL API
  run: |
    docker run --network host --rm yugabytedb/yugabyte-client:latest ysqlsh -h localhost -p "${{ steps.server.outputs.ysql_port }}" \
      -c "CREATE TABLE foo(id int primary key); INSERT INTO foo SELECT * FROM generate_series(1,10);"
- name: Test YCQL API
  run: |
    docker run --network host --rm yugabytedb/yugabyte-client:latest ycqlsh localhost "${{ steps.server.outputs.ycql_port }}" \
      --execute 'create keyspace foo; create table foo.bar(id int primary key); insert into foo.bar (id) values (1);'

- name: Test YB Master UI
  run: curl --head "http://localhost:${{ steps.server.outputs.yb_master_ui_port }}"

- name: Test YB Tserver UI
  run: curl --head "http://localhost:${{ steps.server.outputs.yb_tserver_ui_port }}"
```

2. Customized connection settings:

```yaml
- name: Setup YugabyteDB cluster
  uses: yugabyte/yugabyte-db-action@master
  with:
    yb_image_tag: 2.2.0.0-b80
    yb_master_ui_port: 7000
    yb_tserver_ui_port: 9000
    ysql_port: 5433
    ycql_port: 9042

# Sample usage:
- name: Test YB Tserver UI
  run: curl --head "http://localhost:9000"
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
- name: Test YSQL API
  run: |
    docker run --network host -e PGPASSWORD=testsqlpass --rm yugabytedb/yugabyte-client:latest ysqlsh -h localhost -U testsqluser -d testdb -p "${{ steps.server.outputs.ysql_port }}" \
      -c "CREATE TABLE foo(id int primary key); INSERT INTO foo SELECT * FROM generate_series(1,10);"

- name: Test YCQL API
  run: |
    docker run --network host --rm yugabytedb/yugabyte-client:latest ycqlsh localhost -u testcqluser -p testcqlpass "${{ steps.server.outputs.ycql_port }}" \
      --execute 'create keyspace foo; create table foo.bar(id int primary key); insert into foo.bar (id) values (1);'
```
