#!/usr/bin/bash

# Copyright (c) 2026. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTY OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   ding_jiao
# @Contact   :   ding_jiao@hoperun.com
# @Date      :   2026-08-04
# @License   :   Mulan PSL v2
# @Desc      :   Test smbinfo subcommands functionality on CIFS mount
# ############################################
# shellcheck disable=SC2119,SC1091

source "$OET_PATH/libs/locallibs/common_lib.sh"
source "$(dirname "$0")/common/samba_server.sh"

SMB_CONF="/etc/samba/smbinfo_test.conf"
SMB_SHARE="/tmp/samba_smbinfo_share"
CIFS_MOUNT="/mnt/smbinfotest"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "samba cifs-utils"
    samba_start "$SMB_CONF" "$SMB_SHARE" "$CIFS_MOUNT" || return 1
    echo "test content for smbinfo verification" > "$CIFS_MOUNT/test_file"
    touch "$CIFS_MOUNT/empty_file"
    mkdir -p "$CIFS_MOUNT/test_dir"
    test_file="$CIFS_MOUNT/test_file"
    empty_file="$CIFS_MOUNT/empty_file"
    test_dir="$CIFS_MOUNT/test_dir"
    touch /tmp/local_test_file

    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."

    # Test -h: Show help
    smbinfo -h 2>&1 | grep "usage:" > /dev/null
    CHECK_RESULT $? 0 0 "smbinfo -h help missing"

    # Test no_args: Show error when no subcommand provided
    smbinfo 2>&1 | grep -i "required\|sub-command" > /dev/null
    CHECK_RESULT $? 0 0 "smbinfo without subcommand shows error"

    # Test filebasicinfo_Creation_Time: Show Creation Time
    smbinfo filebasicinfo "$test_file" 2>&1 | grep -q "Creation Time:"
    CHECK_RESULT $? 0 0 "filebasicinfo missing Creation Time"

    # Test filebasicinfo_Last_Write_Time: Show Last Write Time
    smbinfo filebasicinfo "$test_file" 2>&1 | grep -q "Last Write Time:"
    CHECK_RESULT $? 0 0 "filebasicinfo missing Last Write Time"

    # Test filebasicinfo_File_Attributes: Show File Attributes
    smbinfo filebasicinfo "$test_file" 2>&1 | grep -q "File Attributes:"
    CHECK_RESULT $? 0 0 "filebasicinfo missing File Attributes"

    # Test filebasicinfo_empty_file: Handle empty file
    smbinfo filebasicinfo "$empty_file" > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "filebasicinfo on empty file failed"

    # Test filebasicinfo_directory: Handle directory
    smbinfo filebasicinfo "$test_dir" 2>&1 | grep -q "Creation Time:"
    CHECK_RESULT $? 0 0 "filebasicinfo on directory failed"

    # Test fileallinfo_Allocation_Size: Show Allocation Size
    smbinfo fileallinfo "$test_file" 2>&1 | grep -q "Allocation Size:"
    CHECK_RESULT $? 0 0 "fileallinfo missing Allocation Size"

    # Test fileallinfo_End_Of_File: Show End Of File
    smbinfo fileallinfo "$test_file" 2>&1 | grep -q "End Of File:"
    CHECK_RESULT $? 0 0 "fileallinfo missing End Of File"

    # Test fileallinfo_Number_Of_Links: Show Number of Links
    smbinfo fileallinfo "$test_file" 2>&1 | grep -q "Number of Links:"
    CHECK_RESULT $? 0 0 "fileallinfo missing Number of Links"

    # Test fileallinfo_empty_file_EOF: Empty file EOF should be 0
    smbinfo fileallinfo "$empty_file" 2>&1 | grep -q "End Of File: 0"
    CHECK_RESULT $? 0 0 "fileallinfo empty file EOF should be 0"

    # Test filemodeinfo_Mode: Show Mode
    smbinfo filemodeinfo "$test_file" 2>&1 | grep -q "Mode:"
    CHECK_RESULT $? 0 0 "filemodeinfo missing Mode"

    # Test fileaccessinfo_access_flags: Show access flags
    smbinfo fileaccessinfo "$test_file" 2>&1 | grep -q "access flags"
    CHECK_RESULT $? 0 0 "fileaccessinfo missing access flags"

    # Test filestandardinfo_Allocation_Size: Show Allocation Size
    smbinfo filestandardinfo "$test_file" 2>&1 | grep -q "Allocation Size:"
    CHECK_RESULT $? 0 0 "filestandardinfo missing Allocation Size"

    # Test filestandardinfo_empty_file_Allocation_Size: Empty file allocation size should be 0
    smbinfo filestandardinfo "$empty_file" 2>&1 | grep -q "Allocation Size: 0"
    CHECK_RESULT $? 0 0 "filestandardinfo empty file Allocation Size should be 0"

    # Test filestandardinfo_EOF_positive: Non-empty file EOF should be > 0
    eof_val=$(smbinfo filestandardinfo "$test_file" 2>&1 | grep "End Of File:" | awk '{print $NF}')
    [ "$eof_val" -gt 0 ]
    CHECK_RESULT $? 0 0 "filestandardinfo non-empty file EOF should be > 0"

    # Test filestreaminfo_Name: Show stream info
    smbinfo filestreaminfo "$test_file" 2>&1 | grep -q "Name:"
    CHECK_RESULT $? 0 0 "filestreaminfo missing stream Name"

    # Test fileinternalinfo_Index_Number: Show Index Number
    smbinfo fileinternalinfo "$test_file" 2>&1 | grep -q "Index Number:"
    CHECK_RESULT $? 0 0 "fileinternalinfo missing Index Number"

    # Test fileeainfo_EA_Size: Show EA Size
    smbinfo fileeainfo "$test_file" 2>&1 | grep -q "EA Size:"
    CHECK_RESULT $? 0 0 "fileeainfo missing EA Size"

    # Test filefsfullsizeinfo_Total_Allocation_Units: Show Total Allocation Units
    smbinfo filefsfullsizeinfo "$test_file" 2>&1 | grep -q "Total Allocation Units:"
    CHECK_RESULT $? 0 0 "filefsfullsizeinfo missing Total Allocation Units"

    # Test filefsfullsizeinfo_Bytes_Per_Sector: Show Bytes Per Sector
    smbinfo filefsfullsizeinfo "$test_file" 2>&1 | grep -q "Bytes Per Sector:"
    CHECK_RESULT $? 0 0 "filefsfullsizeinfo missing Bytes Per Sector"

    # Test filepositioninfo_Current_Byte_Offset: Show Current Byte Offset
    smbinfo filepositioninfo "$test_file" 2>&1 | grep -q "Current Byte Offset:"
    CHECK_RESULT $? 0 0 "filepositioninfo missing Current Byte Offset"

    # Test secdesc_Revision: Show security descriptor Revision
    smbinfo secdesc "$test_file" 2>&1 | grep -q "Revision:"
    CHECK_RESULT $? 0 0 "secdesc missing Revision"

    # Test secdesc_Owner: Show security descriptor Owner
    smbinfo secdesc "$test_file" 2>&1 | grep -q "Owner:"
    CHECK_RESULT $? 0 0 "secdesc missing Owner"

    # Test secdesc_DACL: Show security descriptor DACL
    smbinfo secdesc "$test_file" 2>&1 | grep -q "DACL:"
    CHECK_RESULT $? 0 0 "secdesc missing DACL"

    # Test filealigninfo: Work on CIFS file
    smbinfo filealigninfo "$test_file" > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "filealigninfo on CIFS file failed"

    # Test getcompression: Show compression setting
    smbinfo getcompression "$test_file" 2>&1 | grep -q "Compression:"
    CHECK_RESULT $? 0 0 "getcompression missing Compression"

    # Test setcompression_no: Set compression to no
    smbinfo setcompression no "$test_file" > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "setcompression 'no' failed"

    # Test setcompression_default: Set compression to default
    smbinfo setcompression default "$test_file" > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "setcompression 'default' failed"

    # Test setcompression_lznt1: Set compression to lznt1
    smbinfo setcompression lznt1 "$test_file" > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "setcompression 'lznt1' failed"

    # Test setcompression_invalid: Invalid compression option should fail
    smbinfo setcompression invalid "$test_file" > /dev/null 2>&1; ret=$?; [ $ret -eq 2 ]
    CHECK_RESULT $? 0 0 "setcompression invalid option should fail with code 2"

    # Test -V: Show verbose output with attribute names
    smbinfo -V filebasicinfo "$test_file" 2>&1 | grep -q "ARCHIVE"
    CHECK_RESULT $? 0 0 "smbinfo -V verbose output missing attribute names"

    # Test local_file_error: Report error on local (non-CIFS) file
    smbinfo filebasicinfo /tmp/local_test_file 2>&1 | grep -qi "failed\|syscall" > /dev/null
    CHECK_RESULT $? 0 0 "smbinfo on local file should report error"

    # Test invalid_subcommand: Invalid subcommand should fail
    ! smbinfo invalid_sub "$test_file" > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "smbinfo invalid subcommand should fail"

    # Test directory_attributes: Directory should have directory attribute (0x10)
    dir_attr=$(smbinfo filebasicinfo "$test_dir" 2>&1 | grep "File Attributes:" | awk '{print $3}')
    [ "$dir_attr" = "0x00000010" ]
    CHECK_RESULT $? 0 0 "directory File Attributes should include DIRECTORY flag"

    # Test file_attributes: File should have archive attribute (0x20)
    file_attr=$(smbinfo filebasicinfo "$test_file" 2>&1 | grep "File Attributes:" | awk '{print $3}')
    [ "$file_attr" = "0x00000020" ]
    CHECK_RESULT $? 0 0 "file File Attributes should include ARCHIVE flag"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    samba_stop "$SMB_CONF" "$CIFS_MOUNT"
    rm -f /tmp/local_test_file
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
