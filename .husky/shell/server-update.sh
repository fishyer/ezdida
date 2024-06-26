#!/bin/bash
source ./.husky/template.sh

# shellcheck disable=SC2034
start_time=$(date +%s)
log "✅Running post-push hook..."

source ./.husky/shell/config-read.sh
log "post-push config: $build_type $build_version $build_time"

# log "Apply docker-compose.yml"
# sh ./.husky/shell/compose-apply.sh

ent_time=$(date +%s)
log "🎉Success post-push hook. Time elapsed: $((ent_time-start_time))s"

# post-push: 在远程服务器上执行shell脚本 2