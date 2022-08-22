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
# function_config_params() {
#    echo "export SAM_PATH=$SAM_PATH:/tmp/samtools-1.16/bin/:$PATH" > ~/.bashrc
#    source ~/.bashrc
# }
function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL htslib zlib-devel bzip2 bzip2-devel xz-devel ncurses-devel -y
    mkdir tmp    
    cd /tmp
    wget http://www.candidagenome.org/download/gff/C_albicans_SC5314/Assembly19/A19_ForcheSNPs.gff  	
#    wget https://github.com/samtools/samtools/releases/download/1.16/samtools-1.16.tar.bz2
    wget https://github.com/billzt/gff3sort   #tabix需要输入排好序的
    sort -k1,1 -k4,4n A19_ForcheSNPs.gff > A19_ForcheSNPs.sorted.gff
    bgzip A19_ForcheSNPs.sorted.gff
#    tar jxvf samtools-1.16.tar.bz2
#    cd samtools-1.16
#    configure --prefix=/tmp/samtools-1.16
    make && make install
# cd tmp
    LOG_INFO "End of environmental preparation!"
}
#测试点执行+check校验
function run_test() {
    LOG_INFO "Start testing..."	
    tabix --version 2&>1
    CHECK_RESULT $? 0 0 "Failed\ to run command:tabix --version"
    tabix -p gff /tmp/A19_ForcheSNPs.sorted.gff.gz 2>&1
    CHECK_RESULT $? 0 0 "Failed\ to run command:tabix -p"
    tabix -0 -f /tmp/A19_ForcheSNPs.sorted.gff.gz 2>&1
    CHECK_RESULT $? 0 0 "Failed\ to run command:tabix -0 -f"
    tabix -b 4 -f /tmp/A19_ForcheSNPs.sorted.gff.gz 2>&1
    CHECK_RESULT $? 0 0 "Failed\ to run command:tabix -b -f"
    tabix -c "#" -f /tmp/A19_ForcheSNPs.sorted.gff.gz 2>&1
    CHECK_RESULT $? 0 0 "Failed\ to run command:tabix -c -f"
    tabix -C -f /tmp/A19_ForcheSNPs.sorted.gff.gz 2>&1
    CHECK_RESULT $? 0 0 "Failed\ to run command:tabix -C -f"
    tabix -e 5 -f /tmp/A19_ForcheSNPs.sorted.gff.gz 2>&1
    CHECK_RESULT $? 0 0 "Failed\ to run command:tabix -e -f"
    tabix -m 14 -f /tmp/A19_ForcheSNPs.sorted.gff.gz 2>&1
    CHECK_RESULT $? 0 0 "Failed\ to run command:tabix -m -f"
    tabix -s 1 -f /tmp/A19_ForcheSNPs.sorted.gff.gz 2>&1
    CHECK_RESULT $? 0 0 "Failed\ to run command:tabix -s 1 -f"
    tabix -S 0 -f /tmp/A19_ForcheSNPs.sorted.gff.gz 2>&1
    CHECK_RESULT $? 0 0 "Failed\ to run command:tabix -S 0 -f"
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    rm -rf /tmp/A19_ForcheSNPs.gff.gz 
    rm -rf /tmp/A19_ForcheSNPs.sorted.gff.gz 
    rm -rf /tmp/A19_ForcheSNPs.sorted.gff.gz.tbi
    rm -rf /tmp/A19_ForcheSNPs.sorted.gff.gz.csi
    rm -rf tmp
    DNF_REMOVE htslib zlib-devel bzip2 bzip2-devel xz-devel ncurses-devel
    LOG_INFO "Finish environment cleanup!"
}
main "$@"


