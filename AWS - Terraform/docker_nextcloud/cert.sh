#!/bin/bash

openssl req -x509 -out localhost.crt -keyout localhost.key \
  -newkey rsa:2048 -nodes -sha256 \
  -subj '/CN=groupefyb.fr' -extensions EXT -config <( \
   printf "[dn]\nCN=groupefyb.fr\n[req]\ndistinguished_name = dn\n[EXT]\nsubjectAltName=DNS:groupefyb.fr\nkeyUsage=digitalSignature\nextendedKeyUsage=serverAuth")

cp localhost.crt /etc/nginx/localhost.crt
cp localhost.key /etc/nginx/localhost.key