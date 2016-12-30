FROM ubuntu:14.04
MAINTAINER  Kyle Falconer "kyle.falconer@vta.org"


# set the locale
# this is important for database creation

RUN locale-gen en_US.UTF-8 && \
echo 'LANG="en_US.UTF-8"' > /etc/default/locale
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# CKAN - Web
# install deps

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

RUN mkdir -p /usr/lib/ckan/default && chown -R `whoami` /usr/lib/ckan/default

WORKDIR /usr/lib/ckan/default

RUN virtualenv --no-site-packages /usr/lib/ckan/default

RUN . /usr/lib/ckan/default/bin/activate

RUN pip install -e 'git+https://github.com/ckan/ckan.git@ckan-2.6.0#egg=ckan'
#RUN git clone --branch ckan-2.6.0 https://github.com/ckan/ckan.git

RUN pip install -r /usr/lib/ckan/default/src/ckan/requirements.txt

RUN mkdir -p /etc/ckan/ && chown -R `whoami` /etc/ckan/

COPY ./resources/production.ini /etc/ckan/default/production.ini

RUN pip install ckanext-geoview

# initializes the database
# cd /usr/lib/ckan/default/src/ckan
# paster db init -c /etc/ckan/default/production.ini


RUN ln -s /usr/lib/ckan/default/src/ckan/who.ini /etc/ckan/default/who.ini

WORKDIR /usr/lib/ckan/default/src/ckan

EXPOSE 8080

# COPY resources/wait_for_start.sh /usr/lib/ckan/wait_for_start.sh
# RUN chmod +x /usr/lib/ckan/wait_for_start.sh
# CMD [ "/usr/lib/ckan/wait_for_start.sh"]

COPY ./docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh
