#!/bin/sh

# -i -t --entrypoint /bin/bash \
docker run \
 --net=host \
 --name ckan-web \
 -v /Users/falconer_k/git/vta/ckan/data/ckan_storage:/var/lib/postgresql/data/ckan \
 -p 5000:5000 \
 -d 902eec4a2097