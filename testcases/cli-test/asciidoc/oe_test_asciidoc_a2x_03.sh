#!/usr/bin/bash

# Copyright (c) 2023. Lanzhou University of Technology.,Univ.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use this software according to the terms and conditions of the Mulan PSL v2.
# You may obtain a copy of Mulan PSL v2 at:
#          http://license.coscl.org.cn/MulanPSL2
# THIS SOFTWARE IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
# #############################################
# @Author    :   yangshicheng
# @Contact   :   scyang_zjut@163.com
# @Date      :   2023/04/12
# @License   :   Mulan PSL v2
# @Desc      :   Take the test a2x option
# #############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function config_params() {
    LOG_INFO "Start to config params of the case."
    TMP_DIR="./tmp"
    LOG_INFO "End to config params of the case."
}

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "asciidoc fop docbook-xsl"
    mkdir $TMP_DIR
    sed -i "s|<xsl:import href=\"/usr/share/sgml/docbook/xsl-stylesheets-1.79.2/common/common.xsl\"/>|<xsl:import href=\"$(find /usr/share -name common.xsl | awk 'NR==1')\"/>|" common/xsl/test.xsl
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    a2x -f xhtml  --xsltproc-opts='--stringparam page.margin.inner 10cm' -D ${TMP_DIR}/ common/test.adoc 2>&1 && \
    test -f ${TMP_DIR}/test.html
    CHECK_RESULT $? 0 0 "Check a2x --xsltproc-opts failed"
    a2x -f xhtml --xsl-file=common/xsl/test.xsl -D ${TMP_DIR}/ common/test.adoc 2>&1 && \
    test -f ${TMP_DIR}/test.html
    CHECK_RESULT $? 0 0 "Check a2x --xsl-file failed"
    a2x --icons -f xhtml -D ${TMP_DIR}/ common/test.adoc 2>&1 && \
    test -f ${TMP_DIR}/test.html
    CHECK_RESULT $? 0 0 "Check a2x --icons failed"
    a2x -f xhtml --icons-dir=common/icons_test/ -D ${TMP_DIR}/ common/test.adoc 2>&1 && \
    test -f ${TMP_DIR}/test.html
    CHECK_RESULT $? 0 0 "Check a2x --icons-dir failed"
    for format in "xhtml" "epub" "docbook" "chunked" "htmlhelp" "manpage"
    do
        a2x -v -f ${format} -D ${TMP_DIR}/ common/test.adoc
        CHECK_RESULT $? 0 0 "Check a2x -f ${format} failed"
        a2x --format ${format} -D ${TMP_DIR}/ common/test.adoc
        CHECK_RESULT $? 0 0 "Check a2x --format ${format} failed"
    done
    a2x --fop -f pdf -D ${TMP_DIR}/ common/test.adoc
    CHECK_RESULT $? 0 0 "Check a2x -f pdf failed"
    a2x --fop -f pdf -D ${TMP_DIR}/ common/test.adoc
    CHECK_RESULT $? 0 0 "Check a2x --format pdf failed"
    a2x -f xhtml --copy -D ${TMP_DIR}/ common/test.adoc 2>&1 && \
    test -f ${TMP_DIR}/test.html
    CHECK_RESULT $? 0 0 "Check a2x --copy failed"
    a2x -f xhtml --safe -D ${TMP_DIR}/ common/test.adoc 2>&1 && \
    test -f ${TMP_DIR}/test.html
    CHECK_RESULT $? 0 0 "Check a2x --safe failed"
    a2x -f xhtml -s -D ${TMP_DIR}/ common/test.adoc 2>&1 && \
    test -f ${TMP_DIR}/test.html
    CHECK_RESULT $? 0 0 "Check a2x -s failed"
    a2x -f xhtml --skip-asciidoc -D ${TMP_DIR}/ common/test.adoc 2>&1 && \
    test -f ${TMP_DIR}/test.html
    CHECK_RESULT $? 0 0 "Check a2x --skip-asciidoc failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf ${TMP_DIR}
    sed -i '17s/.*/<xsl:import href="\/usr\/share\/sgml\/docbook\/xsl-stylesheets-1.79.2\/common\/common.xsl\"\/>/' common/xsl/test.xsl
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
