
#!/usr/bin/bash
# 本测试用例用于测试 mousepad 命令的各种参数组合

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "mousepad"
    # 准备测试数据
    echo "Test content" > ./testfile.txt
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试帮助选项
    mousepad --help
    CHECK_RESULT $? 0 0 "mousepad --help failed"
    mousepad --help-all
    CHECK_RESULT $? 0 0 "mousepad --help-all failed"
    mousepad --help-gapplication
    CHECK_RESULT $? 0 0 "mousepad --help-gapplication failed"
    mousepad --help-gtk
    CHECK_RESULT $? 0 0 "mousepad --help-gtk failed"

    # 测试文件打开模式
    mousepad --opening-mode=tab ./testfile.txt
    CHECK_RESULT $? 0 0 "mousepad --opening-mode=tab failed"
    mousepad --opening-mode=window ./testfile.txt
    CHECK_RESULT $? 0 0 "mousepad --opening-mode=window failed"
    mousepad --opening-mode=mixed ./testfile.txt
    CHECK_RESULT $? 0 0 "mousepad --opening-mode=mixed failed"

    # 测试编码选项
    mousepad --encoding=utf-8 ./testfile.txt
    CHECK_RESULT $? 0 0 "mousepad --encoding=utf-8 failed"
    mousepad --list-encodings
    CHECK_RESULT $? 0 0 "mousepad --list-encodings failed"

    # 测试光标位置选项
    mousepad --line=1 --column=1 ./testfile.txt
    CHECK_RESULT $? 0 0 "mousepad --line=1 --column=1 failed"
    mousepad --line=-1 --column=-1 ./testfile.txt
    CHECK_RESULT $? 0 0 "mousepad --line=-1 --column=-1 failed"

    # 测试其他选项
    mousepad --preferences
    CHECK_RESULT $? 0 0 "mousepad --preferences failed"
    mousepad --disable-server
    CHECK_RESULT $? 0 0 "mousepad --disable-server failed"
    mousepad --quit
    CHECK_RESULT $? 0 0 "mousepad --quit failed"
    mousepad --version
    CHECK_RESULT $? 0 0 "mousepad --version failed"
    mousepad --display=:0.0
    CHECK_RESULT $? 0 0 "mousepad --display=:0.0 failed"

    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 卸载安装的软件包
    DNF_REMOVE "mousepad"
    # 清理测试中间产物文件
    rm -f ./testfile.txt
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
