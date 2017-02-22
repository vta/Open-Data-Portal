FROM ubuntu:14.04
MAINTAINER  Kyle Falconer "kyle.falconer@vta.org"

#install requirements for the DataPusher
RUN apt-get update && apt-get install -y \
  libxslt1-dev \
  libxml2-dev \
  git \
  libpq-dev \
  python-dev \
  python-setuptools \
  build-essential

RUN easy_install pip
RUN pip install --upgrade pip
RUN pip install --upgrade virtualenv
RUN pip install virtualenvwrapper

RUN /bin/bash -c "source /usr/local/bin/virtualenvwrapper.sh"

RUN virtualenv /usr/lib/ckan/datapusher
RUN . /usr/lib/ckan/datapusher/bin/activate

RUN mkdir /usr/lib/ckan/datapusher/src
WORKDIR /usr/lib/ckan/datapusher/src

RUN git clone https://github.com/ckan/datapusher.git
WORKDIR /usr/lib/ckan/datapusher/src/datapusher
RUN git checkout 0.0.9

RUN pip install -r requirements.txt
RUN pip install 'Flask-Login==0.2.11'
RUN python setup.py develop

RUN pip install gunicorn

COPY ./datapusher_settings.py ./deployment/datapusher_settings.py
COPY ./datapusher.wsgi ./datapusher.wsgi

EXPOSE 8800
CMD ["gunicorn", "--log-file=-", "-b", "0.0.0.0:8800", "-t", "1000", "wsgi:app"]