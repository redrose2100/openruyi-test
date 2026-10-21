#!/usr/bin/bash
# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   geyaning
# @Contact   :   geyaning@uniontech.com
# @Date      :   2023/07/12
# @License   :   Mulan PSL v2
# @Desc      :   npm nodejs-jsonpointer test
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL npm
    npm install jsonfile --save
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    cat > employee.json << EOF
[
  {
    "emp_id" : "101",
    "emp_name" : "Mike",
    "emp_addr" : "123 California, USA",
    "designation" : "Editor"
  },
  {
    "emp_id" : "102",
    "emp_name" : "Jacob",
    "emp_addr" : "456 Log Angelis, USA",
    "designation" : "Chief Editor"
  }
]
EOF
    cat > ReadJsonFile.js  << EOF
var jsonFile = require('jsonfile')
var fileName = 'employee.json'

jsonFile.readFile(fileName, function(err, jsonData) {
  if (err) throw err;
  for (var i = 0; i < jsonData.length; ++i) {

    console.log("Emp ID: "+jsonData[i].emp_id);
    console.log("Emp Name: "+jsonData[i].emp_name);
    console.log("Emp Address: "+jsonData[i].emp_addr);
    console.log("Designation: "+jsonData[i].designation);
    console.log("----------------------------------");
  }
})
EOF
    node ReadJsonFile.js > test.txt
    diff test.txt ResaJsonFile.txt
    CHECK_RESULT $? 0 0 "node ReadJsonFile.js cannot display the correct result"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    npm uninstall jsonfile
    rm -rf test.txt ReadJsonFile.js employee.json package-lock.json node_modules
    DNF_REMOVE "$@"
    LOG_INFO "Een to restore the test environment."
}

main "$@"
