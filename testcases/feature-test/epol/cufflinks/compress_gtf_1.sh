
#!/usr/bin/bash
# 测试用例描述：测试 compress_gtf 命令的基本功能和参数组合

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "cufflinks"
    # 准备测试数据
    echo 'gene_id "gene1"; transcript_id "transcript1";' > ./reference.gtf
    echo '>chr1' > ./reference.fasta
    echo 'ATCG' >> ./reference.fasta
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试 compress_gtf 命令的基本功能
    compress_gtf ./reference.gtf ./compressed_reference.gtf
    CHECK_RESULT $? 0 0 "compress_gtf command failed"
    
    # 测试 --reference-seq 参数
    compress_gtf --reference-seq ./reference.fasta ./reference.gtf ./compressed_reference.gtf
    CHECK_RESULT $? 0 0 "compress_gtf --reference-seq failed"
    
    # 测试 --raw-fpkm 参数
    compress_gtf --raw-fpkm ./reference.gtf ./compressed_reference.gtf
    CHECK_RESULT $? 0 0 "compress_gtf --raw-fpkm failed"
    
    # 测试 --union 参数
    compress_gtf --union ./reference.gtf ./compressed_reference.gtf
    CHECK_RESULT $? 0 0 "compress_gtf --union failed"
    
    # 测试 --intersection 参数
    compress_gtf --intersection ./reference.gtf ./compressed_reference.gtf
    CHECK_RESULT $? 0 0 "compress_gtf --intersection failed"
    
    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 测试后环境恢复
    DNF_REMOVE "cufflinks"
    rm -f ./reference.gtf ./reference.fasta ./compressed_reference.gtf
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
