#!/bin/bash

source ./utils.sh

DEPLOY_LANGFUSE=true
if [ "$1" == "lf" ]; then
  DEPLOY_LANGFUSE=true
elif [ "$1" == "nolf" ]; then
  DEPLOY_LANGFUSE=false
fi

msg "Starting Total View Composition..."

if [ ! -f ./CONF_DOCKER_GTW ];
then
    # trace "Configuring ./CONF_DOCKER_GTW with default Gateway of 172.20.0.1. If IRIS Adaptive Analytics doesn't start with this default configuration, please read the README.md file."
    printf "172.20.0.1" >> ./CONF_DOCKER_GTW
fi

if [ ! -f ./CONF_DOCKER_SUBNET ];
then
    # trace "Configuring ./CONF_DOCKER_SUBNET with default Gateway of 172.20.0.1. If IRIS Adaptive Analytics doesn't start with this default configuration, please read the README.md file."
    printf "172.20.0.0/16" >> ./CONF_DOCKER_SUBNET
fi

if [ ! -f ./CONF_FRONTEND_LOCAL_PORT ];
then
    # trace "Configuring ./CONF_FRONTEND_LOCAL_PORT with default host port for Angular frontend."
    printf "8081" >> ./CONF_FRONTEND_LOCAL_PORT
fi

if [ ! -f ./CONF_IRIS_LOCAL_JDBC_PORT ];
then
    # trace "Configuring ./CONF_IRIS_LOCAL_JDBC_PORT with default host port for IRIS JDBC."
    printf "41972" >> ./CONF_IRIS_LOCAL_JDBC_PORT
fi

if [ ! -f ./CONF_IRIS_LOCAL_WEB_PORT ];
then
    # trace "Configuring ./CONF_IRIS_LOCAL_WEB_PORT with default host port for IRIS Management Portal."
    printf "42773" >> ./CONF_IRIS_LOCAL_WEB_PORT
fi

source ./conf.sh

if [ "$DEPLOY_LANGFUSE" == "true" ]; then
  source ./export-langfuse-config.sh
  export DEBUGGER_METHOD="Langfuse"
  msg "Langfuse deployment enabled."
fi

if [ ! -f ./licenses/iris.key ];
then
    exit_with_error "Could not find file './licenses/iris.key'."
fi

# trace "Making sure ./iris-volumes has the files-dir folder"
if [ ! -d ./iris-volumes/files-dir ];
then
    mkdir -p ./iris-volumes/files-dir
    chmod og+rwx ./iris-volumes/files-dir
fi

if [ ! -d ./semanticsearch/volumes ];
then
    mkdir -p ./semanticsearch/volumes
    chmod og+rwx ./semanticsearch/volumes
fi

# trace "Making sure ./irisaa-volumes can be writable for other users so that atscale inside the container can create its conf and data folders..."
chmod o+rwx ./iris-volumes

COMPOSE_FILES="-f docker-compose.yml"
if [ "$DEPLOY_LANGFUSE" == "true" ]; then
  COMPOSE_FILES="$COMPOSE_FILES -f docker-compose.langfuse.yml"
fi

REMOVE_ORPHANS=""
if [ "$DEPLOY_LANGFUSE" == "true" ]; then
  REMOVE_ORPHANS="--remove-orphans"
fi

# trace "Starting the composition..."
docker compose $COMPOSE_FILES up --quiet-pull $REMOVE_ORPHANS -d
exit_if_error "Could not start composition."

msg "Total View Composition started."
msg "You may want to use some of the logs-*.sh scripts to see if all the containers have finished starting."
