#!/bin/bash
source ./.husky/template.sh

rm -rf .husky/log

# shellcheck disable=SC2034
start_time=$(date +%s)
log "✅Running post-push hook..."

source ./.husky/shell/config-read.sh
log "post-push config: $build_type $build_version $build_time"

# git pull -f origin fishyer
# sh .husky/shell/docker-deploy.sh

ent_time=$(date +%s)
log "🎉Success post-push hook. Time elapsed: $((ent_time-start_time))s"

# post-push: 在远程服务器上执行shell脚本 2
# git push -f -u --tags origin fishyer --no-verify 