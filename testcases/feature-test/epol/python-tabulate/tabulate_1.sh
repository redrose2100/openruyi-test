
#!/usr/bin/bash
# 本测试用例用于验证tabulate命令的基本功能，包括不同的输出格式、自定义分隔符、使用第一行作为表头等功能。

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "python-tabulate"
    # 准备测试数据
    echo -e "Name\tAge\tCity\nAlice\t30\tNew York\nBob\t25\tLos Angeles" > ./test_data.txt
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试默认格式
    tabulate ./test_data.txt
    CHECK_RESULT $? 0 0 "tabulate default format failed"
    
    # 测试不同输出格式
    for fmt in plain simple grid fancy_grid pipe orgtbl rst mediawiki html latex latex_raw latex_booktabs latex_longtable tsv; do
        tabulate -f $fmt ./test_data.txt
        CHECK_RESULT $? 0 0 "tabulate format $fmt failed"
    done
    
    # 测试自定义分隔符
    tabulate -s '\t' ./test_data.txt
    CHECK_RESULT $? 0 0 "tabulate custom separator failed"
    
    # 测试使用第一行作为表头
    tabulate -1 ./test_data.txt
    CHECK_RESULT $? 0 0 "tabulate header failed"
    
    # 测试输出到文件
    tabulate -o ./output.txt ./test_data.txt
    CHECK_RESULT $? 0 0 "tabulate output to file failed"
    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 测试后环境恢复
    DNF_REMOVE "python-tabulate"
    rm -f ./test_data.txt ./output.txt
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
