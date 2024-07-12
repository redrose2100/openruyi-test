#!/usr/bin/bash

# Copyright (c) 2024. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
#@Author        :   linmengmeng
#@Contact       :   linmengmeng@huawei.com
#@Date          :   2024-07-10
#@License       :   Mulan PSL v2
#@Desc          :   Public class
#####################################
# shellcheck disable=SC2086

source "${OET_PATH}/libs/locallibs/common_lib.sh"

function init_env() {
    packages=("elfutils-libelf-devel" "openssl-devel" "flex" "python3-devel" "rpm-build" "bison" "cmake" "make" "gcc" "kpatch-runtime" "telnet" "perl-devel" "bind-utils")
    yum install -y ${packages[*]}
    rpm -q syscare || yum install -y syscare
    rpm -q syscare-build || yum install -y syscare-build
}

function download_and_compile_redis() {
    pushd ./
    cd /root
    ls | grep redis | grep 'src.rpm' || {
        openeulerversion=$(cat /etc/openEuler-latest | grep openeulerversion | awk -F '=' '{print $2}')
        wget -r -np -nd -nH --accept="redis-4.0.14*.src.rpm" https://repo.openeuler.org/${openeulerversion}/source/Packages/
        redis_src_rpm=$(ls | grep "^redis.*src.rpm")
        rpm -ivh ${redis_src_rpm}
        cd /root/rpmbuild/SPECS && rpmbuild -ba redis.spec
        cp /root/rpmbuild/SRPMS/* /root/
        cp /root/rpmbuild/RPMS/$(arch)/* /root/
        cd /root
        rpm -ivh $(ls | grep "^redis-[1-9].*$(arch).rpm")
    }
    popd
}
