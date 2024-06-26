#!/bin/bash
source ./.husky/shell/config-read.sh

input_file="./docker-compose.yaml"

# 修改目录权限
dir_name=$(dirname "$0")
echo "Current directory: $dir_name"
chmod -R 777 $dir_name/php
chmod 644 $dir_name/mysql/my.cnf

# 构建本地镜像
docker-compose -f $input_file build

# 使用 yq 读取 services 下的所有服务名称
services=$(yq eval '.services | keys' $input_file -o json | jq -r '.[]')

# 遍历服务名称
for service in $services; do
    # 获取当前服务使用的镜像
    image=$(yq eval ".services.${service}.image" $input_file)
    build=$(yq eval ".services.${service}.build" $input_file)

    if [  "$build" = "null"  ]; then
      service_name=$(echo $image | awk -F':' '{print $1}')
      service_version=$(echo $image | awk -F':' '{print $2}')
      log "build远程仓库服务 $service $image with $service_name:$service_version"
      remote_image="$harbor_url/$harbor_library/$service_name:$service_version"
      docker tag $image $remote_image
      docker push $remote_image
    else
      latest_image="$project_name-$service:latest"
      remote_latest_image="$harbor_url/$harbor_library/$project_name-$service:latest"
      remote_version_image="$harbor_url/$harbor_library/$project_name-$service:$build_version"
      log "build本地构建镜像 $project_name $service $image -> $latest_image"
      # 查看构建的镜像ID
      image_id=$(docker images $latest_image | awk 'NR>1 {print $3}')
      log "镜像ID: $latest_image $image_id"

      docker tag $latest_image $remote_latest_image
      docker tag $latest_image $remote_version_image
      docker push $remote_latest_image
      docker push $remote_version_image
    fi

done