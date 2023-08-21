#!/bin/bash

source ./utils.sh

export CONF_DOCKER_SUBNET=$(head -1 ./CONF_DOCKER_SUBNET)

export CONF_DOCKER_GTW=$(head -1 ./CONF_DOCKER_GTW)

export CONF_FRONTEND_LOCAL_PORT=$(head -1 ./CONF_FRONTEND_LOCAL_PORT)

export CONF_IRIS_LOCAL_JDBC_PORT=$(head -1 ./CONF_IRIS_LOCAL_JDBC_PORT)

export CONF_IRIS_LOCAL_WEB_PORT=$(head -1 ./CONF_IRIS_LOCAL_WEB_PORT)

export VERSION=$(head -1 ./VERSION)

trace "Stopping..."

docker-compose stop 
exit_if_error "Could not stop composition."

trace "Composition stopped."