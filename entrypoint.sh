#!/bin/bash

set -eo pipefail

SERVICE_ID=$(docker run \
  -p "${INPUT_YB_MASTER_UI_PORT}:${INPUT_YB_MASTER_UI_PORT}" \
  -p "${INPUT_YB_TSERVER_UI_PORT}:${INPUT_YB_TSERVER_UI_PORT}" \
  -p "${INPUT_YSQL_PORT}:${INPUT_YSQL_PORT}" \
  -p "${INPUT_YCQL_PORT}:${INPUT_YCQL_PORT}" \
  --detach \
  yugabytedb/yugabyte:"${INPUT_YB_IMAGE_TAG}" \
  bin/yugabyted start --ycql_port="${INPUT_YCQL_PORT}" --ysql_port="${INPUT_YSQL_PORT}" \
  --master_webserver_port="${INPUT_YB_MASTER_UI_PORT}" --tserver_webserver_port="${INPUT_YB_TSERVER_UI_PORT}" \
  --daemon=false --ui=false)

function waitUntilHealthy() {
  while ! docker exec "$1" ysqlsh -p "$2" -c \\conninfo; do
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
