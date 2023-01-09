# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   hua
# @Contact   :   dchang@zhixundn.com
# @Date      :   2022/11/20
# @License   :   Mulan PSL v2
# @Desc      :   verify the uasge of libappstream-glib command
# ############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL libappstream-glib
    mkdir -p glibtest/pkg
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run test."

    appstream-builder -v --temp-dir glibtest/tepmtest --packages-dir glibtest/pkg --origin metadata && test -f example.xml.gz
    CHECK_RESULT $? 0 0 "Check appstream-builder -v --log-dir --packages-dir --origin failed"

    rm -rf cache example-ignore.xml.gz  example.xml.gz tepmtest
    appstream-builder -v --output-dir glibtest/out --packages-dir glibtest/pkg --origin metadata && test -f glibtest/out/example.xml.gz
    CHECK_RESULT $? 0 0 "Check appstream-builder -v --log-dir --packages-dir --origin failed"

    rm -rf cache example-ignore.xml.gz  example.xml.gz tepmtest
    appstream-builder -v --icons-dir glibtest/icons --packages-dir glibtest/pkg --origin metadata && test -f example.xml.gz
    CHECK_RESULT $? 0 0 "Check appstream-builder -v --icons-dir --packages-dir --origin metadata  failed"

    rm -rf cache example-ignore.xml.gz  example.xml.gz tepmtest
    appstream-builder -v --cache-dir glibtest/caches --packages-dir glibtest/pkg --origin metadata && test -f example.xml.gz
    CHECK_RESULT $? 0 0 "Check appstream-builder -v --cache-dir --packages-dir --origin failed"

    rm -rf cache example-ignore.xml.gz  example.xml.gz tepmtest
    appstream-builder -v --basename metadata --packages-dir glibtest/pkg --origin metadata --max-threads 3 && test -f metadata.xml.gz
    CHECK_RESULT $? 0 0 "Check appstream-builder -v --basename --packages-dir --origin --max-threads failed"

    rm -rf cache metadata-ignore.xml.gz  metadata.xml.gz tmp
    appstream-builder -v --basename metadata --packages-dir glibtest/pkg --origin metadata --min-icon-size=1024 && test -f metadata.xml.gz
    CHECK_RESULT $? 0 0 "Check appstream-builder -v --basename --packages-dir --origin --min-icon-size failed"

    rm -rf cache metadata-ignore.xml.gz  metadata.xml.gz tmp
    appstream-builder -v --basename metadata --packages-dir glibtest/pkg --origin metadata --old-metadata glibtest/old && test -f metadata.xml.gz
    CHECK_RESULT $? 0 0 "Check appstream-builder -v --basename --packages-dir --origin --old-metadata failed"

    rm -rf cache metadata-ignore.xml.gz  metadata.xml.gz tmp
    appstream-builder -v --basename metadata --packages-dir glibtest/pkg --origin metadata --veto-ignore component && test -f metadata.xml.gz
    CHECK_RESULT $? 0 0 "Check appstream-builder -v --basename --packages-dir --origin --veto-ignore failed"
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    rm -rf glibtest cache tmp *.gz
    LOG_INFO "Finish restore the test environment."
}

main "$@"
