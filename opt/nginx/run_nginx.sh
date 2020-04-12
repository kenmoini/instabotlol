#!/usr/bin/env bash

echo "################################## Run nginx"
/opt/nginx/envsubst_wrapper.sh
nginx -g "daemon off;"
