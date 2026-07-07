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
# @Author    :   blackgaryc
# @Contact   :   blackgaryc@gmail.com
# @Date      :   2022/5/17
# @License   :   Mulan PSL v2
# @Desc      :   Test container-exception-logger
# #############################################


source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL "docker-engine wget"
    #read version from file
    . /etc/os-release
    PRETTY_NAME=$(echo "$PRETTY_NAME" | tr -d '(' | tr -d ')' | tr ' ' -)
    #对于riscv架构，从sp3版本开始有rva20和rva23两个版本，兼容该场景
    RVER=$(grep -o "rva2[03]" /etc/yum.repos.d/*.repo | head -n1 | tr '[:lower:]' '[:upper:]')
    local DAILYBUILD_BASE="https://dailybuild.openeuler.openatom.cn/dailybuild/EBS-"
    local CDN_BASE="https://dl-cdn.openeuler.openatom.cn"
    local IMG_ROOT=""
    
    if grep -E "rc[0-9]_openeuler-" /etc/yum.repos.d/*.repo 2>/dev/null; then
	rc_dir=$(grep -Eo "rc[0-9]_openeuler-[0-9\-]+" /etc/yum.repos.d/*.repo | head -n1)
        IMG_ROOT="${DAILYBUILD_BASE}${PRETTY_NAME}/${rc_dir}"
    else
        IMG_ROOT="${CDN_BASE}/${PRETTY_NAME}"
    fi

    if [[ "$RVER" == RVA* ]]; then
       wget -q "${IMG_ROOT}/docker_img/${NODE1_FRAME}/openEuler-docker.$NODE1_FRAME-$RVER.tar.xz"
    else
       wget -q "${IMG_ROOT}/docker_img/${NODE1_FRAME}/openEuler-docker.$NODE1_FRAME.tar.xz"
    fi

    DFILE=$(ls openEuler-docker."${NODE1_FRAME}"*.tar.xz)
    docker load < "$DFILE"
    IMAGE_NAME=$(tar -xJvf "$DFILE" -O manifest.json | grep -Eo 'docker.io/library/openeuler[^"]+' | awk -F'/' '{print $NF}')
    
    # create Dockerfile to build image
    rm -fv Dockerfile
    cat <<EOF >Dockerfile
FROM $IMAGE_NAME
RUN sed -i "s|https://repo\.openeuler\.org/${PRETTY_NAME}|${IMG_ROOT}|g" /etc/yum.repos.d/*.repo
RUN sed -i "s|http://repo\.openeuler\.org/${PRETTY_NAME}|${IMG_ROOT}|g" /etc/yum.repos.d/*.repo
RUN yum install -y container-exception-logger && yum clean all
EOF

    # Build an image to avoid repeated installation of container-exception-logger
    docker build -t openeuler-container-exception-logger .
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    # test without any option
    echo without-option-test | docker run --rm -i openeuler-container-exception-logger container-exception-logger 2>&1 | grep "container-exception-logger - without-option-test"
    CHECK_RESULT $? 0 0 "test failed without option"
    # test option --help
    docker run --rm -i openeuler-container-exception-logger container-exception-logger --help 2>&1 | grep "Usage: container-exception-logger"
    CHECK_RESULT $? 0 0 "test failed with option --help"
    # test option --no-tag
    echo option-no-tag-test | docker run --rm -i openeuler-container-exception-logger container-exception-logger --no-tag 2>&1 | grep "option-no-tag-test"
    CHECK_RESULT $? 0 0 "test failed with option --no-tag"
    # test option --tag
    echo option-tag-test | docker run --rm -i openeuler-container-exception-logger container-exception-logger --tag example-tag 2>&1 | grep "example-tag - option-tag-test"
    CHECK_RESULT $? 0 0 "test failed with option --tag"
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    rm -rf Dockerfile "$DFILE"
    docker rmi openeuler-container-exception-logger "$IMAGE_NAME"
    DNF_REMOVE
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
