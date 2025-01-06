
#!/usr/bin/bash
# 本测试用例用于测试kf5-plasma软件包中的kpackagetool5命令的升级功能

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "kf5-plasma"
    # 准备测试数据
    mkdir -p ./test_package
    touch ./test_package/package1
    touch ./test_package/package2
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试升级功能
    /usr/bin/kpackagetool5 -t Plasma/Theme -u ./test_package/package1
    CHECK_RESULT $? 0 0 "Failed to upgrade package1"
    /usr/bin/kpackagetool5 -t Plasma/Theme -u ./test_package/package2
    CHECK_RESULT $? 0 0 "Failed to upgrade package2"
    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 卸载安装的软件包
    DNF_REMOVE "kf5-plasma"
    # 清理测试中间产物文件
    rm -rf ./test_package
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
