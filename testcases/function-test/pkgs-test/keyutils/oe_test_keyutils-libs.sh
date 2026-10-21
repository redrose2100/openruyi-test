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
# @Author    :   geyaning
# @Contact   :   geyaning@uniontech.com
# @Date      :   2023/04/18
# @License   :   Mulan PSL v2
# @Desc      :   keyutils basic library call
# #############################################

source "../common/common_lib.sh"

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL "keyutils keyutils-libs-devel gcc"
    mkdir /tmp/test
    Directory=/tmp/test
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    cd $Directory
    cat > t_request_key.c <<-EOF
/* t_request_key.c */

#include <sys/types.h>
#include <keyutils.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(int argc, char *argv[])
{
key_serial_t key;

if (argc != 4) {
fprintf(stderr, "Usage: %s type description callout-data\n",
argv[0]);
exit(EXIT_FAILURE);
}

key = request_key(argv[1], argv[2], argv[3],
KEY_SPEC_SESSION_KEYRING);
if (key == -1) {
perror("request_key");
exit(EXIT_FAILURE);
}

printf("Key ID is %lx\n", (long) key);

exit(EXIT_SUCCESS);
}

EOF
    gcc -lkeyutils t_request_key.c -o test
    CHECK_RESULT $? 0 0 "t_request_key.c failed to compile"
    cp /etc/request-key.conf /etc/request-key.conf_bak
    echo 'create user mtk:* * /bin/keyctl instantiate %k %c %S' >>/etc/request-key.conf
    CHECK_RESULT $? 0 0 "support info error"
    ./test user mtk:key1 "Payload data" >tmp.log 2>&1
    key_id=$(cat tmp.log | awk '{print $NF}')
    grep ${key_id} /proc/keys
    CHECK_RESULT $? 0 0 "import key error"
    LOG_INFO "Finish testing!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    mv -f /etc/request-key.conf_bak /etc/request-key.conf
    DNF_REMOVE
    rm -rf $Directory
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
