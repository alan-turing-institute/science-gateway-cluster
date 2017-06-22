#! /bin/bash
REPO_NAME=blue-source-ubuntu
IMAGE_NAME=blueubuntu
REPO_DIR=secret-source/$REPO_NAME

(if cd $REPO_DIR; then git pull; else mkdir $REPO_DIR; git clone git@github.com:alan-turing-institute/$REPO_NAME $REPO_DIR; fi)

docker build -t $IMAGE_NAME .
