#!/bin/bash

MYSQL=$(docker run -p 3306:3306 -name mysql -d mysql)
RABBITMQ=$(docker run -p 5672:5672 -p 15672:15672 -name rabbitmq -d rabbitmq)
SOLR=$(docker run -p 8983:8983 -name solr -d solr)

echo -e "Running tests for ruby_app... \n"

docker run -privileged -p 80 -p 443 -name ruby_app -link rabbitmq:rabbitmq -link mysql:mysql -link solr:solr -entrypoint="/opt/ci.sh" -t ruby_app | perl -pe '/Tests failed inside docker./ && `echo -n "Tests failed" > docker-tests-failed`'

if [ ! -f docker-tests-failed ]; then
  echo -e "No docker-tests-failed file. Apparently tests passed."
else
  echo -e "docker-tests-failed file found, so build failed."
  rm docker-tests-failed
  exit 1
fi

docker kill mysql rabbitmq solr ruby_app
docker rm mysql rabbitmq solr ruby_app
