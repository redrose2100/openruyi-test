
#!/usr/bin/bash
# 测试用例描述：测试 engine-vacuum 命令的各种参数组合

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "ovirt-engine"
    # 准备测试数据等,如果要创建文件请使用"./你要创建的文件"直接把文件创建到当前目录下
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试命令的各种参数组合
    engine-vacuum -a
    CHECK_RESULT $? 0 0 "engine-vacuum -a failed"
    
    engine-vacuum -A
    CHECK_RESULT $? 0 0 "engine-vacuum -A failed"
    
    engine-vacuum -f
    CHECK_RESULT $? 0 0 "engine-vacuum -f failed"
    
    engine-vacuum -t "example_table"
    CHECK_RESULT $? 0 0 "engine-vacuum -t example_table failed"
    
    engine-vacuum -v
    CHECK_RESULT $? 0 0 "engine-vacuum -v failed"
    
    engine-vacuum -a -f
    CHECK_RESULT $? 0 0 "engine-vacuum -a -f failed"
    
    engine-vacuum -A -f
    CHECK_RESULT $? 0 0 "engine-vacuum -A -f failed"
    
    engine-vacuum -a -t "example_table"
    CHECK_RESULT $? 0 0 "engine-vacuum -a -t example_table failed"
    
    engine-vacuum -A -t "example_table"
    CHECK_RESULT $? 0 0 "engine-vacuum -A -t example_table failed"
    
    engine-vacuum -f -t "example_table"
    CHECK_RESULT $? 0 0 "engine-vacuum -f -t example_table failed"
    
    engine-vacuum -a -f -t "example_table"
    CHECK_RESULT $? 0 0 "engine-vacuum -a -f -t example_table failed"
    
    engine-vacuum -A -f -t "example_table"
    CHECK_RESULT $? 0 0 "engine-vacuum -A -f -t example_table failed"
    
    engine-vacuum -v -a
    CHECK_RESULT $? 0 0 "engine-vacuum -v -a failed"
    
    engine-vacuum -v -A
    CHECK_RESULT $? 0 0 "engine-vacuum -v -A failed"
    
    engine-vacuum -v -f
    CHECK_RESULT $? 0 0 "engine-vacuum -v -f failed"
    
    engine-vacuum -v -t "example_table"
    CHECK_RESULT $? 0 0 "engine-vacuum -v -t example_table failed"
    
    engine-vacuum -v -a -f
    CHECK_RESULT $? 0 0 "engine-vacuum -v -a -f failed"
    
    engine-vacuum -v -A -f
    CHECK_RESULT $? 0 0 "engine-vacuum -v -A -f failed"
    
    engine-vacuum -v -a -t "example_table"
    CHECK_RESULT $? 0 0 "engine-vacuum -v -a -t example_table failed"
    
    engine-vacuum -v -A -t "example_table"
    CHECK_RESULT $? 0 0 "engine-vacuum -v -A -t example_table failed"
    
    engine-vacuum -v -f -t "example_table"
    CHECK_RESULT $? 0 0 "engine-vacuum -v -f -t example_table failed"
    
    engine-vacuum -v -a -f -t "example_table"
    CHECK_RESULT $? 0 0 "engine-vacuum -v -a -f -t example_table failed"
    
    engine-vacuum -v -A -f -t "example_table"
    CHECK_RESULT $? 0 0 "engine-vacuum -v -A -f -t example_table failed"
    
    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 测试后环境恢复：
        # 卸载安装的软件包
        # 清理测试中间产物文件
    DNF_REMOVE "ovirt-engine"
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
