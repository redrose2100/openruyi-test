
#!/usr/bin/bash
# 本测试用例用于测试kf5-plasma软件包中的kpackagetool5命令的--remove参数

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "kf5-plasma"
    # 准备测试数据
    # 假设我们有一个名为"test-package"的包，用于测试
    # 创建一个测试包文件
    mkdir -p ./test-package
    touch ./test-package/metadata.desktop
    echo "[Desktop Entry]" > ./test-package/metadata.desktop
    echo "Name=test-package" >> ./test-package/metadata.desktop
    echo "Type=Application" >> ./test-package/metadata.desktop
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试kpackagetool5 --remove参数
    # 安装测试包
    kpackagetool5 --install ./test-package
    CHECK_RESULT $? 0 0 "Failed to install package 'test-package'"
    # 移除名为"test-package"的包
    kpackagetool5 --remove "test-package"
    CHECK_RESULT $? 0 0 "Failed to remove package 'test-package'"
    # 再次尝试移除已移除的包，验证是否正确处理
    kpackagetool5 --remove "test-package"
    CHECK_RESULT $? 1 0 "Package 'test-package' should not be found after removal"
    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 卸载安装的软件包
    DNF_REMOVE "kf5-plasma"
    # 清理测试中间产物文件
    rm -rf ./test-package
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
