#!/bin/bash

# docker entrypoint for CKAN,
# forked from https://github.com/dmfenton/ckan-docker

checkDB () {
  # Check if the DB is live
  psql \
   --host=$POSTGRES_HOST \
   --port=$POSTGRES_PORT \
   --username=$POSTGRES_USER \
   --dbname=$POSTGRES_CKAN_DATASTORE_DBNAME
}

checkDB

while [ $? -gt 0 ]; do
  echo 'DB not ready waiting 10 seconds'
  sleep 10
  checkDB
done
cd /usr/lib/ckan/default/src/ckan
paster db init -c /etc/ckan/default/production.ini
# paster --plugin=ckanext-harvest harvester initdb --config=/etc/ckan/default/production.ini

echo "starting CKAN server"
paster serve /etc/ckan/default/production.ini
