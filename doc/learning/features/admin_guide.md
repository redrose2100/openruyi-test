# admin_guide

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 文档域（doc-test） |
| 套件路径 | `$OET_PATH/testcases/doc-test/admin_guide` |
| 注册用例数 | 92 |
| 环境约束 | machine num = 2；machine type = kvm；add network interface = 2；add disk = 2,2,2,2 |

> ⚠️ 本套件声明环境约束，执行前由 `check_environment.py` 预检；不满足的用例自动 skipped(255)。

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_basic_del_user | Delete User test | config_params/run_test | 2 |  |  |  |
| oe_test_basic_system_info | View system information | run_test | 8 |  |  |  |
| oe_test_basic_set_pwd_empty | Password setting - password empty | pre_test/run_test/post_test | 1 |  |  |  |
| oe_test_httpd_check_configuration_status | Httpd starts and stops and restarts the service | pre_test/run_test/post_test | 6 | ✔ |  |  |
| oe_test_lvm_pvdispay | Display PV Information | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_basic_query_MEM | Query MEM configure test-lshw -c | pre_test/run_test/post_test | 13 | ✔ |  |  |
| oe_test_httpd_verify_web | Verify that the web service is successfully built | pre_test/run_test/post_test | 4 | ✔ | ✔ |  |
| oe_test_basic_Hwclcok_setting | Hwclock command line test | run_test/post_test | 3 |  |  |  |
| oe_test_basic_mod_current_user_pwd | User password modification_current user | pre_test/run_test/post_test | 2 |  |  |  |
| oe_test_lvm_lvreduce | Reduce LV | pre_test/run_test/post_test | 5 | ✔ |  |  |
| oe_test_lvm_Manual_mount | Create LV | pre_test/run_test/post_test | 8 | ✔ |  |  |
| oe_test_lvm_pvchange | Prevent LVM from allocating PE on PV | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_lvm_lvremove_lvchange | Remove LV | pre_test/run_test/post_test | 5 | ✔ |  |  |
| oe_test_basic_local_setting | Locale setting test | config_params/run_test/post_test | 3 |  |  |  |
| oe_test_basic_query_cpu | Query CPU configure test-lscpu | pre_test/run_test/post_test | 7 | ✔ |  |  |
| oe_test_lvm_lvcreate_lvdisplay | Create LV | pre_test/run_test/post_test | 8 | ✔ |  |  |
| oe_test_lvm_vgextend | Add disks to VG | pre_test/run_test/post_test | 7 | ✔ |  |  |
| oe_test_basic_mod_user_home_directory | Modify user home directory | pre_test/run_test/post_test | 7 |  |  |  |
| oe_test_lvm_auto_mount | Execute the blkid command to query the UUID of the logical volume | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_basic_mod_UID | Modify UID | run_test/post_test | 5 |  |  |  |
| oe_test_lvm_lvchange | Logical volume activation | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_lvm_lvresize_add | Add space to logical volume | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_basic_view_disk_info | View disk information | run_test | 2 |  |  |  |
| oe_test_dnf_package_operate | Package operations | pre_test/run_test/post_test | 7 | ✔ |  |  |
| oe_test_basic_configure_keyboard | Configure keyboard layout test | pre_test/run_test/post_test | 3 |  |  |  |
| oe_test_lvm_pvremvoe | Remove PV | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_lvm_vgcreate_vgdisplay | Print VG group information | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_basic_config_Hostnamectl | hostnamectl configuration hostname test | run_test/post_test | 4 |  | ✔ |  |
| oe_test_httpd_manage_module_ssl | Management module and ssl | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_basic_set_time | Use the timedatectl command to set the time | pre_test/run_test/post_test | 9 |  |  |  |
| oe_test_basic_view_user_group_ids | View user and group id | config_params/run_test/post_test | 4 |  |  |  |
| oe_test_dnf_source_set | Enable source, disable source | run_test | 4 |  |  |  |
| oe_test_dnf_package_group_operate | Package group operations | pre_test/run_test/post_test | 5 |  |  |  |
| oe_test_lvm_shrink_roll_group | Shrink logical volume | pre_test/run_test/post_test | 7 | ✔ |  |  |
| oe_test_basic_add_user | Add User test | pre_test/run_test/post_test | 4 |  |  |  |
| oe_test_basic_related_account_info | Documents related to user account information | run_test | 5 |  |  |  |
| oe_test_lvm_lvresize_reduce | Reduce the size of logical volume | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_dnf_display_config_info | Display current configuration information | run_test | 3 |  |  |  |
| oe_test_lvm_lvextend | Expand LV | pre_test/run_test/post_test | 6 | ✔ |  |  |
| oe_test_basic_expiration_time_setting | Set account and password expiration time test | pre_test/run_test/post_test | 5 |  |  |  |
| oe_test_lvm_vgchange_vgremove | Remove VG | pre_test/run_test/post_test | 5 | ✔ |  |  |
| oe_test_lvm_pvcreate | Create LV | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_mysql_backup_restore_db | Backup / restore database | pre_test/run_test/post_test | 19 | ✔ |  |  |
| oe_test_httpd_transfer_start_stop_restart | Httpd starts and stops and restarts the service | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_mariadb_grant_delete_authorization | User authorization / delete user permissions | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_mysql_configuration | Login and exit configuration database password | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_mysql_create_view_user | Create User / View User | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_mysql_create_view_select_delete_db | Create, view, select, delete database | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_mariadb_install_run_uninstall | Install, run and uninstall | pre_test/run_test/post_test | 5 | ✔ |  |  |
| oe_test_mariadb_create_view_select_delete_db | Create, view, select, delete database | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_mysql_grant_delete_authorization | User authorization / delete user permissions | pre_test/run_test/post_test | 7 | ✔ |  |  |
| oe_test_mariadb_create_view_user | Create User / View User | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_mariadb_backup_restore_db | POSTGRESQL create run delete | pre_test/run_test/post_test | 16 | ✔ |  |  |
| oe_test_httpd_verify_status | Verify the httpd service status | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_mariadb_modify_delete_user | Modify user and delete user | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_dnf_create_local_repository | Create a local software source repository | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_nmcli_config_dynamic_IP | Nmcli configure dynamic IP connection | config_params/run_test/post_test | 3 |  |  |  |
| oe_test_postgresql_create_delete_roles | Postgresql create / delete roles | pre_test/run_test/post_test | 9 | ✔ |  |  |
| oe_test_nginx_verify_web | Verify that the web service is successfully built | pre_test/run_test/post_test | 4 | ✔ | ✔ |  |
| oe_test_postgresql_backup_restore_db | Backup / restore database | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_nmcli_query_link | Nmcli connection query activation test | config_params/run_test/post_test | 7 |  |  |  |
| oe_test_postgresql_create_run_delete | POSTGRESQL create run delete | pre_test/run_test/post_test | 6 | ✔ |  |  |
| oe_test_nmcli_mod_attribute | Nmcli modify attributes test | config_params/pre_test/run_test/post_test | 4 |  |  |  |
| oe_test_postgresql_change_roles | POSTGRESQL changes the role | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_postgresql_create_delete_db | Create / delete the postgresql database | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_nmcli_config_static_IP | Nmcli configure static IP connection | config_params/run_test/post_test | 8 |  |  |  |
| oe_test_nmcli_use_bonding | Use command line bonding test | config_params/pre_test/run_test/post_test | 10 |  |  |  |
| oe_test_nmcli_config_hostname | Nmcli configuration hostname | run_test/post_test | 4 |  |  |  |
| oe_test_nginx_manage_status | Manage nginx and verify service status | pre_test/run_test/post_test | 8 | ✔ |  |  |
| oe_test_mysql_modify_delete_user | Modify user and delete user | pre_test/run_test/post_test | 7 | ✔ |  |  |
| oe_test_nginx_check_configuration | Check the nginx configuration for errors | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_procmgmt_who | Command test-who -b/-s | pre_test/run_test/post_test | 4 |  |  |  |
| oe_test_procmgmt_ps_top_kill | Command test-who -b/-s | run_test | 4 |  |  |  |
| oe_test_set_XLL_Forwarding | Install JDK package | run_test | 3 |  |  |  |
| oe_test_procmgmt_run_programs_regularly | Run a batch of programs regularly-at | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_vsftpd_start_stop | Start and stop vsftpd | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_server_verify_service_status | Start stop and restart services | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_vsftpd_transfer_deleted | FTP transfer file deleted | pre_test/run_test/post_test | 6 | ✔ | ✔ |  |
| oe_test_server_operate_service | Verify service status | pre_test/run_test/post_test | 6 | ✔ |  |  |
| oe_test_procmgmt_create_another_cron_file | User creates another cron file | run_test/post_test | 4 |  |  |  |
| oe_test_postgresql_grant_delete_authorization | Postgresql role authorization / deletion authorization | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_vsftpd_transfer_download | FTP transfer file download | pre_test/run_test/post_test | 6 | ✔ | ✔ |  |
| oe_test_vsftpd_transfer_upload | FTP Transfer File Upload | pre_test/run_test/post_test | 6 | ✔ | ✔ |  |
| oe_test_vsftpd_conf | Configuring VSFTPD | pre_test/run_test/post_test | 8 | ✔ |  |  |
| oe_test_ip_cmd_addr | Command test-ip addr | config_params/run_test/post_test | 7 |  |  |  |
| oe_test_ip_cmd_route | Command test-ip route | config_params/run_test/post_test | 5 |  |  |  |
| oe_test_ip_cmd_rule | Command test-ip rule | config_params/run_test/post_test | 5 |  |  |  |
| oe_test_ip_config_mtu | Set the mtu of the interface device | config_params/run_test/post_test | 8 |  |  |  |
| oe_test_ip_config_multiple_address | ip configure multiple addresses | config_params/run_test/post_test | 3 |  |  |  |
| oe_test_ip_config_static_address | IP configuration static address | config_params/run_test/post_test | 2 |  |  |  |
| oe_test_ip_config_static_route | ip configure static routing | config_params/run_test/post_test | 4 |  |  |  |
| oe_test_basic_date_common | Date command line test | pre_test/run_test/post_test | 8 |  |  |  |

