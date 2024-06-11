#!/bin/bash
source ./.husky/shell/config-read.sh

# shellcheck disable=SC2034
start_time=$(date +%s)

echo "正在服务器上拉取最新的Docker镜像：${remote_image}:${new_build_version}"
docker pull ${remote_image}:latest
docker pull ${remote_image}:${new_build_version}
mkdir -p /app/log/ez-docker-ui
echo ${new_build_time} ${new_build_version} >> /app/log/ez-docker-ui/image_update.log
tail -n 3 /app/log/ez-docker-ui/image_update.log
docker images | grep my-docker-ui
echo "镜像拉取完成。"

ent_time=$(date +%s)
echo "$0 执行完成,耗时：$((ent_time-start_time))s"