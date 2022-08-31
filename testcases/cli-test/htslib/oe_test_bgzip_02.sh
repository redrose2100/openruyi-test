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
    DNF_INSTALL bgzip zlib-devel bzip2 bzip2-devel xz-devel -y
    wget http://www.candidagenome.org/download/gff/C_albicans_SC5314/Assembly19/A19_ForcheSNPs.gff
    wget http://www.candidagenome.org/download/gff/C_albicans_SC5314/Assembly19/C_albicans_SC5314_version_A19-s01-m04-r05_features.gff
    wget http://www.candidagenome.org/download/gff/C_albicans_SC5314/Assembly19/C_albicans_SC5314_version_A19-s01-m04-r05_intergenic.gff
    mv A19_ForcheSNPs.gff fst.gff
    mv C_albicans_SC5314_version_A19-s01-m04-r05_features.gff snd.gff
    mv C_albicans_SC5314_version_A19-s01-m04-r05_intergenic.gff trd.gff
    LOG_INFO "End of environmental preparation!"
}
function run_test() {
    LOG_INFO "Start testing..."
    bgzip -i /tmp/fst.gff 2>&1
    CHECK_RESULT $? 0 0 "Failed to run command: bgzip -i"
    bgzip -r /tmp/fst.gff.gz 2>&1#重新索引
    CHECK_RESULT $? 0 0 "Failed to run command: bgzip -r"
    bgzip -g /tmp/snd.gff -I fst.gff.gz.gzi 2>&1
    CHECK_RESULT $? 0 0 "Failed to run command: bgzip -g"
    bgzip -b 0.1 /tmp/fst.gff.gz 2>&1 #解压到标准输出
    CHECK_RESULT $? 0 0 "Failed to run command: bgzip -b"
    bgzip -s 1 /tmp/fst.gff.gz 2>&1 #解压stdout
    CHECK_RESULT $? 0 0 "Failed to run command: bgzip -s"
    bgzip -f /tmp/trd.gff
    CHECK_RESULT $? 0 0 "Failed to run command: bgzip -f"

    LOG_INFO "Finish test!"
}
function post_test() {
    LOG_INFO "start environment cleanup."
    rm -rf /tmp/fst.gff.gz /tmp/fst.gff.gz.gzi /tmp/snd.gff.gz /tmp/trd.gff.gz
    DNF_REMOVE
    LOG_INFO "Finish environment cleanup!"
}
main "$@"
