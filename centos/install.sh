#! /usr/bin/bash

#jdk安装
function jdkFun(){
cd ~
mkdir /usr/java/
tar -zxvf jdk-8u221-linux-x64.tar.gz -C /usr/java/

#echo -e "#java
#JAVA_HOME=/usr/java/jdk1.8.0_221
#JRE_HOME=/usr/java/jdk1.8.0_221/jre
#CLASS_PATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar:$JRE_HOME/lib
#PATH=$PATH:$JAVA_HOME/bin:$JRE_HOME/bin
#export JAVA_HOME JRE_HOME CLASS_PATH PATH"  >> /etc/profile


echo -e "#java
export JAVA_HOME=/usr/java/jdk1.8.0_221
export PATH=$JAVA_HOME/bin:$PATH"  >> /etc/profile

source /etc/profile


#查看版本
echo "jdk安装完成，查看版本"
java -version
}

function nginxFun(){
echo "===============必要环境安装==============="
echo "=============gcc安装============="
 sudo yum install gcc

echo "=============openssl安装============="
 sudo yum install -y openssl openssl-devel

echo "=============pcre安装============="
 sudo yum install -y pcre pcre-devel
 
echo "=============zlib安装============="
 sudo yum install -y zlib zlib-devel
 
 
echo "===============nginx安装==============="
#mkdir /usr/local/nginx

cd ~
tar -zxvf nginx-1.16.1.tar.gz
cd /root/nginx-1.16.1/
chmod +x configure

echo '#nginx'  >> /etc/profile
echo 'export PATH=/usr/local/nginx/sbin:$PATH' >> /etc/profile
 source /etc/profile 

./configure && make && make install
ln -s /usr/local/nginx/sbin/nginx /usr/bin/
echo "===============nginx完成==============="
nginx -V
}

function redisFun(){
 echo "===============必要环境安装==============="
 
yum install cpp
yum install binutils
yum install glibcQ
yum install glibc-kernheaders
yum install glibc-common

echo "===============redis安装==============="
cd ~
mkdir /home/webuser/software
tar -zxvf redis-5.0.14.tar.gz -C /home/webuser/software/
cd /home/webuser/software/redis-5.0.14/
make && make install

#修改配置文件
sed -i 's/daemonize no/daemonize yes/g' /home/webuser/software/redis-5.0.14/redis.conf

echo "===============redis安装完成==============="
redis-cli --version

#启动redis
#redis-server redis.conf
}

function pgsqlFun(){
 echo "===============pgsql安装==============="
 # Install the repository RPM:
 sudo yum install -y https://download.postgresql.org/pub/repos/yum/reporpms/EL-7-x86_64/pgdg-redhat-repo-latest.noarch.rpm
 # Install PostgreSQL:
 sudo yum install -y postgresql13-server
 
 # Optionally initialize the database and enable automatic start:
 sudo /usr/pgsql-13/bin/postgresql-13-setup initdb
 sudo systemctl enable postgresql-13
 sudo systemctl start postgresql-13

 #启动服务
 #firewall-cmd --list-service
 firewall-cmd --permanent --add-service=postgresql --permanent
 firewall-cmd --zone=public --add-port=5432/tcp --permanent
 firewall-cmd --reload

#修改配置文件，
#vi /var/lib/pgsql/13/data/pg_hba.conf

#[将host(远程连接)/local(本地连接)设置成md5(需要验证密码)或trust(不需要验证密码)]
#local all all 0.0.0.0/0 trust 

#修改配置文件，
#vi /var/lib/pgsql/13/data/postgresql.conf
#修改为listen_addresses='*'

#重启
#systemctl restart postgresql 或 systemctl restart postgresql.service
}

#服务查看
function getFirewallFun(){
 echo "===============查看开放的端口==============="
 firewall-cmd --list-ports
 
 echo "===============查看开放的服务==============="
 firewall-cmd --list-service
}



#开启防火墙
function firewalldFun(){
 sudo systemctl start firewalld
 sudo systemctl enable firewalld
 echo "===============防火墙状态===============" 
 sudo firewall-cmd --state
}

#放开端口
function portPublic(){
 for arg in "$@";do
  sudo firewall-cmd --zone=public --add-port=${arg}/tcp --permanent
 done
 echo "===============重启防火墙==============="
 sudo firewall-cmd --reload
}
#创建并进入目录
function mkdirFun(){
 mkdir $1
 cd $1
 echo "===============当前目录路径==============="
 pwd
}



echo -e "\033[31m！初始化配置里面不包含挂载盘符相关的文件夹配置，使用前请注意调整\033[0m"
echo "================选择您需要进行的操作(输入数字)，使用前请先输入1进行初始化操作================"
#echo "===0.退出 1.初始化配置 2.开放防火墙端口 3.查看开放服务状态 4.安装jdk 5.nginx安装 6.redis安装==="

while true;do

echo -e "\033[32m===0.退出 1.初始化配置 2.开放防火墙端口 3.查看开放服务状态===\033[0m"
echo -e "\033[32m===4.安装jdk 5.nginx安装 6.redis安装===\033[0m"
read -p "请输入你的选择:" num
 if [[ $num =~ ^[0-9]+$ ]];then
  echo "退出！" 
  if [ 0 == $num ];then
   break;
  elif [ 1 == $num ];then
     portPublic
  elif [ 2 == $num ];then
    read -p "请输入要开放的端口，以空格分隔(例如：22 3389): " params
    portPublic $params
  elif [ 3 == $num ];then
    getFirewallFun
  elif [ 4 == $num ];then
    jdkFun
  elif [ 5 == $num ];then
    nginxFun
  elif [ 6 == $num ];then
    redisFun
  elif [ 7 == $num ];then
   read -p "请输入要创建的路径: " urldir
    mkdirFun $urldir
  else
   break;
  fi
 else
 echo "请输入数字"
 fi
done
