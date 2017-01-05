[![Stories in Ready](https://badge.waffle.io/vta/Open-Data-Portal.svg?label=ready&title=Ready)](http://waffle.io/vta/Open-Data-Portal)


<p align="center">
  <img src="resources/VTA_logo.png?raw=true" height="70" alt="VTA logo"/>
  <img src="http://www.clipartbest.com/cliparts/RTG/76r/RTG76rgTL.png" height="50" alt="heart"/>
  <img src="resources/open_data_logo_sq.png?raw=true" height="70" alt="Open Data logo"/>
</p>


# Open Data Portal
 <p>Powered by <img src="resources/CKAN_Logo_full_color.png?raw=true" height="25" alt="CKAN logo"/></p>

## PostgreSQL Database deployment to Amazon RDS
Deployed using Amazon's RDS PostgreSQL service.

Currently using a db.m4.large instance for PostgreSQL (2 vCPU, 8GB RAM), with 500GB storage allocated. Refer to the [RDS pricing sheet](https://aws.amazon.com/rds/pricing/).

* DB Instance Identifier : ckandb
* Master Username : ckandb_admin
* Master Password : password_for_ckandb_admin
* DB Parameter Group : default.postgres9.5
* Database Name : ckan
* Database Port : 5432
* Backup Retention Period: 7 days
* Backup Window: Start Time: 08:00 UTC (midnight Pacific Time),duration: 2 hours
* Auto Minor Version Upgrade: Yes

connection string:
`User=ckandb_admin, Schema=public, URL=jdbc:postgresql://ckandb.somehost.us-west-2.rds.amazonaws.com:5432/ckan`

*Note:* For debugging purposes, it may be useful to open up the security groups to allow connections from any IP address to port 5432. For more information or if connection attempts to the database fails, check out [the Connecting to a DB Instance Running the PostgreSQL Database Engine documentation](http://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_ConnectToPostgreSQLInstance.html).

### Create DataStore Database
Create a database called `datastore_default` and a user called `datastore_default` with read-only access to that database.

####Connect to the database:

```
psql  --host=$POSTGRES_HOST --port=$POSTGRES_PORT --username=$POSTGRES_USER --dbname=$POSTGRES_CKAN_DBNAME
```

#### Grant access to user:
```
\connect datastore_default
GRANT CONNECT ON DATABASE datastore_default TO datastore_default;
GRANT USAGE ON SCHEMA public TO datastore_default;

-- revoke permissions for the read-only user
REVOKE CREATE ON SCHEMA public FROM PUBLIC;
REVOKE USAGE ON SCHEMA public FROM PUBLIC;

GRANT CREATE ON SCHEMA public TO "ckandb_admin";
GRANT USAGE ON SCHEMA public TO "ckandb_admin";

GRANT CREATE ON SCHEMA public TO "ckandb_admin";
GRANT USAGE ON SCHEMA public TO "ckandb_admin";

-- take connect permissions from main db
REVOKE CONNECT ON DATABASE "ckan" FROM "datastore_default";

-- grant select permissions for read-only user
GRANT CONNECT ON DATABASE "datastore_default" TO "datastore_default";
GRANT USAGE ON SCHEMA public TO "datastore_default";

-- grant access to current tables and views to read-only user
GRANT SELECT ON ALL TABLES IN SCHEMA public TO "datastore_default";

-- grant access to new tables and views by default
ALTER DEFAULT PRIVILEGES FOR USER "ckandb_admin" IN SCHEMA public
   GRANT SELECT ON TABLES TO "datastore_default";
```
## S3 storage
Create an IAM user to have access to the S3 bucket, then grant permissions to that user:

```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "s3:*",
            "Resource": "arn:aws:s3:::vta-open-data/*"
        }
    ]
}
```

Once permissions have been granted to the user to access the S3 bucket, create an access key for this user and note the Access key ID and Secret access key. These values are used in the `CLOUDSTORAGE_OPTIONS` value, as `key` and `secret`.

Now add a bucket policy to [allow read access for anonymous users](https://docs.aws.amazon.com/AmazonS3/latest/dev/example-bucket-policies.html#example-bucket-policies-use-case-2)

```
{
	"Version": "2012-10-17",
	"Statement": [
		{
			"Sid": "AddPerm",
			"Effect": "Allow",
			"Principal": "*",
			"Action": [
				"s3:GetObject"
			],
			"Resource": [
				"arn:aws:s3:::vta-open-data/*"
			]
		}
	]
}
```

Also edit the CORS Configuration to allow access from any origin. 
```
<CORSConfiguration>
    <CORSRule>
        <AllowedOrigin>*</AllowedOrigin>
        <AllowedMethod>GET</AllowedMethod>
        <MaxAgeSeconds>3000</MaxAgeSeconds>
        <AllowedHeader>*</AllowedHeader>
    </CORSRule>
</CORSConfiguration>
```

## Docker deployment to Amazon EC2
Amazon EC2 Instance using Ubuntu 16.04 on a t2.medium
* 16 GB EBS GP2 SSD storage
* SSH (22), HTTP (80), HTTPS (443) ports opened

### Protect access to database
Once the Amazon EC2 instance is set up, note its IP address and set the RDS Security Group's inbound rules to allow access to port 5432 only from the CKAN instance's IP address.


### Install dependencies

To  ssh into the instance:
```
cp ~/Donwloads/opendata_prod.pem to ~/.ssh/opendata_prod.pem
chmod 0400 ~/.ssh/opendata_prod.pem
ssh -i ~/.ssh/opendata_prod.pem ubuntu@some-instance.us-west-2.compute.amazonaws.com
```

Follow [these instructions for installing Docker on Ubuntu 16.04](https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-ubuntu-16-04):
```
sudo apt-get update
sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
sudo apt-add-repository 'deb https://apt.dockerproject.org/repo ubuntu-xenial main'
sudo apt-get update
sudo apt-get install -y docker-engine
sudo usermod -aG docker $(whoami)
```

Now [install docker-compose](https://docs.docker.com/compose/install/):
```
sudo curl -L "https://github.com/docker/compose/releases/download/1.9.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
```

Log out and then log back in to complete the process (the group assignment needs to take effect).


### Deploy the project

Clone the project:
```
git clone https://github.com/vta/Open-Data-Portal
cd Open-Data-Portal
```

Set the environment variables used by the docker-compose.yml through the `.env` file. The `sample.env` file provides a template for the production `.env` file. See [this docker-compose issue about the env_file value vs .env file](https://github.com/docker/compose/issues/4189).

```
cp example.env .env
nano .env
```

#### contents of .env
```
POSTGRES_CKAN_DBNAME=ckan
POSTGRES_CKAN_DATASTORE_DBNAME=datastore_default
POSTGRES_HOST=ckandb.somehost.us-west-2.rds.amazonaws.com
POSTGRES_PORT=5432
POSTGRES_USER=ckandb_admin
POSTGRES_DATASTORE_USER=datastore_default
POSTGRES_DATASTORE_PASSWORD=the_read_only_password_for_datastore_default
POSTGRES_PASSWORD=the_postgres_database_password
PGPASSWORD=the_postgres_database_password
CKAN_SITE_URL=http://some-instance.us-west-2.compute.amazonaws.com
CLOUDSTORAGE_DRIVER=S3_US_WEST
CLOUDSTORAGE_NAME=vta-open-data
CLOUDSTORAGE_OPTIONS={'key': 'IAM user key', 'secret': 'IAM user secret'}
```



#### Build and Run

```
docker-compose build
docker-compose run -d
```

Check the status of the services using `docker`:

##### list services:
There should be four docker containers running. This can be checked with the `ps` docker command:
```
docker ps
```

![docker ps](resources/docker_ps.png?raw=true)

##### see logs for ckan:
```
docker logs ckan
```

#### Create the first user
Once the ckan container is up and running, go to the site, create an account, then get shell access to the ckan container by running this command:
```
sudo docker exec -i -t ckan /bin/bash
```

Once in, [create an admin account](http://docs.ckan.org/en/latest/maintaining/getting-started.html#create-admin-user) for the user you just created by running this command:

```
paster sysadmin add <user name> -c /etc/ckan/default/production.ini
```
