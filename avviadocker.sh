#!/bin/bash

function ctrl_c(){
	echo "terminando il processo...."
	docker container stop mysqldb
	docker container rm mysqldb

	docker container stop fcuser
	docker container rm fcuser

	docker network rm springmysql
	echo "Processo terminato!"

	exit 0
}

trap ctrl_c INT

MYSQL_PASSWORD=

docker container stop mysqldb
docker container rm mysqldb

docker container stop fcuser
docker container rm fcuser

docker network rm springmysql
docker network create springmysql || exit 255

docker container run --name mysqldb --network springmysql -e MYSQL_ROOT_PASSWORD="${MYSQL_PASSWORD:?}" -e MYSQL_DATABASE=fcuser -d mysql  || exit 255

docker build --build-arg MYSQL_DATABASE=fcuser --build-arg MYSQLDB_ROOT_PASSWORD="${MYSQL_PASSWORD:?}"  -t fcuser . --no-cache || exit 255

echo "STARTING "
docker container run --network springmysql --name fcuser -p 8080:8080 -d fcuser 

docker logs -f fcuser



ctrl_c