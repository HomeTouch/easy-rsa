#!/bin/bash
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 USERNAME PASSWORD"
    exit 1
fi

CERTS="/etc/openvpn/client-certs"
mkdir -p $CERTS

newclient () {
	cd /etc/openvpn/easy-rsa/
    ./easyrsa build-client-full $1 pass:$2 # nopass
	# Generates the custom client.ovpn
	cp /etc/openvpn/client-common.txt $CERTS/$1.ovpn
	echo "<ca>" >> $CERTS/$1.ovpn
	cat /etc/openvpn/easy-rsa/pki/ca.crt >> $CERTS/$1.ovpn
	echo "</ca>" >> $CERTS/$1.ovpn
	echo "<cert>" >> $CERTS/$1.ovpn
	cat /etc/openvpn/easy-rsa/pki/issued/$1.crt >> $CERTS/$1.ovpn
	echo "</cert>" >> $CERTS/$1.ovpn
	echo "<key>" >> $CERTS/$1.ovpn
	cat /etc/openvpn/easy-rsa/pki/private/$1.key >> $CERTS/$1.ovpn
	echo "</key>" >> $CERTS/$1.ovpn
	echo "<tls-auth>" >> $CERTS/$1.ovpn
	cat /etc/openvpn/ta.key >> $CERTS/$1.ovpn
	echo "</tls-auth>" >> $CERTS/$1.ovpn
}

newclient $1 $2