### 断言与命令明细

#### oe_test_basic_del_user

- 描述：Delete User test
- 函数：`config_params, run_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 1
  CHECK_RESULT $? 1
```

- 涉及命令：userdel×2, test×1

#### oe_test_basic_system_info

- 描述：View system information
- 函数：`run_test`
- 断言（8 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

#### oe_test_basic_set_pwd_empty

- 描述：Password setting - password empty
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $?
```

- 涉及命令：grep×3, expect×1, userdel×1

#### oe_test_httpd_check_configuration_status

- 描述：Httpd starts and stops and restarts the service
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

#### oe_test_lvm_pvdispay

- 描述：Display PV Information
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：pvcreate×1

#### oe_test_basic_query_MEM

- 描述：Query MEM configure test-lshw -c
- 函数：`pre_test, run_test, post_test`
- 断言（13 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  ... 共 13 条（其余见源脚本）
```

- 涉及命令：lshw×13

#### oe_test_httpd_verify_web

- 描述：Verify that the web service is successfully built
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：python3×1, kill×1

#### oe_test_basic_Hwclcok_setting

- 描述：Hwclock command line test
- 函数：`run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：date×1, hwclock×1

#### oe_test_basic_mod_current_user_pwd

- 描述：User password modification_current user
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：expect×1, userdel×1

#### oe_test_lvm_lvreduce

- 描述：Reduce LV
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：pvcreate×1, lvcreate×1, lvremove×1, vgremove×1

#### oe_test_lvm_Manual_mount

- 描述：Create LV
- 函数：`pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：pvcreate×1, vgcreate×1, lvcreate×1, mkfs.ext4×1, lvremove×1, vgremove×1, pvremove×1

