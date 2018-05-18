#!/bin/bash
set -e

cd /docker-entrypoint-initdb.d/ 
#wget https://raw.githubusercontent.com/apache/ambari/release-2.6.1/ambari-server/src/main/resources/Ambari-DDL-Postgres-CREATE.sql
#sed -i "s/\${ambariSchemaVersion}/2.6.1/g" Ambari-DDL-Postgres-CREATE.sql

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" <<-EOSQL
    create database ambari;
    create user ambari with password 'dev';
    GRANT ALL PRIVILEGES ON DATABASE ambari TO ambari;

    CREATE SCHEMA ambari AUTHORIZATION ambari;
    ALTER SCHEMA ambari OWNER TO ambari;
    ALTER SCHEMA public OWNER to ambari;

    ALTER ROLE ambari SET search_path to 'ambari', 'public';

    \connect ambari ambari;
    \i Ambari-DDL-Postgres-CREATE.sql 
EOSQL

cp /pg_hba.conf /var/lib/postgresql/data/
