#!/usr/bin/bash

# Copyright (c) 2022. Lanzhou University of Technology.,Univ.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use this software according to the terms and conditions of the Mulan PSL v2.
# You may obtain a copy of Mulan PSL v2 at:
#          http://license.coscl.org.cn/MulanPSL2
# THIS SOFTWARE IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   DingYaoyao
# @Contact   :   d1005562341@126.com
# @Date      :   2022/08/20
# @License   :   Mulan PSL v2
# @Desc      :   nototools common prepare
# #############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function notoconfig_pre(){
    TMP_SRCDIR="$(mktemp -d -t nototools.SRC.XXXXXXXXXXXX)"
    yumdownloader --source nototools --destdir ${TMP_SRCDIR} > /dev/null
    rpm2cpio ${TMP_SRCDIR}/*.rpm | cpio -div -D ${TMP_SRCDIR} > /dev/null 2>&1
    tar -zxf ${TMP_SRCDIR}/*.tar.gz --strip-components 1 --directory ${TMP_SRCDIR} > /dev/null
    echo "noto_tools=${TMP_SRCDIR}" > ~/.notoconfig

    for src in "fonts" "cjk" "emoji"
    do
        # git clone https://github.com/notofonts/noto-${src}.git ${TMP_SRCDIR}
        echo "noto_${src}=${TMP_SRCDIR}/noto-${src}" >> ~/.notoconfig
    done
}

function common_pre() {
    pip install -r ../common/requirements.txt > /dev/null 2>&1
    DNF_INSTALL "nototools harfbuzz-devel cpio pango python3-gobject python3-cairo"
    notoconfig_pre
}

function common_post() {
    rm -rf ${TMP_SRCDIR} ~/.notoconfig
    DNF_REMOVE
    # pip3 uninstall -r ../common/requirements.txt -y > /dev/null 2>&1
}