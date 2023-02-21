#! /usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   xiechangyan1
# @Contact   :   xiechangyan@uniontech.com
# @Date      :   2023-02-20
# @License   :   Mulan PSL v2
# @Desc      :   Test use ruby
# ############################################


source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL ruby
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    version=`ruby -v | awk '{print $2}'`
    if [[ $version!='3.0.3p157' ]];then
      CHECK_RESULT $? 0 0 "Error, 'ruby' is not installed"
    else
      echo 'successful'
    fi
    cat > testfile << EOF
#!/usr/bin/ruby
class Sample
def hello
puts "hello world"
end
end
s = Sample.new
s.hello
EOF
    CHECK_RESULT $? 0 0 "Error, fail to touch testfile"
    chmod 750 testfile
    CHECK_RESULT $? 0 0 "Error, fail to change permissions"
    result=`./testfile`
    if [[ $result='hello world' ]];then
            echo 'successful'
    else
          CHECK_RESULT $? 0 0 "Error, check file"
    fi
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to clean the test environment."
    rm testfile
    DNF_REMOVE
    LOG_INFO "End to clean the test environment."
}
main "$@"
