#!/usr/bin/bash

# Copyright (c) 2024. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   fuyahong
# @Contact   :   fuyahong@uniontech.com
# @Date      :   2024/4/9
# @License   :   Mulan PSL v2
# @Desc      :   test gawk structured command
# ############################################

source "${OET_PATH}/libs/locallibs/common_lib.sh"
function pre_test() {
  LOG_INFO "Start environmental preparation."
  DNF_INSTALL "gawk"
  cat  > data1.txt  << EOF
130 120 135
160 113 140 
145 170 215
EOF
  cat  > data2.txt  << EOF
Average: 128.333
Average: 137.667
Average: 176.667
EOF
  cat  > data3.txt  << EOF
The average of the first two data elements is: 125
The average of the first two data elements is: 136.5
The average of the first two data elements is: 157.5
EOF
   cat  > data4.txt  << EOF
250
160
315
EOF
  cat  > data5.txt  << EOF
Average: 128.3
Average: 137.7
Average: 176.7
EOF
  LOG_INFO "End of environmental preparation!"
}

function run_test() {
  LOG_INFO "Start to run test."
  gawk '{total=0; i=1; while(i<4){total += $i; i++;}; avg=total/3; print "Average:",avg;}' data1.txt > data6.txt
  diff data2.txt data6.txt
  CHECK_RESULT $? 0 0 "test while failed"

  gawk '{total=0; i=1; while(i<4){total += $i; if(i == 2) break; i++;}; avg=total/2; print "The average of the first two data elements is:",avg;}' data1.txt > data7.txt
  diff data3.txt data7.txt
  CHECK_RESULT $? 0 0 "test while and if failed"

  gawk '{total=0; i=1; do {total += $i; i++;} while(total <150); print total}' data1.txt > data8.txt
  diff data4.txt data8.txt
  CHECK_RESULT $? 0 0 "test do-while loop failed"

  gawk '{total=0; for(i=1; i<4; i++){total += $i;}; avg=total/3; printf "Average: %5.1f\n",avg;}' data1.txt > data9.txt
  diff data5.txt data9.txt
  CHECK_RESULT $? 0 0 "test for loop failed"
  LOG_INFO "End of the test."
}

function post_test() {
  LOG_INFO "start environment cleanup."
  DNF_REMOVE "$@"
  rm -rf ./*.txt 
  LOG_INFO "Finish environment cleanup!"
}
main "$@"
