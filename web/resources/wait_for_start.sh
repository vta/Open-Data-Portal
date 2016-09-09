#!/bin/sh
su -c "
    while ! psql --host=ckan_db --username=ckan_default > /dev/null 2>&1; do
        echo 'Waiting for connection with postgres...'
        sleep 1;
    done;
    echo 'Connected to postgres...';"
su -c "cd /usr/lib/ckan/default/src/ckan"
su -c "paster serve /etc/ckan/default/production.ini"