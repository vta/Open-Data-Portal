#!/bin/sh

# -i -t --entrypoint /bin/bash \
docker run \
 -i -t --entrypoint /bin/bash \
 --name ckan_web \
 -v /Users/falconer_k/git/vta/ckan/data/ckan_storage:/var/lib/postgresql/data/ckan \
 -p 5000:5000 \
 vta/ckan_web:latest