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

    sgml2xml-isoent -b utf-8 -f doctest/error -D ./doctest doctest/hello.sgml | grep "Hello World!"
    CHECK_RESULT $? 0 0 "Check sgml2xml-isoent -D failed"

    sgml2xml-isoent -b utf-8 -f doctest/error --directory=./doctest doctest/hello.sgml | grep "Hello World!"
    CHECK_RESULT $? 0 0 "Check sgml2xml-isoent --directory failed"

    sgml2xml-isoent -b utf-8 -f doctest/error -R doctest/hello.sgml | grep 'xml version="1.0" encoding="utf-8"'
    CHECK_RESULT $? 0 0 "Check sgml2xml-isoent -R failed"

    sgml2xml-isoent -b utf-8 -f doctest/error --restricted doctest/hello.sgml | grep 'xml version="1.0" encoding="utf-8"'
    CHECK_RESULT $? 0 0 "Check sgml2xml-isoent --restricted failed"

    sgml2xml-isoent -b utf-8 -f doctest/error -a doctype doctest/hello.sgml | grep "Hello World!"
    CHECK_RESULT $? 0 0 "Check sgml2xml-isoent -a failed"

    sgml2xml-isoent -b utf-8 -f doctest/error --activate=doctype doctest/hello.sgml | grep "Hello World!"
    CHECK_RESULT $? 0 0 "Check sgml2xml-isoent --activate failed"

    sgml2xml-isoent -b utf-8 -f doctest/error -A doc doctest/hello.sgml | grep 'xml version="1.0" encoding="utf-8"'
    CHECK_RESULT $? 0 0 "Check sgml2xml-isoent -A failed"

    sgml2xml-isoent -b utf-8 -f doctest/error --architecture=doc doctest/hello.sgml | grep 'xml version="1.0" encoding="utf-8"'
    CHECK_RESULT $? 0 0 "Check sgml2xml-isoent --architecture failed"

    sgml2xml-isoent -b utf-8 -f doctest/error -E 10 doctest/hello.sgml | grep "Hello World!"
    CHECK_RESULT $? 0 0 "Check sgml2xml-isoent -E failed"

    sgml2xml-isoent -b utf-8 -f doctest/error --max-errors=10 doctest/hello.sgml | grep "Hello World!"
    CHECK_RESULT $? 0 0 "Check sgml2xml-isoent --max-errors failed"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    rm -rf doctest
    LOG_INFO "Finish restore the test environment."
}

main "$@"
