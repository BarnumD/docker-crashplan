#!/bin/bash
docker stop crashplan; docker rm crashplan
docker build -t crashplan --rm=true .
