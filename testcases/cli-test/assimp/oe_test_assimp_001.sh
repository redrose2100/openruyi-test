#!/usr/bin/bash

# Copyright (c) 2021. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more detaitest -f.

# #############################################
# @Author    :   huangdaohong
# @Contact   :   3170809690@qq.com
# @Date      :   2022/08/18
# @License   :   Mulan PSL v2
# @Desc      :   Test assimp
# #############################################

source "../common/common_lib.sh"

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL assimp
    tar -zxvf test.tar.gz
    mkdir tmp 
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    ! assimp --help 2>&1 | grep 'Unrecognized command' && assimp --help | grep 'assimp <verb> <parameters>'
    CHECK_RESULT $? 0 0 "Failed option: help"
    ! assimp version 2>&1 | grep 'Unrecognized command' && assimp version | grep 'Open Asset Import Library'
    CHECK_RESULT $? 0 0 "Failed option: version"
    assimp listext | grep '*.3d;'
    CHECK_RESULT $? 0 0 "Failed option: listext"
    assimp info test/1.obj | grep 'Memory consumption: '
    CHECK_RESULT $? 0 0 "Failed option: info"
    assimp knowext 'obj' | grep 'is known'
    CHECK_RESULT $? 0 0 "Failed option: knowext"
    assimp listexport | grep 'collada'
    CHECK_RESULT $? 0 0 "Failed option: listexport"
    assimp export --help | grep 'assimp export'
    CHECK_RESULT $? 0 0 "Failed option: export --help"
    assimp export ./test/1.obj ./tmp/out -fx | grep 'out'
    CHECK_RESULT $? 0 0 "Failed option: export"
    ! assimp extract --help | grep 'assimp extract:' && assimp extract --help | grep 'assimp extract'
    CHECK_RESULT $? 0 0 "Failed option: extract --help"
    assimp extract ./test/1.obj ba | grep 'import took approx'
    CHECK_RESULT $? 0 0 "Failed option: extract ba"
    assimp extract ./test/1.obj -t1 | grep 'assimp extract: Texture'
    CHECK_RESULT $? 0 0 "Failed option: extract -t"
    assimp extract ./test/1.obj -f | grep 'Exporting [0-9]* textures'
    CHECK_RESULT $? 0 0 "Failed option: extract -f"
    assimp extract ./test/1.obj -cfast | grep 'Exporting [0-9]* textures'
    CHECK_RESULT $? 0 0 "Failed option: extract -cfast"
    assimp extract ./test/1.obj -cdefault | grep 'Exporting [0-9]* textures'
    CHECK_RESULT $? 0 0 "Failed option: extract -cdefault"
    assimp extract ./test/1.obj -cfull | grep 'Exporting [0-9]* textures'
    CHECK_RESULT $? 0 0 "Failed option: extract -cfull"
    assimp exportinfo obj | grep 'obj'
    CHECK_RESULT $? 0 0 "Failed option: exportinfo"
    assimp dump ./test/1.obj ./tmp/1.xml | grep 'xml'
    CHECK_RESULT $? 0 0 "Failed option: dump"
    assimp dump ./test/1.obj ./tmp/1.xml && cp -r ./tmp/1.xml ./tmp/2.xml && assimp cmpdump ./tmp/1.xml ./tmp/2.xml | grep 'Success'
    CHECK_RESULT $? 0 0 "Failed option: cmpdump"
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    rm -rf tmp test
    DNF_REMOVE
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
