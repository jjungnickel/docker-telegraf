#!/bin/bash
#

set -ueo pipefail

export COMPOSE_FILE=${COMPOSE_FILE:-docker-compose.drone.yml}
#export COMPOSE_PROJECT_NAME="drone_$(echo $DRONE_REPO |sed 's/[:/]/-/g')"
export COMPOSE_PROJECT_NAME="dronesut"

function debug() {
  echo ">>>>>>>>>>> $@"
  "$@"
}

function cleanup {
  debug docker-compose kill
  debug docker-compose down --remove-orphans -v   #remove also orphans
  debug docker-compose rm --all -f -v             #faster
}

#ensure docker-compose clean-up
trap cleanup SIGINT SIGTERM EXIT
cleanup
debug docker-compose pull
debug docker-compose build
debug docker-compose run sut
