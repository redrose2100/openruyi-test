
#!/usr/bin/bash
# 本测试用例用于测试xorg-x11-drv-synaptics包中的syndaemon命令，包括其各个参数的正确性和组合使用情况。

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "xorg-x11-drv-synaptics"
    # 创建测试所需的文件
    touch ./syndaemon.pid
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试基本命令
    syndaemon -i 1 -m 100 -d -p ./syndaemon.pid -t -k -K -R -v
    CHECK_RESULT $? 0 0 "syndaemon command failed"

    # 测试各个参数的组合
    syndaemon -i 3 -m 500 -d -p ./syndaemon.pid -t -k -K -R -v
    CHECK_RESULT $? 0 0 "syndaemon command with different parameters failed"

    # 测试帮助信息
    syndaemon -?
    CHECK_RESULT $? 0 0 "syndaemon help message failed"
    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 测试后环境恢复：
    # 卸载安装的软件包
    DNF_REMOVE "xorg-x11-drv-synaptics"
    # 清理测试中间产物文件
    rm -f ./syndaemon.pid
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
