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
# @Date      :   2024/4/1
# @License   :   Mulan PSL v2
# @Desc      :   test gawk
# ############################################

source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test() {
  LOG_INFO "Start environmental preparation."
  DNF_INSTALL "gawk"
  cat  > data1.txt  << EOF
data11,data12,data13,data14,data15
data21,data22,data23,data24,data25
data31,data32,data33,data34,data35
EOF
  cat  > data2.txt  << EOF
data11 data12 data13
data21 data22 data23
data31 data32 data33
EOF
  cat  > data3.txt  << EOF
data11-data12-data13-data14
data21-data22-data23-data24
data31-data32-data33-data34
EOF

   cat  > data7.txt  << EOF
Rilly
123 Main Street
(312)555-1234

Frank
456 Oak Street
(317)555-9876

Haley
4231 Elm Street
(313)555-4938
EOF
   cat  > data8.txt  << EOF
Rilly (312)555-1234
Frank (317)555-9876
Haley (313)555-4938
EOF
   cat  > data10.txt  << EOF
data11 data15
data21 data25
data31 data35
EOF
  LOG_INFO "End of environmental preparation!"
}

function run_test() {
  LOG_INFO "Start to run test."
  gawk 'BEGIN{FS=","} {print $1,$2,$3}' data1.txt > data4.txt
  diff data2.txt data4.txt
  CHECK_RESULT $? 0 0 "test FS failed"
  gawk 'BEGIN{FS=","; OFS="-"} {print $1,$2,$3,$4}' data1.txt > data5.txt
  diff data3.txt data5.txt
  CHECK_RESULT $? 0 0 "test FS OFS failed"

  gawk 'BEGIN{FS="\n"; RS=""} {print $1,$3}' data7.txt > data9.txt
  diff data8.txt data9.txt
  CHECK_RESULT $? 0 0 "test FS RS failed"
  gawk 'BEGIN{FS=","} {split($0,var);print var[1],var[5]}' data1.txt > data11.txt
  diff data10.txt data11.txt
  CHECK_RESULT $? 0 0 "test split failed"
  LOG_INFO "End of the test."
}

function post_test() {
  LOG_INFO "start environment cleanup."
  DNF_REMOVE "$@"
  rm -rf ./*.txt 
  LOG_INFO "Finish environment cleanup!"
}
main "$@"
