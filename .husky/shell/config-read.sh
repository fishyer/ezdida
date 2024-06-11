#!/bin/bash

# shellcheck disable=SC2034
start_time=$(date +%s)
# shellcheck disable=SC1091
source ./.husky/template.sh

# 自动更新git_config.yaml文件中的版本号和构建时间
FILE=".husky/config/build_config.yaml"
build_version=$(yq e '.build_version' "$FILE")
build_time=$(yq e '.build_time' "$FILE")
log "Latest build_version: $build_version"
log "Latest build time: $build_time"

ent_time=$(date +%s)
log "$0 执行完成,耗时：$((ent_time-start_time))s"