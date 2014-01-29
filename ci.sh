#!/bin/bash

rake assets:precompile

rspec

return_code=$?
if [[ $return_code != 0 ]] ; then
  echo -e "Tests failed inside docker."
  exit $return_code
fi
