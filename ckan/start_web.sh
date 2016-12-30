#!/bin/sh

# -i -t --entrypoint /bin/bash \
docker run \
 -d \
 --name ckan_web \
 --net="host" \
 -v /var/lib/ckan:/var/lib/ckan \
 vta/ckan_web:latest

# --net="host" \
# -v /var/lib/ckan:/var/lib/ckan \

# -v /Users/falconer_k/git/vta/ckan/data/ckan_storage:/var/lib/postgresql/data/ckan \
# -p 5000:5000 \
# vta/ckan_web:latest
