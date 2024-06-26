#!/bin/bash
source ./.husky/shell/config-read.sh

output_file='./docker-compose-prod.yaml'

# 更新远程服务
docker-compose -f $output_file --env-file env/prod.env down
docker-compose -f $output_file --env-file env/prod.env up -d
docker ps | grep $project_name

log "🎉🎉🎉Deploy success!"