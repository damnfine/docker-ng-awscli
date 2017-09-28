FROM node:8.6-alpine
# update and upgrade packages
RUN apk update && apk upgrade && apk add --update alpine-sdk

# Install GIT
RUN apk add --no-cache bash git openssh

# Install Python
RUN apk add python py-pip

# Install AWS CLI
RUN pip install awscli --user --upgrade
# Tidy up
RUN apk del py-pip \
    && apk del py-setuptools \
    && rm -rf /var/cache/apk/* \
    && rm -rf /tmp/*
# Add CLI to PATH
ENV PATH "$PATH:~/.local/bin"

# Install Angular CLI
RUN yarn global add @angular/cli@1.4.3 \
  && ng set --global packageManager=yarn

# Install PhantomJS (required on Alpine)
RUN apk update && apk add --no-cache fontconfig curl curl-dev && \
  mkdir -p /usr/share && \
  cd /usr/share \
  && curl -L https://github.com/Overbryd/docker-phantomjs-alpine/releases/download/2.11/phantomjs-alpine-x86_64.tar.bz2 | tar xj \
  && ln -s /usr/share/phantomjs/phantomjs /usr/bin/phantomjs \
  && phantomjs --version

# Tidy up
RUN apk del alpine-sdk \
  && rm -rf /tmp/* /var/cache/apk/* *.tar.gz ~/.npm \
  && npm cache verify \
  && sed -i -e "s/bin\/ash/bin\/sh/" /etc/passwd