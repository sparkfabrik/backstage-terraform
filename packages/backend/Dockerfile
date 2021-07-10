# Stage 1 - Create yarn install skeleton layer
FROM node:14-buster-slim AS packages

WORKDIR /usr/src/app

COPY package.json yarn.lock ./

# COPY plugins
COPY packages packages

RUN find packages \! -name "package.json" -mindepth 2 -maxdepth 2 -print | xargs rm -rf

# Stage 2 - Install dependencies and build packages
FROM node:14-buster-slim AS build

WORKDIR /usr/src/app
COPY --from=packages /usr/src/app .

RUN yarn install --network-timeout 600000 && rm -rf "$(yarn cache dir)"

COPY . .

COPY app-config.yaml ./

RUN yarn tsc
RUN yarn --cwd packages/backend backstage-cli backend:bundle --build-dependencies

# Stage 3 - Build the actual backend image and install production dependencies
FROM node:14-alpine3.13

ENV NPM_VERSION=6.14.12
ARG NPM_REGISTRY="https://registry.npmjs.org"

WORKDIR /usr/src/app

# Fix openjdk-11-jdk-headless error
RUN mkdir -p /usr/share/man/man1

# Install cookiecutter
RUN apk add --no-cache python3 python3-dev py3-pip py3-matplotlib py3-wheel g++ \
    gcc musl-dev openjdk11-jre-headless curl graphviz ttf-dejavu fontconfig

# Download plantuml file, Validate checksum & Move plantuml file
RUN curl -o plantuml.jar -L http://sourceforge.net/projects/plantuml/files/plantuml.1.2021.4.jar/download \ 
    && echo "be498123d20eaea95a94b174d770ef94adfdca18  plantuml.jar" | sha1sum -c - && mv plantuml.jar /opt/plantuml.jar

# Install cookiecutter and mkdocs
RUN pip3 install cookiecutter && pip3 install mkdocs-techdocs-core==0.0.16

RUN apk del curl

# Create script to call plantuml.jar from a location in path
RUN echo $'#!/bin/sh\n\njava -jar '/opt/plantuml.jar' ${@}' >> /usr/local/bin/plantuml
RUN chmod 755 /usr/local/bin/plantuml

# Install dependencies and update npm
RUN npm config set registry ${NPM_REGISTRY} \
    && npm config set strict-ssl false  \
    && yarn config set registry ${NPM_REGISTRY} \
    && yarn config set strict-ssl false  \
    && npm install -g npm@${NPM_VERSION}

# Copy from build stage
COPY --from=build /usr/src/app/yarn.lock /usr/src/app/package.json /usr/src/app/packages/backend/dist/skeleton.tar.gz ./
RUN tar xzf skeleton.tar.gz && rm skeleton.tar.gz

RUN yarn install --production --network-timeout 600000 && rm -rf "$(yarn cache dir)"

COPY --from=build /usr/src/app/packages/backend/dist/bundle.tar.gz .
RUN tar xzf bundle.tar.gz && rm bundle.tar.gz

COPY app-config.yaml ./

ENV PORT 7000

CMD ["node", "packages/backend", "--config", "app-config.yaml"]
