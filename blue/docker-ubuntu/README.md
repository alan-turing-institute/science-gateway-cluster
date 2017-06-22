# Dockerised Blue installation running on Ubuntu

## Install Docker
See https://www.docker.com/community-edition#/download 

## Create docker image
- Run `./build.sh`

## Run docker image and test Blue
- Run image: `docker run -it --entrypoint /bin/bash blueubuntu`
- Change to example project directory: `cd blue/project/example/`
- Build example: `make`
- Run example: `make exe`
