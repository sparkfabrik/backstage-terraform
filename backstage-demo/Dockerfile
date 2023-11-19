FROM node:18-bookworm-slim

ENV NPM_VERSION=10.1.0
ARG NPM_REGISTRY="https://registry.npmjs.org"

WORKDIR /usr/src/app

# Install gettext-base to use envsubst
RUN apt-get update && apt-get install gettext-base

# Install cookiecutter
RUN apt-get install -y python3 python3-dev python3-pip g++ \
    gcc musl-dev openjdk-17-jre-headless curl graphviz fontconfig

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
