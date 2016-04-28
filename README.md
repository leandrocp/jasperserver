# jasperserver


Jasperserver running on Docker, using mysql database and tomcat7 as webserver.

## How to build and run

```
docker-compose build --no-cache

docker-compose up
```

## Example of compose output

```
$ docker-compose ps
           Name                         Command             State               Ports
------------------------------------------------------------------------------------------------
jasperserver_jasperdata_1     true                          Exit 0
jasperserver_jasperserver_1   /entrypoint.sh jasperserver   Up       192.168.64.3:8080->8080/tcp
jasperserver_mysql_1          docker-entrypoint.sh mysqld   Up       192.168.64.3:3310->3306/tcp
jasperserver_mysqldata_1      docker-entrypoint.sh true     Exit 0
jasperserver_tomcatdata_1     true                          Exit 0
```
---------------------

Server url: http://{DOCKER_HOST}:8080/jasperserver
* User: jasperadmin
* Pass: jasperadmin