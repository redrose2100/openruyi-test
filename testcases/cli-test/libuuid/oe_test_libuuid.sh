#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more detaitest -f.

# ##############################################################################################################
# @Author    :   kouhuiying
# @Contact   :   kouhuiying@uniontech.com
# @Date      :   2023/02/07
# @License   :   Mulan PSL v2
# @Desc      :   libuuid function
# ##############################################################################################################
source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment!"
    DNF_INSTALL libuuid
    LOG_INFO "End to prepare the test environment!"
}

function run_test() {
    LOG_INFO "Start executing testcase!"
cat > test_uuid.c <<-EOF
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
    gcc test_uuid.c -luuid -o uuid
    CHECK_RESULT $? 0 0 "compilation fail"
    ./uuid &> uuid_log
    CHECK_RESULT $? 0 0 "excute fail"
    num_uuid=$(grep uu uuid_log | wc -l)
    CHECK_RESULT "${num_uuid}" 4 0 "uuid generate fail"
    LOG_INFO "End of testcase execution!"
}

function post_test() {
    LOG_INFO "Start environment cleanup."
    DNF_REMOVE
    rm -fr uuid* test_uuid.c
    LOG_INFO "Finish environment cleanup."
}

main $@
