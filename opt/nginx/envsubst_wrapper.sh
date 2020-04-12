#!/usr/bin/env bash

echo "################################## Substitute Environment Variables in Nginx Config"

export DOLLAR='$'
envsubst < /opt/nginx/app.conf.template > /etc/nginx/conf.d/app.conf
