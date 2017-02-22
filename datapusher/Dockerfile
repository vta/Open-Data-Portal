FROM keitaro/base:0.1

# Forked from https://github.com/keitaroinc/docker-ckan-datapusher/blob/master/rootfs/Dockerfile
MAINTAINER Keitaro Inc <info@keitaro.info>

ENV APP_DIR=/srv/app
ENV GIT_BRANCH stable
ENV GIT_URL https://github.com/ckan/datapusher.git
ENV JOB_CONFIG ${APP_DIR}/datapusher_settings.py

WORKDIR ${APP_DIR}

RUN apk add --no-cache python \
    py-pip \
    py-gunicorn \
    libxslt && \
    # Temporary packages to build CKAN requirements
    apk add --no-cache --virtual .build-deps \
    gcc \
    git \
    musl-dev \
    python-dev \
    libxml2-dev \
    libxslt-dev && \
    # Fetch datapusher and install
    mkdir ${APP_DIR}/src && cd ${APP_DIR}/src && \
    git clone -b ${GIT_BRANCH} --depth=1 --single-branch ${GIT_URL} && \
    cd datapusher && \
    python setup.py install && \
    pip install --no-cache-dir -r requirements.txt && \
    # Remove temporary packages and files
    apk del .build-deps && \
    rm -rf ${APP_DIR}/src

COPY setup ${APP_DIR}

EXPOSE 8000

CMD ["gunicorn", "--log-file=-", "-b", "0.0.0.0:8000", "wsgi"]