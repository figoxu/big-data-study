#!/bin/bash

# 进入 Flink SQL Client
docker exec -it $(docker ps -qf "name=jobmanager") ./bin/sql-client.sh