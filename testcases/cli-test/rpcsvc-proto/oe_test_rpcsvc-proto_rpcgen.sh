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
# @Desc      :   verify the uasge of rpcsvc-proto command
# ############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL rpcgen
    mkdir rpscvc
    cd rpscvc
    cp ../common/text.x ./
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run test."

    rpcgen -C text.x -T
    test -f ./text.h
    CHECK_RESULT $? 0 0 "Check rpcgen -C  text.x  -T  failed"

    rpcgen -C -a -b text.x -I -K 2 -L -M -N -5
    test -f ./Makefile.text
    CHECK_RESULT $? 0 0 "Check rpcgen -C -a -b text.x -I -K 2 -L -M -N -5  failed"

    rpcgen -C text.x -h -i 100 | grep "extern  struct TEST"
    CHECK_RESULT $? 0 0 "Check rpcgen -C text.x -h -i 100  failed"

    rpcgen -C text.x -l | grep "test_proc_2(struct"
    CHECK_RESULT $? 0 0 "Check rpcgen -C text.x -l  failed"

    rpcgen -C text.x -m | grep "xdrproc_t _xdr_argument"
    CHECK_RESULT $? 0 0 "Check rpcgen -C text.x -m  failed"

    rpcgen -C text.x -c -o demo1
    test -f ./demo1
    CHECK_RESULT $? 0 0 "Check rpcgen -C text.x -c -o demo1  failed"

    rpcgen -C text.x -Sc | grep "usage: %s"
    CHECK_RESULT $? 0 0 "Check rpcgen -C  text.x  -Sc  failed"

    rpcgen -C text.x -t | grep "struct rpcgen_table"
    CHECK_RESULT $? 0 0 "Check rpcgen -C text.x -t  failed"

    rpcgen --version | grep "rpcgen (rpcsvc-proto) [[:digit:]]"
    CHECK_RESULT $? 0 0 "Check rpcgen --version  failed"

    rpcgen --help | grep "usage: rpcgen infile"
    CHECK_RESULT $? 0 0 "Check rpcgen --help  failed"
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    cd ..
    rm -rf rpscvc
    LOG_INFO "Finish restoring the test environment."
}

main "$@"
