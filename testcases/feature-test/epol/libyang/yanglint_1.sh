
#!/usr/bin/bash
# 请填写测试用例描述

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "libyang"
    # 准备测试数据等,如果要创建文件请使用"./你要创建的文件"直接把文件创建到当前目录下
    echo "module test { namespace test; prefix test; }" > ./test.yang
    echo "<test xmlns='test'>data</test>" > ./test.xml
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试内容,请尽可能详尽的测试命令的参数,如命令的参数组合,命令的参数顺序等
    yanglint -v
    CHECK_RESULT $? 0 0 "yanglint version check failed"

    yanglint -V -f yang ./test.yang
    CHECK_RESULT $? 0 0 "yanglint verbose and format check failed"

    yanglint -p ./ -f xml ./test.yang ./test.xml
    CHECK_RESULT $? 0 0 "yanglint path and format check failed"

    yanglint -D -f json ./test.yang
    CHECK_RESULT $? 0 0 "yanglint disable-searchdir and format check failed"

    yanglint -s -f tree ./test.yang
    CHECK_RESULT $? 0 0 "yanglint strict and format check failed"

    yanglint -m -f jsons ./test.yang
    CHECK_RESULT $? 0 0 "yanglint merge and format check failed"

    yanglint -a -f xml ./test.yang ./test.xml
    CHECK_RESULT $? 0 0 "yanglint auto and format check failed"

    yanglint -i -f tree-rfc ./test.yang
    CHECK_RESULT $? 0 0 "yanglint allimplemented and format check failed"

    yanglint -l -f json ./test.yang
    CHECK_RESULT $? 0 0 "yanglint list and format check failed"

    yanglint -o ./output.json -f json ./test.yang
    CHECK_RESULT $? 0 0 "yanglint output and format check failed"

    yanglint -F test:feature -f xml ./test.yang ./test.xml
    CHECK_RESULT $? 0 0 "yanglint features and format check failed"

    yanglint -d all -f xml ./test.yang ./test.xml
    CHECK_RESULT $? 0 0 "yanglint default and format check failed"

    yanglint -t data -f xml ./test.yang ./test.xml
    CHECK_RESULT $? 0 0 "yanglint type and format check failed"

    yanglint -O ./test.xml -f xml ./test.yang ./test.xml
    CHECK_RESULT $? 0 0 "yanglint operational and format check failed"

    yanglint -y ./test.yang -f xml ./test.yang ./test.xml
    CHECK_RESULT $? 0 0 "yanglint yanglib and format check failed"

    yanglint --tree-help
    CHECK_RESULT $? 0 0 "yanglint tree-help check failed"

    yanglint --tree-print-groupings -f tree ./test.yang
    CHECK_RESULT $? 0 0 "yanglint tree-print-groupings and format check failed"

    yanglint --tree-print-uses -f tree ./test.yang
    CHECK_RESULT $? 0 0 "yanglint tree-print-uses and format check failed"

    yanglint --tree-no-leafref-target -f tree ./test.yang
    CHECK_RESULT $? 0 0 "yanglint tree-no-leafref-target and format check failed"

    yanglint --tree-path=/test -f tree ./test.yang
    CHECK_RESULT $? 0 0 "yanglint tree-path and format check failed"

    yanglint --tree-line-length=80 -f tree ./test.yang
    CHECK_RESULT $? 0 0 "yanglint tree-line-length and format check failed"

    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 测试后环境恢复：
        # 卸载安装的软件包
        # 清理测试中间产物文件
    DNF_REMOVE "libyang"
    rm -f ./test.yang ./test.xml ./output.json
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
