#!/bin/bash
source ./.husky/shell/config-read.sh

# 复制出一份用于部署的 docker-compose-deploy.yaml
input_file="./docker-compose.yaml"
output_file="${input_file%.*}-prod.${input_file##*.}"
cp -f "$input_file" "$output_file"

# 使用 yq 读取 services 下的所有服务名称
services=$(yq eval '.services | keys' $output_file -o json | jq -r '.[]')

# 遍历服务名称
for service in $services; do
    # 获取当前服务使用的镜像
    image=$(yq eval ".services.${service}.image" $output_file)
    build=$(yq eval ".services.${service}.build" $output_file)

    if [  "$build" = "null"  ]; then
      service_name=$(echo $image | awk -F':' '{print $1}')
      service_version=$(echo $image | awk -F':' '{print $2}')
      log "pre远程仓库服务 $service $image with $service_name:$service_version"
      remote_image="$harbor_url/$harbor_library/$service_name:$service_version"
      yq e -i ".services.${service}.image = \"$remote_image\"" "$output_file"
    else
      latest_image="$project_name-$service:latest"
      remote_latest_image="$harbor_url/$harbor_library/$project_name-$service:latest"
      remote_version_image="$harbor_url/$harbor_library/$project_name-$service:$build_version"
      log "pre本地构建镜像 $project_name $service $image -> $latest_image"
      # 部署的配置中,删除build字段
      yq e -i "del(.services.${service}.build)" "$output_file"
      # 部署的配置中，更新项目名和版本号
      yq e -i ".services.${service}.image = \"$remote_version_image\"" "$output_file"
      log "更新远程latest镜像为 $remote_latest_image"
      log "更新远程version镜像为 $remote_version_image"
    fi

done

git add "$output_file"