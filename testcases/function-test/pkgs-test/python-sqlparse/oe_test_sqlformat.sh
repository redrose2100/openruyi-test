
#!/usr/bin/bash
# 测试用例描述：测试 sqlformat 命令的各种参数组合

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "python-sqlparse"
    # 准备测试数据
    echo "SELECT * FROM table;" > ./test.sql
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试基本命令
    sqlformat ./test.sql
    CHECK_RESULT $? 0 0 "sqlformat basic command failed"

    # 测试 -o 参数
    sqlformat -o ./output.sql ./test.sql
    CHECK_RESULT $? 0 0 "sqlformat -o parameter failed"

    # 测试 --keywords 参数
    sqlformat --keywords upper ./test.sql
    CHECK_RESULT $? 0 0 "sqlformat --keywords parameter failed"

    # 测试 --identifiers 参数
    sqlformat --identifiers lower ./test.sql
    CHECK_RESULT $? 0 0 "sqlformat --identifiers parameter failed"

    # 测试 --language 参数
    sqlformat --language python ./test.sql
    CHECK_RESULT $? 0 0 "sqlformat --language parameter failed"

    # 测试 --strip-comments 参数
    sqlformat --strip-comments ./test.sql
    CHECK_RESULT $? 0 0 "sqlformat --strip-comments parameter failed"

    # 测试 --reindent 参数
    sqlformat --reindent ./test.sql
    CHECK_RESULT $? 0 0 "sqlformat --reindent parameter failed"

    # 测试 --indent_width 参数
    sqlformat --indent_width 4 ./test.sql
    CHECK_RESULT $? 0 0 "sqlformat --indent_width parameter failed"

    # 测试 --indent_after_first 参数
    sqlformat --indent_after_first ./test.sql
    CHECK_RESULT $? 0 0 "sqlformat --indent_after_first parameter failed"

    # 测试 --indent_columns 参数
    sqlformat --indent_columns ./test.sql
    CHECK_RESULT $? 0 0 "sqlformat --indent_columns parameter failed"

    # 测试 --reindent_aligned 参数
    sqlformat --reindent_aligned ./test.sql
    CHECK_RESULT $? 0 0 "sqlformat --reindent_aligned parameter failed"

    # 测试 --use_space_around_operators 参数
    sqlformat --use_space_around_operators ./test.sql
    CHECK_RESULT $? 0 0 "sqlformat --use_space_around_operators parameter failed"

    # 测试 --wrap_after 参数
    sqlformat --wrap_after 80 ./test.sql
    CHECK_RESULT $? 0 0 "sqlformat --wrap_after parameter failed"

    # 测试 --comma_first 参数
    sqlformat --comma_first ./test.sql
    CHECK_RESULT $? 0 0 "sqlformat --comma_first parameter failed"

    # 测试 --encoding 参数
    sqlformat --encoding utf-8 ./test.sql
    CHECK_RESULT $? 0 0 "sqlformat --encoding parameter failed"

    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 卸载安装的软件包
    DNF_REMOVE "python-sqlparse"
    # 清理测试中间产物文件
    rm -f ./test.sql ./output.sql
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
