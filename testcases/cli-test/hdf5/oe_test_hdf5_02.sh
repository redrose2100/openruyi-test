#!/usr/bin/bash

# Copyright (c) 2026. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more detaitest -f.

# #############################################
# @Author    :   yangxi
# @Contact   :   yangxi@uniontech.com
# @Date      :   2026/04/24
# @License   :   Mulan PSL v2
# @Desc      :   Test hdf5 function
# #############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL "hdf5 hdf5-devel"
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    
    # 测试点1：创建并编译HDF5写入程序
    LOG_INFO "Test point 1: Create and compile HDF5 write program."
    cat > hdf5_example.c <<'EOF'
#include <stdio.h>
#include <stdlib.h>
#include <hdf5.h>

#define FILENAME "example.h5"
#define DATASETNAME "dataset"

int main()
{
    hid_t file_id, dataset_id, dataspace_id;
    hsize_t dims[2] = {3, 3};
    int data[3][3] = {{1, 2, 3}, {4, 5, 6}, {7, 8, 9}};

    file_id = H5Fcreate(FILENAME, H5F_ACC_TRUNC, H5P_DEFAULT, H5P_DEFAULT);
    if (file_id < 0) {
        printf("Failed to create file\n");
        return 1;
    }
    
    dataspace_id = H5Screate_simple(2, dims, NULL);
    if (dataspace_id < 0) {
        printf("Failed to create dataspace\n");
        H5Fclose(file_id);
        return 1;
    }
    
    dataset_id = H5Dcreate2(file_id, DATASETNAME, H5T_NATIVE_INT, dataspace_id, H5P_DEFAULT, H5P_DEFAULT, H5P_DEFAULT);
    if (dataset_id < 0) {
        printf("Failed to create dataset\n");
        H5Sclose(dataspace_id);
        H5Fclose(file_id);
        return 1;
    }

    H5Dwrite(dataset_id, H5T_NATIVE_INT, H5S_ALL, H5S_ALL, H5P_DEFAULT, data);

    H5Dclose(dataset_id);
    H5Sclose(dataspace_id);
    H5Fclose(file_id);

    printf("Data has been written to HDF5 file.\n");
    return 0;
}
EOF
    CHECK_RESULT $? 0 0 "Create hdf5_example.c file fail"
    
    gcc hdf5_example.c -o hdf5_example -lhdf5
    CHECK_RESULT $? 0 0 "Compile hdf5_example fail"
    
    ./hdf5_example
    CHECK_RESULT $? 0 0 "Execute hdf5_example fail"
    
    ls example.h5
    CHECK_RESULT $? 0 0 "Create example.h5 file fail"
    
    # 测试点2：读取HDF5文件功能测试
    LOG_INFO "Test point 2: Test read HDF5 file function."
    cat > hdf5_read.c <<'EOF'
#include <stdio.h>
#include <hdf5.h>

#define FILENAME "example.h5"
#define DATASETNAME "dataset"

int main()
{
    hid_t file_id, dataset_id;
    int data[3][3];
    
    file_id = H5Fopen(FILENAME, H5F_ACC_RDONLY, H5P_DEFAULT);
    if (file_id < 0) {
        printf("Failed to open file\n");
        return 1;
    }
    
    dataset_id = H5Dopen2(file_id, DATASETNAME, H5P_DEFAULT);
    if (dataset_id < 0) {
        printf("Failed to open dataset\n");
        H5Fclose(file_id);
        return 1;
    }
    
    H5Dread(dataset_id, H5T_NATIVE_INT, H5S_ALL, H5S_ALL, H5P_DEFAULT, data);
    
    printf("Data read from HDF5 file:\n");
    for (int i = 0; i < 3; i++) {
        for (int j = 0; j < 3; j++) {
            printf("%d ", data[i][j]);
        }
        printf("\n");
    }
    
    H5Dclose(dataset_id);
    H5Fclose(file_id);
    
    return 0;
}
EOF
    CHECK_RESULT $? 0 0 "Create hdf5_read.c file fail"
    
    gcc hdf5_read.c -o hdf5_read -lhdf5
    CHECK_RESULT $? 0 0 "Compile hdf5_read fail"
    
    ./hdf5_read | grep -E "Data read from HDF5 file:|1 2 3|4 5 6|7 8 9"
    CHECK_RESULT $? 0 0 "Read HDF5 file fail"
    
    # 测试点3：测试h5dump工具功能
    LOG_INFO "Test point 3: Test h5dump tool function."
    which h5dump
    CHECK_RESULT $? 0 0 "h5dump command not found"
    
    h5dump example.h5 | grep -E "HDF5|dataset"
    CHECK_RESULT $? 0 0 "h5dump execute fail"
    
    # 测试点4：测试h5ls工具功能
    LOG_INFO "Test point 4: Test h5ls tool function."
    which h5ls
    CHECK_RESULT $? 0 0 "h5ls command not found"
    
    h5ls example.h5 | grep "dataset"
    CHECK_RESULT $? 0 0 "h5ls execute fail"
    
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    rm -f hdf5_example.c hdf5_example hdf5_read.c hdf5_read example.h5
    # shellcheck disable=SC2119
    DNF_REMOVE "$@"
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
