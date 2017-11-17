#!/bin/sh
cd ~
git clone https://bitbucket.org/bemppsolutions/dev-examples
cd "dev-examples"
docker build -t flaskimage -f Dockerfile .
docker run -d --name bempp-container -p 8000:80 --restart=always flaskimage:latest
exit 0
