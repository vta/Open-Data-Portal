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

# ckanext-mapviews plugin
# there are no release labels for this, so work only on a known-good commit
WORKDIR /usr/lib/ckan/
RUN git clone https://github.com/ckan/ckanext-mapviews.git
WORKDIR /usr/lib/ckan/ckanext-mapviews/
RUN git checkout 9dc4c9315a2fe6a3adb0a9c9556f00855c6d8be6
RUN python setup.py install

# PDF View plugin
# https://github.com/ckan/ckanext-pdfview
WORKDIR /usr/lib/ckan/default
RUN pip install ckanext-pdfview

# CKAN CloudConnector plugin
WORKDIR /usr/lib/ckan/
RUN git clone https://github.com/DataShades/ckanext-cloudconnector.git
WORKDIR /usr/lib/ckan/ckanext-cloudconnector/
RUN git checkout 1f4b7ea416aa57b9bd75841c21e067095e327b02
RUN python setup.py install

RUN ln -s /usr/lib/ckan/default/src/ckan/who.ini /etc/ckan/default/who.ini

WORKDIR /usr/lib/ckan/default/src/ckan

EXPOSE 8080

# COPY resources/wait_for_start.sh /usr/lib/ckan/wait_for_start.sh
# RUN chmod +x /usr/lib/ckan/wait_for_start.sh
# CMD [ "/usr/lib/ckan/wait_for_start.sh"]

COPY ./docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh
