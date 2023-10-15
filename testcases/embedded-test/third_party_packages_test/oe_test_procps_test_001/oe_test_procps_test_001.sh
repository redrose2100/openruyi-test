#!/usr/bin/bash

# Copyright (c) 2021. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
#@Author    	:   s-c-c
#@Contact   	:   shichuchao@huawei.com
#@Date      	:   2022-08-31 16:24:43
#@License   	:   Mulan PSL v2
#@Desc      	:   Run procps-ng testsuite
#####################################

source ../comm_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."

    pushd ./tmp_test/ps
    # 去掉pscommand wrapper
    rm -f pscommand
    cp .libs/pscommand pscommand
    chmod +x pscommand
    popd

    pushd ./tmp_test/testsuite
    # 修改site.exp
    cur=$(pwd)
    sed -i "s\set objdir .*$\set objdir ${cur}\g" site.exp

    # 修改unix.exp 避免调用getconf
    sed -i 's/min(\[ exec \/usr\/bin\/getconf ARG_MAX \], 104857)/104857/g' config/unix.exp
    
    # 修改所有exp直接调用系统bin
    cat free.test/free.exp | grep -q "{topdir}src/free"
    if [ $? -eq 0 ]; then
        sed -i "s/\${topdir}\/src\//\${topdir}\//g" config/unix.exp
        sed -i "s/\${topdir}src\//\${topdir}\//g" config/unix.exp
        sed -i "s/\${topdir}src\//\${topdir}/g" lib.test/fileutils.exp
        sed -i "s/\${topdir}src\//\${topdir}/g" lib.test/strutils.exp
        sed -i "s/\${topdir}src\//\${topdir}/g" ps.test/ps_output.exp
        sed -i "s/\${topdir}src\//\${topdir}/g" ps.test/ps_personality.exp
        sed -i "s/\${topdir}src\//\${topdir}/g" ps.test/ps_sched_batch.exp
        sed -i "s/..\/src/..\//g" lib.test/fileutils_badfd.sh
        sed -i "s/..\/src/..\//g" lib.test/fileutils_full.sh

        sed -i "s/\${topdir}src\///g" free.test/free.exp
        sed -i "s/\${topdir}src\///g" kill.test/kill.exp
        sed -i "s/pgrep \"\${topdir}src\//pgrep \"/g" pgrep.test/pgrep.exp
        sed -i "s/\${topdir}src\//\${topdir}/g" pgrep.test/pgrep.exp
        sed -i "s/pkill \"\${topdir}src\//pkill \"/g" pkill.test/pkill.exp
        sed -i "s/\${topdir}src\///g" pmap.test/pmap.exp
        sed -i "s/\${topdir}src\///g" pwdx.test/pwdx.exp
        sed -i "s/\${topdir}src\///g" slabtop.test/slabtop.exp
        sed -i "s/\${topdir}src\///g" sysctl.test/sysctl_read.exp
        sed -i "s/\${topdir}src\///g" uptime.test/uptime.exp
        sed -i "s/\${topdir}src\///g" vmstat.test/vmstat.exp
        sed -i "s/\${topdir}src\///g" w.test/w.exp
    else
        sed -i "s/\${topdir}//g" free.test/free.exp
        sed -i "s/\${topdir}//g" kill.test/kill.exp
        sed -i "s/pgrep \"\${topdir}/pgrep \"/g" pgrep.test/pgrep.exp
        sed -i "s/pkill \"\${topdir}/pkill \"/g" pkill.test/pkill.exp
        sed -i "s/\${topdir}//g" pmap.test/pmap.exp
        sed -i "s/\${topdir}//g" pwdx.test/pwdx.exp
        sed -i "s/\${topdir}//g" slabtop.test/slabtop.exp
        sed -i "s/\${topdir}//g" sysctl.test/sysctl_read.exp
        sed -i "s/\${topdir}//g" uptime.test/uptime.exp
        sed -i "s/\${topdir}//g" vmstat.test/vmstat.exp
        sed -i "s/\${topdir}//g" w.test/w.exp
    fi

    popd
    LOG_INFO "End to prepare the test environment."
}

# 测试点的执行
function run_test() {
    LOG_INFO "Start to run test."

    pushd ./tmp_test/testsuite

    suites=$(ls *.test -d)
    for tc in ${suites}; do
        tool=${tc%.test}
        cmd=$(which ${tool})
        if [[ -n "${cmd}" ]]; then
            ln -s ${cmd} ../${tool}
        fi
        ${RUNTEST} --tool ${tool} --srcdir .
        CHECK_RESULT $? 0 0 "run procps-ng test ${tool} fail"
    done

    popd

    LOG_INFO "End to run test."
}

main "$@"
