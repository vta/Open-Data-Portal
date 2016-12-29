#!/bin/bash

# docker entrypoint for CKAN,
# forked from https://github.com/dmfenton/ckan-docker

checkDB () {
  # Check if the DB is live
  psql -d "$DATABASE_URL"
}

checkDB

while [ $? -gt 0 ]; do
  echo 'DB not ready waiting 10 seconds'
	sleep 10
	checkDB
done
cd /usr/lib/ckan/default/src/ckan && paster db init -c /etc/ckan/default/default.ini
paster --plugin=ckanext-harvest harvester initdb --config=/etc/ckan/default/default.ini

echo "starting server"

exec paster serve /etc/ckan/default/default.ini