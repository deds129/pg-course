!#/bin/zsh

# source: https://stackoverflow.com/questions/37694987/connecting-to-postgresql-in-a-docker-container-from-outside

# get list of containers
docker ps

# go inside container
docker exec -ti pg-course-psql-1 bash

# execute psql with postgres user
psql -U postgres

# run single command
psql -d my_database -c "SELECT * FROM my_table;"

# common commands 

# postgres version
SELECT VERSION();

# list of available commands
\?

# command history
\s

# get hlp
\h

# execute commands from file
\o <file_name>

# list of databases 
\l

#switch database
\c <database_name>

# list of all available tables
\dt

# list of all views
\dv

# list of all functions
\dv

# list of all users
\du

# discibe all tables
\d

# enable timing
\timing

# run previous command
\g


# quit psql
\q

# all active connections
SELECT * FROM pg_stat_activity;
SELECT * FROM pg_stat_activity WHERE datname = 'mydb' AND state = 'active';

# kill connect
SELECT pg_terminate_backend(1234);
