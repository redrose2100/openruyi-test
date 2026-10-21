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
# @Author    :   libeibei
# @Contact   :   libeibei@uniontech.com
# @Date      :   20231228
# @License   :   Mulan PSL v2
# @Desc      :   jruby formatting test
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test(){
    LOG_INFO "Start environment preparation."    
    cat > /tmp/jruby_test.rb << EOF
require 'java'
java_import 'java.util.ArrayList'
# 创建一个Java ArrayList对象
list = ArrayList.new
# 添加元素到ArrayList
list.add('Hello')
list.add('World')
# 遍历ArrayList并打印元素
list.each do |element|
  puts element
end
EOF

    DNF_INSTALL "jruby"
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    rpm -qa | grep jruby
    CHECK_RESULT $? 0 0 "Return value error"
    cd /tmp && jruby jruby_test.rb > jruby.file
    test -f /tmp/jruby.file
    CHECK_RESULT $? 0 0 "jruby test fail"
    grep "Hello" /tmp/jruby.file    
    CHECK_RESULT $? 0 0 "execute jruby.file fail"

}

function post_test() {
    LOG_INFO "start environment cleanup."
    rm -rf /tmp/jruby.file
    DNF_REMOVE "$@"
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
