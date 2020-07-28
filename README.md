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
