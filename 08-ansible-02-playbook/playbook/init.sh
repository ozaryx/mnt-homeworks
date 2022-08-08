#!/bin/bash

docker run --name clickhouse-01 -d -ti -p 8123:8123 -p 9000:9000 centos 
docker run --name vector-01 -d -ti centos 

docker ps

ansible-playbook -i inventory/prod.yml test.yml
