FROM ubuntu:14.04
MAINTAINER  Kyle Falconer "kyle.falconer@vta.org"


# set the locale
# this is important for database creation
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en  
ENV LC_ALL en_US.UTF-8

# CKAN - Web
# install deps
RUN sudo apt-get update
RUN sudo apt-get -y install git python-dev libpq-dev python-pip python-virtualenv postgresql-client

RUN sudo mkdir -p /usr/lib/ckan/default
RUN sudo chown -R `whoami` /usr/lib/ckan/default

WORKDIR /usr/lib/ckan/default

RUN virtualenv --no-site-packages /usr/lib/ckan/default
RUN . /usr/lib/ckan/default/bin/activate

RUN pip install -e 'git+https://github.com/ckan/ckan.git@ckan-2.6.0#egg=ckan'
RUN pip install -r /usr/lib/ckan/default/src/ckan/requirements.txt


RUN sudo mkdir -p /etc/ckan/
RUN sudo chown -R `whoami` /etc/ckan/



RUN paster make-config ckan /etc/ckan/default/development.ini
COPY resources/development.ini /etc/ckan/default/development.ini
RUN ln -s /etc/ckan/default/development.ini /etc/ckan/default/production.ini
COPY resources/apache.wsgi /etc/ckan/default/apache.wsgi


# initializes the database
# cd /usr/lib/ckan/default/src/ckan
# paster db init -c /etc/ckan/default/production.ini


RUN ln -s /usr/lib/ckan/default/src/ckan/who.ini /etc/ckan/default/who.ini

WORKDIR /usr/lib/ckan/default/src/ckan

EXPOSE 8080

# COPY resources/wait_for_start.sh /usr/lib/ckan/wait_for_start.sh
# RUN chmod +x /usr/lib/ckan/wait_for_start.sh
# CMD [ "/usr/lib/ckan/wait_for_start.sh"]

CMD [ "paster", "serve", "/etc/ckan/default/production.ini"]
