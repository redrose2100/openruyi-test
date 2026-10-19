
#!/usr/bin/bash
# 测试用例描述：测试 hbase regionsplitter 命令，包括不同参数组合和参数顺序的测试

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "hbase"
    # 准备测试数据
    echo "test_data" > ./test_data.txt
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试 regionsplitter 命令的基本用法
    hbase regionsplitter test_table HexStringSplit
    CHECK_RESULT $? 0 0 "hbase regionsplitter test_table HexStringSplit failed"

    # 测试 -c 参数
    hbase regionsplitter test_table HexStringSplit -c 5
    CHECK_RESULT $? 0 0 "hbase regionsplitter test_table HexStringSplit -c 5 failed"

    # 测试 -f 参数
    hbase regionsplitter test_table HexStringSplit -f cf1:cf2
    CHECK_RESULT $? 0 0 "hbase regionsplitter test_table HexStringSplit -f cf1:cf2 failed"

    # 测试 --firstrow 参数
    hbase regionsplitter test_table HexStringSplit --firstrow "first_row"
    CHECK_RESULT $? 0 0 "hbase regionsplitter test_table HexStringSplit --firstrow first_row failed"

    # 测试 --lastrow 参数
    hbase regionsplitter test_table HexStringSplit --lastrow "last_row"
    CHECK_RESULT $? 0 0 "hbase regionsplitter test_table HexStringSplit --lastrow last_row failed"

    # 测试 -o 参数
    hbase regionsplitter test_table HexStringSplit -o 10
    CHECK_RESULT $? 0 0 "hbase regionsplitter test_table HexStringSplit -o 10 failed"

    # 测试 -r 参数
    hbase regionsplitter test_table HexStringSplit -r
    CHECK_RESULT $? 0 0 "hbase regionsplitter test_table HexStringSplit -r failed"

    # 测试 --risky 参数
    hbase regionsplitter test_table HexStringSplit --risky
    CHECK_RESULT $? 0 0 "hbase regionsplitter test_table HexStringSplit --risky failed"

    # 测试 -D 参数
    hbase regionsplitter test_table HexStringSplit -D "hbase.regionserver.wal.codec=org.apache.hadoop.hbase.regionserver.wal.IndexedWALEditCodec"
    CHECK_RESULT $? 0 0 "hbase regionsplitter test_table HexStringSplit -D hbase.regionserver.wal.codec=org.apache.hadoop.hbase.regionserver.wal.IndexedWALEditCodec failed"

    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 卸载安装的软件包
    DNF_REMOVE "hbase"
    # 清理测试中间产物文件
    rm -f ./test_data.txt
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
