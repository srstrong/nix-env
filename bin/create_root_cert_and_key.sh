#!/usr/bin/env bash
openssl genrsa -out rootCA.key 2048
openssl req -x509 -new -nodes -key rootCA.key -sha256 -days 1024 -out rootCA.pem -batch -subj "/C=US/ST=CA/O=id3as, Inc./CN=steve-dev-root-ca"