#### oe_test_lvm_pvchange

- 描述：Prevent LVM from allocating PE on PV
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $?
```

- 涉及命令：pvcreate×1, pvchange×1

#### oe_test_lvm_lvremove_lvchange

- 描述：Remove LV
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：pvcreate×1, lvcreate×1, vgremove×1

#### oe_test_basic_local_setting

- 描述：Locale setting test
- 函数：`config_params, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

#### oe_test_basic_query_cpu

- 描述：Query CPU configure test-lscpu
- 函数：`pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：grep×1, lshw×1

#### oe_test_lvm_lvcreate_lvdisplay

- 描述：Create LV
- 函数：`pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：pvcreate×1, vgcreate×1, lvcreate×1, lvremove×1, vgremove×1, pvremove×1

#### oe_test_lvm_vgextend

- 描述：Add disks to VG
- 函数：`pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：pvcreate×1, vgcreate×1, lvcreate×1, pvs×1, lvremove×1, vgremove×1, pvremove×1

#### oe_test_basic_mod_user_home_directory

- 描述：Modify user home directory
- 函数：`pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：grep×2, test×2, usermod×2, userdel×1

#### oe_test_lvm_auto_mount

- 描述：Execute the blkid command to query the UUID of the logical volume
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：pvcreate×1, vgcreate×1, lvcreate×1, mount×1, sed×1

