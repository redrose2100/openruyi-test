#!/usr/bin/bash
# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
# @Author    :   zhuwenshuo
# @Contact   :   1003254035@qq.com
# @Date      :   2023/02/21
# @License   :   Mulan PSL v2
# @Desc      :   Test conmon command 
#####################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function deploy_env() {
    DNF_INSTALL "conmon podman docker-runc podman-docker tar"
    echo -e "[registries.search]
registries = ['docker.io']

[registries.insecure]
registries = []

[registries.block]
registries = []
" >/etc/containers/registries.conf
}

function clear_env() {
    podman rm -all
    podman rmi -f -all
    DNF_REMOVE
}
