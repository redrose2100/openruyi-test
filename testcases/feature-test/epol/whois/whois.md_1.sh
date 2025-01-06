
#!/usr/bin/bash
# 请填写测试用例描述：测试whois命令的基本功能和参数组合

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "whois"
    # 准备测试数据等,如果要创建文件请使用"./你要创建的文件"直接把文件创建到当前目录下
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试基本功能
    whois help
    CHECK_RESULT $? 0 0 "whois help failed"
    
    # 测试-h参数
    whois -h whois.nic.help help
    CHECK_RESULT $? 0 0 "whois -h whois.nic.help help failed"
    
    # 测试-p参数
    whois -p 43 help
    CHECK_RESULT $? 0 0 "whois -p 43 help failed"
    
    # 测试-I参数
    whois -I help
    CHECK_RESULT $? 0 0 "whois -I help failed"
    
    # 测试-H参数
    whois -H help
    CHECK_RESULT $? 0 0 "whois -H help failed"
    
    # 测试--verbose参数
    whois --verbose help
    CHECK_RESULT $? 0 0 "whois --verbose help failed"
    
    # 测试-l参数
    whois -l help
    CHECK_RESULT $? 0 0 "whois -l help failed"
    
    # 测试-L参数
    whois -L help
    CHECK_RESULT $? 0 0 "whois -L help failed"
    
    # 测试-m参数
    whois -m help
    CHECK_RESULT $? 0 0 "whois -m help failed"
    
    # 测试-M参数
    whois -M help
    CHECK_RESULT $? 0 0 "whois -M help failed"
    
    # 测试-c参数
    whois -c help
    CHECK_RESULT $? 0 0 "whois -c help failed"
    
    # 测试-x参数
    whois -x help
    CHECK_RESULT $? 0 0 "whois -x help failed"
    
    # 测试-b参数
    whois -b help
    CHECK_RESULT $? 0 0 "whois -b help failed"
    
    # 测试-B参数
    whois -B help
    CHECK_RESULT $? 0 0 "whois -B help failed"
    
    # 测试-G参数
    whois -G help
    CHECK_RESULT $? 0 0 "whois -G help failed"
    
    # 测试-d参数
    whois -d help
    CHECK_RESULT $? 0 0 "whois -d help failed"
    
    # 测试-i参数
    whois -i mnt-by help
    CHECK_RESULT $? 0 0 "whois -i mnt-by help failed"
    
    # 测试-T参数
    whois -T domain help
    CHECK_RESULT $? 0 0 "whois -T domain help failed"
    
    # 测试-K参数
    whois -K help
    CHECK_RESULT $? 0 0 "whois -K help failed"
    
    # 测试-r参数
    whois -r help
    CHECK_RESULT $? 0 0 "whois -r help failed"
    
    # 测试-R参数
    whois -R help
    CHECK_RESULT $? 0 0 "whois -R help failed"
    
    # 测试-a参数
    whois -a help
    CHECK_RESULT $? 0 0 "whois -a help failed"
    
    # 测试-s参数
    whois -s whois.nic.help help
    CHECK_RESULT $? 0 0 "whois -s whois.nic.help help failed"
    
    # 测试-g参数
    whois -g whois.nic.help:1-10 help
    CHECK_RESULT $? 0 0 "whois -g whois.nic.help:1-10 help failed"
    
    # 测试-t参数
    whois -t domain help
    CHECK_RESULT $? 0 0 "whois -t domain help failed"
    
    # 测试-v参数
    whois -v domain help
    CHECK_RESULT $? 0 0 "whois -v domain help failed"
    
    # 测试-q参数
    whois -q version help
    CHECK_RESULT $? 0 0 "whois -q version help failed"
    
    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 测试后环境恢复：
    # 卸载安装的软件包
    DNF_REMOVE "whois"
    # 清理测试中间产物文件
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
