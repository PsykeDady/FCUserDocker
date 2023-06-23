#!/bin/bash

function ctrl_c(){
	echo "terminando il processo...."
	docker container stop mysqldb
	docker container stop fcuser
	echo "Processo terminato!"

	exit 0
}

function runonly () {
	echo "STARTING "
	docker container run --name mysqldb --network springmysql -e MYSQL_ROOT_PASSWORD="$1" -e MYSQL_DATABASE=fcuser -d mysql  
	if (($?!=0)); then
		docker restart mysqldb || exit 255;
	fi
	docker container run --network springmysql --name fcuser -p 8080:8080 -d fcuser 
	if (($?!=0)); then
		docker restart fcuser || exit 255;
	fi
	docker logs -f fcuser
	ctrl_c
}

trap ctrl_c INT

MYSQL_PASSWORD=
force=0
runonly=0
forceparam=""

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

docker container stop mysqldb
docker container stop fcuser

if ((runonly==1)); then 
	runonly "${MYSQL_PASSWORD:?}"
fi

if ((force==1)); then 
	forceparam="--no-cache"
	docker container rm mysqldb
	docker container rm fcuser
	docker network rm springmysql
	docker network create springmysql || exit 255
fi

docker build --build-arg MYSQL_DATABASE=fcuser --build-arg MYSQLDB_ROOT_PASSWORD="${MYSQL_PASSWORD:?}" $forceparam  -t fcuser . 

if (($?!=0)); then
	exit 255
fi

runonly "${MYSQL_PASSWORD:?}"