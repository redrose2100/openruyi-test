#!/usr/bin/bash

# Copyright (c) 2024. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   gaoshuaishuai
# @Contact   :   gaoshuaishaui@uniontech.com
# @Date      :   2024/02/22
# @License   :   Mulan PSL v2
# @Desc      :   test  ffmpeg
# ############################################
# shellcheck disable=SC1090,SC2119

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
  LOG_INFO "Start environmental preparation."
  DNF_INSTALL ffmpeg
  LOG_INFO "End of environmental preparation!"
}

function run_test() {
  LOG_INFO "Start to run test."
  ffprobe common/test.mpg
  CHECK_RESULT $? 0 0 "Failed to obtain information from test.mpg file"
  ffmpeg -i common/test.mpg test.yuv
  CHECK_RESULT $? 0 0 "Ffmpeg decoding MPEG-2 video file to YUV format error"
  
  # 新增：检测图形显示环境（同时兼容X11(DISPLAY)、Wayland(WAYLAND_DISPLAY)图形环境），无图形设备则跳过ffplay
  if [[ -z "${DISPLAY}" && -z "${WAYLAND_DISPLAY}" ]]; then
    LOG_INFO "Current environment has no graphical display device, skip ffplay playback test"
  else
    # -nodisp 关闭窗口、-autoexit 播放完成自动退出，避免阻塞
    ffplay -autoexit -nodisp test.yuv
    CHECK_RESULT $? 0 0 "ffplay cannot play generated yuv raw video"
  fi
  LOG_INFO "End of the test."
}

function post_test() {
  LOG_INFO "start environment cleanup."
  DNF_REMOVE
  rm -rf test.yuv
  LOG_INFO "Finish environment cleanup!"
}

main "$@"
