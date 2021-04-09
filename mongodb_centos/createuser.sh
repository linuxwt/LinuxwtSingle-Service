#!/bin/bash

# 启动未认证的mongodb实例
echo "start noauth mongodb instance"
docker-compose -f docker-compose.yml.noauth up -d
sleep 10

# 创建admin库用户
echo -n "create admin database user,please enter 容器名 库用户 库密码 ->"
read container_name mongoadmin_user mongoadmin_password 
docker exec ${container_name} mongo admin --eval "db.createUser({user:\"${mongoadmin_user}\", pwd:\"${mongoadmin_password}\", roles:[{role:\"root\", db:\"admin\"},{role:\"clusterAdmin\",db:\"admin\"}]})"

# 创建普通用户
echo -n "create normal database user,please enter 容器名 库用户 库密码  库名->"
read container_name mongonormal_user mongonormal_password dbname
docker exec ${container_name} mongo ${dbname} --eval "db.createUser({user:\"${mongonormal_user}\", pwd:\"${mongonormal_password}\", roles:[{role:\"dbOwner\", db:\"${dbname}\"},{role:\"clusterAdmin\",db:\"admin\"}]})"

# 启动带认证的mongodb实例
echo "start auth mongodb instance"
docker-compose -f docker-compose.yml down
sleep 10
docker-compose up -d
