opyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   Classicriver_jia
# @Contact   :   classicriver_jia@foxmail.com
# @Date      :   2020-06-08
# @License   :   Mulan PSL v2
# @Desc      :   prepare isulad
# ############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_isulad_env() {
    DNF_INSTALL "iSulad tar wget"
    clean_isulad_env
    #if grep -i version= /etc/os-release | awk -F '"' '{print$2}' | grep "("; then
    #    os_version=$(grep -i version= /etc/os-release | awk -F '"' '{print$2}' | tr '()' '- ' | sed s/[[:space:]]//g)
    #else
    #    if grep -i version= /etc/os-release | awk -F '"' '{print$2}' | grep "LTS"; then
    #        os_version=$(grep -i version= /etc/os-release | awk -F '"' '{print$2}' | awk -F ' ' '{print$1"-"$2}')
    #    else
    #        os_version=$(grep -i version= /etc/os-release | awk -F '"' '{print$2}')
    #    fi
    #fi
    #wget -P ../common/ https://repo.tarsier-infra.isrc.ac.cn/openEuler-RISC-V/testing/2403LTS-test/v1/24.03_docker_image.tar.gz
    cp ~/24.03_docker_image.tar.gz ../common/
    #isula load -i ../common/openEuler-docker.${NODE1_FRAME}.tar.xz
    isula load -i ../common/24.03_docker_image.tar.gz
    Images_name=jchzhou/oerv:24.03
    test -n "${Images_name}" || exit 1
}

function run_isulad_container() {
    containerId=$(isula run -itd ${Images_name})
    CHECK_RESULT $?
    isula inspect -f {{.State.Status}} ${containerId} | grep running
    CHECK_RESULT $?
}

function clean_isulad_env() {
    isula stop $(isula ps -aq)
    isula rm $(isula ps -aq)
    isula rmi $(isula images -q)
    test -z "$(isula images -q)"
    rm -rf ../common/24.03_docker_image.tar.gz
    CHECK_RESULT $?
}

