#!/bin/bash

sed "s/USERNAME/$1/" src/main/resources/application.properties | tee application.properties
sed "s/PASSWORD/$2/" application.properties | tee src/main/resources/application.properties
sed "s/127.0.0.1/mysqldb/" src/main/resources/application.properties | tee application.properties

mv -f application.properties src/main/resources/application.properties

