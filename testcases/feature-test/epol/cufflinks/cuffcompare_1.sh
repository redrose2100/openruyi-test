
#!/usr/bin/bash
# 测试用例描述：测试cuffcompare命令的基本用法和参数组合

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "cufflinks"
    # 准备测试数据
    echo "chr1    source    exon    1    100    .    +    .    gene_id \"g1\"; transcript_id \"t1\";" > ./input1.gtf
    echo "chr1    source    exon    1    100    .    +    .    gene_id \"g1\"; transcript_id \"t1\";" > ./input2.gtf
    echo "input1.gtf" > ./input_list.txt
    echo "input2.gtf" >> ./input_list.txt
    echo "chr1    source    exon    1    100    .    +    .    gene_id \"g1\"; transcript_id \"t1\";" > ./reference.gtf
    echo "chr1    source    exon    1    100    .    +    .    gene_id \"g1\"; transcript_id \"t1\";" > ./seq_path
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试命令的基本用法
    cuffcompare -o ./output -i ./input_list.txt
    CHECK_RESULT $? 0 0 "cuffcompare basic usage failed"
    
    # 测试命令的参数组合
    cuffcompare -r ./reference.gtf -o ./output -i ./input_list.txt
    CHECK_RESULT $? 0 0 "cuffcompare with reference failed"
    
    # 测试命令的参数顺序
    cuffcompare -o ./output -r ./reference.gtf -i ./input_list.txt
    CHECK_RESULT $? 0 0 "cuffcompare with reference and output failed"
    
    # 测试命令的其他参数
    cuffcompare -R -Q -M -N -s ./seq_path -e 100 -d 100 -p TCONS -C -F -G -T -V -o ./output -i ./input_list.txt
    CHECK_RESULT $? 0 0 "cuffcompare with all parameters failed"
    
    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 测试后环境恢复
    DNF_REMOVE "cufflinks"
    # 清理测试中间产物文件
    rm -f ./input1.gtf ./input2.gtf ./input_list.txt ./reference.gtf ./seq_path ./output.*
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
