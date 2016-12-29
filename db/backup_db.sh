# set env variables
POSTGRES_DB=ckan_default
POSTGRES_HOST=127.0.0.1
POSTGRES_PORT=5432
POSTGRES_USER=ckan_default
POSTGRES_PASSWORD=password
PGPASSWORD=password

# put connection string in ~/.pgpass
# see https://www.postgresql.org/docs/current/static/libpq-pgpass.html
echo $POSTGRES_HOST:$POSTGRES_PORT:$POSTGRES_DB:$POSTGRES_USER:$POSTGRES_PASSWORD > ~/.pgtest && chmod 0600 ~/.pgtest


# backup database to file
PG_BACKUP_FILENAME=ckan_default__backup_`date +"%Y-%m-%d"`.pgbackup
pg_dump -w -c -h $POSTGRES_HOST -p $POSTGRES_PORT -U $POSTGRES_USER -d $POSTGRES_DB -f $PG_BACKUP_FILENAME -Fc