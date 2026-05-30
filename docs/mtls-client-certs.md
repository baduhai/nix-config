# mTLS Client Certificates

Public-facing services on trantor require a client certificate signed by the internal CA.
This doc covers generating and installing a client cert.

## Generate a client certificate

Requires `rage` and `openssl`. Run from the repo root:

```bash
mkdir -p /tmp/mtls-cert && cd /tmp/mtls-cert

# Decrypt the CA key (you need one of the user SSH keys from secrets.nix)
rage -d -i ~/.ssh/id_ed25519 -o ca.key secrets/rss-mtls-ca.key.age
rage -d -i ~/.ssh/id_ed25519 -o ca.crt secrets/rss-mtls-ca.crt.age

# Generate and sign a client cert (change CN to identify the device)
CN="my-device"
openssl genrsa -out client.key 2048
openssl req -new -key client.key -out client.csr -subj "/CN=$CN"
openssl x509 -req -days 365 -in client.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out client.crt

# Package for browser/OS import (set a password; Android requires non-empty)
openssl pkcs12 -export -out client.p12 -inkey client.key -in client.crt -certfile ca.crt -passout pass:baduhai

rm -f ca.key ca.crt client.key client.csr client.crt
```

## Install

### Android

1. Transfer `client.p12` to the phone
2. Settings → Security → More security → Encryption & credentials → Install a certificate → **VPN & app user certificate**
3. Select the file, enter the PKCS12 password

### Desktop (Firefox)

1. Settings → Privacy & Security → Certificates → View Certificates → Your Certificates → Import
2. Select `client.p12`, enter the password

### Desktop (Chrome/Chromium)

Settings → Privacy & Security → Security → Manage certificates → Your Certificates → Import
