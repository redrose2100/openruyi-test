
#!/usr/bin/bash
# 测试用例描述：测试 createPYMB 命令，创建拼音码表文件

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "fcitx"
    # 准备测试数据
    echo "测试拼音数据" > ./test.py
    echo "测试短语数据" > ./test.phrase
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试 createPYMB 命令的基本用法
    createPYMB ./test.py ./test.phrase
    CHECK_RESULT $? 0 0 "createPYMB command failed"
    # 检查生成的文件是否存在
    test -f ./test.pymb
    CHECK_RESULT $? 0 0 "createPYMB file not found"
    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 卸载安装的软件包
    DNF_REMOVE "fcitx"
    # 清理测试中间产物文件
    rm -f ./test.py ./test.phrase ./test.pymb
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
