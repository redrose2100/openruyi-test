# cifs-utils

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/cifs-utils` |
| 注册用例数 | 10 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_cifs-utils_install | Test cifs-utils package installation integrity | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_cifs-utils_mount | Test mount.cifs command with local Samba server | pre_test/run_test/post_test | 15 | ✔ |  |  |
| oe_test_cifs-utils_mount_smb3 | Test mount.smb3 command - SMB3 mount with local Samba | create_creds_file/cleanup_creds_file/pre_test/run_test/post_test | 19 | ✔ |  |  |
| oe_test_cifs-utils_creds | Test cifscreds command - manage CIFS credentials | cifscreds_run/pre_test/run_test/post_test | 24 | ✔ |  |  |
| oe_test_cifs-utils_getcifsacl | Test getcifsacl command - display CIFS/NTFS ACL on Samba share | pre_test/run_test/post_test | 12 | ✔ |  |  |
| oe_test_cifs-utils_setcifsacl | Test setcifsacl command - modify CIFS/NTFS ACL on Samba share | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_cifs-utils_smbinfo | Test smbinfo subcommands functionality on CIFS mount | pre_test/run_test/post_test | 38 | ✔ |  |  |
| oe_test_cifs-utils_smb2_quota | Test smb2-quota command - SMB2 quota tool | pre_test/run_test/post_test | 8 | ✔ |  |  |
| oe_test_cifs-utils_idmap | Test cifs.idmap command - CIFS idmap upcall helper | pre_test/run_test/post_test | 11 | ✔ |  |  |
| oe_test_cifs-utils_upcall | Test cifs.upcall command - CIFS upcall helper for Kerberos | pre_test/run_test/post_test | 11 | ✔ |  |  |

### 断言与命令明细

#### oe_test_cifs-utils_install

- 描述：Test cifs-utils package installation integrity
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "cifs-utils package not installed"
  CHECK_RESULT $? 0 0 "Package integrity check failed"
  CHECK_RESULT $? 0 0 "Package contains no files"
  CHECK_RESULT $? 0 0 "Critical binary missing: $f"
  CHECK_RESULT $? 0 0 "Config file missing: $f"
  CHECK_RESULT $? 0 0 "idmapwb.so library missing"
  CHECK_RESULT $? 0 0 "pam_cifscreds.so library missing"
  CHECK_RESULT $? 0 0 "mount.cifs version output missing"
  CHECK_RESULT $? 0 0 "mount.smb3 version output missing"
  CHECK_RESULT $? 0 0 "keyutils dependency not satisfied"
```

- 涉及命令：rpm×3, mount.cifs×1, mount.smb3×1

#### oe_test_cifs-utils_mount

- 描述：Test mount.cifs command with local Samba server
- 函数：`pre_test, run_test, post_test`
- 断言（15 条）：

```
  CHECK_RESULT $? 0 0 "mount.cifs -V version failed"
  CHECK_RESULT $? 0 0 "mount.cifs help not displayed"
  CHECK_RESULT $? 1 0 "mount.cifs missing args should fail"
  CHECK_RESULT $? 0 0 "mount.cifs invalid option should fail"
  CHECK_RESULT $? 0 0 "mount.cifs mount not found in mount table"
  CHECK_RESULT $? 0 0 "mount.cifs: test.txt not visible"
  CHECK_RESULT $? 0 0 "mount.cifs: file content mismatch"
  CHECK_RESULT $? 0 0 "mount.cifs: write failed"
  CHECK_RESULT $? 0 0 "mount.cifs: subdir not visible"
  CHECK_RESULT $? 0 0 "mount.cifs: nested file content mismatch"
  CHECK_RESULT $? 0 0 "umount failed after mount.cifs"
  CHECK_RESULT $? 1 0 "mount.cifs: still mounted after umount"
  ... 共 15 条（其余见源脚本）
```

- 涉及命令：grep×4, mkdir×2, umount×1, mount.cifs×1

#### oe_test_cifs-utils_mount_smb3

- 描述：Test mount.smb3 command - SMB3 mount with local Samba
- 函数：`create_creds_file, cleanup_creds_file, pre_test, run_test, post_test`
- 断言（19 条）：

