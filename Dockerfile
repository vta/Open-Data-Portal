FROM ubuntu:14.04

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


# # Install app dependencies
# COPY package.json /usr/src/app/
# RUN npm install
# 
# # Bundle app source
# COPY . /usr/src/app
# 
EXPOSE 8080
# CMD [ "npm", "start" ]