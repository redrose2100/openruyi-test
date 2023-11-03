#!/usr/bin/bash

#Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   xiechangyan1
# @Contact   :   xiechangyan@uniontech.com
# @Date      :   2023-07-31
# @License   :   Mulan PSL v2
# @Desc      :   Use hdf5 case
# ############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "hdf5 hdf5-devel"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    cat > /tmp/hdf5_example.c << EOF
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
    dataspace_id = H5Screate_simple(2, dims, NULL);
    dataset_id = H5Dcreate2(file_id, DATASETNAME, H5T_NATIVE_INT, dataspace_id, H5P_DEFAULT, H5P_DEFAULT, H5P_DEFAULT);

    H5Dwrite(dataset_id, H5T_NATIVE_INT, H5S_ALL, H5S_ALL, H5P_DEFAULT, data);

    H5Dclose(dataset_id);
    H5Sclose(dataspace_id);
    H5Fclose(file_id);

    printf("Data has been written to HDF5 file.\n");

    return 0;
}
EOF
    CHECK_RESULT $? 0 0 "Error,Fail to create hdf5_example.c"
    gcc /tmp/hdf5_example.c -o /tmp/hdf5_example -lhdf5
    CHECK_RESULT $? 0 0 "Error,Fail to create hdf5_example"
    cd /tmp && ./hdf5_example && ls example.h5
    CHECK_RESULT $? 0 0 "Error,Please check the file 'hdf5_example'"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm /tmp/*example*
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"