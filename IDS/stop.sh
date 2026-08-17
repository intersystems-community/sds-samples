#!/bin/bash

source ./utils.sh

source ./conf.sh

COMPOSE_FILES="-f docker-compose.yml"
if [ -f docker-compose.langfuse.yml ]; then
  COMPOSE_FILES="$COMPOSE_FILES -f docker-compose.langfuse.yml"
  source ./export-langfuse-config.sh
fi

msg "Stopping Total View Composition..."

docker compose $COMPOSE_FILES stop
exit_if_error "Could not stop composition."

msg "Total View composition stopped."