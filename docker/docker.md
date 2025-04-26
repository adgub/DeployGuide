# 1. **docker源配置**

 

```json
{ "registry-mirrors": ["https://docker.registry.cyou", "https://docker-cf.registry.cyou", "https://dockercf.jsdelivr.fyi", "https://docker.jsdelivr.fyi", "https://dockertest.jsdelivr.fyi", "https://mirror.aliyuncs.com", "https://dockerproxy.com", "https://mirror.baidubce.com", "https://docker.m.daocloud.io", "https://docker.nju.edu.cn", "https://docker.mirrors.sjtug.sjtu.edu.cn", "https://docker.mirrors.ustc.edu.cn", "https://mirror.iscas.ac.cn", "https://docker.rainbond.cc"]} 
```

 

# 2. **常用命令**

 

## 2.1. **镜像**

 

##### 下载

```shell
docker pull nginx:1.26.0
```

 

##### 列表

```shell
docker images
```

 

##### 删除

```shell
docker rmi [IMAGE ID]
```

 

## 2.2. **容器**

 

##### 运行

```shell
--name mynginx 设置别名

-p 80:80 本机端口:容器端口

-d 后台运行

nginx:1.26.0 镜像以及版本

docker run --name mynginx -p 80:80 -d nginx:1.26.0
```

 

##### 目录挂载:创建空的目录

```shell
docker run -v /app/nghtml:/usr/share/nginx/html -d nginx:1.26.0
```

 

##### 卷映射：会将镜像地址内的文件映射到卷目录，可用docker相关的命令查看卷位置

```shell
docker run -v ngconf:/etc/nginx -d nginx:1.26.0
```

 

##### 卷默认位置

```shell
/var/lib/docker/volumes/<volume-name>
```

 

##### 卷查看

```shell
docker volume ls
```

 

##### 卷新增

```shell
docker volume create <volume-name>
```

 

##### 卷详情

<volume-name> 卷的名称

```shell
docker volume inspect <volume-name>
```

 

##### 查看（正在运行）

```shell
docker ps
```

 

##### 查看(所有)

```shell
docker ps -a
```

 

##### 停止

```shell
docker stop [CONTAINER ID]
```

 

##### 启动

```shell
docker start [CONTAINER ID]
```

 

##### 重启

```shell
docker restart [CONTAINER ID]
```

 

##### 状态

```shell
docker stats
```

 

##### 日志

```shell
docker logs [CONTAINER ID]
```

 

##### 进入容器

-it 交互模式

mynginx 容器名或id

/bin/bash 控制台

```shell
docker exec -it mynginx /bin/bash
```

 

##### 删除

```shell
docker rm [CONTAINER ID]
```

 

##### 提交

```shell
docker commit -m "更新备注" [CONTAINER ID] mynginxv1.0
```

 

##### 保存

```shell
docker save -o mynginx.tar mynginxv1.0
```

 

##### 加载

```shell
docker load -i mynginxv1.0
```

 

 

##### Mysql



```shell
docker run \

--name mysql \

-d \

-p 3306:3306 \

--restart=always \

-v /docker/mysql/log:/var/log/mysql \

-v /docker/mysql/data:/var/lib/mysql \

-v /docker/mysql/conf:/etc/mysql/conf.d \

-v /etc/localtime:/etc/localtime:ro \

-e MYSQL_ROOT_PASSWORD=root \

mysql:5.7
```

 

docker run：这是 Docker 启动容器的命令。

 

-d：这个选项使容器在后台运行，以允许您继续在终端中执行其他命令。

 

--name mysql：创建的容器名称。

 

-p 3306:3306：这部分命令将主机的端口 3306 映射到容器内的 3306 端口。

 

--restart=always ：开机自动启动

 

-v /docker/mysql/log:/var/log/mysql：映射日志目录，宿主机:容器。

 

-v /docker/mysql/data:/var/lib/mysql：映射数据目录，宿主机:容器。

 

-v /docker/mysql/conf:/etc/mysql/conf.d：映射配置目录，宿主机:容器。

 

 -v /etc/localtime:/etc/localtime:ro \ : 让容器的时钟与宿主机时钟同步，避免时区的问题，ro是read only的意思，就是只读。

 

-e MYSQL_ROOT_PASSWORD=root：这个选项设置 MySQL 根用户的密码。

 

mysql:5.7：这是要运行的 Docker 镜像的名称和标签。

 

 

 