```
  CHECK_RESULT $? 0 0 "mount.smb3 -V version failed"
  CHECK_RESULT $? 0 0 "mount.smb3 help not displayed"
  CHECK_RESULT $? 1 0 "mount.smb3 missing args should fail"
  CHECK_RESULT $? 0 0 "mount.smb3 invalid option should fail"
  CHECK_RESULT $? 0 0 "mount.smb3: mount not found in mount table"
  CHECK_RESULT $? 0 0 "mount.smb3: test.txt not visible"
  CHECK_RESULT $? 0 0 "mount.smb3: file content mismatch"
  CHECK_RESULT $? 0 0 "mount.smb3: write failed"
  CHECK_RESULT $? 0 0 "mount.smb3: subdir not visible"
  CHECK_RESULT $? 0 0 "mount.smb3: nested file content mismatch"
  CHECK_RESULT $? 0 0 "mount.smb3: directory missing DIRECTORY attribute"
  CHECK_RESULT $? 0 0 "mount.smb3: directory attribute check fallback"
  ... 共 19 条（其余见源脚本）
```

- 涉及命令：grep×4, mkdir×2, umount×1, mount.smb3×1

#### oe_test_cifs-utils_creds

- 描述：Test cifscreds command - manage CIFS credentials
- 函数：`cifscreds_run, pre_test, run_test, post_test`
- 断言（24 条）：

```
  CHECK_RESULT $? 0 0 "cifscreds usage not displayed"
  CHECK_RESULT $? 0 0 "cifscreds add cifs-test-host failed"
  CHECK_RESULT $? 0 0 "cifscreds add verification: credential not found in keyring"
  CHECK_RESULT $? 0 0 "cifscreds clear cifs-test-host failed"
  CHECK_RESULT $? 1 0 "cifscreds clear verification: credential still exists"
  CHECK_RESULT $? 0 0 "cifscreds add -u testuser failed"
  CHECK_RESULT $? 0 0 "cifscreds add -u verification: credential not found in keyring"
  CHECK_RESULT $? 0 0 "cifscreds update -u failed"
  CHECK_RESULT $? 0 0 "cifscreds update -u verification: credential not found after update"
  CHECK_RESULT $? 0 0 "cifscreds clear -u failed"
  CHECK_RESULT $? 1 0 "cifscreds clear -u verification: credential still exists"
  CHECK_RESULT $? 0 0 "cifscreds add -d cifs-test-domain failed"
  ... 共 24 条（其余见源脚本）
```

- 涉及命令：sed×3

#### oe_test_cifs-utils_getcifsacl

- 描述：Test getcifsacl command - display CIFS/NTFS ACL on Samba share
- 函数：`pre_test, run_test, post_test`
- 断言（12 条）：

```
  CHECK_RESULT $? 0 0 "getcifsacl -h help missing"
  CHECK_RESULT $? 0 0 "getcifsacl -v version failed"
  CHECK_RESULT $? 0 0 "getcifsacl without file shows error"
  CHECK_RESULT $? 0 0 "getcifsacl basic usage failed"
  CHECK_RESULT $? 0 0 "getcifsacl basic output missing DACL"
  CHECK_RESULT $? 0 0 "getcifsacl -r raw option failed"
  CHECK_RESULT $? 0 0 "getcifsacl -r output missing raw values"
  CHECK_RESULT $? 0 0 "getcifsacl -R recursive option failed"
  CHECK_RESULT $? 0 0 "getcifsacl -R did not recurse into subdirectory"
  CHECK_RESULT $? 0 0 "getcifsacl multi-file usage failed"
  CHECK_RESULT $? 0 0 "getcifsacl multi-file output missing nested_file"
  CHECK_RESULT $? 0 0 "getcifsacl invalid option should fail"
```

- 涉及命令：getcifsacl×2, mkdir×1

#### oe_test_cifs-utils_setcifsacl

- 描述：Test setcifsacl command - modify CIFS/NTFS ACL on Samba share
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "setcifsacl -h help missing"
  CHECK_RESULT $? 0 0 "setcifsacl -v version failed"
  CHECK_RESULT $? 0 0 "setcifsacl without file shows error"
  CHECK_RESULT $? 0 0 "setcifsacl invalid option should fail"
  CHECK_RESULT $? 0 0 "setcifsacl -a ACE format valid on Samba"
  CHECK_RESULT $? 0 0 "setcifsacl -A ACE format valid on Samba"
  CHECK_RESULT $? 0 0 "setcifsacl -M ACE format valid on Samba"
  CHECK_RESULT $? 0 0 "setcifsacl -S ACE format valid on Samba"
  CHECK_RESULT $? 0 0 "setcifsacl multi-file arguments accepted"
  CHECK_RESULT $? 0 0 "setcifsacl non-existent file should fail"
