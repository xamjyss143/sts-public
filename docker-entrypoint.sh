#!/bin/sh
set -e

NGINX_CONF="/etc/nginx/nginx.conf"
GCP_HOST="${GCP_HOST:sts-public-771699844894.us-central1.run.app}"
API_URL="https://vpnhub.cloud/xjvpn/api/server/register-gcp"

awk '
/location \/[a-z0-9]+ \{/ {
    path=$2
}
/proxy_pass http:\/\/[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+:700;/ {
    gsub(";", "", $2)
    gsub("http://", "", $2)
    split($2, parts, ":")
    ip=parts[1]
    print path "|" ip
}
' "$NGINX_CONF" | while IFS="|" read -r gcp_path ip; do
    code=$(echo "$gcp_path" | sed 's#^/##')
    gcp_xray_path="/vmess_${code}"

    echo "Registering $ip -> $gcp_path -> $gcp_xray_path"

    curl -X POST "$API_URL" \
      -H "Content-Type: application/json" \
      -d "{
        \"ip\": \"$ip\",
        \"gcp_host\": \"$GCP_HOST\",
        \"gcp_path\": \"$gcp_path\",
        \"gcp_xray_path\": \"$gcp_xray_path\"
      }"
done

exec nginx -g 'daemon off;'
