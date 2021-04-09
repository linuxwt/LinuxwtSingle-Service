alter user 'root'@'localhost' identified by 'linuxwt123';

create user 'root'@'%' identified by 'linuxwt@123';

grant all privileges on *.* to 'root'@'%';

flush privileges;
