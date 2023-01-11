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
# @Desc      :   verify the uasge of docbook-utils command
# ############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL docbook-utils
    cp -r ./common doc
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run test."

    jw -f docbook -b html -d none -p /usr/bin/jade -c doc/helloworld.sgml -o ./doc -i parajw doc/helloworld.sgml && test -f ./doc/t1.htm
    CHECK_RESULT $? 0 0 "Check jw -f -b -d -p -c -o -i failed"

    jw --frontend docbook --backend html --dsl none --parser /usr/bin/jade --cat doc/helloworld.sgml --output doc/doc1 --include parajw doc/helloworld.sgml && test -f doc/doc1/t1.htm
    CHECK_RESULT $? 0 0 "Check jw --frontend --backend --dsl --parser --cat --output --include failed"

    echo aaa > doc/1.txt
    jw -n -c doc/1.txt doc/1.txt -b texi && test -f 1.texi
    CHECK_RESULT $? 0 0 "Check jw -n -c failed"

    echo aaa > doc/2.txt
    jw --nostd -c doc/2.txt doc/2.txt -b texi && test -f 2.texi
    CHECK_RESULT $? 0 0 "Check jw --nostd -c failed"

    echo aaa > doc/3.txt
    jw -l doc/3.txt -b texi doc/3.txt && test -f 3.texi
    CHECK_RESULT $? 0 0 "Check jw -l failed"

    echo aaa > doc/4.txt
    jw --dcl doc/4.txt -b texi doc/4.txt && test -f 4.texi
    CHECK_RESULT $? 0 0 "Check jw --dcl failed"

    rm -rf t1.html
    jw -s /usr/share/sgml/ doc/helloworld.sgml && test -f ./t1.html
    CHECK_RESULT $? 0 0 "Check jw -s failed"

    rm -rf t1.html
    jw --sgmlbase /usr/share/sgml/ doc/helloworld.sgml && test -f ./t1.html
    CHECK_RESULT $? 0 0 "Check jw --sgmlbase failed"

    jw -u -c ./doc/helloworld.sgml doc/helloworld.sgml && test -f ./helloworld.html
    CHECK_RESULT $? 0 0 "Check jw -u -c failed"

    rm -rf helloworld.html
    jw --nochunks -c doc/helloworld.sgml doc/helloworld.sgml && test -f ./helloworld.html
    CHECK_RESULT $? 0 0 "Check jw --nochunks -c failed"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    rm -rf doc t1.html helloworld.html *.texi db2texi.refs
    LOG_INFO "Finish restore the test environment."
}

main "$@"
