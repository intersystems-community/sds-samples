#!/bin/bash

source ./utils.sh

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

if [ ! -f ./licenses/iris.key ];
then
    exit_with_error "Could not find file './licenses/iris.key'."
fi

if [ ! -f ./licenses/AtScaleLicense.json ];
then
    exit_with_error "Could not find file './licenses/AtScaleLicense.json'. "
fi

# trace "Making sure ./iris-volumes has the files-dir folder"
if [ ! -d ./iris-volumes/files-dir ];
then
    mkdir -p ./iris-volumes/files-dir
    chmod og+rwx ./iris-volumes/files-dir
fi

# trace "Making sure ./irisaa-volumes can be writable for other users so that atscale inside the container can create its conf and data folders..."
chmod o+rwx ./iris-volumes

# trace "Making sure ./irisaa-volumes has the home-atscale folder"
if [ ! -d ./irisaa-volumes/home-atscale ];
then
    mkdir -p ./irisaa-volumes/home-atscale
    chmod og+rwx ./irisaa-volumes/home-atscale
fi

# trace "Starting the composition..."
docker compose up --remove-orphans -d
exit_if_error "Could not start composition."

msg "Total View Composition started."
msg "You may want to use some of the logs-*.sh scripts to see if all the containers have finished starting."
msg "If it is uncommented in the composition, AtScale, will take a couple of minutes to be ready."