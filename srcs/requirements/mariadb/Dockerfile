FROM debian:stable-slim

#PLACEHOLDERS for enviroment
# ENV MYSQL_ROOT_PASSWORD=changeme
# ENV MYSQL_DATABASE=placeholder_db
# ENV MYSQL_USER=placeholder_user
# ENV MYSQL_PASSWORD=placeholder_pass

#run this when building docker image
RUN apt -y update && apt install -y mariadb-server
RUN rm -rf /var/lib/apt/lists/*
RUN mkdir -p /run/mysqld
RUN chown mysql:mysql /run/mysqld 
RUN apt install -y mariadb-server mariadb-client

#create and bind a volume for this image
VOLUME ["/var/lib/mysql"]

#expose a listening port
EXPOSE 3306

COPY tools/entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]

# docker exec -it maria mysql -u root -p // to test if db is running

#SHOW DATABASES; // in mariadb 
