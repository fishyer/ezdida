#!/bin/bash
source ./.husky/shell/config-read.sh

# 获取当前服务器的公网IP地址
public_ip=$(curl ifconfig.me)

# 将.env.prod文件中的"127.0.0.1"替换为公网IP地址，并保存到.env文件
sed "s/127.0.0.1/$public_ip/g" env/prod.env > .env


# 获取当前项目目录
dir_name=$(dirname "$0")
log "Current directory: $dir_name"

# 修改目录权限
chmod -R 777 $dir_name/php
chmod 644 $dir_name/mysql/my.cnf

# 读取配置文件
source ./.husky/shell/config-read.sh
log "post-push config: $build_type $build_version $build_time"

# 部署服务
log "Apply docker-compose.yml"
sh ./.husky/shell/compose-apply.sh

# 导入数据库数据
sh $dir_name/mysql/mysql-import.sh