
#!/usr/bin/bash
# 请填写测试用例描述：测试 kwin_wayland 的 --exit-with-session 参数

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "kwin"
    # 准备测试数据等,如果要创建文件请使用"./你要创建的文件"直接把文件创建到当前目录下
    # 创建一个简单的测试应用
    echo -e '#!/bin/bash\nsleep 5' > ./test_app.sh
    chmod +x ./test_app.sh
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试 --exit-with-session 参数
    kwin_wayland --exit-with-session ./test_app.sh &
    sleep 10
    CHECK_RESULT $? 0 0 "kwin_wayland --exit-with-session failed"
    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 测试后环境恢复：
    # 卸载安装的软件包
    DNF_REMOVE "kwin"
    # 清理测试中间产物文件
    rm -f ./test_app.sh
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
