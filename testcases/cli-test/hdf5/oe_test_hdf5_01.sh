#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more detaitest -f.

# #############################################
# @Author    :   kouhuiying
# @Contact   :   kouhuiying@uniontech.com
# @Date      :   2023/07/17
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
    cat > hdf5_example.c <<EOF
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
    ls hdf5_example.c
    CHECK_RESULT $? 0 0 "Create hdf5_example.c file fail"
    gcc hdf5_example.c -o hdf5_example -lhdf5
    CHECK_RESULT $? 0 0 "Compile fail"
    ./hdf5_example
    CHECK_RESULT $? 0 0 "Execute fail"
    ls example.h5
    CHECK_RESULT $? 0 0 "Create example.h5 file fail"
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    rm -fr hdf5_example.c hdf5_example example.h5
    DNF_REMOVE "$@"
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
