
#!/usr/bin/bash
# 请填写测试用例描述：测试mibcopy.py命令的基本功能和参数组合

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "python-pysmi"
    # 准备测试数据等,如果要创建文件请使用"./你要创建的文件"直接把文件创建到当前目录下
    mkdir -p ./test_mibs ./dest_mibs
    touch ./test_mibs/test_mib1.mib ./test_mibs/test_mib2.mib
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试基本功能
    mibcopy.py ./test_mibs ./dest_mibs
    CHECK_RESULT $? 0 0 "mibcopy.py basic function failed"
    # 测试--verbose参数
    mibcopy.py --verbose ./test_mibs ./dest_mibs
    CHECK_RESULT $? 0 0 "mibcopy.py --verbose failed"
    # 测试--quiet参数
    mibcopy.py --quiet ./test_mibs ./dest_mibs
    CHECK_RESULT $? 0 0 "mibcopy.py --quiet failed"
    # 测试--debug参数
    mibcopy.py --debug=all ./test_mibs ./dest_mibs
    CHECK_RESULT $? 0 0 "mibcopy.py --debug=all failed"
    # 测试--mib-source参数
    mibcopy.py --mib-source=file:///test_mibs ./test_mibs ./dest_mibs
    CHECK_RESULT $? 0 0 "mibcopy.py --mib-source failed"
    # 测试--cache-directory参数
    mibcopy.py --cache-directory=./cache ./test_mibs ./dest_mibs
    CHECK_RESULT $? 0 0 "mibcopy.py --cache-directory failed"
    # 测试--ignore-errors参数
    mibcopy.py --ignore-errors ./test_mibs ./dest_mibs
    CHECK_RESULT $? 0 0 "mibcopy.py --ignore-errors failed"
    # 测试--dry-run参数
    mibcopy.py --dry-run ./test_mibs ./dest_mibs
    CHECK_RESULT $? 0 0 "mibcopy.py --dry-run failed"
    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 测试后环境恢复：
    # 卸载安装的软件包
    DNF_REMOVE "python-pysmi"
    # 清理测试中间产物文件
    rm -rf ./test_mibs ./dest_mibs ./cache
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
