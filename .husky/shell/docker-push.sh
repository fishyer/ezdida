#!/bin/bash
source ./.husky/shell/config-read.sh

# shellcheck disable=SC2034
start_time=$(date +%s)

# 自动上传镜像到docker-hub
# shellcheck disable=SC2154
remote_image=$docker_user/$docker_image
docker push "$remote_image:latest"
docker push "$remote_image:$build_version"

# 通过SSH免密登录到远程服务器并执行更新脚本
# shellcheck disable=SC2154
# shellcheck disable=SC2086
# shellcheck disable=SC2087
# ssh -p ${ssh_port} ${ssh_user}@${ssh_server} << EOF
# sh .husky/shell/docker-pull.sh
# EOF

ent_time=$(date +%s)
echo "$0 执行完成,耗时：$((ent_time-start_time))s"