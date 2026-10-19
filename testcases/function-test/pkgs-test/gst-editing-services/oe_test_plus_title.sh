
#!/usr/bin/bash
# 测试用例描述：测试ges-launch-1.0命令的+title参数，创建并播放一个标题为指定文本的多媒体时间线。

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "gst-editing-services"
    # 准备测试数据等,如果要创建文件请使用"./你要创建的文件"直接把文件创建到当前目录下
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试内容,请尽可能详尽的测试命令的参数,如命令的参数组合,命令的参数顺序等
    ges-launch-1.0 +title "Hello World" duration=10.0
    CHECK_RESULT $? 0 0 "Failed to run ges-launch-1.0 with +title parameter and duration option."

    ges-launch-1.0 +title "Hello World" start=5.0 duration=10.0
    CHECK_RESULT $? 0 0 "Failed to run ges-launch-1.0 with +title parameter, start and duration options."

    ges-launch-1.0 +title "Hello World" inpoint=2.0 duration=10.0
    CHECK_RESULT $? 0 0 "Failed to run ges-launch-1.0 with +title parameter, inpoint and duration options."

    ges-launch-1.0 +title "Hello World" layer=1 duration=10.0
    CHECK_RESULT $? 0 0 "Failed to run ges-launch-1.0 with +title parameter, layer and duration options."

    ges-launch-1.0 +title "Hello World" start=5.0 duration=10.0 inpoint=2.0 layer=1
    CHECK_RESULT $? 0 0 "Failed to run ges-launch-1.0 with +title parameter and all options."
    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 测试后环境恢复：
        # 卸载安装的软件包
        # 清理测试中间产物文件
    DNF_REMOVE "gst-editing-services"
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
