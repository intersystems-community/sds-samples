#!/bin/bash

source ./utils.sh

source ./conf.sh

COMPOSE_FILES="-f docker-compose.yml"
if [ -f docker-compose.langfuse.yml ]; then
  COMPOSE_FILES="$COMPOSE_FILES -f docker-compose.langfuse.yml"
  source ./export-langfuse-config.sh
fi

trace "Removing containers..."
docker compose $COMPOSE_FILES rm -f

trace "Removing network..."
docker network rm ids_default 2>/dev/null

trace "Cleaning IRIS Durable Folder"
docker volume rm business-360_iris-durable-volume
docker volume rm total-view_iris-durable-volume
docker volume rm idfs_iris-durable-volume
docker volume rm ids_iris-durable-volume
docker volume rm ids_search-durable-volume
# Keeping this rm -rf to clean up developer's machines now that we don't need this dur folder anymore
rm -rf ./iris/volumes/dur
rm -rf ./semanticsearch/volumes
