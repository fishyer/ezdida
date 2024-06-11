#!/bin/bash
source ./.husky/shell/config-read.sh

# shellcheck disable=SC2034
start_time=$(date +%s)
log "✅Running post-push hook..."

# git pull -f origin fishyer
sh .husky/shell/docker-deploy.sh
log "post-push config: $build_version"


ent_time=$(date +%s)
log "🎉Success post-push hook. Time elapsed: $((ent_time-start_time))s"

# post-push: 在远程服务器上执行shell脚本