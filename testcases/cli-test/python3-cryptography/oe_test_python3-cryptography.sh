#!/usr/bin/bash

# #############################################
# @Author    :   xiechangyan1
# @Contact   :   xiechangyan@uniontech.com
# @Date      :   2023-8-2
# @License   :   Mulan PSL v2
# @Desc      :   Use oe_test_python3-cryptography case
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"


function run_test() {
    LOG_INFO "Start to run test."
    cat > /tmp/test.py << EOF
from cryptography.hazmat.primitives.asymmetric import rsa
from cryptography import x509


pem_cert=open("./cert.pem","rb").read()
cert=x509.load_pem_x509_certificate(pem_cert)
public_key = cert.public_key()
print(public_key)
EOF
    CHECK_RESULT $? 0 0 "Error,Please check the file 'test.py'"
    python3 /tmp/test.py | grep 'cryptography'
    CHECK_RESULT $? 0 0 "Error,Please check test.py"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm /tmp/test.py
    LOG_INFO "End to restore the test environment."
}

main "$@"
