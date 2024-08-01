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
# @Author    :   shangyingjie
# @Contact   :   yingjie@isrc.iscas.ac.cn
# @Date      :   2022/1/13
# @License   :   Mulan PSL v2
# @Desc      :   Test tsdb
# #############################################

source "./common_lib.sh"

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL prometheus2
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    promtool tsdb --help 2>&1 | grep 'usage: promtool tsdb'
    CHECK_RESULT $? 0 0 "Failed to check flag: --help."
    promtool tsdb --version 2>&1 | grep 'promtool, version'
    CHECK_RESULT $? 0 0 "Failed to check flag: --version."
    promtool tsdb --help-long 2>&1 | grep 'usage: promtool'
    CHECK_RESULT $? 0 0 "Failed to check flag: --help-long."
    promtool tsdb --help-man 2>&1 | grep '.TH promtool 1 promtool, version'
    CHECK_RESULT $? 0 0 "Failed to check flag: --help-man."
    promtool tsdb bench write --help 2>&1 | grep 'usage: promtool tsdb bench write'
    CHECK_RESULT $? 0 0 "Failed to use command: bench write, with flag: --help."
    promtool tsdb bench write ./20kseries.json | grep 'completed' 2>&1
    CHECK_RESULT $? 0 0 "Failed to use command: bench write, with arg: file."
    promtool tsdb bench write ./20kseries.json --out ./out_of_bench_write
    CHECK_RESULT "$(ls ./out_of_bench_write | grep -cE 'block.prof|cpu.prof|mem.prof|mutex.prof|storage')" 5 0 "Failed to use command: bench write, with flag: --out."
    promtool tsdb bench write ./20kseries.json --metrics=100 | grep 'completed'
    CHECK_RESULT $? 0 0 "Failed to use command: bench write, with flag: --metrics."
    promtool tsdb list --help 2>&1 | grep 'usage: promtool tsdb list'
    CHECK_RESULT $? 0 0 "Failed to use command: list, with flag: --help."
    promtool tsdb list | grep -E 'BLOCK|ULID|MIN|TIME|MAX|TIME|NUM|SAMPLES|NUM|CHUNKS|NUM|SERIES'
    CHECK_RESULT $? 0 0 "Failed to use command: list."
    promtool tsdb list | grep -E 'BLOCK|ULID|MIN|TIME|MAX|TIME|NUM|SAMPLES|NUM|CHUNKS|NUM|SERIES|UTC'
    CHECK_RESULT $? 0 0 "Failed to use command: list, with flag: -h."
    promtool tsdb list ./out_of_bench_write/storage | grep -E 'BLOCK|ULID|MIN|TIME|MAX|TIME|NUM|SAMPLES|NUM|CHUNKS|NUM|SERIES'
    CHECK_RESULT $? 0 0 "Failed to use command: list, with arg: db path."
    promtool tsdb analyze --help 2>&1 | grep 'usage: promtool tsdb analyze'
    CHECK_RESULT $? 0 0 "Failed to use command: analyze, with flag: --help."
    CHECK_RESULT "$(promtool tsdb analyze | grep -cE 'Block ID|Duration|Series|Label names|Postings|Postings entries')" 8 0 "Failed to use command: analyze"
    CHECK_RESULT "$(promtool tsdb analyze ./out_of_bench_write/storage | grep -cE 'Block ID|Duration|Series|Label names|Postings|Postings entries')" 8 0 "Failed to use command: analyze, with arg: db path"
    CHECK_RESULT "$(promtool tsdb analyze --limit=1 | wc -l)" 24 0 "Failed to use command: analyze, with flag: --limit"
    block_id=$(promtool tsdb list | awk '{if(NR==2) print $1}')
    promtool tsdb analyze ./benchout/storage $block_id | grep "Block ID: ${block_id}"
    CHECK_RESULT $? 0 0 "Failed to use command: analyze, with arg: block id"
    LOG_INFO "Finish test!"
} 

function post_test() {
    LOG_INFO "start environment cleanup."
    rm -rf ./benchout
    rm -rf ./out_of_bench_write
    DNF_REMOVE
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
