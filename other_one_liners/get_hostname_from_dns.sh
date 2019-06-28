#!/bin/sh
# From: ./get_all_ip_addresses.sh
IPV4="$(ip addr show | grep -Po 'inet \K[\d.]+' | grep -vE '^(192\.168|10\.|172\.1[6789]\.|172\.2[0-9]\.|172\.3[01]\.|127\.)')"
host -4  "$IPV4"  | cut -d ' ' -f 5 | sed -e 's/\.$//'
