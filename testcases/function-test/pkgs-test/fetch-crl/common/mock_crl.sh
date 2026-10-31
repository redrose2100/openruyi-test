#!/usr/bin/bash

source "${OET_PATH}/libs/locallibs/common_lib.sh"

function setup_mock_crl(){
  # setup_mock_crl.sh - 为 fetch-crl 测试准备有效的 KEK.pem + CRL 服务

  TEST_DIR="/opt/mugen/testcases/function-test/pkgs-test/fetch-crl/data"
  CA_DIR="$TEST_DIR/ca"
  HTTP_PORT=8000
  CERTS_DIR="/etc/grid-security/certificates"

  # 创建目录
  mkdir -p "$CA_DIR"/{certs,crl,newcerts,private}
  cd "$CA_DIR" || exit 1
  chmod 700 private
  touch index.txt
  echo 1000 > serial
  echo 1000 > crlnumber

  # OpenSSL 配置
  cat>openssl.cnf<<EOF
  [ ca ]
  default_ca = CA_default

  [ CA_default ]
  dir            = $CA_DIR
  certs          = \$dir/certs
  crl_dir        = \$dir/crl
  new_certs_dir  = \$dir/newcerts
  database       = \$dir/index.txt
  serial         = \$dir/serial
  crlnumber      = \$dir/crlnumber
  private_key    = \$dir/private/ca.key.pem
  certificate    = \$dir/certs/ca.cert.pem
  default_days   = 365
  default_crl_days= 30
  default_md     = sha256
  preserve       = no
  policy         = policy_any

  [ policy_any ]
  countryName             = optional
  stateOrProvinceName     = optional
  localityName            = optional
  organizationName        = optional
  organizationalUnitName  = optional
  commonName              = supplied
  emailAddress            = optional

  [ req ]
  default_bits        = 2048
  distinguished_name  = req_distinguished_name
  x509_extensions     = v3_ca
  prompt              = no

  [ req_distinguished_name ]
  CN = Test KEK CA

  [ v3_ca ]
  subjectKeyIdentifier = hash
  authorityKeyIdentifier = keyid:always,issuer
  basicConstraints = critical, CA:true
  keyUsage = critical, digitalSignature, cRLSign, keyCertSign
EOF
  # 生成 CA 私钥和证书（KEK.pem）
  openssl genrsa -out private/ca.key.pem 2048
  openssl req -x509 -new -key private/ca.key.pem -out certs/ca.cert.pem \
    -config openssl.cnf -extensions v3_ca -days 3650
  # 生成 CRL（DER 格式，fetch-crl 默认要求）
  openssl ca -gencrl -out crl/crl.der -config openssl.cnf -crldays 30
  # 验证 CRL（可选）
  # openssl crl -inform DER -in crl/crl.der -text -noout

  # 准备测试文件
  cp certs/ca.cert.pem "$TEST_DIR/KEK.pem"
  echo "http://127.0.0.1:$HTTP_PORT/crl/crl.der" > "$TEST_DIR/KEK.crl_url"

  # 确保证书目录存在
  sudo mkdir -p "$CERTS_DIR"

  # 复制到系统目录
  sudo cp "$TEST_DIR/KEK.pem" "$CERTS_DIR/"
  sudo cp "$TEST_DIR/KEK.crl_url" "$CERTS_DIR/"

  # 启动 HTTP 服务（后台）
  echo "Starting HTTP server on http://127.0.0.1:$HTTP_PORT ..."
  python3 -m http.server "$HTTP_PORT" --bind 127.0.0.1 > /dev/null 2>&1 &
  HTTP_PID=$!

  #back to testcase dir
  cd ../..

  # 保存 PID 供后续清理
  echo $HTTP_PID > "$TEST_DIR/http.pid"

  echo "✅ Mock CRL environment ready!"
  echo "KEK.pem -> $CERTS_DIR/KEK.pem"
  echo "KEK.crl_url -> $CERTS_DIR/KEK.crl_url (points to local CRL)"
  echo "HTTP server PID: $HTTP_PID"
}

function setdown_mock_crl(){
  TEST_DIR="/opt/mugen/testcases/function-test/pkgs-test/fetch-crl/data"
  CERTS_DIR="/etc/grid-security/certificates"
  pid=$(cat $TEST_DIR/http.pid)
  kill -9 "$pid"
  rm -rf $TEST_DIR $CERTS_DIR
}
