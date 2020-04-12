#!/usr/bin/env bash

echo "################################## Reloading nginx..."
/opt/nginx/envsubst_wrapper.sh
nginx -s reload
