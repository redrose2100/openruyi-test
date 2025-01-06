
#!/usr/bin/bash
# 测试用例描述：测试hddtemp命令的基本功能和参数组合

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "hddtemp"
    # 准备测试数据等,如果要创建文件请使用"./你要创建的文件"直接把文件创建到当前目录下
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试基本功能
    hddtemp /dev/sda
    CHECK_RESULT $? 0 0 "hddtemp /dev/sda failed"

    # 测试--numeric参数
    hddtemp -n /dev/sda
    CHECK_RESULT $? 0 0 "hddtemp -n /dev/sda failed"

    # 测试--unit参数
    hddtemp -u C /dev/sda
    CHECK_RESULT $? 0 0 "hddtemp -u C /dev/sda failed"

    # 测试--unit参数，单位为F
    hddtemp -u F /dev/sda
    CHECK_RESULT $? 0 0 "hddtemp -u F /dev/sda failed"

    # 测试--quiet参数
    hddtemp -q /dev/sda
    CHECK_RESULT $? 0 0 "hddtemp -q /dev/sda failed"

    # 测试--drivebase参数
    hddtemp -b
    CHECK_RESULT $? 0 0 "hddtemp -b failed"

    # 测试--debug参数
    hddtemp -D /dev/sda
    CHECK_RESULT $? 0 0 "hddtemp -D /dev/sda failed"

    # 测试--daemon参数
    hddtemp -d
    CHECK_RESULT $? 0 0 "hddtemp -d failed"

    # 测试--file参数
    hddtemp -f /etc/hddtemp.db /dev/sda
    CHECK_RESULT $? 0 0 "hddtemp -f /etc/hddtemp.db /dev/sda failed"

    # 测试--foreground参数
    hddtemp -F /dev/sda
    CHECK_RESULT $? 0 0 "hddtemp -F /dev/sda failed"

    # 测试--listen参数
    hddtemp -l 127.0.0.1
    CHECK_RESULT $? 0 0 "hddtemp -l 127.0.0.1 failed"

    # 测试--port参数
    hddtemp -p 7634 /dev/sda
    CHECK_RESULT $? 0 0 "hddtemp -p 7634 /dev/sda failed"

    # 测试--separator参数
    hddtemp -s ":" /dev/sda
    CHECK_RESULT $? 0 0 "hddtemp -s : /dev/sda failed"

    # 测试--syslog参数
    hddtemp -S 10 /dev/sda
    CHECK_RESULT $? 0 0 "hddtemp -S 10 /dev/sda failed"

    # 测试--wake-up参数
    hddtemp -w /dev/sda
    CHECK_RESULT $? 0 0 "hddtemp -w /dev/sda failed"

    # 测试--version参数
    hddtemp -v
    CHECK_RESULT $? 0 0 "hddtemp -v failed"

    # 测试--version参数
    hddtemp --version
    CHECK_RESULT $? 0 0 "hddtemp --version failed"

    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 测试后环境恢复：
    # 卸载安装的软件包
    DNF_REMOVE "hddtemp"
    # 清理测试中间产物文件
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
