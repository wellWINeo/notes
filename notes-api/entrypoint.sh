#!/bin/sh

connection_string="postgres://$DB_USERNAME:$DB_PASSWORD@$DB_HOST:$DB_PORT/$DB_NAME"

echo $connection_string

dart run conduit db upgrade --connect $connection_string || exit 1

dart run conduit serve --port 80