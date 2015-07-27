#!/bin/bash

usage()
{
cat << EOF
usage: $0 

This script requires the following environment variables are set.

OPTIONS:
    DATABASE_NAME      
    DATABASE_USER
    DATABASE_PASSWORD
    DATABASE_PORT
    MIGRATIONS_PATH      
EOF
}

export MIGRATIONS_PATH=${MIGRATIONS_PATH:-'/home/flyway/migrations'}
export DATABASE_PORT=${DATABASE_PORT:-3306}

if [[ -z $DATABASE_NAME ]] || [[ -z $DATABASE_USER ]] || [[ -z $DATABASE_PASSWORD ]] || [[ -z $MIGRATIONS_PATH ]]; then
    usage
    exit 1
fi

while if ! nmap -T5 -p $DATABASE_PORT -sT db | grep open | wc -l ;then continue; else break;fi do break; done


flyway -url=jdbc:mysql://db:$DATABASE_PORT/$DATABASE_NAME -user=$DATABASE_USER -password=$DATABASE_PASSWORD -locations=filesystem:$MIGRATIONS_PATH migrate

