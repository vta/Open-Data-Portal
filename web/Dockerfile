FROM ubuntu:14.04

# set the locale
# this is important for database creation
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en  
ENV LC_ALL en_US.UTF-8

# CKAN - Web
# install deps
RUN sudo apt-get update
RUN sudo apt-get -y install git python-dev libpq-dev python-pip

RUN sudo mkdir -p /usr/lib/ckan/default
RUN sudo chown -R `whoami` /usr/lib/ckan/default

WORKDIR /usr/lib/ckan/default

RUN pip install -e 'git+https://github.com/ckan/ckan.git@ckan-2.5.2#egg=ckan'
RUN pip install -r /usr/lib/ckan/default/src/ckan/requirements.txt


RUN sudo mkdir -p /etc/ckan
RUN sudo chown -R `whoami` /etc/ckan/


RUN paster make-config ckan /etc/ckan/default/development.ini
COPY development.ini /etc/ckan/default/development.ini


# create the database
# cd /usr/lib/ckan/default/src/ckan
# paster db init -c /etc/ckan/default/development.ini

RUN ln -s /usr/lib/ckan/default/src/ckan/who.ini /etc/ckan/default/who.ini



WORKDIR cd /usr/lib/ckan/default/src/ckan

EXPOSE 5000
CMD [ "paster", "serve", "/etc/ckan/default/development.ini"]