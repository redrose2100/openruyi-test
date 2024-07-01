#!/usr/bin/bash

# Copyright (c) 2024 Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   liangjiayu01
# @Contact   :   liangjiayu@uniontech.com
# @Date      :   2024-07-01
# @License   :   Mulan PSL v2
# @Desc      :   test c/c++/python idna
# ############################################

source "$OET_PATH"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start environment preparation."
    DNF_INSTALL "python2-idna python3-idna"
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    cat > test.py << EOF
import idna
unicode_domain = "xn--p1ai"
decoded_domain = idna.decode(unicode_domain)
print(f"Decoded domain: {decoded_domain}")
ascii_domain = "example.com"
encoded_domain = idna.encode(ascii_domain).decode('ascii')
print(f"Encoded domain (although it's already ASCII): {encoded_domain}")
unicode_domain_with_non_ascii = "пример.рф"
encoded_domain_with_non_ascii = idna.encode(unicode_domain_with_non_ascii).decode('ascii')
print(f"Encoded domain with non-ASCII characters: {encoded_domain_with_non_ascii}")
EOF
    CHECK_RESULT $? 0 0 "Error, fail to create test.py"
    python3 test.py | grep "Decoded domain: рф"
    LOG_INFO "End test!"
}

function post_test() {
    LOG_INFO "start environment!"
    DNF_REMOVE "$@"
    rm -rf test.py
    LOG_INFO "end environment!"
}

main "$@"

