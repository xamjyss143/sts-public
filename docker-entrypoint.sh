#!/bin/sh
set -e

PUBLIC_IP="${SERVER_IP}"
GCP_HOST="${GCP_HOST}"
GCP_PATH="${GCP_PATH}"
GCP_XRAY_PATH="${GCP_XRAY_PATH}"

curl -X POST "https://vpnhub.cloud./xjvpn/api/server/register-gcp" \
  -H "Content-Type: application/json" \
  -d "{
    \"ip\": \"$PUBLIC_IP\",
    \"gcp_host\": \"$GCP_HOST\",
    \"gcp_path\": \"$GCP_PATH\",
    \"gcp_xray_path\": \"$GCP_XRAY_PATH\"
  }" || true

exec nginx -g 'daemon off;'
