#!/usr/bin/bash

# Copyright (c) 2025. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   gaoshuaishuai
# @Contact   :   gaoshuaishuai@uniontech.com
# @Date      :   2025/10/20
# @License   :   Mulan PSL v2
# @Desc      :   test metaflac
# ############################################

source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL "flac"
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run test."
    metaflac --list common/myaudio.flac
    CHECK_RESULT $? 0 0 "Failed to display all metadata for FLAC file"
    metaflac --export-tags-to=tags.txt common/myaudio.flac
    CHECK_RESULT $? 0 0 "Exporting all tags from FLAC file to one text file failed"
    metaflac --remove-tag="ARTIST" common/myaudio.flac
    CHECK_RESULT $? 0 0 "Failed to delete a tag in FLAC file"
    metaflac --set-tag="ARTIST=John Doe" common/myaudio.flac
    CHECK_RESULT $? 0 0 "Adding a new tag to FLAC file failed"
    metaflac --preserve-modtime --set-tag="ALBUM=My Album" common/myaudio.flac
    CHECK_RESULT $? 0 0 "Failed to retain the original modification time of the file"
    LOG_INFO "End of the test."
}

function post_test() {
  LOG_INFO "start environment cleanup."
  rm -rf tags.txt
  DNF_REMOVE "$@"
  LOG_INFO "Finish environment cleanup!"
}

main "$@"
