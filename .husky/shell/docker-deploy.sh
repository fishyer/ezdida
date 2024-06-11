#!/bin/bash
source ./.husky/shell/config-read.sh

# shellcheck disable=SC2034
start_time=$(date +%s)

docker-compose up -d --build

ent_time=$(date +%s)
echo "$0 执行完成,耗时：$((ent_time-start_time))s"