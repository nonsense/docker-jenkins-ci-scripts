#!/bin/bash

# Tests if an image has already been built. Images like "mysql", "rabbitmq", "solr", etc. don't have to be re-build often.
function check_if_exists_and_build {
  echo -e "Testing whether $1 image has been built? \n"

  if docker images | grep -w $1
  then
    echo -e "$1 already exists. do not build. \n"
  else
    echo -e "$1 does not exists. building now... \n"

    build $1
  fi
}

# Builds a given image
function build {
  rm -f docker-built-id
  docker build -t $1 ./$1 \
    | perl -pe '/Successfully built (\S+)/ && `echo -n $1 > docker-built-id`'
  if [ ! -f docker-built-id ]; then
    echo -e "No docker-built-id file found."
    exit 1
  else
    echo -e "docker-built-id file found, so build was successful."
  fi
  rm -f docker-built-id
}


check_if_exists_and_build solr
check_if_exists_and_build mysql
check_if_exists_and_build rabbitmq
build ruby_app
