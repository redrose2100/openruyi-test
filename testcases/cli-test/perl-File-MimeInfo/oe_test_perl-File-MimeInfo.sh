#!/usr/bin/bash

# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more detaitest -f.

# #############################################
# @Author    :   huangdaorong
# @Contact   :   3170809690@qq.com
# @Date      :   2022/5/6
# @License   :   Mulan PSL v2
# @Desc      :   Test perl-File-Mimeinfo
# #############################################

source "../common/common_lib.sh"

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL perl-File-MimeInfo
    tar -zxvf test.tar.gz
    mkdir -p tmp/ /root/.local/share/applications/
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    expect <<EOF > tmp/1.txt
    spawn mimeopen data/data.txt
    expect "use application" {send "1\n"}
    expect "use command" {send "vim\n"}
    expect "hello" {send ":q\n"}
    expect eof
EOF
    head -n 8 tmp/1.txt | grep 'Opening "data/data.txt" with vim  (text/plain)'
    CHECK_RESULT $? 0 0 "Failed option: mimeopen"
    mimetype data/data.txt | grep 'data/data.txt: text/plain'
    CHECK_RESULT $? 0 0 "Failed option: mimetype"
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    rm -rf tmp/ /root/.local/share/applications/ data/
    DNF_REMOVE
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
