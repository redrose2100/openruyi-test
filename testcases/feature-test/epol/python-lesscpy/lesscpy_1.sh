
#!/usr/bin/bash
# 本测试脚本用于测试lesscpy命令的各种参数组合和行为

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "python-lesscpy"
    # 准备测试数据
    echo "body { color: red; }" > ./test.less
    mkdir -p ./test_dir
    echo "body { color: blue; }" > ./test_dir/test.less
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试基本命令
    lesscpy ./test.less ./test.css
    CHECK_RESULT $? 0 0 "failed to run basic command"
    # 测试版本信息
    lesscpy -v
    CHECK_RESULT $? 0 0 "failed to run version command"
    # 测试verbose模式
    lesscpy -V ./test.less ./test.css
    CHECK_RESULT $? 0 0 "failed to run verbose mode"
    # 测试minify选项
    lesscpy -x ./test.less ./test.min.css
    CHECK_RESULT $? 0 0 "failed to run minify option"
    # 测试xminify选项
    lesscpy -X ./test.less ./test.xmin.css
    CHECK_RESULT $? 0 0 "failed to run xminify option"
    # 测试tabs选项
    lesscpy -t ./test.less ./test.tabs.css
    CHECK_RESULT $? 0 0 "failed to run tabs option"
    # 测试spaces选项
    lesscpy -s 4 ./test.less ./test.spaces.css
    CHECK_RESULT $? 0 0 "failed to run spaces option"
    # 测试输出目录选项
    lesscpy -o ./test_dir ./test.less
    CHECK_RESULT $? 0 0 "failed to run output directory option"
    # 测试递归选项
    lesscpy -r ./test_dir
    CHECK_RESULT $? 0 0 "failed to run recursive option"
    # 测试force选项
    lesscpy -f ./test_dir
    CHECK_RESULT $? 0 0 "failed to run force option"
    # 测试min-ending选项
    lesscpy -m ./test.less ./test.min.css
    CHECK_RESULT $? 0 0 "failed to run min-ending option"
    # 测试dry-run选项
    lesscpy -D ./test.less ./test.css
    CHECK_RESULT $? 0 0 "failed to run dry-run option"
    # 测试debug选项
    lesscpy -g ./test.less ./test.css
    CHECK_RESULT $? 0 0 "failed to run debug option"
    # 测试scopemap选项
    lesscpy -S ./test.less ./test.css
    CHECK_RESULT $? 0 0 "failed to run scopemap option"
    # 测试lex-only选项
    lesscpy -L ./test.less
    CHECK_RESULT $? 0 0 "failed to run lex-only option"
    # 测试no-css选项
    lesscpy -N ./test.less
    CHECK_RESULT $? 0 0 "failed to run no-css option"
    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 卸载安装的软件包
    DNF_REMOVE "python-lesscpy"
    # 清理测试中间产物文件
    rm -rf ./test.less ./test.css ./test.min.css ./test.xmin.css ./test.tabs.css ./test.spaces.css ./test_dir
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