#### oe_test_basic_mod_UID

- 描述：Modify UID
- 函数：`run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：grep×2, usermod×1, userdel×1

#### oe_test_lvm_lvchange

- 描述：Logical volume activation
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：lvchange×4, pvcreate×1, lvcreate×1, vgremove×1

#### oe_test_lvm_lvresize_add

- 描述：Add space to logical volume
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：pvcreate×1, lvcreate×1, lvextend×1, lvresize×1, lvremove×1, vgremove×1

#### oe_test_basic_view_disk_info

- 描述：View disk information
- 函数：`run_test`
- 断言（2 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：fdisk×2

#### oe_test_dnf_package_operate

- 描述：Package operations
- 函数：`pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

#### oe_test_basic_configure_keyboard

- 描述：Configure keyboard layout test
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

#### oe_test_lvm_pvremvoe

- 描述：Remove PV
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $?
```

- 涉及命令：pvcreate×1

#### oe_test_lvm_vgcreate_vgdisplay

- 描述：Print VG group information
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：pvcreate×1, vgremove×1

#### oe_test_basic_config_Hostnamectl

- 描述：hostnamectl configuration hostname test
- 函数：`run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $? 1
  CHECK_RESULT $?
```

#### oe_test_httpd_manage_module_ssl

- 描述：Management module and ssl
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：sed×2, httpd×2

#### oe_test_basic_set_time

- 描述：Use the timedatectl command to set the time
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT "$ret" 0 1
  CHECK_RESULT $?
```

#### oe_test_basic_view_user_group_ids

- 描述：View user and group id
- 函数：`config_params, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

#### oe_test_dnf_source_set

- 描述：Enable source, disable source
- 函数：`run_test`
- 断言（4 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT "$(grep "\[${reponame}\]" -A 6 /etc/yum.repos.d/*.repo | grep "enabled=" | awk -F '=' '{print$2}')" 0
  CHECK_RESULT $?
  CHECK_RESULT "$(grep "\[${reponame}\]" -A 6 /etc/yum.repos.d/*.repo | grep "enabled=" | awk -F '=' '{print$2}')" 1
```

#### oe_test_dnf_package_group_operate

- 描述：Package group operations
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

#### oe_test_lvm_shrink_roll_group

- 描述：Shrink logical volume
- 函数：`pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：lvextend×2, pvcreate×1, lvcreate×1, lvremove×1, vgremove×1, pvremove×1

#### oe_test_basic_add_user

- 描述：Add User test
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：grep×4, chage×3, userdel×2, useradd×1

#### oe_test_basic_related_account_info

- 描述：Documents related to user account information
- 函数：`run_test`
- 断言（5 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

#### oe_test_lvm_lvresize_reduce

- 描述：Reduce the size of logical volume
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $? 1
```

- 涉及命令：pvcreate×1, lvcreate×1, lvextend×1, grep×1, lvremove×1, vgremove×1

#### oe_test_dnf_display_config_info

- 描述：Display current configuration information
- 函数：`run_test`
- 断言（3 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

#### oe_test_lvm_lvextend

- 描述：Expand LV
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：lvextend×3, pvcreate×1, lvcreate×1, vgremove×1

#### oe_test_basic_expiration_time_setting

- 描述：Set account and password expiration time test
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：chage×5, grep×3, userdel×1

#### oe_test_lvm_vgchange_vgremove

- 描述：Remove VG
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $? 1
```

- 涉及命令：pvcreate×1, vgcreate×1, vgremove×1

#### oe_test_lvm_pvcreate

- 描述：Create LV
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：lvcreate×1

#### oe_test_mysql_backup_restore_db

- 描述：Backup / restore database
- 函数：`pre_test, run_test, post_test`
- 断言（19 条）：

```
  CHECK_RESULT $? 1
  CHECK_RESULT $?
  CHECK_RESULT $? 1
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  ... 共 19 条（其余见源脚本）
```

- 涉及命令：mysqldump×5, expect×4, grep×2, mysql×1, test×1

#### oe_test_httpd_transfer_start_stop_restart

- 描述：Httpd starts and stops and restarts the service
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

#### oe_test_mariadb_grant_delete_authorization

- 描述：User authorization / delete user permissions
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $? 1
```

