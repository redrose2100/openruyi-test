
#!/usr/bin/bash
# 测试用例描述：测试 ges-launch-1.0 +test-clip 命令及其参数

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
    ges-launch-1.0 +test-clip "pattern1" duration=10
    CHECK_RESULT $? 0 0 "failed to run ges-launch-1.0 +test-clip pattern1 with duration"

    ges-launch-1.0 +test-clip "pattern2" name=testclip1 start=5 duration=10
    CHECK_RESULT $? 0 0 "failed to run ges-launch-1.0 +test-clip pattern2 with properties"

    ges-launch-1.0 +test-clip "pattern3" start=10 duration=15 inpoint=2 layer=1
    CHECK_RESULT $? 0 0 "failed to run ges-launch-1.0 +test-clip pattern3 with properties"

    ges-launch-1.0 +test-clip "pattern4" name=testclip2 start=0 duration=20 inpoint=5 layer=2
    CHECK_RESULT $? 0 0 "failed to run ges-launch-1.0 +test-clip pattern4 with properties"

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
