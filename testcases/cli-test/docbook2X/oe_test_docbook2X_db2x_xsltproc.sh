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

    db2x_xsltproc --version | grep "db2x_xsltproc (part of docbook2X [[:digit:]].*)"
    CHECK_RESULT $? 0 0 "Check db2x_xsltproc --version  failed"

    db2x_xsltproc --help | grep "Usage: /usr/bin/db2x_xsltproc \[options]"
    CHECK_RESULT $? 0 0 "Check --help  failed"

    db2x_xsltproc -s texi -o doctest/hello.txml -D 100 -C /etc/xml/catalog -X libxslt doctest/text.xml -d -I -S -N -P
    test -f doctest/hello.txml
    CHECK_RESULT $? 0 0 "Check db2x_xsltproc -s -o -D -C -X -d -I -S -N -P failed"

    db2x_xsltproc --stylesheet texi --output doctest/hello1.txml --nesting-limit 100 --catalogs /etc/xml/catalog --xslt-processor libxslt doctest/text.xml --debug --xinclude --sgml --network --profile
    test -f doctest/hello1.txml
    CHECK_RESULT $? 0 0 "Check db2x_xsltproc --stylesheet --output --nesting-limit --catalogs --xslt-processor --debug --xinclude --sgml --network --profile failed"

    db2x_xsltproc -s texi -o doctest/hello2.txml -D 100 -C /etc/xml/catalog -X libxslt -p name=admin doctest/text.xml -d -I -S -N
    test -f doctest/hello2.txml
    CHECK_RESULT $? 0 0 "Check db2x_xsltproc -p failed"

    db2x_xsltproc -s texi -o doctest/hello3.txml -D 100 -C /etc/xml/catalog -X libxslt --param name=admin doctest/text.xml -d -I -S -N
    test -f doctest/hello3.txml
    CHECK_RESULT $? 0 0 "Check db2x_xsltproc --param failed"

    db2x_xsltproc -s texi -o doctest/hello4.txml -D 100 -C /etc/xml/catalog -X libxslt -g name=admin doctest/text.xml -d -I -S -N
    test -f doctest/hello4.txml
    CHECK_RESULT $? 0 0 "Check db2x_xsltproc -g failed"

    db2x_xsltproc -s texi -o doctest/hello5.txml -D 100 -C /etc/xml/catalog -X libxslt --string-param name=admin doctest/text.xml -d -I -S -N
    test -f doctest/hello5.txml
    CHECK_RESULT $? 0 0 "Check db2x_xsltproc -g failed"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    rm -rf doctest
    LOG_INFO "Finish restore the test environment."
}

main "$@"
