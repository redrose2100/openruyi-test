#!/bin/bash
# shellcheck disable=SC1017

source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 部署secD
function secD_deploy() {
    yum install -y gdb secDetector*
    modprobe secDetector_core
    modprobe secDetector_kmodule_baseline
    modprobe secDetector_memory_corruption
    modprobe secDetector_program_action
}

# 移除secD
function secD_remove() {
    modprobe -r secDetector_program_action
    modprobe -r secDetector_memory_corruption
    modprobe -r secDetector_kmodule_baseline
    modprobe -r secDetector_core
}

function secD_start() {
    ulimit -l unlimited
    secDetectord
}

function secD_stop() {
    pkill secDetectord
}
