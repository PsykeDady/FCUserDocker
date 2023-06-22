FROM maven:3.9.2-eclipse-temurin-11

ARG MYSQL_DATABASE
ARG MYSQLDB_ROOT_PASSWORD

ENV MYSQL_DATABASE=$MYSQL_DATABASE
ENV MYSQLDB_ROOT_PASSWORD=$MYSQLDB_ROOT_PASSWORD

RUN git clone "http://github.com/PsykeDady/FCUser"

WORKDIR /FCUser

COPY sedparameter.sh .

RUN ./sedparameter.sh root $MYSQLDB_ROOT_PASSWORD

RUN mvn install

RUN ["/bin/bash", "-c", "cp target/*jar app.jar"]

RUN echo $MYSQL_DATABASE
RUN echo $MYSQLDB_ROOT_PASSWORD

RUN cat src/main/resources/application.properties

# RUN 

EXPOSE 8080
ENTRYPOINT ["java","-jar","app.jar"]

