
#!/usr/bin/bash
# 本测试脚本用于测试xfconf-query命令的各种参数组合和功能

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "xfconf"
    # 准备测试数据
    mkdir -p ./test_channel
    echo "test_property" > ./test_channel/test_property
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试版本信息
    xfconf-query --version
    CHECK_RESULT $? 0 0 "xfconf-query --version failed"

    # 测试列出所有通道
    xfconf-query --list
    CHECK_RESULT $? 0 0 "xfconf-query --list failed"

    # 测试列出指定通道的属性
    xfconf-query --channel test_channel --list
    CHECK_RESULT $? 0 0 "xfconf-query --channel test_channel --list failed"

    # 测试设置属性值
    xfconf-query --channel test_channel --property test_property --set "test_value"
    CHECK_RESULT $? 0 0 "xfconf-query --channel test_channel --property test_property --set test_value failed"

    # 测试获取属性值
    xfconf-query --channel test_channel --property test_property
    CHECK_RESULT $? 0 0 "xfconf-query --channel test_channel --property test_property failed"

    # 测试创建属性
    xfconf-query --channel test_channel --property new_property --set "new_value" --create
    CHECK_RESULT $? 0 0 "xfconf-query --channel test_channel --property new_property --set new_value --create failed"

    # 测试重置属性
    xfconf-query --channel test_channel --property test_property --reset
    CHECK_RESULT $? 0 0 "xfconf-query --channel test_channel --property test_property --reset failed"

    # 测试递归重置属性
    xfconf-query --channel test_channel --property test_property --reset --recursive
    CHECK_RESULT $? 0 0 "xfconf-query --channel test_channel --property test_property --reset --recursive failed"

    # 测试强制数组
    xfconf-query --channel test_channel --property test_property --set "test_value1 test_value2" --force-array
    CHECK_RESULT $? 0 0 "xfconf-query --channel test_channel --property test_property --set test_value1 test_value2 --force-array failed"

    # 测试切换布尔属性
    xfconf-query --channel test_channel --property test_property --set true --type bool
    xfconf-query --channel test_channel --property test_property --toggle
    CHECK_RESULT $? 0 0 "xfconf-query --channel test_channel --property test_property --toggle failed"

    # 测试监控通道
    xfconf-query --channel test_channel --monitor &
    sleep 5
    xfconf-query --channel test_channel --property test_property --set "new_value"
    CHECK_RESULT $? 0 0 "xfconf-query --channel test_channel --monitor failed"

    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 卸载安装的软件包
    DNF_REMOVE "xfconf"
    # 清理测试中间产物文件
    rm -rf ./test_channel
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
