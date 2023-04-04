#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more detaitest -f.

# #############################################
# @Author    :   xiongneng
# @Contact   :   xiongneng@uniontech.com
# @Date      :   2023/04/04
# @License   :   Mulan PSL v2
# @Desc      :   Test libtasn1使用
# #############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh
function pre_test() {
	  LOG_INFO "Start to prepare the test environment."
	  DNF_INSTALL "libtasn1-devel libtasn1-tools"
	  LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start testing..."
    cat > example.asn <<EOF
MYPKIX1 {}
DEFINITIONS IMPLICIT TAGS ::=
BEGIN
OtherStruct ::= SEQUENCE {
    x       INTEGER,
    y       CHOICE {
    y1 INTEGER,
    y2 OCTET STRING
    }
}
Dss-Sig-Value ::= SEQUENCE {
    r       INTEGER,
    s       INTEGER,
    other   OtherStruct,
    z       INTEGER OPTIONAL
}
END
EOF
    CHECK_RESULT $? 0 0 "File creation failed"
    asn1Parser example.asn
    test -f example_asn1_tab.c
    CHECK_RESULT $? 0 0 "File generation failed"
    cat > example.asg <<EOF
dp MYPKIX1.Dss-Sig-Value

r 42
s 47
other.x 66
other.y y1
other.y.y1 15
z (NULL)

EOF
    CHECK_RESULT $? 0 0 "File creation failed"
    asn1Coding example.asn example.asg
    test -f example.out
    CHECK_RESULT $? 0 0 "File creation failed"
    asn1Decoding example.asn example.out MYPKIX1.Dss-Sig-Value
    CHECK_RESULT $? 0 0 "Failed to return the result"
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "Start to restore the tet environment."
    rm -rf example*
    DNF_REMOVE
    LOG_INFO "Finish to restore the tet environment."
}

main "$@"