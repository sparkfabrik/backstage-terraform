uname_S := $(shell uname -s)

all: check-env-file build build-terraform-cli up

check-env-file:
	@test -f .env || { echo ".env file does not exists. You can create one starting from env.template"; exit 1; }

build:
	docker-compose build
	@echo "Application has been built succesfully."

build-terraform-cli:
	docker build -t backstage/terraform-cli ./terraform

up:
	docker-compose down -v
	docker-compose up -d

cli:
	docker-compose run --rm app bash

terraform-cli:
	docker run --rm -it --workdir /app \
	--entrypoint bash -v $${PWD}/terraform:/app \
	--env-file .env \
	backstage/terraform-cli
