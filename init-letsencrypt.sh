#!/bin/bash

# Check for docker-compose on this system
if ! [ -x "$(command -v docker-compose)" ]; then
  echo 'Error: docker-compose is not installed.' >&2
  exit 1
fi

# Pull in global env vars
source bot-variables.env

# Check for data path - should be empty
if [ -d "$DATA_PATH" ]; then
  read -p "Existing data found for $DOMAINS. Continue and replace existing certificate? (y/N) " decision
  if [ "$decision" != "Y" ] && [ "$decision" != "y" ]; then
    exit
  fi
fi

# Check for Lets encrypt config files
if [ ! -e "$DATA_PATH/conf/options-ssl-nginx.conf" ] || [ ! -e "$DATA_PATH/conf/ssl-dhparams.pem" ]; then
  echo "### Downloading recommended TLS parameters ..."
  mkdir -p "$DATA_PATH/conf"
  curl -s https://raw.githubusercontent.com/certbot/certbot/master/certbot-nginx/certbot_nginx/_internal/tls_configs/options-ssl-nginx.conf > "$DATA_PATH/conf/options-ssl-nginx.conf"
  curl -s https://raw.githubusercontent.com/certbot/certbot/master/certbot/certbot/ssl-dhparams.pem > "$DATA_PATH/conf/ssl-dhparams.pem"
  echo
fi

echo "### Creating dummy certificate for $DOMAINS ..."
path="/etc/letsencrypt/live/$DOMAINS"
mkdir -p "$DATA_PATH/conf/live/$DOMAINS"
docker-compose run --rm --entrypoint "\
  openssl req -x509 -nodes -newkey rsa:1024 -days 1\
    -keyout '$path/privkey.pem' \
    -out '$path/fullchain.pem' \
    -subj '/CN=localhost'" certbot
echo


echo "### Starting nginx ..."
docker-compose up --force-recreate -d nginx
echo

echo "### Deleting dummy certificate for $DOMAINS ..."
docker-compose run --rm --entrypoint "\
  rm -Rf /etc/letsencrypt/live/$DOMAINS && \
  rm -Rf /etc/letsencrypt/archive/$DOMAINS && \
  rm -Rf /etc/letsencrypt/renewal/$DOMAINS.conf" certbot
echo


echo "### Requesting Let's Encrypt certificate for $DOMAINS ..."
#Join $DOMAINS to -d args
domain_args=""
for domain in "${DOMAINS[@]}"; do
  domain_args="$domain_args -d $domain"
done

# Select appropriate email arg
case "$EMAIL" in
  "") email_arg="--register-unsafely-without-email" ;;
  *) email_arg="--email $EMAIL" ;;
esac

# Enable staging mode if needed
if [ $STAGING != "0" ]; then staging_arg="--staging"; fi

docker-compose run --rm --entrypoint "\
  certbot certonly --webroot -w /var/www/certbot \
    $staging_arg \
    $email_arg \
    $domain_args \
    --rsa-key-size $RSA_KEY_SIZE \
    --agree-tos \
    --force-renewal" certbot
echo

echo "### Reloading nginx ..."
docker-compose exec nginx /opt/nginx/reload_nginx.sh
