FROM ubuntu:14.04

# set the locale
# this is important for database creation
RUN locale-gen en_US.UTF-8 && \
echo 'LANG="en_US.UTF-8"' > /etc/default/locale
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

##################
#  DEPENDENCIES  #
##################
RUN apt-get update && apt-get install -y \
  postgresql-client \
  git-core \
  libpq-dev \
  python-setuptools \
  python-dev \
  build-essential

RUN easy_install pip
RUN pip install --upgrade pip
RUN pip install --upgrade setuptools
RUN pip install --upgrade virtualenv
RUN pip install --upgrade sqlalchemy-migrate
RUN pip install virtualenvwrapper

RUN /bin/bash -c "source /usr/local/bin/virtualenvwrapper.sh"

##################
#   CKAN SETUP   #
##################
RUN mkdir -p /usr/lib/ckan/default && chown -R `whoami` /usr/lib/ckan/default
WORKDIR /usr/lib/ckan/default
RUN virtualenv --no-site-packages /usr/lib/ckan/default
RUN . /usr/lib/ckan/default/bin/activate

RUN pip install -e 'git+https://github.com/ckan/ckan.git@ckan-2.6.0#egg=ckan'
#RUN git clone --branch ckan-2.6.0 https://github.com/ckan/ckan.git

RUN pip install -r /usr/lib/ckan/default/src/ckan/requirements.txt


##################
#   CKAN CONFIG  #
##################
RUN mkdir -p /etc/ckan/ && chown -R `whoami` /etc/ckan/
COPY ./resources/production.ini /etc/ckan/default/production.ini
RUN ln -s /usr/lib/ckan/default/src/ckan/who.ini /etc/ckan/default/who.ini


##################
# CKAN PLUGINS   #
##################
WORKDIR /usr/lib/ckan/
RUN pip install 'ckanext-geoview==0.0.12'
RUN pip install 'ckanext-envvars==0.0.1'
RUN pip install 'ckanext-pdfview==0.0.5'

# there are no release labels for this, so work only on a known-good commit
WORKDIR /usr/lib/ckan/
RUN git clone https://github.com/ckan/ckanext-mapviews.git
WORKDIR /usr/lib/ckan/ckanext-mapviews/
RUN git checkout 9dc4c9315a2fe6a3adb0a9c9556f00855c6d8be6
RUN python setup.py install

# there are no release labels for this, so work only on a known-good commit
WORKDIR /usr/lib/ckan/
RUN pip install 'apache-libcloud==1.2.1'
RUN pip install 'backports.ssl_match_hostname==3.5.0.1'
RUN git clone https://github.com/open-data/ckanext-cloudstorage.git
WORKDIR /usr/lib/ckan/ckanext-cloudstorage/
RUN git checkout d354fc752a9d501a3f4696295a83794393e447fe
RUN python setup.py install


###################################
#   FINAL DOCKER CONTAINER SETUP  #
###################################
WORKDIR /usr/lib/ckan/default/src/ckan
EXPOSE 8080
EXPOSE 5000
COPY ./docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh
CMD ["/docker-entrypoint.sh"]
