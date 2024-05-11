#!/usr/bin/bash

# Copyright (c) 2024. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more detaitest -f.

# #############################################
# @Author    :   pengrui
# @Contact   :   pengrui@uniontech.com
# @Date      :   2024/04/29
# @License   :   Mulan PSL v2
# @Desc      :   elfutils package testing
# #############################################

source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test(){
    LOG_INFO "Start environment preparation." 
    mkdir /tmp/elfutils   
    cat > /tmp/elfutils/app.c << EOF
#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <errno.h>
#include <stdint.h>

void bug(int id) {
  /* illegal pointer, si_code = 128 (send by kernel) */
  printf("[%d] This is bug\n", id);
  int *p = (int *)-1;
  printf("%d\n", *p);
}

void extra_func() {
  printf("");
}

int func_b(int id)
{
  printf("[%d] This is func_b\n", id);
  sleep(rand()%5);
  extra_func();
  bug(id);
  extra_func();
}

int func_a(int id)
{
  printf("[%d] This is func_a\n", id);
  sleep(rand()%5);
  extra_func();
  func_b(id);
  extra_func();
}

void* func(void* param) {
  int id = (int)param;
  sleep(1);
  extra_func();
  func_a(id);
  extra_func();
  return NULL;
}

int main(int argc, char *argv[])
{
  int i;
  for(i = 0; i < 10; ++i) {
    pthread_t pid;
    if (0 != pthread_create(&pid, NULL, func, (void*)i)) {
      fprintf(stderr, "create thread %d failed (%d).\n", errno);
      exit(1);
    }
  }

  sleep(100);

  return 0;
}
EOF

    DNF_INSTALL "elfutils gcc"
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    rpm -qa | grep elfutils
    CHECK_RESULT $? 0 0 "Return value error"
    cd /tmp/elfutils && gcc -g -O2 app.c -lm -lpthread -o app
    CHECK_RESULT $? 0 0 "Compilation failed"
    objcopy --only-keep-debug app app.debug  
    strip app  
    objcopy --add-gnu-debuglink=app.debug app  
    cp ./app.debug ./app_debug  
    eu-unstrip ./app ./app_debug  
    ulimit -c unlimited
    test -f /tmp/elfutils/app_debug
    CHECK_RESULT $? 0 0 "Execution failed"
    cd /tmp/elfutils/ && ./app
    coredumpctl -r -1 -o app.core dump app > dump.txt
    test -f /tmp/elfutils/app.core
    CHECK_RESULT $? 0 0 "Collapse failure"
    cd /tmp/elfutils/ || exit
    nu=$(sed -n '$p' dump.txt | awk '{print $3}')
    eu-addr2line -e ./app_debug --core ./app.core "$nu"
    CHECK_RESULT $? 0 0 "Acquisition failed"

}

function post_test() {
    LOG_INFO "start environment cleanup."
    rm -rf /tmp/elfutils 
    DNF_REMOVE "$@"
    LOG_INFO "Finish environment cleanup!"
}

main "$@"