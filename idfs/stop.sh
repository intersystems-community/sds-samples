#!/bin/bash

source ./utils.sh

source ./conf.sh

msg "Stopping Total View Composition..."

docker compose stop 
exit_if_error "Could not stop composition."

msg "Total View composition stopped."
docker network rm business-360_default