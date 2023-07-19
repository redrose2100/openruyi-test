#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   liujingjing
# @Contact   :   liujingjing25812@163.com
# @Date      :   2023/07/06
# @License   :   Mulan PSL v2
# @Desc      :   Compile
# ############################################
# shellcheck disable=SC2154
# shellcheck disable=SC1091

source "${OET_PATH}"/libs/locallibs/common_lib.sh
source /etc/openEuler-latest
source ./compile.conf

#Configure original repo source
function configure_round_repo() {
    version=$1
    echo "[OS]
name=OS
baseurl=${http_url}/${version}/OS/$(arch)/
enabled=1
gpgcheck=1
gpgkey=${http_url}/${version}/OS/$(arch)/RPM-GPG-KEY-openEuler

[everything]
name=everything
baseurl=${http_url}/${version}/everything/$(arch)/
enabled=1
gpgcheck=1
gpgkey=${http_url}/${version}/everything/$(arch)/RPM-GPG-KEY-openEuler

[source]
name=source
baseurl=${source_http_url}/${version}/source/
enabled=1
gpgcheck=1
gpgkey=${http_url}/${version}/OS/$(arch)/RPM-GPG-KEY-openEuler
" >/etc/yum.repos.d/"${version}".repo
}

function configure_update_repo() {
    version=$1
    echo "[OS]
name=OS
baseurl=${http_url}/${version}/OS/$(arch)/
enabled=1
gpgcheck=1
gpgkey=${http_url}/${version}/OS/$(arch)/RPM-GPG-KEY-openEuler

[everything]
name=everything
baseurl=${http_url}/${version}/everything/$(arch)/
enabled=1
gpgcheck=1
gpgkey=${http_url}/${version}/everything/$(arch)/RPM-GPG-KEY-openEuler

[source]
name=source
baseurl=${update_http_url}/${version}/${update_version}/source/
enabled=1
gpgcheck=1
gpgkey=${http_url}/${version}/OS/$(arch)/RPM-GPG-KEY-openEuler

[update]
name=update
baseurl=${http_url}/${version}/update/$(arch)/
enabled=1
gpgcheck=1
gpgkey=${http_url}/${version}/OS/$(arch)/RPM-GPG-KEY-openEuler

[${update_version}]
name=${update_version}
baseurl=${update_http_url}/${version}/${update_version}/$(arch)/
enabled=1
gpgcheck=1
gpgkey=${http_url}/${version}/OS/$(arch)/RPM-GPG-KEY-openEuler
" >/etc/yum.repos.d/"${version}".repo
    if [[ ${version}x == "openEuler-20.03-LTS"x ]] || [[ ${version}x == "openEuler-20.03-LTS-SP1"x ]]; then
        echo "[EPOL]
name=EPOL
baseurl=${http_url}/${version}/EPOL/$(arch)/
enabled=1
gpgcheck=1
gpgkey=${http_url}/${version}/OS/$(arch)/RPM-GPG-KEY-openEuler

[EPOL_update]
name=EPOL_update
baseurl=${http_url}/${version}/EPOL/update/$(arch)/
enabled=1
gpgcheck=1
gpgkey=${http_url}/${version}/OS/$(arch)/RPM-GPG-KEY-openEuler" >>/etc/yum.repos.d/"${version}".repo
    else
        echo "[EPOL]
name=EPOL
baseurl=${http_url}/${version}/EPOL/main/$(arch)/
enabled=1
gpgcheck=1
gpgkey=${http_url}/${version}/OS/$(arch)/RPM-GPG-KEY-openEuler

[EPOL_update]
name=EPOL_update
baseurl=${http_url}/${version}/EPOL/update/main/$(arch)/
enabled=1
gpgcheck=1
gpgkey=${http_url}/${version}/OS/$(arch)/RPM-GPG-KEY-openEuler" >>/etc/yum.repos.d/"${version}".repo
    fi
}

main "$@"
