
#!/usr/bin/bash
# 本测试脚本用于测试kf5-plasma软件包中的kpackagetool5命令的--install参数

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "kf5-plasma"
    # 准备测试数据
    mkdir -p ./test_package
    touch ./test_package/package.kpackage
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试安装单个包
    kpackagetool5 --install ./test_package/package.kpackage
    CHECK_RESULT $? 0 0 "Failed to install package"
    
    # 测试安装全局包
    kpackagetool5 --global --install ./test_package/package.kpackage
    CHECK_RESULT $? 0 0 "Failed to install global package"
    
    # 测试安装指定类型的包
    kpackagetool5 --type Plasma/Theme --install ./test_package/package.kpackage
    CHECK_RESULT $? 0 0 "Failed to install package with type"
    
    # 测试安装包到指定的包根目录
    mkdir -p ./custom_packageroot
    kpackagetool5 --packageroot ./custom_packageroot --install ./test_package/package.kpackage
    CHECK_RESULT $? 0 0 "Failed to install package to custom packageroot"
    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 卸载安装的软件包
    DNF_REMOVE "kf5-plasma"
    # 清理测试中间产物文件
    rm -rf ./test_package
    rm -rf ./custom_packageroot
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
