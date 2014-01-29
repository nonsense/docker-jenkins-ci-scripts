#!/bin/bash

REPO=188.226.XXX.XX:5000
CURRENT_IMAGE_ID=`docker images | grep -w ruby_app | awk '{ print $3 }'`

docker pull $REPO/ruby_app

NEW_IMAGE_ID=`docker images | grep -w ruby_app | awk '{ print $3 }'`

if [ "$CURRENT_IMAGE_ID" == "$NEW_IMAGE_ID" ]
then
  echo -n "Image ids are equal. Therefore we have no new image."
else
  echo -n "Image ids are not equal. Therefore we should stop old image and start new one."

  docker kill ruby_app
  docker rm ruby_app

  docker run -privileged -p 80 -p 443 -name ruby_app -link rabbitmq:rabbitmq -link mysql:mysql -link solr:solr -volumes-from ruby_app_data -t ruby_app
fi
