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
    mkdir glibtest
    cp ../common/dejavu.metainfo.xml ./glibtest
    appstream-util -v --profile --nonet install glibtest/dejavu.metainfo.xml
    mv /usr/share/metainfo/dejavu.metainfo.xml /usr/share/metainfo/dejavu.metainfo.xml-bak
    cp glibtest/dejavu.metainfo.xml /usr/share/metainfo/
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run test."

    appstream-compose -h | grep -Pz "Usage:[\S\s]*appstream-compose \[OPTION…\]"
    CHECK_RESULT $? 0 0 "Check appstream-compose -h failed"

    appstream-compose --help | grep -Pz "Usage:[\S\s]*appstream-compose \[OPTION…\]"
    CHECK_RESULT $? 0 0 "Check appstream-compose --help failed"

    appstream-compose -v dejavu | grep "Done!"
    CHECK_RESULT $? 0 0 "Check appstream-compose --v failed"

    appstream-compose --verbose dejavu | grep "Done!"
    CHECK_RESULT $? 0 0 "Check appstream-compose --verbose failed"

    appstream-compose -v --prefix /usr dejavu | grep "Done!"
    CHECK_RESULT $? 0 0 "Check appstream-compose -prefix failed"

    appstream-compose -v --output-dir glibtest/compose --icons-dir glibtest/icons --min-icon-size 1024 --origin apptest dejavu | grep "Done!"
    CHECK_RESULT $? 0 0 "Check appstream-compose --min-icon-size failed"

    appstream-compose -v --output-dir glibtest/compose --icons-dir glibtest/icons --min-icon-size 1024 --basename appbase dejavu | grep "Done!"
    CHECK_RESULT $? 0 0 "Check appstream-compose --basename failed"

}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    rm -rf glibtest
    mv -f /usr/share/metainfo/dejavu.metainfo.xml-bak /usr/share/metainfo/dejavu.metainfo.xml
    LOG_INFO "Finish restore the test environment."
}

main "$@"
