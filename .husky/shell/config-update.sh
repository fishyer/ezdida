#!/bin/bash
source ./.husky/shell/config-read.sh

# shellcheck disable=SC2034
start_time=$(date +%s)
log "config-update.sh 开始执行"

# shellcheck disable=SC2154
IFS='.' read -r -a version_parts <<< "$build_version"
((version_parts[2]++))
new_build_version="${version_parts[0]}.${version_parts[1]}.${version_parts[2]}"
new_build_time=$(date "+%Y-%m-%d %H:%M:%S")
log "New build version: $new_build_version"
log "New build time: $new_build_time"

yq e -i ".build_version = \"$new_build_version\"" "$FILE"
yq e -i ".build_time = \"$new_build_time\"" "$FILE"
yq e -i ".build_type = \"dev\"" "$FILE"
git add "$FILE"

build_version=$new_build_version
build_time=$new_build_time
build_type="dev"

ent_time=$(date +%s)
log "config-update.sh 执行完成,耗时：$((ent_time-start_time))s"