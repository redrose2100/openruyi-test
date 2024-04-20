#!/usr/bin/bash
# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more detaitest -f.

# #############################################
# @Author    :   leijie
# @Contact   :   593557320@qq.com
# @Date      :   2023/07/21
# @License   :   Mulan PSL v2
# @Desc      :   imageTailor function test
# #############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh
source "${OET_PATH}"/testcases/cli-test/common/common_lib.sh
TIMEOUT="90m"
oeversion="$(cat /etc/openEuler-latest | grep openeulerversion | awk -F '=' '{print $2}')"
dir="$(pwd)"

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL imageTailor wget
    mv /opt/imageTailor /home/
    mkdir -p /home/imageTailor/repos/euler_base/
    wget --no-check-certificate https://repo.openeuler.org/"${oeversion}"/ISO/"$(arch)"/"${oeversion}"-everything-"$(arch)"-dvd.iso -P /home
    ls /mnt/shared/"${oeversion}"-everything-"$(arch)"-dvd.iso
    CHECK_RESULT $? 0 0
    mount /mnt/shared/"${oeversion}"-everything-"$(arch)"-dvd.iso /mnt
    cp -ar /mnt/Packages/* /home/imageTailor/repos/euler_base/
    chmod -R 644 /home/imageTailor/repos/euler_base
    umount /mnt
    echo 'GRUB_PASSWORD="grub.pbkdf2.sha512.10000.D4D775602C4E9F76EF4A9A6E726486941C8AAFB4762227E6973690ED5A760D59247E7E6ECA72472FBEEBFD9DB60F8EE56A4078094542C790BF0967879BE2D60C.B2742F38995B4B716EA7B0E639D02BE6C4E649E30576E5F5505B85844172B831841DA80D264FD14B025F3C8804158E7FC082998664BD03A92663FB4CE293807B"' >> /home/imageTailor/custom/*/usr_file/etc/default/grub
    sed -i 's/user pwd=""/user pwd="$6$yJiM4Ips$eto\/4erJfqkYcAtYw87Ne5Gj1ERWG2iAQiiO4iLMaYgqZOTPn5k\/xM9EEdofQZXAuJxxuYE8G6Tmgl4LaSopq1"/g' /home/imageTailor/kiwi/minios/cfg_minios/rpm.conf
    sed -i 's/user pwd=""/user pwd="$6$yJiM4Ips$eto\/4erJfqkYcAtYw87Ne5Gj1ERWG2iAQiiO4iLMaYgqZOTPn5k\/xM9EEdofQZXAuJxxuYE8G6Tmgl4LaSopq1"/g' /home/imageTailor/custom/*/rpm.conf
    sed -i 's/user pwd=""/user pwd="$6$yJiM4Ips$eto\/4erJfqkYcAtYw87Ne5Gj1ERWG2iAQiiO4iLMaYgqZOTPn5k\/xM9EEdofQZXAuJxxuYE8G6Tmgl4LaSopq1"/g' /home/imageTailor/kiwi/minios/cfg_minios*/rpm.conf
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    cd /home/imageTailor || exit
    ./mkdliso -p openEuler -c custom/cfg_openEuler
    CHECK_RESULT $? 0 0
    ls /home/imageTailor/result/"$(date +%Y)"*/openEuler-"$(arch)".iso
    CHECK_RESULT $? 0 0
    cd /home/imageTailor/result/"$(date +%Y)"*/ || exit
    sha256sum -c openEuler-"$(arch)".iso.sha256
    CHECK_RESULT $? 0 0
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    cd "${dir}"
    rm -rf /home/imageTailor /home/"${oeversion}"-everything-"$(arch)"-dvd.iso
    DNF_REMOVE
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
