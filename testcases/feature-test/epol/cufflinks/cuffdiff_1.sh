
#!/usr/bin/bash
# 测试用例描述：测试cuffdiff命令的基本功能和参数组合

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "cufflinks"
    # 准备测试数据
    touch ./transcripts.gtf
    touch ./sample1_hits.sam
    touch ./sample2_hits.sam
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试基本命令
    cuffdiff ./transcripts.gtf ./sample1_hits.sam ./sample2_hits.sam
    CHECK_RESULT $? 0 0 "cuffdiff basic command failed"

    # 测试输出目录参数
    cuffdiff -o ./output ./transcripts.gtf ./sample1_hits.sam ./sample2_hits.sam
    CHECK_RESULT $? 0 0 "cuffdiff --output-dir failed"

    # 测试条件标签参数
    cuffdiff -L "condition1,condition2" ./transcripts.gtf ./sample1_hits.sam ./sample2_hits.sam
    CHECK_RESULT $? 0 0 "cuffdiff --labels failed"

    # 测试FDR参数
    cuffdiff --FDR 0.1 ./transcripts.gtf ./sample1_hits.sam ./sample2_hits.sam
    CHECK_RESULT $? 0 0 "cuffdiff --FDR failed"

    # 测试多线程参数
    cuffdiff -p 2 ./transcripts.gtf ./sample1_hits.sam ./sample2_hits.sam
    CHECK_RESULT $? 0 0 "cuffdiff --num-threads failed"

    # 测试不进行差异分析参数
    cuffdiff --no-diff ./transcripts.gtf ./sample1_hits.sam ./sample2_hits.sam
    CHECK_RESULT $? 0 0 "cuffdiff --no-diff failed"

    # 测试不进行等位基因切换测试参数
    cuffdiff --no-js-tests ./transcripts.gtf ./sample1_hits.sam ./sample2_hits.sam
    CHECK_RESULT $? 0 0 "cuffdiff --no-js-tests failed"

    # 测试时间序列参数
    cuffdiff -T ./transcripts.gtf ./sample1_hits.sam ./sample2_hits.sam
    CHECK_RESULT $? 0 0 "cuffdiff --time-series failed"

    # 测试库类型参数
    cuffdiff --library-type fr-firststrand ./transcripts.gtf ./sample1_hits.sam ./sample2_hits.sam
    CHECK_RESULT $? 0 0 "cuffdiff --library-type failed"

    # 测试分散方法参数
    cuffdiff --dispersion-method blind ./transcripts.gtf ./sample1_hits.sam ./sample2_hits.sam
    CHECK_RESULT $? 0 0 "cuffdiff --dispersion-method failed"

    # 测试库归一化方法参数
    cuffdiff --library-norm-method classic-fpkm ./transcripts.gtf ./sample1_hits.sam ./sample2_hits.sam
    CHECK_RESULT $? 0 0 "cuffdiff --library-norm-method failed"

    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 卸载安装的软件包
    DNF_REMOVE "cufflinks"
    # 清理测试中间产物文件
    rm -f ./transcripts.gtf ./sample1_hits.sam ./sample2_hits.sam ./output
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
