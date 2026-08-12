#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
#@Author    	:   wangshan
#@Contact   	:   wang_shan001@hoperun.com
#@Date      	:   2024-01-23 14:39:43
#@License   	:   Mulan PSL v2
#@Desc      	:   Run cracklib testsuite
#####################################
# shellcheck disable=SC1091
source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    cat >"test-data" <<EOF
antzer
G@ndalf
neulinger
lantzer
Pa\$\$w0rd
PaS\$W0rd
Pas\$w0rd
Pas\$W0rd
Pa\$sw0rd
Pa\$sW0rd
EOF

    cat >"format-data" <<EOF
antzer
g@ndalf
lantzer
neulinger
pa\$\$w0rd
pa\$sw0rd
pas\$w0rd
EOF
    echo -e "2948_Obaym-" >pw_dict.new
    LOG_INFO "Finish preparing the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    echo -e "test" | cracklib-check | grep -q "too short"
    CHECK_RESULT $? 0 0 "check cracklib-check failed"
    echo -e "testing" | cracklib-check | grep -q "dictionary"
    CHECK_RESULT $? 0 0 "check cracklib-check failed"
    echo -e "1234_abc" | cracklib-check | grep -q 'simplistic'
    CHECK_RESULT $? 0 0 "check cracklib-check failed"
    echo -e "2948_Obaym-" | cracklib-check | grep -q "OK"
    CHECK_RESULT $? 0 0 "cracklib-check failed"

    cracklib-format test-data >format-dict
    CHECK_RESULT $? 0 0 "check cracklib-foramt failed"
    diff format-data format-dict >/dev/null
    CHECK_RESULT $? 0 0 "check cracklib-foramt result error"

    cracklib-format test-data | cracklib-packer words
    CHECK_RESULT $? 0 0 "check cracklib-packer failed"
    [ -f words.hwm ] && [ -f words.pwd ] && [ -f words.pwi ]
    CHECK_RESULT $? 0 0 "check cracklib-packer failed"

    cracklib-unpacker words >unpacker-data
    CHECK_RESULT $? 0 0 "check cracklib-unpacker failed"
    diff format-data unpacker-data >/dev/null
    CHECK_RESULT $? 0 0 "check cracklib-unpacker result error"
    cracklib-unpacker /usr/share/cracklib/pw_dict >pw_dict.orig
    CHECK_RESULT $? 0 0 "check cracklib-unpacker failed"

    create-cracklib-dict pw_dict.new
    CHECK_RESULT $? 0 0 "check create-cracklib-dict failed"
    echo -e "2948_Obaym-" | cracklib-check | grep -q "dictionary"
    CHECK_RESULT $? 0 0 "check create-cracklib-dict failed"
    create-cracklib-dict pw_dict.orig
    CHECK_RESULT $? 0 0 "check create-cracklib-dict failed"
    echo -e "2948_Obaym-" | cracklib-check | grep -q "OK"
    CHECK_RESULT $? 0 0 "check create-cracklib-dict failed"
    create-cracklib-dict -o output test-data
    CHECK_RESULT $? 0 0 "check create-cracklib-dict option --output failed"
    [ -f output.hwm ] && [ -f output.pwd ] && [ -f output.pwi ]
    CHECK_RESULT $? 0 0 "check cracklib-packer failed"
    create-cracklib-dict -h | grep -q "This help output"
    CHECK_RESULT $? 0 0 "check create-cracklib-dict option --help failed"

    LOG_INFO "End of the test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."

    create-cracklib-dict pw_dict.orig
    rm -rf test-data format-data format-dict pw_dict.new pw_dict.orig words.hwm words.pwd words.pwi unpacker-data output.hwm output.pwd output.pwi

    LOG_INFO "End to restore the test environment."
}

main "$@"
