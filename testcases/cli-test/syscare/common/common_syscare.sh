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
# shellcheck disable=SC2086,SC2010

source "${OET_PATH}/libs/locallibs/common_lib.sh"

function init_env() {
    DNF_INSTALL "elfutils-libelf-devel openssl-devel flex python3-devel rpm-build bison cmake make gcc kpatch-runtime telnet perl-devel bind-utils syscare syscare-build"
    systemctl start syscare.service
}

function download_and_compile_redis() {
    pushd ./ || return
    cd /root || return
    ls | grep redis | grep 'src.rpm' || {
        openeulerversion=$(grep openeulerversion /etc/openEuler-latest | awk -F '=' '{print $2}')
        wget -r -np -nd -nH --accept="redis-4.0.14*.src.rpm" https://repo.openeuler.org/${openeulerversion}/source/Packages/
        redis_src_rpm=$(ls | grep "^redis.*src.rpm")
        rpm -ivh ${redis_src_rpm}
        cd /root/rpmbuild/SPECS || return
        rpmbuild -ba redis.spec
        cp /root/rpmbuild/SRPMS/* /root/
        cp "/root/rpmbuild/RPMS/$(arch)/*" /root/
        cd /root || return
        rpm -ivh "$(ls | grep "^redis-[1-9].*$(arch).rpm")"
    }
    popd || return
}

function restore_env() {
    DNF_REMOVE "$@"    
}
