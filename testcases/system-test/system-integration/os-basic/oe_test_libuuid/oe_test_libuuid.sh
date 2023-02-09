#!/usr/bin/bash

# Copyright (c) 2023 Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   pengrui
# @Contact   :   pengrui@uniontech.com
# @Date      :   2023.2.9
# @License   :   Mulan PSL v2
# @Desc      :   File system common command test-libuuid
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test(){
    LOG_INFO "Start environment preparation."
    cat > /tmp/test_uuid.c  <<EOF
#include <stdio.h>
#include <uuid/uuid.h>
// gcc test_uuid.c -luuid -o uuid
int main()
{
int i,n;
uuid_t uu[4];
char buf[1024];
struct timeval tv;
//1、
uuid_generate(uu[0]);
//2、
uuid_generate_random(uu[1]);
//3、
uuid_generate_time(uu[2]);
//4、
n = uuid_generate_time_safe(uu[3]);
printf("n = %d\n",n);
for(i=0;i<4;++i){
uuid_unparse(uu[i],buf);
printf("uu[%d]\t\t%s\n",i,buf);
}
uuid_time(uu[2],&tv);
printf("tv s:%lx  u:%lx\n",tv.tv_sec,tv.tv_usec);
return 0;
}
EOF
    yum install libuuid-devel -y
    yum install libuuid -y
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    rpm -qa | grep libuuid
    CHECK_RESULT $? 0 0 "Return value error"
    cd /tmp && gcc test_uuid.c -luuid -o uuid
    test -f /tmp/uuid
    CHECK_RESULT $? 0 0 "compile testfile fail"    
    ./uuid > uuid.txt
    test -f /tmp/uuid.txt
    CHECK_RESULT $? 0 0 "Generate data fail "
    cat /tmp/uuid.txt | grep tv
    CHECK_RESULT $? 0 0 "information is error"   
}

function post_test() {
    LOG_INFO "start environment cleanup."
    rm -rf /tmp/uuid.c
    rm -rf /tmp/uuid
    rm -rf /tmp/uuid.txt
    rpm -e libuuid --nodeps
    rpm -e util-linux-devel --nodeps
    LOG_INFO "Finish environment cleanup!"
}

main $@
