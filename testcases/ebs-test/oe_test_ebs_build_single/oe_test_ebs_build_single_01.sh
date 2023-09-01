#!/usr/bin/bash

# Copyright (c) 2023. huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
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
# @Desc      :   Test build single
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
    ccb build-single os_project=test-00${num} | grep '\"code\": 0'
    CHECK_RESULT $? 1 0 "Check build single lack of packages parameter"
    ccb build-single packages=python-flask | grep '\"code\": 0'
    CHECK_RESULT $? 1 0 "Check build single lack of os_project parameter"
    ccb build-single os_project=test-00${num} packages=python-flask | grep '\"code\": 0'
    CHECK_RESULT $? 0 0 "build single failed no build_id"
    ccb build-single os_project=test-00${num} packages=python-flask --json ../data/json/build_single-all-params.json| grep '\"code\": 0'
    CHECK_RESULT $? 0 0 "build single failed no build_id"
    ccb build-single os_project=test-00${num} packages=python-flask --json ../data/json/build_targets_include.json | grep '\"code\": 0'
    CHECK_RESULT $? 0 0 "build single failed build_targets not included in project"
    ccb build-single os_project=test-00${num} packages=python-flask --json ../data/json/build_targets_error.json| grep '\"code\": 0'
    CHECK_RESULT $? 1 0 "build single failed build_targets not included in project"
    ccb build-single os_project={xx} packages=python-flask | grep '\"code\": 0'
    CHECK_RESULT $? 1 0 "Check build sinlge os_project parameter error "
    ccb build-single os_project=xx packages=python-flask | grep '\"code\": 0'
    CHECK_RESULT $? 1 0 "Check build sinlge os_project no exist"
    build_id=$(ccb select builds os_project=test-00${num} -f build_id | tail -10  | grep build_id | awk -F ":" '{print $2}' | sed -e 's/^[ ]*//g' | sed 's/"\(.*\)"/\1/g')
    ccb build-single os_project=test-00${num} packages=python-flask build_id=xx | grep '\"code\": 0'
    CHECK_RESULT $? 1 0 "Check build single lack of build_id no exist"
    snapshot_id=$(ccb select builds os_project=test-00${num} build_id=${build_id} -f snapshot_id | grep snapshot_id | awk -F ":" '{print $2}' | sed -e 's/^[ ]*//g' | sed 's/"\(.*\)"/\1/g')
    ccb build-single os_project=test-00${num} packages=python-flask snapshot_id=${snapshot_id} | grep '\"code\": 0'
    CHECK_RESULT $? 0 0 "Check build single failed only snapshot_id"
    ccb build-single os_project=test-00${num} packages=python-flask snapshot_id=${snapshot_id} --json ../data/json/build_targets_snapshot_noinclude.json| grep '\"code\": 0'
    CHECK_RESULT $? 1 0 "Check build single failed build targets not include in snapshot"
    ccb build-single os_project=test-00${num} packages=python-flask snapshot_id=${snapshot_id} --json ../data/json/build_targets_snapshot.json| grep '\"code\": 0'
    CHECK_RESULT $? 0 0 "Check build single failed build targets include in snapshot"
    ccb build-single os_project=test-00${num} packages=python-flask  --json ../data/json/build_targets_snapshot.json --yaml ../data/yaml/build_single-all-params.yaml build_id=1234 | grep '\"code\": 0'
    CHECK_RESULT $? 1 0 "Check build single failed build id no exist"
    ccb build-single os_project=test-00${num} packages=python-flask  --json ../data/json/build_targets_snapshot.json --yaml ../data/yaml/build_single-all-params.yaml | grep '\"code\": 0'
    CHECK_RESULT $? 0 0 "Check build single failed json error"
    ccb build-single os_project=test-00${num} packages=python-flask  --json ../data/json/build_targets_snapshot.json  build_id=1234 --yaml ../data/yaml/build_single-all-params.yaml | grep '\"code\": 0'
    CHECK_RESULT $? 1 0 "Check build single failed build id no exist"
    ccb build-single os_project=test-00${num} packages=python-flask build_id=${build_id} snapshot_id=xx | grep '\"code\": 0'
    CHECK_RESULT $? 1 0 "Check build single failed snapshot_id no exist"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    ccb update projects test-00${num} -j ../data/json/del.json
    LOG_INFO "End to restore the test environment."
}

main "$@"
