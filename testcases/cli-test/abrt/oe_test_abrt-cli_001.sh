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
# @Author    :   huangrong
# @Contact   :   1820463064@qq.com
# @Date      :   2023/04/20
# @License   :   Mulan PSL v2
# @Desc      :   Test abrtd.service restart
# #############################################

source "../common/common_lib.sh"

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL "abrt-cli abrt abrt-addon-ccpp "
    cp /etc/abrt/abrt-action-save-package-data.conf /etc/abrt/abrt-action-save-package-data.conf_bak
    echo 'ProcessUnpackaged=yes' >> /etc/abrt/abrt-action-save-package-data.conf
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    systemctl start abrtd
    CHECK_RESULT $? 0 0 "abrtd service start fail"
    systemctl start abrt-journal-core
    CHECK_RESULT $? 0 0 "abrt-journal-core service start fail"
    cat > test.c <<EOF
    #include <stdio.h>
int main(){
char *p;
p = NULL;
*p = 'x';
printf("%c", *p);
return 0;
}
EOF
    gcc -o test test.c   
    test -e test 
    CHECK_RESULT $? 0 0 "Compilation failure"
    ./test 
    CHECK_RESULT $? 0 1 "Test fail"	
    abrt-cli list | grep Id
    CHECK_RESULT $? 0 0 "Execution failure"
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    DNF_REMOVE
    rm -rf test.c test
    mv -f /etc/abrt/abrt-action-save-package-data.conf_bak /etc/abrt/abrt-action-save-package-data.conf
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
