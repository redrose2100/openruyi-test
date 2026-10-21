
#!/usr/bin/bash
# 请填写测试用例描述：测试cuffdiff命令的基本功能和参数组合

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
    touch ./sample3_hits.sam
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
    CHECK_RESULT $? 0 0 "cuffdiff with --output-dir failed"

    # 测试多线程参数
    cuffdiff -p 2 ./transcripts.gtf ./sample1_hits.sam ./sample2_hits.sam
    CHECK_RESULT $? 0 0 "cuffdiff with --num-threads failed"

    # 测试库类型参数
    cuffdiff --library-type fr-firststrand ./transcripts.gtf ./sample1_hits.sam ./sample2_hits.sam
    CHECK_RESULT $? 0 0 "cuffdiff with --library-type failed"

    # 测试片段长度参数
    cuffdiff -m 250 -s 50 ./transcripts.gtf ./sample1_hits.sam ./sample2_hits.sam
    CHECK_RESULT $? 0 0 "cuffdiff with --frag-len-mean and --frag-len-std-dev failed"

    # 测试多个参数组合
    cuffdiff -o ./output -p 2 --library-type fr-firststrand -m 250 -s 50 ./transcripts.gtf ./sample1_hits.sam ./sample2_hits.sam
    CHECK_RESULT $? 0 0 "cuffdiff with multiple parameters failed"

    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 卸载安装的软件包
    DNF_REMOVE "cufflinks"
    # 清理测试中间产物文件
    rm -f ./transcripts.gtf ./sample1_hits.sam ./sample2_hits.sam ./sample3_hits.sam ./output/*
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
