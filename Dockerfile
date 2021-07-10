FROM node:14-buster-slim

ENV NPM_VERSION=6.14.12
ARG NPM_REGISTRY="https://registry.npmjs.org"

WORKDIR /usr/src/app

# Install gettext-base to use envsubst
RUN apt-get update && apt-get install gettext-base

# Fix openjdk-11-jdk-headless error
RUN mkdir -p /usr/share/man/man1

# Install cookiecutter
RUN apt-get install -y python3 python3-dev python3-pip python-matplotlib g++ \
    gcc musl-dev openjdk-11-jdk-headless curl graphviz ttf-dejavu fontconfig

# Download plantuml file, Validate checksum & Move plantuml file
RUN curl -o plantuml.jar -L http://sourceforge.net/projects/plantuml/files/plantuml.1.2021.4.jar/download \ 
    && echo "be498123d20eaea95a94b174d770ef94adfdca18  plantuml.jar" | sha1sum -c - && mv plantuml.jar /opt/plantuml.jar

# Install cookiecutter and mkdocs
RUN pip3 install cookiecutter && pip3 install mkdocs-techdocs-core==0.0.16

RUN apt-get remove -y --auto-remove curl

# Create script to call plantuml.jar from a location in path
RUN echo $'#!/bin/sh\n\njava -jar '/opt/plantuml.jar' ${@}' >> /usr/local/bin/plantuml
RUN chmod 755 /usr/local/bin/plantuml

# Install dependencies and update npm
RUN npm config set registry ${NPM_REGISTRY} \
    && npm config set strict-ssl false  \
    && yarn config set registry ${NPM_REGISTRY} \
    && yarn config set strict-ssl false  \
    && npm install -g npm@${NPM_VERSION}

COPY package.json yarn.lock /usr/src/app/

RUN cd /usr/src/app && yarn install --frozen-lockfile

# Expose ports
EXPOSE 3000 7000

# Configure the entrypoint script.
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Copy the app.
COPY . /usr/src/app

ENTRYPOINT ["/entrypoint.sh"]
CMD ["yarn", "dev"]
