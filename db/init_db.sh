#!/bin/sh

# init CKAN db from ./data directory
sudo chown postgres /var/lib/postgresql/9.3/main
sudo chgrp postgres /var/lib/postgresql/9.3/main
sudo chmod 0700 /var/lib/postgresql/9.3/main
sudo service postgresql start

# initialize the CKAN database
sudo -u postgres psql -l
sudo -u postgres createuser -S -D -R -P ckan_default
sudo -u postgres createdb -O ckan_default ckan_default -E utf-8