
#!/usr/bin/bash
# 测试用例描述：测试 ges-launch-1.0 命令的 +clip 参数

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "gst-editing-services"
    # 准备测试数据等,如果要创建文件请使用"./你要创建的文件"直接把文件创建到当前目录下
    touch "./test_video.mp4"
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试内容,请尽可能详尽的测试命令的参数,如命令的参数组合,命令的参数顺序等
    ges-launch-1.0 +clip ./test_video.mp4
    CHECK_RESULT $? 0 0 "failed to play video clip without parameters"

    ges-launch-1.0 +clip ./test_video.mp4 inpoint=4.0
    CHECK_RESULT $? 0 0 "failed to play video clip with inpoint parameter"

    ges-launch-1.0 +clip ./test_video.mp4 inpoint=4.0 duration=2.0 start=4.0
    CHECK_RESULT $? 0 0 "failed to play video clip with inpoint, duration, and start parameters"

    ges-launch-1.0 --track-types=audio +clip ./test_video.mp4
    CHECK_RESULT $? 0 0 "failed to play audio clip with track-types parameter"

    ges-launch-1.0 +clip ./test_video.mp4 layer=1 set-alpha 0.9 +clip ./test_video.mp4 layer=0
    CHECK_RESULT $? 0 0 "failed to play video clip with layer and alpha parameters"
    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 测试后环境恢复：
        # 卸载安装的软件包
        # 清理测试中间产物文件
    DNF_REMOVE "gst-editing-services"
    rm -f "./test_video.mp4"
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
