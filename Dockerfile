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
RUN yarn global add @angular/cli@1.4.4 \
  && ng set --global packageManager=yarn

ENV CHROMIUM_VERSION=61.0 \
  CHROME_PATH=/usr/bin/chromium-browser \
  CHROME_BIN=/usr/bin/chromium-browser

# Install Chromium
RUN apk add --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/edge/main --repository http://dl-cdn.alpinelinux.org/alpine/edge/community \
	"chromium>${CHROMIUM_VERSION}"

# Tidy up
RUN apk del alpine-sdk \
  && rm -rf /tmp/* /var/cache/apk/* *.tar.gz ~/.npm \
  && npm cache verify \
  && sed -i -e "s/bin\/ash/bin\/sh/" /etc/passwd