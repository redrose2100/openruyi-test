#!/usr/bin/bash

# Copyright (c) 2023.Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   zhengyiwen
# @Contact   :   470257028@qq.com
# @Date      :   2023-10-12
# @License   :   Mulan PSL v2
# @Desc      :   isula-build test common
# ############################################
# shellcheck disable=SC2068
source ./common/common.sh

function pre_test() {
    LOG_INFO "Start environment preparation."
    pre_isula_build_env
    LOG_INFO "Environmental preparation is over."
}

function run_test() {
    LOG_INFO "Start executing testcase."
    images_name=$(isula-build ctr-img images | grep "docker.io/library/openeuler" | awk '{print$1}')
    cat > Dockerfile << EOF
FROM "${images_name}":latest
RUN touch build_test
EOF
    isula-build ctr-img build -f Dockerfile -o isulad:openeulerbase:latest .
    CHECK_RESULT $? 0 0 "isula-build build failed"

    con_id=$(isula run -itd openeulerbase:latest bash)
    CHECK_RESULT $? 0 0 "isula run failed"

    isula rm -f "${con_id}"
    isula rmi openeulerbase

    isula-build ctr-img rm openeulerbase "${images_name}"
    CHECK_RESULT $? 0 0 "isula-build rm images failed"
    LOG_INFO "End of testcase execution."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    rm -rf Dockerfile
    clean_isula_build_env
    LOG_INFO "Finish environment cleanup."
}

main $@
