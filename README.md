# containered-flywaydb

This project aims to be an easy way to do migrations for you withou resorting to ORMs, just 
plain old SQL files.

The following variables are available to configure the image:

* DATABASE_NAME sets the database that the migrations will be run into
* DATABASE_USER sets the database user that the migrations will be run with
* DATABASE_PASSWORD sets the database password the migrations will be run with
* DATABASE_PORT sets the database port
* DATABASE_ENCODING sets the encoding the database will expect
* DATABASE_DRIVER sets the database driver to be used eg. mysql
* MIGRATIONS_PATH sets the path the sql files will be found     

# Usage

Considering your current project has a path that contain the sql files named migrations/sql/*.sql ([follow flyway 
sql files convention](http://flywaydb.org/documentation/migration/sql.html)). Then
your docker-compose.yml file could look something like this:

## docker-compose.yml
```
data:
    image: debian:jessie
    volumes:
        - .:/var/www/html
migrations:
    image: rdccosmo/flywaydb
    volumes_from:
        - data
    links:
        - db
    environment:
        - DATABASE_NAME=dbname
        - DATABASE_USER=dbuser
        - DATABASE_PASSWORD=dbpass
        - DATABASE_PORT=3306
        - DATABASE_ENCODING=utf8
        - DATABASE_DRIVER=mysql
        - MIGRATIONS_PATH=/var/www/html/migrations/sql
php:
    build: php:5.6-fpm
    volumes_from:
        - data
    links:
        - db
    ports:
        - "80:80"
db:
    build: rdccosmo/mysql
    ports:
        -   "3306"
    environment:
        - MYSQL_ROOT_PASSWORD=root
        - MYSQL_USER=dbuser
        - MYSQL_PASSWORD=dbpass
        - MYSQL_DATABASE=dbname
```

OBS: the script that runs the migrations expects a database instance with name db, so if you name your database instance with a different name than db, remember to create a label mapping to db, like this:
```
links:
    mydb:db
```
