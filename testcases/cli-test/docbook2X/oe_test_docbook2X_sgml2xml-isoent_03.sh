# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   hua
# @Contact   :   dchang@zhixundn.com
# @Date      :   2022/11/20
# @License   :   Mulan PSL v2
# @Desc      :   verify the uasge of docbook2X command
# ############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL docbook2X
    cp -r common doctest
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run test."
  
    sgml2xml-isoent -b utf-8 -f doctest/error -e doctest/hello.sgml | grep "Hello World!"
    CHECK_RESULT $? 0 0 "Check sgml2xml-isoent -b -f -e failed"
  
    sgml2xml-isoent -b utf-8 -f doctest/error --open-entities doctest/hello.sgml | grep "Hello World!"
    CHECK_RESULT $? 0 0 "Check sgml2xml-isoent -b -f --open-entities failed"
  
    sgml2xml-isoent -b utf-8 -f doctest/error -g doctest/hello.sgml | grep "Hello World!"
    CHECK_RESULT $? 0 0 "Check sgml2xml-isoent -g failed"
  
    sgml2xml-isoent -b utf-8 -f doctest/error --open-entities doctest/hello.sgml | grep "Hello World!"
    CHECK_RESULT $? 0 0 "Check sgml2xml-isoent --open-entities failed"
  
    sgml2xml-isoent -b utf-8 -f doctest/error -n doctest/hello.sgml | grep "Hello World!"
    CHECK_RESULT $? 0 0 "Check sgml2xml-isoent -n failed"
  
    sgml2xml-isoent -b utf-8 -f doctest/error --error-numbers doctest/hello.sgml | grep "Hello World!"
    CHECK_RESULT $? 0 0 "Check sgml2xml-isoent --error-numbers failed"
  
    sgml2xml-isoent -b utf-8 -f doctest/error --references doctest/hello.sgml | grep "Hello World!"
    CHECK_RESULT $? 0 0 "Check sgml2xml-isoent --references failed"
  
    sgml2xml-isoent -b utf-8 -f doctest/error -i doc doctest/hello.sgml | grep "Hello World!"
    CHECK_RESULT $? 0 0 "Check sgml2xml-isoent -i failed"
  
    sgml2xml-isoent -b utf-8 -f doctest/error --include=doc doctest/hello.sgml | grep "Hello World!"
    CHECK_RESULT $? 0 0 "Check sgml2xml-isoent --include failed"
  
    sgml2xml-isoent -b utf-8 -f doctest/error -w default doctest/hello.sgml | grep "Hello World!"
    CHECK_RESULT $? 0 0 "Check sgml2xml-isoent -w failed"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    cd ..
    rm -rf doctest
    LOG_INFO "Finish restore the test environment."
}

main "$@"
