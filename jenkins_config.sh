#!/bin/bash

rm -rf docker-jenkins-ci-scripts

git clone https://github.com/nonsense/docker-jenkins-ci-scripts.git

cd docker-jenkins-ci-scripts

chmod +x *.sh

./build_ruby_app.sh

rc=$?
if [[ $rc != 0 ]] ; then
    echo -e "Docker images build failed."
    exit $rc
fi

echo -e "Docker images build passed successfully."

./run_tests_ruby_app.sh

rc=$?
if [[ $rc != 0 ]] ; then
    echo -e "Tests failed."
    exit $rc
fi

echo -e "Tests passed successfully. Pushing ruby_app image to local private repository."

docker tag ruby_app localhost:5000/ruby_app
docker push localhost:5000/ruby_app

echo -e "Tested image pushed successfully to local repository."
