#!/bin/bash
source ./.husky/shell/config-read.sh

# 自动根据当前运行的docker容器生成镜像并上传到docker-hub
# shellcheck disable=SC2154
remote_image=$docker_user/$docker_image
echo "remote_image: $remote_image"
docker commit "$docker_image" "$remote_image:latest"
docker tag "$remote_image:latest" "$remote_image:$build_version"
docker images | grep "$docker_image"