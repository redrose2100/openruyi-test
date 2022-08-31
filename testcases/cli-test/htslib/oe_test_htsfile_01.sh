#oe测试用例案例，命名要写用途，测啥
#!/usr/bin/bash
# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
# @Author    	:   chen zebin
# @Contact   	:   zebin@isrc.iscas.ac.cn
# @Date      	:   2022-8-13
# @License   	:   Mulan PSL v2
# @Desc      	:   测什么
####################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL htslib zlib-devel bzip2 bzip2-devel xz-devel -y
    cd /tmp
    wget http://hgdownload.cse.ucsc.edu/goldenPath/hg19/encodeDCC/wgEncodeUwRepliSeq/wgEncodeUwRepliSeqBjG2AlnRep1.bam
    mv wgEncodeUwRepliSeqBjG2AlnRep1.bam data.bam
    LOG_INFO "End of environmental preparation!"
}
function run_test() {
    LOG_INFO "Start testing..."

    htsfile --version 2 &>1
    CHECK_RESULT $? 0 0 "Failed to run command:htsfile --version"
    htsfile -c /tmp/data.bam 2>&1
    CHECK_RESULT $? 0 0 "Failed to run command:htsfile -c"
    htsfile -C /tmp/data.bam /tmp/data1.bam 2>&1
    CHECK_RESULT $? 0 0 "Failed to run command:htsfile -C"
    htsfile -h /tmp/data1.bam 2>&1
    CHECK_RESULT $? 0 0 "Failed to run command:htsfile -h"
    htsfile -H /tmp/data.bam 2>&1
    CHECK_RESULT $? 0 0 "Failed to run command:htsfile -H"
    htsfile -v /tmp/data.bam 2>&1
    CHECK_RESULT $? 0 0 "Failed to run command:htsfile -v"
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    rm -rf /tmp/data.bam
    rm -rf tmp
    DNF_REMOVE
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
