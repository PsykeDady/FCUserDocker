#!/bin/bash

function ctrl_c(){
	echo "terminando il processo...."
	docker container stop mysqldb
	docker container stop fcuser
	echo "Processo terminato!"

	exit 0
}

trap ctrl_c INT

MYSQL_PASSWORD=
force=0
runonly=0

while (( $# >0 )); do 
	case $1 in 
		"-f"|"--force") force=1;;
		"-r"|"--runonly") runonly=1;;
		*) 
			echo "bad param $1"
		;;
	esac
	shift
done;

runonly () {
	echo "STARTING "
	docker container run --network springmysql --name fcuser -p 8080:8080 -d fcuser 
	docker logs -f fcuser
	ctrl_c
}


docker container stop mysqldb
docker container stop fcuser

if ((runonly==1)); then 
	runonly
fi

if ((force==1)); then 
	forceparam="--no-cache"
	docker container rm mysqldb
	docker container rm fcuser
	docker network rm springmysql
	docker network create springmysql || exit 255
fi


docker container run --name mysqldb --network springmysql -e MYSQL_ROOT_PASSWORD="${MYSQL_PASSWORD:?}" -e MYSQL_DATABASE=fcuser -d mysql  || exit 255

docker build --build-arg MYSQL_DATABASE=fcuser --build-arg MYSQLDB_ROOT_PASSWORD="${MYSQL_PASSWORD:?}"  -t fcuser . "$forceparam" || exit 255

runonly