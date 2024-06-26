#!/bin/bash
# shellcheck disable=SC1091
# source ./.env
source ./.husky/template.sh

# shellcheck disable=SC2034
start_time=$(date +%s)
log "config-read.sh 开始执行"

# 以项目的文件名作为项目名称
project_name=$(basename "$PWD")
echo "project_name=$project_name"

# 自动更新git_config.yaml文件中的版本号和构建时间
FILE=".husky/build_config.yaml"
build_version=$(yq e '.build_version' "$FILE")
build_time=$(yq e '.build_time' "$FILE")
build_type=$(yq e '.build_type' "$FILE")
harbor_url=$(yq e '.harbor_url' "$FILE")
harbor_library=$(yq e '.harbor_library' "$FILE")
log "Latest build_version: $build_version"
log "Latest build_time: $build_time"
log "Latest build_type: $build_type"
log "Latest harbor_url: $harbor_url"
log "Latest harbor_library: $harbor_library"

ent_time=$(date +%s)
log "config-read.sh 执行完成,耗时：$((ent_time-start_time))s"