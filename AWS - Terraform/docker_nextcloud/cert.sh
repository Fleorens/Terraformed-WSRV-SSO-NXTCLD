#!/bin/bash

openssl req -x509 -out localhost.crt -keyout localhost.key \
  -newkey rsa:2048 -nodes -sha256 \
  -subj '/CN=localhost.fr' -extensions EXT -config <( \
   printf "[dn]\nCN=localhost.fr\n[req]\ndistinguished_name = dn\n[EXT]\nsubjectAltName=DNS:localhost.fr\nkeyUsage=digitalSignature\nextendedKeyUsage=serverAuth")

cp localhost.crt /etc/nginx/localhost.crt
cp localhost.key /etc/nginx/localhost.key