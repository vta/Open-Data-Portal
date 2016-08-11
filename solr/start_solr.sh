#!/bin/sh

docker run \
  --name ckan_solr \
   -d -p 8983:8983 \
   -t solr:6.0.1