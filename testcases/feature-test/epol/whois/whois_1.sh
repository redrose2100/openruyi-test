
#!/usr/bin/bash
# 本测试用例用于验证whois命令的基本功能和参数组合

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "whois"
    # 准备测试数据等
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 基本功能测试
    whois HELP
    CHECK_RESULT $? 0 0 "whois HELP failed"

    # 测试-h参数
    whois -h whois.nic.help HELP
    CHECK_RESULT $? 0 0 "whois -h whois.nic.help HELP failed"

    # 测试-p参数
    whois -p 43 HELP
    CHECK_RESULT $? 0 0 "whois -p 43 HELP failed"

    # 测试-I参数
    whois -I HELP
    CHECK_RESULT $? 0 0 "whois -I HELP failed"

    # 测试-H参数
    whois -H HELP
    CHECK_RESULT $? 0 0 "whois -H HELP failed"

    # 测试--verbose参数
    whois --verbose HELP
    CHECK_RESULT $? 0 0 "whois --verbose HELP failed"

    # 测试-l参数
    whois -l HELP
    CHECK_RESULT $? 0 0 "whois -l HELP failed"

    # 测试-L参数
    whois -L HELP
    CHECK_RESULT $? 0 0 "whois -L HELP failed"

    # 测试-m参数
    whois -m HELP
    CHECK_RESULT $? 0 0 "whois -m HELP failed"

    # 测试-M参数
    whois -M HELP
    CHECK_RESULT $? 0 0 "whois -M HELP failed"

    # 测试-c参数
    whois -c HELP
    CHECK_RESULT $? 0 0 "whois -c HELP failed"

    # 测试-x参数
    whois -x HELP
    CHECK_RESULT $? 0 0 "whois -x HELP failed"

    # 测试-b参数
    whois -b HELP
    CHECK_RESULT $? 0 0 "whois -b HELP failed"

    # 测试-B参数
    whois -B HELP
    CHECK_RESULT $? 0 0 "whois -B HELP failed"

    # 测试-G参数
    whois -G HELP
    CHECK_RESULT $? 0 0 "whois -G HELP failed"

    # 测试-d参数
    whois -d HELP
    CHECK_RESULT $? 0 0 "whois -d HELP failed"

    # 测试-i参数
    whois -i mnt-irt HELP
    CHECK_RESULT $? 0 0 "whois -i mnt-irt HELP failed"

    # 测试-T参数
    whois -T domain HELP
    CHECK_RESULT $? 0 0 "whois -T domain HELP failed"

    # 测试-K参数
    whois -K HELP
    CHECK_RESULT $? 0 0 "whois -K HELP failed"

    # 测试-r参数
    whois -r HELP
    CHECK_RESULT $? 0 0 "whois -r HELP failed"

    # 测试-R参数
    whois -R HELP
    CHECK_RESULT $? 0 0 "whois -R HELP failed"

    # 测试-a参数
    whois -a HELP
    CHECK_RESULT $? 0 0 "whois -a HELP failed"

    # 测试-s参数
    whois -s whois.nic.help HELP
    CHECK_RESULT $? 0 0 "whois -s whois.nic.help HELP failed"

    # 测试-g参数
    whois -g whois.nic.help:1-10 HELP
    CHECK_RESULT $? 0 0 "whois -g whois.nic.help:1-10 HELP failed"

    # 测试-t参数
    whois -t domain HELP
    CHECK_RESULT $? 0 0 "whois -t domain HELP failed"

    # 测试-v参数
    whois -v domain HELP
    CHECK_RESULT $? 0 0 "whois -v domain HELP failed"

    # 测试-q参数
    whois -q version HELP
    CHECK_RESULT $? 0 0 "whois -q version HELP failed"

    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 卸载安装的软件包
    DNF_REMOVE "whois"
    # 清理测试中间产物文件
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
