
#!/usr/bin/bash
# 本测试脚本用于测试parole命令的各种参数组合

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "parole"
    # 准备测试数据
    touch "./testfile1.mp4"
    touch "./testfile2.mp3"
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试帮助选项
    parole --help
    CHECK_RESULT $? 0 0 "parole --help failed"
    parole --help-all
    CHECK_RESULT $? 0 0 "parole --help-all failed"
    parole --help-gst
    CHECK_RESULT $? 0 0 "parole --help-gst failed"
    parole --help-gtk
    CHECK_RESULT $? 0 0 "parole --help-gtk failed"

    # 测试应用选项
    parole -i
    CHECK_RESULT $? 0 0 "parole -i failed"
    parole --new-instance
    CHECK_RESULT $? 0 0 "parole --new-instance failed"
    parole -n
    CHECK_RESULT $? 0 0 "parole -n failed"
    parole --no-plugins
    CHECK_RESULT $? 0 0 "parole --no-plugins failed"
    parole -d /dev/cdrom
    CHECK_RESULT $? 0 0 "parole -d /dev/cdrom failed"
    parole --device /dev/cdrom
    CHECK_RESULT $? 0 0 "parole --device /dev/cdrom failed"
    parole -E
    CHECK_RESULT $? 0 0 "parole -E failed"
    parole --embedded
    CHECK_RESULT $? 0 0 "parole --embedded failed"
    parole -F
    CHECK_RESULT $? 0 0 "parole -F failed"
    parole --fullscreen
    CHECK_RESULT $? 0 0 "parole --fullscreen failed"
    parole -p
    CHECK_RESULT $? 0 0 "parole -p failed"
    parole --play
    CHECK_RESULT $? 0 0 "parole --play failed"
    parole -N
    CHECK_RESULT $? 0 0 "parole -N failed"
    parole --next
    CHECK_RESULT $? 0 0 "parole --next failed"
    parole -P
    CHECK_RESULT $? 0 0 "parole -P failed"
    parole --previous
    CHECK_RESULT $? 0 0 "parole --previous failed"
    parole -r
    CHECK_RESULT $? 0 0 "parole -r failed"
    parole --volume-up
    CHECK_RESULT $? 0 0 "parole --volume-up failed"
    parole -l
    CHECK_RESULT $? 0 0 "parole -l failed"
    parole --volume-down
    CHECK_RESULT $? 0 0 "parole --volume-down failed"
    parole -m
    CHECK_RESULT $? 0 0 "parole -m failed"
    parole --mute
    CHECK_RESULT $? 0 0 "parole --mute failed"
    parole -u
    CHECK_RESULT $? 0 0 "parole -u failed"
    parole --unmute
    CHECK_RESULT $? 0 0 "parole --unmute failed"
    parole -a ./testfile1.mp4
    CHECK_RESULT $? 0 0 "parole -a ./testfile1.mp4 failed"
    parole --add ./testfile2.mp3
    CHECK_RESULT $? 0 0 "parole --add ./testfile2.mp3 failed"
    parole -V
    CHECK_RESULT $? 0 0 "parole -V failed"
    parole --version
    CHECK_RESULT $? 0 0 "parole --version failed"
    parole --display=:0.0
    CHECK_RESULT $? 0 0 "parole --display=:0.0 failed"

    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 卸载安装的软件包
    DNF_REMOVE "parole"
    # 清理测试中间产物文件
    rm -f "./testfile1.mp4"
    rm -f "./testfile2.mp3"
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