- 涉及命令：expect×4, chown×2, useradd×1, test×1, mysqladmin×1, userdel×1

#### oe_test_mysql_configuration

- 描述：Login and exit configuration database password
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 1
  CHECK_RESULT "$(grep -ic 'Query OK' testlog)" 4
```

- 涉及命令：expect×1, grep×1, test×1

#### oe_test_mysql_create_view_user

- 描述：Create User / View User
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 1
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：expect×2, grep×1, test×1

#### oe_test_mysql_create_view_select_delete_db

- 描述：Create, view, select, delete database
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 1
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT "$(grep -v changed <testlog | grep -w 'Database' -A 5 | grep -c databaseexample)" 1
```

- 涉及命令：grep×2, expect×1, test×1

#### oe_test_mariadb_install_run_uninstall

- 描述：Install, run and uninstall
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $? 1
  CHECK_RESULT $? 1
  CHECK_RESULT $?
```

- 涉及命令：test×2, chown×2, expect×2, grep×2, useradd×1, mysqladmin×1, kill×1, userdel×1

#### oe_test_mariadb_create_view_select_delete_db

- 描述：Create, view, select, delete database
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT "$(grep -v changed testlog | grep -w "Database" -A 5 | grep -wc databaseexample)" 1
```

- 涉及命令：test×2, chown×2, useradd×1, mysqladmin×1, expect×1, grep×1, userdel×1

#### oe_test_mysql_grant_delete_authorization

- 描述：User authorization / delete user permissions
- 函数：`pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $? 1
  CHECK_RESULT $?
  CHECK_RESULT $? 1
  CHECK_RESULT $?
  CHECK_RESULT $? 1
  CHECK_RESULT $?
  CHECK_RESULT $? 1
```

- 涉及命令：expect×4, grep×3, test×1

#### oe_test_mariadb_create_view_user

- 描述：Create User / View User
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：chown×2, expect×2, useradd×1, test×1, mysqladmin×1, userdel×1

#### oe_test_mariadb_backup_restore_db

- 描述：POSTGRESQL create run delete
- 函数：`pre_test, run_test, post_test`
- 断言（16 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $? 1
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  ... 共 16 条（其余见源脚本）
```

- 涉及命令：mysqldump×5, expect×4, chown×2, useradd×1, test×1, mysqladmin×1, grep×1, mysql×1, userdel×1

#### oe_test_httpd_verify_status

- 描述：Verify the httpd service status
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $?
```

#### oe_test_mariadb_modify_delete_user

- 描述：Modify user and delete user
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 1
  CHECK_RESULT $?
  CHECK_RESULT $? 1
  CHECK_RESULT $? 1
```

- 涉及命令：expect×3, test×2, chown×2, useradd×1, mysqladmin×1, userdel×1

#### oe_test_dnf_create_local_repository

- 描述：Create a local software source repository
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：mkdir×1

#### oe_test_nmcli_config_dynamic_IP

- 描述：Nmcli configure dynamic IP connection
- 函数：`config_params, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

#### oe_test_postgresql_create_delete_roles

- 描述：Postgresql create / delete roles
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $? 1
  CHECK_RESULT $?
  CHECK_RESULT $? 1
  CHECK_RESULT $? 1
  CHECK_RESULT $? 1
  CHECK_RESULT $? 1
```

- 涉及命令：grep×3, useradd×1, test×1, chown×1, userdel×1

#### oe_test_nginx_verify_web

- 描述：Verify that the web service is successfully built
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

#### oe_test_postgresql_backup_restore_db

- 描述：Backup / restore database
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：useradd×1, test×1, chown×1, pg_dump×1, psql×1, userdel×1

#### oe_test_nmcli_query_link

- 描述：Nmcli connection query activation test
- 函数：`config_params, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

#### oe_test_postgresql_create_run_delete

- 描述：POSTGRESQL create run delete
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：useradd×1, test×1, chown×1, rpm×1, userdel×1

#### oe_test_nmcli_mod_attribute

