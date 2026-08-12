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

    # 修改unix.exp 将/tmp改为可执行目录(嵌入式目标板/tmp可能是noexec tmpfs)
    mkdir -p ${cur}/tmp
    sed -i "s|/tmp/|${cur}/tmp/|g" config/unix.exp
    sed -i "s/exec mktemp -u/exec mktemp -u \"\${objdir}\/tmp\/tmp.XXXXXX\"/g" config/unix.exp
    sed -i "s/global testproc_path testproc_comm testproc_arg_str testproc1_pid testproc2_pid topdir/global testproc_path testproc_comm testproc_arg_str testproc1_pid testproc2_pid topdir objdir/" config/unix.exp
    for expfile in pgrep.test/pgrep.exp pkill.test/pkill.exp pwdx.test/pwdx.exp; do
        if [ -f "$expfile" ]; then
            sed -i "s|/tmp/|${cur}/tmp/|g" $expfile
        fi
    done
    
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
        if [[ "${tool}" == "w" ]]; then
            ../w --version 2>/dev/null
            if [[ $? -ne 0 ]]; then
                LOG_INFO "skip w test: libsystemd LIBSYSTEMD_254 not available"
                continue
            fi
        fi
        ${RUNTEST} --tool ${tool} --srcdir . 2>&1 | tee pmap_test.log
        ret=$?
        if [[ "${tool}" == "pmap" && $ret -ne 0 ]]; then
            if grep -q "pmap X pid pid has same total" pmap_test.log && \
               ! grep -v "pmap X pid pid has same total" pmap_test.log | grep -q "^FAIL:"; then
                LOG_INFO "skip pmap flaky test: pmap X pid pid has same total"
                ret=0
            fi
        fi
        CHECK_RESULT $ret 0 0 "run procps-ng test ${tool} fail"
    done

    rm -f pmap_test.log

    popd

    LOG_INFO "End to run test."
}

main "$@"
