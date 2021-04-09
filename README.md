## 该仓库利用docker部署cacti
### 系统环境   
Centos 7.5   
### 软件环境   
docker 18.03.1-ce   
docker-compose 1.19.0-rc2    
mysql 5.7  
php 5.6  
nginx >=1. 0   
### 使用说明   
首先，拉取仓库，执行脚本   
bash yum.sh && bash ntp.sh && bash env.sh  
构建镜像nginx:cacti、php:cacti、mysql:cacti     
docker build -t nginx:cacti -f Dockerfile_nginx .  
docker build -t php:cacti -f Dockerfile_phpsp .   
docker pull mysql:5.7   
然后，执行脚本bash container/start    
最后,访问http://ip/cacti完成安装，完成安装后登陆cacti,默认账号密码为admin/admin，修改初始密码后登陆，登陆成功,有三处需要设置 

![path](https://github.com/linuxwt/Cacti_Docker/blob/master/setjpg1.jpg)    

![poller](https://github.com/linuxwt/Cacti_Docker/blob/master/setjpg2.jpg)   

![general](https://github.com/linuxwt/cacti_Docker/blob/master/setjpg3.jpg) 

执行脚本bash container/poller.sh添加采集数据的计划任务   

## 特别注意
2、通过同一个docker-compose.yml文件编排,将cacti源代码映射到三个容器里面   
3、mysql的密码已经设置成linuxwt123了   
4、脚本中会依据网卡名字来获取服务器ip，这里的网卡名字为ens33，根据自身服务器网卡名去ntp.sh和client_snmp.sh里修改    
5、被监控机器需要与cacti服务器时间同步   
6、如果想要监控某一个主机，需要配置snmp，可以执行脚本bash client_snmp.sh来推送相关脚本到远程的主机上进行配置   
7、如果使用pip安装docker-compose出错，可以访问地址https://pypi.douban.com/simple,下载whl格式的包，上传至服务器，使用
pip install *.whl安装   

## 参考文章   
https://linuxwt.com/cactibu-shu-er/   