```

- 涉及命令：setcifsacl×7, mkdir×1

#### oe_test_cifs-utils_smbinfo

- 描述：Test smbinfo subcommands functionality on CIFS mount
- 函数：`pre_test, run_test, post_test`
- 断言（38 条）：

```
  CHECK_RESULT $? 0 0 "smbinfo -h help missing"
  CHECK_RESULT $? 0 0 "smbinfo without subcommand shows error"
  CHECK_RESULT $? 0 0 "filebasicinfo missing Creation Time"
  CHECK_RESULT $? 0 0 "filebasicinfo missing Last Write Time"
  CHECK_RESULT $? 0 0 "filebasicinfo missing File Attributes"
  CHECK_RESULT $? 0 0 "filebasicinfo on empty file failed"
  CHECK_RESULT $? 0 0 "filebasicinfo on directory failed"
  CHECK_RESULT $? 0 0 "fileallinfo missing Allocation Size"
  CHECK_RESULT $? 0 0 "fileallinfo missing End Of File"
  CHECK_RESULT $? 0 0 "fileallinfo missing Number of Links"
  CHECK_RESULT $? 0 0 "fileallinfo empty file EOF should be 0"
  CHECK_RESULT $? 0 0 "filemodeinfo missing Mode"
  ... 共 38 条（其余见源脚本）
```

- 涉及命令：smbinfo×2, mkdir×1

#### oe_test_cifs-utils_smb2_quota

- 描述：Test smb2-quota command - SMB2 quota tool
- 函数：`pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $? 0 0 "smb2-quota command not found"
  CHECK_RESULT $? 0 0 "python not found for smb2-quota"
  CHECK_RESULT $? 0 0 "smb2-quota no-args usage/error missing"
  CHECK_RESULT $? 0 0 "smb2-quota -h help missing"
  CHECK_RESULT $? 0 0 "smb2-quota -t option accepted"
  CHECK_RESULT $? 0 0 "smb2-quota -c option accepted"
  CHECK_RESULT $? 0 0 "smb2-quota -l option accepted"
  CHECK_RESULT $? 0 0 "smb2-quota invalid option should fail"
```

- 涉及命令：smb2-quota×4, hash×1

#### oe_test_cifs-utils_idmap

- 描述：Test cifs.idmap command - CIFS idmap upcall helper
- 函数：`pre_test, run_test, post_test`
- 断言（11 条）：

```
  CHECK_RESULT $? 0 0 "cifs.idmap command not found"
  CHECK_RESULT $? 0 0 "cifs.idmap -h help missing"
  CHECK_RESULT $? 0 0 "cifs.idmap -v version failed"
  CHECK_RESULT $? 1 0 "cifs.idmap without key_serial should fail"
  CHECK_RESULT $? 1 0 "cifs.idmap -t timeout without key_serial should fail"
  CHECK_RESULT $? 0 0 "cifs.idmap invalid option should fail"
  CHECK_RESULT $? 0 0 "cifs.idmap config file missing"
  CHECK_RESULT $? 0 0 "idmap-plugin config missing"
  CHECK_RESULT $? 0 0 "idmapwb.so plugin missing"
  CHECK_RESULT $? 0 0 "cifs_idmap_sss.so plugin missing"
  CHECK_RESULT $? 0 0 "cifs.idmap.conf missing upcall path"
```

- 涉及命令：cifs.idmap×3, grep×1

#### oe_test_cifs-utils_upcall

- 描述：Test cifs.upcall command - CIFS upcall helper for Kerberos
- 函数：`pre_test, run_test, post_test`
- 断言（11 条）：

```
  CHECK_RESULT $? 0 0 "cifs.upcall command not found"
  CHECK_RESULT $? 0 0 "cifs.upcall usage not displayed"
  CHECK_RESULT $? 0 0 "cifs.upcall -v version display failed"
  CHECK_RESULT $? 1 0 "cifs.upcall -t should fail without key_serial"
  CHECK_RESULT $? 1 0 "cifs.upcall -E should fail without key_serial"
  CHECK_RESULT $? 1 0 "cifs.upcall -l should fail without key_serial"
  CHECK_RESULT $? 1 0 "cifs.upcall -e should fail without key_serial"
  CHECK_RESULT $? 1 0 "cifs.upcall -K should fail without key_serial"
  CHECK_RESULT $? 1 0 "cifs.upcall -k should fail without key_serial"
  CHECK_RESULT $? 0 0 "cifs.upcall invalid option should fail"
  CHECK_RESULT $? 0 0 "cifs.upcall config file missing"
```

- 涉及命令：cifs.upcall×7
