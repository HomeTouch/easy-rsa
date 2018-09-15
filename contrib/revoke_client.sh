#!/bin/bash
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 USERNAME"
    exit 1
fi

CLIENT=$1

cd /etc/openvpn/easy-rsa/
./easyrsa --batch revoke $CLIENT
EASYRSA_CRL_DAYS=3650 ./easyrsa gen-crl
rm -f pki/reqs/$CLIENT.req
rm -f pki/private/$CLIENT.key
rm -f pki/issued/$CLIENT.crt
rm -f /etc/openvpn/crl.pem
cp /etc/openvpn/easy-rsa/pki/crl.pem /etc/openvpn/crl.pem
# CRL is read with each client connection, when OpenVPN is dropped to nobody
chown nobody:nogroup /etc/openvpn/crl.pem
echo "Certificate for client $CLIENT revoked!"
