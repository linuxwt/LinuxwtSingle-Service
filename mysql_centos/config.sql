alter user 'root'@'localhost' identified by 'Gooalgene@123';

create user 'root'@'%' identified by 'Gooalgene@123';

create database linuxwt;

create user 'linuxwt'@'localhost' identified by 'Gooalgene@123';

create user 'linuxwt'@'%' identified by 'Gooalgene@123';

grant all privileges on *.* to 'root'@'%';

grant all privileges on linuxwt.* to 'linuxwt'@'localhost';

grant all privileges on linuxwt.* to 'linuxwt'@'%';  


flush privileges;
