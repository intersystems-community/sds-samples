#!/bin/bash

LANGFUSE_CONFIG_FILE="./semanticsearch/langfuse.yaml"
if [ ! -f "$LANGFUSE_CONFIG_FILE" ]; then
  exit_with_error "Configuration file $LANGFUSE_CONFIG_FILE not found!"
fi

while IFS=":" read -r key value; do
  key=$(echo "$key" | xargs)
  value=$(echo "$value" | xargs)
  if [[ -z "$key" || "$key" == \#* ]]; then
    continue
  fi
  value=$(echo "$value" | sed -e 's/^"//' -e 's/"$//')
  export "$key"="$value"
done < "$LANGFUSE_CONFIG_FILE"

export REDIS_PORT=$REDIS_PORT_EXTERNAL
export CONF_LANGFUSE_INIT_USER_NAME=$CONF_LANGFUSE_INITIAL_USER_NAME
