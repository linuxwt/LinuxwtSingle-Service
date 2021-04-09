# cacti_spine
# 轮询器使用spine
# 使用supervisor管理多个进程
# 启动容器后，执行脚本cacti.sh，然后cacti数据库初始化，初始化步骤位
docker exec -it mysql_cacti bash  
mysql -u root -p  
create database cacti;  
use cacti;  
source /usr/local/Nginx/html/cacti/cacti/sql  
create user 'cactiuser'@'%' identified by 'cactipassword';  
create user 'cactiuser'@'localhost' identified by 'cactipassword';  
gran all on *.* to root;  
grant all on cacti.* to root@localhost;  
grant all on cacti.* to cactiuser;  
grant all on cacti.* to cactiuser@localhost  
vi /usr/local/Nginx/html/cacti/include/config.php  
