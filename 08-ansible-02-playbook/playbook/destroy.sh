#!/bin/bash

docker ps

docker stop clickhouse-01 vector-01
docker rm clickhouse-01 vector-01

docker ps -a
