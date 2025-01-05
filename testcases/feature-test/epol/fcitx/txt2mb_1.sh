
#!/usr/bin/bash
# 测试用例描述：测试 txt2mb 命令，确保其能够正确处理源文件和目标文件

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "fcitx"
    # 准备测试数据
    echo "This is a test source file." > ./source.txt
    touch ./imfile.mb
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试 txt2mb 命令的基本用法
    txt2mb ./source.txt ./imfile.mb
    CHECK_RESULT $? 0 0 "txt2mb command failed to execute"
    # 检查生成的文件是否存在
    test -f ./imfile.mb
    CHECK_RESULT $? 0 0 "IM file not created"
    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 卸载安装的软件包
    DNF_REMOVE "fcitx"
    # 清理测试中间产物文件
    rm -f ./source.txt ./imfile.mb
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
