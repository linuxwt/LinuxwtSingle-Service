#!/bin/bash

/usr/bin/docker exec php_cacti  /usr/local/php/bin/php /usr/local/Nginx/html/cacti/poller.php --force
