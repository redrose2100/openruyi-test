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
# @Date      :   2024/2/4
# @License   :   Mulan PSL v2
# @Desc      :   test gawk
# ############################################

source "${OET_PATH}/libs/locallibs/common_lib.sh"
function pre_test() {
  LOG_INFO "Start environmental preparation."
  DNF_INSTALL "gawk"
  cat  > numbers.txt  << EOF
1005.3247596.37
11522.349194.00
05810.1298100.1
EOF
  cat  > numbers1.txt  << EOF
100 5.324 75 96.37
115 22.34 91 94.00
058 10.12 98 100.1
EOF
  cat  > numbers3.txt  << EOF
Index: 1  - value 5
Index: 2  - value 6
Index: 3  - value 7
Index: 4  - value 8
EOF
    cat  > numbers4.txt  << EOF
Index: 1  - value a
Index: 2  - value g
Index: 3  - value m
Index: 4  - value u
EOF
  LOG_INFO "End of environmental preparation!"
}

function run_test() {
  LOG_INFO "Start to run test."
  gawk 'BEGIN{FIELDWIDTHS="3 5 2 5"} {print $1,$2,$3,$4}' numbers.txt > numbers2.txt
  diff numbers1.txt numbers2.txt
  CHECK_RESULT $? 0 0 "test FIELDWIDTHS failed"
  CHECK_RESULT "$(gawk 'BEGIN{x = 4; x = x * 2 + 3; print x;}')" "11" 0 "test variable failed"
  CHECK_RESULT "$(gawk 'BEGIN{var[1] = 34;var[2] = 3;total = var[1] + var[2];print total;}')" "37" 0 "test data collection failed"
  CHECK_RESULT "$(gawk 'BEGIN{x="testing"; print toupper(x),length(x)}')" "TESTING 7" 0 "test toupper length failed"
  gawk 'BEGIN{var["a"]=5; var["g"]=8; var["m"]=6; var["u"]=7; asort(var,test); for(i in test) print "Index:",i," - value",test[i];}' > numbers5.txt
  diff numbers3.txt numbers5.txt
  CHECK_RESULT $? 0 0 "test asort failed"
  gawk 'BEGIN{var["a"]=5; var["g"]=8; var["m"]=6; var["u"]=7; asorti(var,test); for(i in test) print "Index:",i," - value",test[i];}' > numbers6.txt
  diff numbers4.txt numbers6.txt
  CHECK_RESULT $? 0 0 "test asorti failed"
  LOG_INFO "End of the test."
}

function post_test() {
  LOG_INFO "start environment cleanup."
  DNF_REMOVE "$@"
  rm -rf ./numbers*.txt 
  LOG_INFO "Finish environment cleanup!"
}
main "$@"
