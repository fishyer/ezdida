#!/bin/bash
source ./.husky/template.sh

# shellcheck disable=SC2034
start_time=$(date +%s)

log "执行build.sh"
source ./.husky/shell/config-read.sh
log "pre-push before version: $build_version"
source .husky/shell/config-update-2.sh
log "pre-push after verison: $build_version"

# exec git push origin fishyer
exec git push origin fishyer --no-verify

# git commit --amend --no-edit --no-verify
exec git commit -m "build: $build_version" --no-verify

commit_hash=$(git rev-parse HEAD)  
log "build.sh Commit hash: $commit_hash"
commit_message=$(git log -1 --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset')
log "build.sh Commit message: $commit_message"

# exec git push -f origin fishyer --no-verify
fit pull origin fishyer --no-verify
exec git push origin fishyer --no-verify
# nohup sh ./.husky/shell/background.sh &
# python ./.husky/shell/git.py
# log "start http request"
# curl 127.0.0.1:38000/git-push &
# log "stop http request"

ent_time=$(date +%s)
log "$0 执行完成,耗时：$((ent_time-start_time))s"