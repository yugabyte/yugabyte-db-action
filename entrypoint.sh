#!/bin/bash

set -eo pipefail

declare -a ENV_VARS

[[ -n "${INPUT_YSQL_USER}" ]] && ENV_VARS+=(-e YSQL_USER="${INPUT_YSQL_USER}") || INPUT_YSQL_USER="yugabyte"

[[ -n "${INPUT_YSQL_PASSWORD}" ]] && ENV_VARS+=(-e YSQL_PASSWORD="${INPUT_YSQL_PASSWORD}" -e PGPASSWORD="${INPUT_YSQL_PASSWORD}")

[[ -n "${INPUT_YSQL_DB}" ]] && ENV_VARS+=(-e YSQL_DB="${INPUT_YSQL_DB}")

[[ -n "${INPUT_YCQL_USER}" ]] && ENV_VARS+=(-e YCQL_USER="${INPUT_YCQL_USER}")

[[ -n "${INPUT_YCQL_PASSWORD}" ]] && ENV_VARS+=(-e YCQL_PASSWORD="${INPUT_YCQL_PASSWORD}")

[[ -n "${INPUT_YCQL_KEYSPACE}" ]] && ENV_VARS+=(-e YCQL_KEYSPACE="${INPUT_YCQL_KEYSPACE}")

SERVICE_ID=$(docker run \
  -p "${INPUT_YB_MASTER_UI_PORT}:${INPUT_YB_MASTER_UI_PORT}" \
  -p "${INPUT_YB_TSERVER_UI_PORT}:${INPUT_YB_TSERVER_UI_PORT}" \
  -p "${INPUT_YSQL_PORT}:${INPUT_YSQL_PORT}" \
  -p "${INPUT_YCQL_PORT}:${INPUT_YCQL_PORT}" \
  --detach "${ENV_VARS[@]}" \
  yugabytedb/yugabyte:"${INPUT_YB_IMAGE_TAG}" \
  bin/yugabyted start --ycql_port="${INPUT_YCQL_PORT}" --ysql_port="${INPUT_YSQL_PORT}" \
  --master_webserver_port="${INPUT_YB_MASTER_UI_PORT}" --tserver_webserver_port="${INPUT_YB_TSERVER_UI_PORT}" \
  --daemon=false --ui=false)

function waitUntilHealthy() {
  while ! docker exec "$1" ysqlsh -U "${INPUT_YSQL_USER}" -p "$2" -c \\conninfo; do
    sleep 5s
  done
}

export -f waitUntilHealthy

echo "Waiting for YugabyteDB to start."
if ! timeout 2m bash -c "waitUntilHealthy ${SERVICE_ID} ${INPUT_YSQL_PORT}"; then
  echo "Timeout while waiting for database"
  exit 1
fi

echo "Docker logs"
docker logs "${SERVICE_ID}"

echo "::set-output name=container_id::${SERVICE_ID}"
echo "::set-output name=yb_master_ui_port::${INPUT_YB_MASTER_UI_PORT}"
echo "::set-output name=yb_tserver_ui_port::${INPUT_YB_TSERVER_UI_PORT}"
echo "::set-output name=ysql_port::${INPUT_YSQL_PORT}"
echo "::set-output name=ycql_port::${INPUT_YCQL_PORT}"
