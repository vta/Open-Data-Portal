FROM solr:6.1.0
MAINTAINER  Kyle Falconer "kyle.falconer@vta.org"

COPY ckan_solr_configs /opt/solr/server/solr/configsets/solr1_configs
USER root
RUN chown -R solr:solr /opt/solr/server/solr/configsets/solr1_configs

USER solr
CMD ["/opt/solr/bin/solr", "-f"]