#!/bin/bash
source ./.husky/shell/config-read.sh

# shellcheck disable=SC2034
start_time=$(date +%s)


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
echo "Updated version to $new_build_version and build time to $new_build_time"
git add "$FILE"

build_version=$new_build_version
build_time=$new_build_time
build_type="dev"

ent_time=$(date +%s)
echo "$0 执行完成,耗时：$((ent_time-start_time))s"