- 描述：Nmcli modify attributes test
- 函数：`config_params, pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

#### oe_test_postgresql_change_roles

- 描述：POSTGRESQL changes the role
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：useradd×1, test×1, chown×1, userdel×1

#### oe_test_postgresql_create_delete_db

- 描述：Create / delete the postgresql database
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $? 1
```

- 涉及命令：useradd×1, test×1, chown×1, userdel×1

#### oe_test_nmcli_config_static_IP

- 描述：Nmcli configure static IP connection
- 函数：`config_params, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：nmcli×1

#### oe_test_nmcli_use_bonding

- 描述：Use command line bonding test
- 函数：`config_params, pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：sed×2

#### oe_test_nmcli_config_hostname

- 描述：Nmcli configuration hostname
- 函数：`run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

#### oe_test_nginx_manage_status

- 描述：Manage nginx and verify service status
- 函数：`pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：kill×1

#### oe_test_mysql_modify_delete_user

- 描述：Modify user and delete user
- 函数：`pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $? 1
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $? 1
  CHECK_RESULT $? 1
  CHECK_RESULT $?
  CHECK_RESULT $? 1
```

- 涉及命令：expect×3, grep×2, test×1

#### oe_test_nginx_check_configuration

- 描述：Check the nginx configuration for errors
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $?
```

#### oe_test_procmgmt_who

- 描述：Command test-who -b/-s
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：who×2

#### oe_test_procmgmt_ps_top_kill

- 描述：Command test-who -b/-s
- 函数：`run_test`
- 断言（4 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：top×1, kill×1

#### oe_test_set_XLL_Forwarding

- 描述：Install JDK package
- 函数：`run_test`
- 断言（3 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

#### oe_test_procmgmt_run_programs_regularly

- 描述：Run a batch of programs regularly-at
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT "$ret" 7
```

#### oe_test_vsftpd_start_stop

- 描述：Start and stop vsftpd
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：netstat×1

#### oe_test_server_verify_service_status

- 描述：Start stop and restart services
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
```

#### oe_test_vsftpd_transfer_deleted

- 描述：FTP transfer file deleted
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $? 1
```

- 涉及命令：setsebool×2, chmod×1

#### oe_test_server_operate_service

- 描述：Verify service status
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

#### oe_test_procmgmt_create_another_cron_file

- 描述：User creates another cron file
- 函数：`run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $ret 1
```

- 涉及命令：crontab×2

#### oe_test_postgresql_grant_delete_authorization

- 描述：Postgresql role authorization / deletion authorization
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 1
  CHECK_RESULT $?
  CHECK_RESULT $? 1
  CHECK_RESULT $?
```

- 涉及命令：grep×2, useradd×1, test×1, chown×1, userdel×1

#### oe_test_vsftpd_transfer_download

- 描述：FTP transfer file download
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：setsebool×2, chmod×1, ftp×1

#### oe_test_vsftpd_transfer_upload

- 描述：FTP Transfer File Upload
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：setsebool×2, chmod×1, mkdir×1

#### oe_test_vsftpd_conf

- 描述：Configuring VSFTPD
- 函数：`pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：useradd×2, sed×2, userdel×2, grep×1

#### oe_test_ip_cmd_addr

- 描述：Command test-ip addr
- 函数：`config_params, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $? 0 1
```

#### oe_test_ip_cmd_route

- 描述：Command test-ip route
- 函数：`config_params, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $? 0 1
```

#### oe_test_ip_cmd_rule

- 描述：Command test-ip rule
- 函数：`config_params, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $? 0 1
```

#### oe_test_ip_config_mtu

- 描述：Set the mtu of the interface device
- 函数：`config_params, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $? 0 1
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

#### oe_test_ip_config_multiple_address

- 描述：ip configure multiple addresses
- 函数：`config_params, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT "$(ip addr show dev "${test_eth1}" | grep -cE "192.168.2.223|192.168.4.223")" "2"
```

#### oe_test_ip_config_static_address

- 描述：IP configuration static address
- 函数：`config_params, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
```

#### oe_test_ip_config_static_route

- 描述：ip configure static routing
- 函数：`config_params, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT "$(ip route | grep -cE "192.168.3.1|192.168.3.0")" "2"
```

#### oe_test_basic_date_common

- 描述：Date command line test
- 函数：`pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $? "$date01" "$date02"
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：date×4, hwclock×2, grep×1
