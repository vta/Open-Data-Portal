#!/bin/sh

docker run\
  --name ckan_db \
  -v /Users/falconer_k/git/vta/ckan/data/ckandb:/var/lib/ckan \
  -e PGDATA=/var/lib/postgresql/data/ckan \
  -e POSTGRES_DB=ckan_default \
  -e POSTGRES_USER=ckan_default \
  -e POSTGRES_PASSWORD=firelock \
  -p 5432:5432 \
  -d \
  vta/ckan_db:latest

  # -d \
  # -i -t --entrypoint /bin/bash \