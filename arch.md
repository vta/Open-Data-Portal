# Architecture of CKAN Deployment

multi-org
- VTA
- City of San Jose
- Code For San Jose
- west coast/regional civic


Azure + CKAN

CKAN on VM Depot within Azure Cloud

VM redundancies (availability redundancies) - snapshots

Web apps in Azure - azure app service

F5 - appliance designer

-------


dividing cost of storage


Azure - subscriptions/billing reporting
can set this up with multiple administrators to the subscription or parts of the subscription (can have network or storage seperate)


Azure Storage
1 TB = $24/mo



power vi 
power vi dashboard
report/show azure data usage

Azure is redundant for data 3x, but also should keep snapshots
(uses storage cost)



CKAN production deployment:
Phase 1 would be the initial deployment for production consisting of the CKAN web server component (running on Ubuntu using Nginx and Apache), Solr for search, and PostgreSQL for the database. This is the standard recommended deployment from CKAN.
Phase 2 introduces more web servers with a load balancer, and would come into play once the website starts getting more traffic.
Phase 3 (not drawn) would introduce more databases in either a replicated/clustered configuration or with database sharding, and would be used if/when we observe excessive load on the database.

Each CKAN web server is recommended to have 2 CPU cores, 4 GB of RAM, and 60 GB of disk space.