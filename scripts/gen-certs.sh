#!/bin/bash
cd "$(dirname "$0")/.."
mkdir -p nginx/certs
MSYS2_ARG_CONV_EXCL='*' openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout nginx/certs/key.pem \
  -out nginx/certs/cert.pem \
  -subj '/C=TH/ST=Bangkok/L=Bangkok/O=RMUTL/OU=ENGSE207/CN=localhost'
echo "Certificate created in nginx/certs/"