#!/usr/bin/bash

# Copyright (c) 2023. huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed -i under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   BaiJing
# @Contact   :   799286817@qq.com
# @Date      :   2023/09/01
# @License   :   Mulan PSL v2
# @Desc      :   Test create snapshot
# #############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    num=$(date +%M%S)
    ccb create projects test-00${num} --json ../data/json/project-all-params.json | grep '\"code\": 0'
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    ccb create snapshots test-00${num}| grep '\"code\": 0'
    CHECK_RESULT $? 0 0 "create snapshot fail" 
    ccb create snapshots | grep '\"code\": 0'
    CHECK_RESULT $? 1 0 "Check create snapshot error no project"
    snapshot_id=$(ccb select snapshots os_project=test-00${num} -f snapshot_id | tail -10  | grep snapshot_id | awk -F ":" '{print $2}' | sed -e 's/^[ ]*//g' | sed 's/"\(.*\)"/\1/g')
    ccb create snapshots test-00${num} prev_snapshot_id=${snapshot_id} | grep '\"code\": 0'
    CHECK_RESULT $? 0 0 "Check create snapshot error"
    ccb create snapshots xxx  prev_snapshot_id=${snapshot_id} | grep '\"code\": 0'
    CHECK_RESULT $? 1 0 "Check create snapshot error"
    ccb create snapshots [test-00${num}] prev_snapshot_id=${snapshot_id} | grep '\"code\": 0'
    CHECK_RESULT $? 1 0 "Check create snapshot error"
    sed -i 's/id\": .*/id\": "'${snapshot_id}'",/g' ../data/json/snapshot-all-params.json
    ccb create snapshots test-00${num} --json ../data/json/snapshot-all-params.json | grep '\"code\": 0'
    CHECK_RESULT $? 0 0 "Check create snapshot error"
    sed -i 's/id\": .*/id\": "'${snapshot_id}'"/g' ../data/json/snapshot-no-is-trunk.json
    ccb create snapshots test-00${num} --json ../data/json/snapshot-no-is-trunk.json | grep '\"code\": 0'
    CHECK_RESULT $? 0 0 "Check create snapshot error"
    ccb create snapshots test-00${num} --json ../data/json/snapshot-no-prev-snapshot.json | grep '\"code\": 0'
    CHECK_RESULT $? 0 0 "Check create snapshot error"
    sed -i 's/: .*/: ${snapshot_id}/g' ../data/yaml/snapshot-no-is-trunk.yaml
    ccb create snapshots test-00${num} --yaml ../data/yaml/snapshot-no-is-trunk.yaml | grep '\"code\": 0'
    CHECK_RESULT $? 0 0 "Check create snapshot error"
    ccb create snapshots test-00${num} --yaml ../data/yaml/snapshot-no-prev-snapshot.yaml | grep '\"code\": 0'
    CHECK_RESULT $? 0 0 "Check create snapshot error"
    ccb create snapshots test-00${num} --yaml ../data/yaml/snapshot-all-params.yaml | grep '\"code\": 0'
    CHECK_RESULT $? 0 0 "Check create snapshot error"
    ccb create snapshots test-00${num} --yaml ../data/yaml/snapshot-no-is-trunk.yaml prev_snapshot_id=${snapshot_id} | grep '\"code\": 0'
    CHECK_RESULT $? 0 0 "Check create snapshot error"
    ccb create snapshots test-00${num} --json ../data/json/snapshot-all-params.json --yaml ../data/yaml/snapshot-no-is-trunk.yaml prev_snapshot_id=${snapshot_id}| grep '\"code\": 0'
    CHECK_RESULT $? 0 0 "Check create snapshot error"
    ccb create snapshots test-00${num} --yaml ../data/yaml/snapshot-all-params.yaml --json ../data/json/snapshot-no-is-trunk.json prev_snapshot_id=${snapshot_id}| grep '\"code\": 0'
    CHECK_RESULT $? 0 0 "Check create snapshot error"
    ccb create snapshots test-00${num} prev_snapshot_id=${snapshot_id} --yaml ../data/yaml/snapshot-all-params.yaml --json ../data/json/snapshot-no-is-trunk.json | grep '\"code\": 0'
    CHECK_RESULT $? 0 0 "Check create snapshot error"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    ccb update projects test-00${num} -j ../data/json/del.json
    LOG_INFO "End to restore the test environment."
}

main "$@"
