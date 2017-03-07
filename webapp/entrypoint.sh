#!/bin/bash

set -e
run_cmd="dotnet run --server.urls http://*:5000"

# Try to create the database if the speciified database in the connection string doesnt exist
#   and then try to run the migrations to create the schema.
# Do this in a loop so that it handles any delay between when the app container comes up and SQL Server comes up.
until dotnet ef database update; do
>&2 echo "SQL Server is starting up"
sleep 1
done

>&2 echo "SQL Server is up - executing command"
exec $run_cmd