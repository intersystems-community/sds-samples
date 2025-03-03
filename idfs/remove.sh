#!/bin/bash

source ./utils.sh

source ./conf.sh

trace "Removing containers..."
docker compose rm -f

trace "Cleaning IRIS Adaptive Analytics Durable Folder"
docker volume rm business-360_irisaa-data
docker volume rm business-360_irisaa-conf
docker volume rm business-360_irisaa-log
rm -rf ./irisaa-volumes/conf
rm -rf ./irisaa-volumes/data
rm -rf ./irisaa-volumes/log

trace "Cleaning IRIS Durable Folder"
docker volume rm business-360_iris-durable-volume
docker volume rm total-view_iris-durable-volume
# Keeping this rm -rf to clean up developer's machines now that we don't need this dur folder anymore
rm -rf ./iris/volumes/dur