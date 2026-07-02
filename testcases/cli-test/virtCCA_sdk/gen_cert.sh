#!/usr/bin/env bash
# =========================================================
# gen_cert.sh
#
# 基于指定 CA 生成服务端/客户端证书
# 支持:
#   - DNS SAN
#   - IP SAN
#   - 私钥加密 (AES-256, RSA 2048-bit)
#
# 用法:
#
#   chmod +x gen_cert.sh
#
#   # 交互式输入密码
#   ./gen_cert.sh \
#       --ca-cert ca.crt \
#       --ca-key ca.key \
#       --cn compute01 \
#       --dns compute01 \
#       --ip 90.91.185.56 \
#       --encrypt-key
#
#   # 不加密私钥
#   ./gen_cert.sh \
#       --ca-cert ca.crt \
#       --ca-key ca.key \
#       --cn compute01
#
# =========================================================

set -e

CA_CERT=""
CA_KEY=""
CN=""
KEY_PASS=""
ENCRYPT_KEY=false
OUT_DIR="./output"

DNS_LIST=()
IP_LIST=()

DAYS=365

usage() {
    cat <<EOF

Usage:
  $0 --ca-cert <ca.crt> --ca-key <ca.key> --cn <common_name> [options]

Required:
  --ca-cert        CA certificate path
  --ca-key         CA private key path
  --cn             Certificate Common Name

Optional:
  --dns            Add DNS SAN (can repeat)
  --ip             Add IP SAN (can repeat)
  --encrypt-key    Enable private key encryption (AES-256, RSA 2048-bit)
                   Password will be prompted interactively (no echo)
  --out-dir        Output directory (default: ./output)
  --days           Valid days (default: 365)

Example:
  # With encrypted private key
  $0 \\
    --ca-cert ca.crt \\
    --ca-key ca.key \\
    --cn compute01 \\
    --dns compute01 \\
    --ip 90.91.185.56 \\
    --encrypt-key

  # Without encryption
  $0 \\
    --ca-cert ca.crt \\
    --ca-key ca.key \\
    --cn compute01

EOF
}

while [[ $# -gt 0 ]]; do
    case "$1" in
        --ca-cert)
            CA_CERT="$2"
            shift 2
            ;;
        --ca-key)
            CA_KEY="$2"
            shift 2
            ;;
        --cn)
            CN="$2"
            shift 2
            ;;
        --encrypt-key)
            ENCRYPT_KEY=true
            shift
            ;;
        --dns)
            DNS_LIST+=("$2")
            shift 2
            ;;
        --ip)
            IP_LIST+=("$2")
            shift 2
            ;;
        --out-dir)
            OUT_DIR="$2"
            shift 2
            ;;
        --days)
            DAYS="$2"
            shift 2
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        *)
            echo "Unknown argument: $1"
            usage
            exit 1
            ;;
    esac
done

if [[ -z "$CA_CERT" || -z "$CA_KEY" || -z "$CN" ]]; then
    echo "ERROR: missing required arguments"
    usage
    exit 1
fi

# Read key password interactively (no echo)
if [[ "$ENCRYPT_KEY" == true ]]; then
    read -rs -p "Enter key password: " KEY_PASS
    echo
    read -rs -p "Confirm key password: " KEY_PASS_CONFIRM
    echo
    if [[ "$KEY_PASS" != "$KEY_PASS_CONFIRM" ]]; then
        echo "ERROR: Passwords do not match"
        exit 1
    fi
    if [[ -z "$KEY_PASS" ]]; then
        echo "ERROR: Key password cannot be empty"
        exit 1
    fi
fi

mkdir -p "$OUT_DIR"

KEY_FILE="${OUT_DIR}/${CN}.key"
CSR_FILE="${OUT_DIR}/${CN}.csr"
CRT_FILE="${OUT_DIR}/${CN}.crt"
PEM_FILE="${OUT_DIR}/${CN}.pem"
CONF_FILE="${OUT_DIR}/${CN}_openssl.cnf"

echo "Generating OpenSSL config..."

cat > "$CONF_FILE" <<EOF
[ req ]
default_bits       = 2048
prompt             = no
default_md         = sha256
req_extensions     = req_ext
distinguished_name = dn

[ dn ]
CN = ${CN}

[ req_ext ]
subjectAltName = @alt_names
keyUsage = critical, digitalSignature, keyEncipherment
extendedKeyUsage = serverAuth, clientAuth

[ alt_names ]
EOF

DNS_INDEX=1
for dns in "${DNS_LIST[@]}"; do
    echo "DNS.${DNS_INDEX} = ${dns}" >> "$CONF_FILE"
    DNS_INDEX=$((DNS_INDEX + 1))
done

IP_INDEX=1
for ip in "${IP_LIST[@]}"; do
    echo "IP.${IP_INDEX} = ${ip}" >> "$CONF_FILE"
    IP_INDEX=$((IP_INDEX + 1))
done

echo "Generating private key (RSA 2048-bit)..."

if [[ "$ENCRYPT_KEY" == true ]]; then
    openssl genrsa -aes256 -passout stdin -out "$KEY_FILE" 2048 <<< "$KEY_PASS"
else
    openssl genrsa -out "$KEY_FILE" 2048
fi

chmod 600 "$KEY_FILE"

echo "Generating CSR..."

if [[ "$ENCRYPT_KEY" == true ]]; then
    openssl req \
        -new \
        -key "$KEY_FILE" \
        -passin stdin \
        -out "$CSR_FILE" \
        -config "$CONF_FILE" <<< "$KEY_PASS"
else
    openssl req \
        -new \
        -key "$KEY_FILE" \
        -out "$CSR_FILE" \
        -config "$CONF_FILE"
fi

echo "Signing certificate with CA..."

openssl x509 \
    -req \
    -in "$CSR_FILE" \
    -CA "$CA_CERT" \
    -CAkey "$CA_KEY" \
    -CAcreateserial \
    -out "$CRT_FILE" \
    -days "$DAYS" \
    -sha256 \
    -extensions req_ext \
    -extfile "$CONF_FILE"

echo "Generating combined PEM..."

cat "$CRT_FILE" "$KEY_FILE" > "$PEM_FILE"

chmod 600 "$PEM_FILE"

# Clear password from shell variable
KEY_PASS=""
KEY_PASS_CONFIRM=""

echo
echo "================================================="
echo "Certificate generation completed"
echo "================================================="
echo "Key:         $KEY_FILE"
echo "Certificate: $CRT_FILE"
echo "PEM:         $PEM_FILE"
if [[ "$ENCRYPT_KEY" == true ]]; then
    echo "Key encrypted: AES-256 (RSA 2048-bit)"
fi
echo
echo "Verify SAN:"
echo "openssl x509 -in $CRT_FILE -text -noout"
echo "================================================="

