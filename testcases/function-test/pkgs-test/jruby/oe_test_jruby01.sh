#!/usr/bin/bash

# Copyright (c) 2026 Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   yangxi
# @Contact   :   yangxi@uniontech.com
# @Date      :   20260519
# @License   :   Mulan PSL v2
# @Desc      :   jruby formatting test
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test(){
    LOG_INFO "Start environment preparation."    
    cat > /tmp/jruby_hash_test.rb << 'EOF'
# 测试HashMap操作
require 'java'
java_import 'java.util.HashMap'
map = HashMap.new
map.put('name', 'JRuby')
map.put('version', '9.4')
map.put('status', 'active')
puts "Hash map size: " + map.size.to_s
puts "Name value: " + map.get('name')
map.each do |key, value|
  puts "Key: " + key + ", Value: " + value
end
EOF

    cat > /tmp/jruby_array_test.rb << 'EOF'
# 测试数组操作 - 使用Ruby数组（兼容性更好）
# 创建字符串数组
arr = ['J', 'R', 'U', 'B', 'Y']
puts "Array length: " + arr.length.to_s
puts "Array elements: " + arr.to_s
# 数组遍历
result = ""
arr.each do |char|
  result += char
end
puts "Concatenated string: " + result
EOF

    DNF_INSTALL "jruby"
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    
    LOG_INFO "Test point 1: Test JRuby HashMap operations"
    cd /tmp && jruby jruby_hash_test.rb > jruby_hash.file 2>&1
    test -f /tmp/jruby_hash.file
    CHECK_RESULT $? 0 0 "Hash test file creation fail"
    grep -q "Hash map size: 3" /tmp/jruby_hash.file
    CHECK_RESULT $? 0 0 "HashMap size verification fail"
    grep -q "Name value: JRuby" /tmp/jruby_hash.file
    CHECK_RESULT $? 0 0 "HashMap get operation fail"
    grep -q "Key: name, Value: JRuby" /tmp/jruby_hash.file
    CHECK_RESULT $? 0 0 "HashMap traversal fail"
    LOG_INFO "Test point 2: Test JRuby array operations"
    cd /tmp && jruby jruby_array_test.rb > jruby_array.file 2>/dev/null
    grep -q "Array length: 5" /tmp/jruby_array.file
    CHECK_RESULT $? 0 0 "Array length verification fail"
    grep -q "Concatenated string: JRUBY" /tmp/jruby_array.file
    CHECK_RESULT $? 0 0 "Array traversal and concatenation fail"

    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    rm -rf /tmp/jruby_*.{file,rb} 2>/dev/null
    # shellcheck disable=SC2119 
    DNF_REMOVE
    LOG_INFO "Finish environment cleanup!"
}


