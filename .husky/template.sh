#!/bin/bash
source ./.env

# tag是脚本名称
tag=$(basename "$0")

log() {
    current_date=$(date "+%Y-%m-%d %H:%M:%S")
    pwd_path=$(pwd)
    base_name=$(basename "$0")
    message="[I] $current_date [$tag] $*"
    log_path="$pwd_path/.husky/log/$base_name.log"
    mkdir -p "$pwd_path/.husky/log"
    echo "$message" | tee -a "$log_path"
    echo "$message" >> "$pwd_path/.husky/log/all.log"
}

exec() {
  local command="$*"  
  log "pre-exec $command" 
  eval "$command"
  log "post-exec $command"
}


test(){
    # shellcheck disable=SC2034
    start_time=$(date +%s)
    log "开始执行 $0"
    log "pwd_path: $(pwd)"
    log "dir_name: $(dirname "$0")"
    log "base_name: $(basename "$0")"
    log "tag: $tag"
    log "env: $build_type"

    ent_time=$(date +%s)
    log "$0 执行完成,耗时：$((ent_time - start_time))s"
}

if [ "$(basename "$0")" == "template.sh" ]; then
    log "直接执行: $(basename "$0")"
else
    log "导入执行: $(basename "$0")"
fi