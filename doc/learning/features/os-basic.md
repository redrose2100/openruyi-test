# os-basic

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 系统域（system-test） |
| 套件路径 | `$OET_PATH/testcases/system-test/system-integration/os-basic` |
| 注册用例数 | 357 |
| 环境约束 | machine num = 2；machine type = kvm；add network interface = 2；add disk = 2,2,2,2 |

> ⚠️ 本套件声明环境约束，执行前由 `check_environment.py` 预检；不满足的用例自动 skipped(255)。

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_enable_hugepage | Test if hugepage enabled | pre_test/run_test/post_test | 1 |  |  |  |
| oe_test_cht_client_mode | test cheat.sh client mode | pre_test/run_test/post_test | 5 |  |  |  |
| oe_test_cht_ordinary_mode | test cheat.sh Ordinary mode | pre_test/run_test/post_test | 5 |  |  |  |
| oe_test_who | Command test-who -b/-s | config_params/run_test/post_test | 4 |  |  |  |
| oe_test_dircolors | Command test-dircolors | pre_test/run_test/post_test | 4 |  |  |  |
| oe_test_factor | Use factor case | pre_test/run_test/post_test | 3 |  |  |  |
| oe_test_csplit | Use csplit case | pre_test/run_test/post_test | 4 |  |  |  |
| oe_test_expand | Use expand case | pre_test/run_test/post_test | 4 |  |  |  |
| oe_test_ctags | Use ctags case | pre_test/run_test/post_test | 6 | ✔ |  |  |
| oe_test_envsubst | Use envsubst case | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_expr | Command test-expr | pre_test/run_test/post_test | 7 |  |  |  |
| oe_test_fold | Use fold case | pre_test/run_test/post_test | 6 |  |  |  |
| oe_test_comm | Command test-comm | pre_test/run_test/post_test | 8 |  |  |  |
| oe_test_dc | Command test-dc | pre_test/run_test/post_test | 5 |  |  |  |
| oe_test_look | Use testfile to compile c programs | pre_test/run_test/post_test | 3 |  |  |  |
| oe_test_whereis | whereis command test | pre_test/run_test/post_test | 6 |  |  |  |
| oe_test_base32 | Command test-base32 | pre_test/run_test/post_test | 5 |  |  |  |
| oe_test_catman | Command test-catman | pre_test/run_test/post_test | 6 |  |  |  |
| oe_test_cal | Command test-cal | pre_test/run_test/post_test | 11 |  |  |  |
| oe_test_autoscan | Command test-autoscan | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_base64 | Command test-base64 | pre_test/run_test/post_test | 5 |  |  |  |
| oe_test_sha256sum | Command test-md5sum | run_test/post_test | 4 |  |  |  |
| oe_test_dmraid | Test xmllint format xml | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_c++ | Use c++ to compile c programs | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_md5sum | Command test-md5sum | pre_test/run_test/post_test | 3 |  |  |  |
| oe_test_tail | Command test-tail | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_systool | Command test-systool | pre_test/run_test/post_test | 5 | ✔ |  |  |
| oe_test_awk | Command test-awk | pre_test/run_test/post_test | 9 |  |  |  |
| oe_test_sdiff | Command sdiff | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_diff3 | diff3 function verification | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_fuse | fuse function verification | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_zstd | function verification | pre_test/run_test/post_test | 6 | ✔ |  |  |
| oe_test_auditctl | Command test-auditctl | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_accessdb | Command test-accessdb | pre_test/run_test/post_test | 4 |  |  |  |
| oe_test_cksum | Command test-cksum | pre_test/run_test/post_test | 7 |  |  |  |
| oe_test_paste | Command test-paste | pre_test/run_test/post_test | 8 |  |  |  |
| oe_test_chgrp | Command test-chgrp | pre_test/run_test/post_test | 10 |  |  |  |
| oe_test_cut | Command test-cut | pre_test/run_test/post_test | 7 |  |  |  |
| oe_test_bsdcat | Command test-bsdcat | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_b2sum | Command test-b2sum | pre_test/run_test/post_test | 6 |  |  |  |
| oe_test_ulimit | Command test-ulimit | pre_test/run_test/post_test | 3 |  |  |  |
| oe_test_versioninfo | Query system version info test | run_test | 6 |  |  |  |
| oe_test_uname | Command test-uname | run_test | 6 |  |  |  |
| oe_test_timedatectl | Use the timedatectl command to set the time | pre_test/run_test/post_test | 9 | ✔ |  |  |
| oe_test_system_monitor_reboot | View information about recent system reboots | run_test/post_test | 3 |  | ✔ |  |
| oe_test_system_monitor_process | The system supports monitoring and testing each process | run_test | 5 |  |  |  |
| oe_test_system_monitor_login | View the user's most recent log-ins | pre_test/run_test/post_test | 2 |  | ✔ |  |
| oe_test_system_log_view | Log View | run_test/post_test | 3 |  |  |  |
| oe_test_system_log_security | Support for the recording of information about system security | run_test/post_test | 1 |  |  |  |
| oe_test_system_log_recorded | The system log is recorded in a fixed log file | pre_test/run_test/post_test | 3 |  |  |  |
| oe_test_system_log_process | Supports logging of scheduled task processes | run_test/post_test | 1 |  |  |  |
| oe_test_system_log_dmesg | Query boot information-dmesg | run_test | 1 |  |  |  |
| oe_test_system_log_device | Supports logging of device information | run_test/post_test | 1 |  |  |  |
| oe_test_system_log_basic | Supports logging of Basic System Operation Information | run_test/post_test | 1 |  |  |  |
| oe_test_server_vsftpd_transfer | FTP Transfer file-disk full | config_params/pre_test/run_test/post_test | 6 | ✔ | ✔ |  |
| oe_test_server_vsftpd_restart | Start and stop the FTP service repeatedly | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_server_vsftpd_NKdelay | FTP File transfer-network delay packet loss | config_params/pre_test/run_test/post_test | 3 | ✔ | ✔ |  |
| oe_test_server_squid_proxy | Set Squid to a cache proxy without authentication | pre_test/run_test/post_test | 6 | ✔ |  |  |
| oe_test_server_squid_ip | Configuring Squid services to listen for a specific port or IP address | pre_test/run_test/post_test | 7 | ✔ |  |  |
| oe_test_server_squid_blacklist | Configuring the domain blacklist in Squid | pre_test/run_test/post_test | 7 | ✔ |  |  |
| oe_test_server_postgresql | Install PostgreSQL | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_server_openssh_verifykey | SSH authentication using a key pair in place of a password | pre_test/run_test/post_test | 4 | ✔ | ✔ |  |
| oe_test_server_openssh_secure | How to make OpenSSH more secure | pre_test/run_test/post_test | 9 | ✔ |  |  |
| oe_test_netscript_cfg | network cfg file test | run_test | 6 |  |  |  |
| oe_test_server_openssh_restart | Restart and stop the OpenSSH service repeatedly | pre_test/run_test/post_test | 5 | ✔ |  |  |
| oe_test_server_openssh_key | Generating SSH key pairs | pre_test/run_test/post_test | 3 | ✔ | ✔ |  |
| oe_test_server_mysql | mysql restarts repeatedly | pre_test/run_test/post_test | 5 | ✔ |  |  |
| oe_test_server_mariadb_stop | Repeatedly starting and stopping the MARIADB database | pre_test/run_test/post_test | 5 | ✔ |  |  |
| oe_test_server_mariadb_onlinebackup | Perform a physical online backup using the Maria backup tool | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_server_mariadb_loadfile | Load the dump file back to the server using mysqldump | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_server_mariadb_compatibilty | MARIADB software compatibility | pre_test/run_test/post_test | 4 | ✔ | ✔ |  |
| oe_test_server_mariadb_dumpMulDB | Dump multiple databases using mysqldump | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_server_mariadb_dump | Dump all databases with mysqldump | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_server_mariadb_copy | Use mysqldump to copy data between two databases | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_server_mariadb_backuptable | Use mysqldump to back up a set of tables from a database | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_server_mariadb_backupDB | Back up the entire database using mysqldump | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_server_mariadb_backup | Perform a file system backup | pre_test/run_test/post_test | 5 | ✔ |  |  |
| oe_test_server_httpd_tls | Enable specific versions of TLSv1.x | pre_test/run_test/post_test | 5 | ✔ |  |  |
| oe_test_server_httpd_restart | Restarting the httpd service | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_server_httpd_recover | Profile lost / recovered | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_server_httpd_port | Httpd port occupied | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_server_httpd_checkfirewall | Check that the firewall is configured to allow services to be used | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_server_git_install | Use for Git installation | pre_test/run_test/post_test | 14 | ✔ |  |  |
| oe_test_sos | Command test  sos | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_reboot | Reboot test | pre_test/run_test/post_test | 3 | ✔ | ✔ | 150m |
| oe_test_power_powertop_startup | Powertop service startup | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_power_powertop_powerup | Power up the POWERTOP | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_power_powertop_calibrate | Calibrating PowerTOP | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_power_powertop2tuned_optimize | Optimizing power consumption using the powertop2tuned utility | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_power_output_HTML | Generating HTML output | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_power_measurement_internal | Set the measurement interval | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_performance_monitor_pcp | Install and enable PCP | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_password_change | User password modification_current user | pre_test/run_test/post_test | 2 |  |  |  |
| oe_test_password_blank | Password setting-blank password | pre_test/run_test/post_test | 1 |  |  |  |
| oe_test_nmcli_vlan | Test nmcli configuration vlan | config_params/run_test/post_test | 18 |  |  |  |
| oe_test_nmcli_systemd_resolved | Test nmcli configuration systemd-resolved | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_nmcli_route | Test nmcli configure static routing | config_params/run_test/post_test | 6 |  |  |  |
| oe_test_nmcli_macsec | Test nmcli configure MACsec | pre_test/config_params/run_test/post_test | 2 | ✔ |  |  |
| oe_test_nmcli_general | Test nmcli general | run_test | 2 |  |  |  |
| oe_test_nmcli_device | Test nmcli device | config_params/run_test/post_test | 7 |  |  |  |
| oe_test_nmcli_config_gw | Test nmcli configure default gateway | config_params/run_test/post_test | 8 |  |  |  |
| oe_test_nmcli_config_connect | Test nmcli configure Ethernet connection | config_params/run_test/post_test | 14 |  |  |  |
| oe_test_nmcli_con_reload | Test nmcli reload | config_params/run_test/post_test | 6 |  |  |  |
| oe_test_nmcli_cancel_auto | Test nmcli cancel auto configuration /etc/resolv.conf | run_test/post_test | 4 |  |  |  |
| oe_test_nmcli_bridge | Test nmcli configuration bridge | config_params/run_test/post_test | 26 |  |  |  |
| oe_test_nmcli_add_connect | Test nmcli connection | config_params/run_test/post_test | 9 |  |  |  |
| oe_test_nmcli_Mgntconnect | Use nmcli to manage network connections after the installation process | config_params/pre_test/run_test/post_test | 7 |  |  |  |
| oe_test_nmcli_8023link | Test nmcli modify 802.3 link configuration | config_params/run_test/post_test | 9 |  |  |  |
| oe_test_USBinfo | Query USB configure test | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_ProcMgmt_vmstat | Process monitoring-vmstat | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_ProcMgmt_top | View process status-top | run_test | 2 |  |  |  |
| oe_test_ProcMgmt_start_kill | Start process / kill process | pre_test/run_test/post_test | 11 | ✔ |  |  |
| oe_test_ProcMgmt_sar | Process monitoring -sar -b | pre_test/run_test/post_test | 9 | ✔ |  |  |
| oe_test_ProcMgmt_ps | View process status-ps | pre_test/run_test/post_test | 5 |  |  |  |
| oe_test_ProcMgmt_pgrep | View process status-pgrep | run_test | 3 |  |  |  |
| oe_test_ProcMgmt_iostat | Process monitoring -iostat | pre_test/run_test/post_test | 6 | ✔ |  |  |
| oe_test_ProcMgmt_crontab_cronfile | User creates another cron file | pre_test/run_test/post_test | 4 |  |  |  |
| oe_test_ProcMgmt_crontab_cmd | Crontab related commands test | pre_test/run_test/post_test | 4 |  |  |  |
| oe_test_ProcMgmt_at | Run a batch of programs regularly-at | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_disk_tuned_set | Setting up the disk scheduler using Tuned(For physical machines only) | config_params/pre_test/run_test/post_test | 5 | ✔ |  |  |
| oe_test_disk_schedule_specific | Temporarily sets the scheduler for a specific disk | config_params/run_test/post_test | 1 |  |  |  |
| oe_test_disk_schedule_udev | Set up the disk scheduler using udev rules | config_params/run_test/post_test | 3 |  |  |  |
| oe_test_disk_tuned_new | Create a new tuned profile | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_disk_tuned_install | Install and enable tuned | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_date | Date command line test | pre_test/run_test/post_test | 4 |  |  |  |
| oe_test_cmd_su_user | Service Management Common Command Test -su | pre_test/run_test/post_test | 4 |  |  |  |
| oe_test_disk_tuned_modify | Modify the existing Tunde configuration file | config_params/pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_disk_tuned_disable | Disable tuned | pre_test/run_test/post_test | 6 | ✔ |  |  |
| oe_test_ethtool | Verify support for hardware timestamps | config_params/pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_basic_create_group | Create User Group test | config_params/run_test/post_test | 7 |  |  |  |
| oe_test_basic_modify_group | Modity User Group test | pre_test/run_test/post_test | 9 |  |  |  |
| oe_test_basic_modify_user | Modify User test | pre_test/run_test/post_test | 4 |  |  |  |
| oe_test_chrony_chronyc_cmd | Use chronyc to control chronyd | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_chrony_chronyc_hardwaretime | Verify hardware timestamp | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_chrony_chronyc_ntpstat | Implement some settings previously supported by ntp in NTP | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_chrony_chronyd | Use Chrony test | pre_test/run_test/post_test | 9 | ✔ |  |  |
| oe_test_chrony_Manuall | Manually adjust the system clock test-makestep | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_cmd_id | View user and group id | pre_test/run_test/post_test | 4 |  |  |  |
| oe_test_cmd_sudo | Service management common command test -sudo | pre_test/run_test/post_test | 3 |  |  |  |
| oe_test_hwclock | Hwclock command line test | pre_test/run_test/post_test | 3 |  |  |  |
| oe_test_IOaccess_500Mfile | 500M file continuous cp,dd,zip,unzip | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_group_access | Group directory access permission settings | pre_test/run_test/post_test | 3 |  |  |  |
| oe_test_kernel_sysctl | SYSCTL modifies kernel parameters | run_test | 5 |  |  |  |
| oe_test_hostnamectl | hostnamectl configuration hostname test | pre_test/run_test/post_test | 6 |  |  |  |
| oe_test_kernel_kdump | KDUMP configuration | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_IOaccess_100Mfile | 100M file continuous cp,dd,zip,unzip | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_IOaccess_1Gfile | 1G file continuous cp,dd,zip,unzip | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_kernel_module_operation | Module operation | run_test/post_test | 4 |  |  |  |
| oe_test_kernel_cgroup | cgroup | pre_test/run_test/post_test | 3 |  |  |  |
| oe_test_home_directory | Modify user home directory | pre_test/run_test/post_test | 10 |  |  |  |
| oe_test_groupdel | Delete User Group test | pre_test/run_test/post_test | 4 |  |  |  |
| oe_test_net_IPVLAN | Ipvlan command test | config_params/run_test/post_test | 4 |  |  |  |
| oe_test_net_setmode | Set hybrid network mode | config_params/pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_net_scriprts | network-scripts test | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_net_cmd_ifconfig | Network commonly used command test-ifconfig | config_params/pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_net_VRF | Create vrf test | config_params/run_test/post_test | 9 |  |  |  |
| oe_test_localectl | Configure keyboard layout test | pre_test/run_test/post_test | 3 |  |  |  |
| oe_test_man | Command test-man -w | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_net_cmd_scp | Common network command test-scp | pre_test/run_test/post_test | 4 |  | ✔ |  |
| oe_test_net_cmd_ping | Common network command test-ping | run_test/post_test | 2 |  |  |  |
| oe_test_net_conninfo_lsof | View network connection information-lsof | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_net_config | Add/remove virtual network card | config_params/pre_test/run_test/post_test | 3 | ✔ | ✔ |  |
| oe_test_net_cmd_telnet | Common network command test-telnet | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_net_ncat | Ncat communication test | pre_test/run_test/post_test | 3 | ✔ | ✔ |  |
| oe_test_nmcli_set_bond | Command test-who -b/-s | pre_test/run_test/post_test | 22 | ✔ |  |  |
| oe_test_basic_UserMgmt_permission | Command test-who -b/-s | pre_test/run_test/post_test | 13 |  |  |  |
| oe_test_system_monitor_share_total | system monitor share total | config_params/run_test/post_test | 5 |  |  |  |
| oe_test_disk_graphics_card | Command test-who -b/-s | pre_test/run_test/post_test | 6 | ✔ |  |  |
| oe_test_nmcli_set_team | Command test-who -b/-s | pre_test/run_test/post_test | 20 | ✔ |  |  |
| oe_test_basic_set_account_expiration_time | account_expiration time | pre_test/run_test/post_test | 7 |  |  |  |
| oe_test_basic_set_permissions | permissions test | pre_test/run_test/post_test | 4 |  |  |  |
| oe_test_patch | Command test patch -p0/-Rp0 | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_exiv2 | Command test exiv2 | pre_test/run_test/post_test | 6 | ✔ |  |  |
| oe_test_json-c | Command test json-c | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_whoami | whoami command | pre_test/run_test/post_test | 2 |  |  |  |
| oe_test_lz4 | Command test lz4 | pre_test/run_test/post_test | 7 | ✔ |  |  |
| oe_test_zlib | Command test zlib | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_brotli | Command test brotli | pre_test/run_test/post_test | 6 |  |  |  |
| oe_test_net_mtr | Command test mtr | pre_test/run_test/post_test | 11 | ✔ |  |  |
| oe_test_gsettings | Command test gsettings | pre_test/run_test/post_test | 5 |  |  |  |
| oe_test_pcre_use | Test pcre use | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_ACL_dir | Command ACL dir | pre_test/run_test/post_test | 3 |  |  |  |
| oe_test_du | Du command test | pre_test/run_test/post_test | 3 |  |  |  |
| oe_test_ar | Ar command test | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_vim | vim command test | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_vim_001 | vim command test | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_basename | basename command test | run_test | 12 |  |  |  |
| oe_test_groff | Groff document format | run_test | 3 |  |  |  |
| oe_test_whatis | whatis command test | run_test | 6 |  |  |  |
| oe_test_auditc_01 | File system common command test-auditctl | pre_test/run_test/post_test | 5 | ✔ |  |  |
| oe_test_gmp | the function of gmp | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_libffi | the function of libffi | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_libunistring | the function of libunistring | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_shred | File system common command shred | run_test/post_test | 3 |  |  |  |
| oe_test_expect | Expect basic function verification | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_xmlsec | Xmlsec1 Encrypt xml | pre_test/run_test/post_test | 5 | ✔ |  |  |
| oe_test_tcl | Use tcl case | run_test/post_test | 3 |  |  |  |
| oe_test_disk_io_sched | package IO SCHED test | pre_test/run_test/post_test | 4 |  |  |  |
| oe_test_lsusb | Command test lsusb | pre_test/run_test/post_test | 6 | ✔ |  |  |
| oe_test_last | test last | run_test | 6 |  |  |  |
| oe_test_lastb | Command test-lastb | run_test | 4 |  |  |  |
| oe_test_aureport | Command aureport | pre_test/run_test/post_test | 9 | ✔ |  |  |
| oe_test_chsh | Command test-chsh | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_lua | Use lua case | run_test/post_test | 4 |  |  |  |
| oe_test_server_fontconfig | 外围包-fontconfig-fc-list、fontconfig-fc-match命令 | run_test | 5 |  |  |  |
| oe_test_server_libtasn1 | Test libtasn1使用 | pre_test/run_test/post_test | 5 | ✔ |  |  |
| oe_test_count_gperftools_function | gperftools-功能验证 | pre_test/run_test/post_test | 5 | ✔ |  |  |
| oe_test_split | File system common command split | run_test/post_test | 6 |  |  |  |
| oe_test_popd_001 | File system common command popd | run_test/post_test | 5 |  |  |  |
| oe_test_glibc | Use glibc case | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_cairo | Use cairo case | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_c_stat | Use c_stat case | pre_test/run_test/post_test | 7 | ✔ |  |  |
| oe_test_chroot | Use chroot case | pre_test/run_test/post_test | 5 |  |  |  |
| oe_test_history | Command test-history | run_test | 8 |  |  |  |
| oe_test_virt-what | 网络-虚拟化环境检查 | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_gcc_01 | File system common command test-gcc | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_locate_001 | File system common command locate | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_bzcmp | 压缩对比工具-bzcmp | pre_test/run_test/post_test | 2 |  |  |  |
| oe_test_unlink | 删除指定文件-unlink | pre_test/run_test/post_test | 1 |  |  |  |
| oe_test_xzcmp | 压缩对比工具-xzcmp | pre_test/run_test/post_test | 1 |  |  |  |
| oe_test_zgrep | 压缩文件搜索工具-zgrep | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_server_subversion | functional testing subversion | pre_test/run_test/post_test | 5 | ✔ |  |  |
| oe_test_auditctl_02 | Test auditctl-查看audit规则并验证规则 | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_bunzip2 | Use php case | pre_test/run_test/post_test | 3 |  |  |  |
| oe_test_zipdetails | 显示zip文件内部结构-zipdetails | pre_test/run_test/post_test | 5 |  |  |  |
| oe_test_zcat | 查看压缩文件的内容-zcat | pre_test/run_test/post_test | 2 |  |  |  |
| oe_test_libsecret | secret-tool of libsecret basic function | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_namei | 列出路径中的成分-namei | run_test | 7 |  |  |  |
| oe_test_rev | Test rev | pre_test/run_test/post_test | 1 |  |  |  |
| oe_test_uid_old_uid | old uid function test | pre_test/run_test/post_test | 4 |  |  |  |
| oe_test_python3-kmod | Use python3-kmod case | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_lsscsi_1 | command lsscsi | pre_test/run_test/post_test | 5 | ✔ |  |  |
| oe_test_seq | Seq formatting test | run_test | 3 |  |  |  |
| oe_test_lsscsi_2 | command lsscsi | pre_test/run_test/post_test | 5 | ✔ |  |  |
| oe_test_xargs | Xargs formatting test | pre_test/run_test/post_test | 2 |  |  |  |
| oe_test_lsscsi_3 | command lsscsi | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_uniq | Uniq formatting test | pre_test/run_test/post_test | 3 |  |  |  |
| oe_test_lsattr | Using the lsattr command | run_test/post_test | 6 |  |  |  |
| oe_test_indent | Using the indent command | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_xzmore | 查看xz压缩文本文件-xzmore | pre_test/run_test/post_test | 1 |  |  |  |
| oe_test_bzless | 查看bzip2压缩过的文本文件-bzless | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_true | 验证 true 命令的返回值、重定向、管道及 shell 控制流行为 | pre_test/run_test/post_test | 9 |  |  |  |
| oe_test_xzless | 查看xz压缩文本文件-xzless | pre_test/run_test/post_test | 1 |  |  |  |
| oe_test_zgrep_002 | 压缩文件搜索工具-zgrep | pre_test/run_test/post_test | 2 |  |  |  |
| oe_test_fdupes | 查找相同文件-fdupes | pre_test/run_test/post_test | 5 | ✔ |  |  |
| oe_test_enchant2 | enchant test | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_hexdump | Using the Hexdump command | pre_test/run_test/post_test | 5 |  |  |  |
| oe_test_logsave | Using the logsave command | run_test/post_test | 3 |  |  |  |
| oe_test_brotli_003 | Command test brotli | pre_test/run_test/post_test | 3 |  |  |  |
| oe_test_libidn | libidn编译支持 | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_ld | ld command test | pre_test/run_test/post_test | 7 | ✔ |  |  |
| oe_test_dirname | 去除文件名中的非目录部分-dirname | pre_test/run_test/post_test | 3 |  |  |  |
| oe_test_tty | TTY formatting test | run_test | 1 |  |  |  |
| oe_test_get_module | 获取模块信息-get_module | run_test | 10 |  |  |  |
| oe_test_gzexe | 压缩执行文件-gzexe | pre_test/run_test/post_test | 2 |  |  |  |
| oe_test_strings | strings查找可打印的字符串 | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_zramctl | Test zramctl function | pre_test/run_test/post_test | 3 |  |  |  |
| oe_test_znew | Test znew function | pre_test/run_test/post_test | 3 |  |  |  |
| oe_test_zegrep | Test zegrep function | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_arp | command arp | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_strace | command strace | pre_test/run_test/post_test | 7 | ✔ |  |  |
| oe_test_tac | 反向输出文件内容-tac | pre_test/run_test/post_test | 1 |  |  |  |
| oe_test_lshw | command lshw | run_test | 9 |  |  |  |
| oe_test_csplit_01 | csplit case | pre_test/run_test/post_test | 3 |  |  |  |
| oe_test_zipnote | Test zipnote function | pre_test/run_test/post_test | 2 |  |  |  |
| oe_test_join | 连接两个文件-join | pre_test/run_test/post_test | 3 |  |  |  |
| oe_test_genisoimage | 创建映像文件-genisoimage | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_zfgrep | Test zfgrep function | pre_test/run_test/post_test | 2 |  |  |  |
| oe_test_bzgrep | 压缩文件搜索工具-bzgrep | pre_test/run_test/post_test | 7 |  |  |  |
| oe_test_ipcs | ipcs formatting test | run_test | 15 |  |  |  |
| oe_test_nl | nl formatting test | pre_test/run_test/post_test | 5 |  |  |  |
| oe_test_nice | nice formatting test | run_test | 4 |  |  |  |
| oe_test_libuv | Basic functional verification of libuv | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_systemd_analyze | Supports logging of device information | pre_test/run_test/post_test | 4 |  |  |  |
| oe_test_readlink | Command test-readlink | pre_test/run_test/post_test | 4 |  |  |  |
| oe_test_ul_001 | Encrypt and decrypt zip | pre_test/run_test/post_test | 1 |  |  |  |
| oe_test_lscpu | command lscpu | run_test | 9 |  |  |  |
| oe_test_lsmem_1 | command lscmem | pre_test/run_test | 7 |  |  |  |
| oe_test_yumdownloader | Test yumdownloader function | pre_test/run_test/post_test | 2 |  |  |  |
| oe_test_lsmem_2 | command lscmem | pre_test/run_test | 7 |  |  |  |
| oe_test_fallocate | Command test-cal | pre_test/run_test/post_test | 5 |  |  |  |
| oe_test_xzgrep | Test zfgrep function | pre_test/run_test/post_test | 2 |  |  |  |
| oe_test_sfdisk | Disk partition management tool | run_test | 2 |  |  |  |
| oe_test_lsmem_3 | command lsmem | pre_test/run_test | 7 |  |  |  |
| oe_test_lscpu_2 | command lscpu | run_test | 7 |  |  |  |
| oe_test_mkfifo | mkfifo命令 – 创建FIFO文件 | run_test/post_test | 2 |  |  |  |
| oe_test_lspci | command lspci | pre_test/run_test/post_test | 6 | ✔ |  |  |
| oe_test_bzcat | bzcat命令 – 读取bzip2压缩文件的内容 | pre_test/run_test/post_test | 1 |  |  |  |
| oe_test_zipinfo | zipinfo命令 – 查看压缩文件信息 | pre_test/run_test/post_test | 13 | ✔ |  |  |
| oe_test_gunzip | gunzip命令 – 解压提取文件内容 | pre_test/run_test/post_test | 3 |  |  |  |
| oe_test_split_01 | split case | pre_test/run_test/post_test | 3 |  |  |  |
| oe_test_getent | getent命令 – 查看系统数据库中的记录信息 | run_test | 9 |  |  |  |
| oe_test_fincore | Fincore | pre_test/run_test/post_test | 7 |  |  |  |
| oe_test_udisksctl | Command test-cal | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_c++_stl | test c++ stl | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_fallocate_01 | Command test-fallocate | pre_test/run_test/post_test | 5 |  |  |  |
| oe_test_lslocks | command lslocks | run_test | 5 |  |  |  |
| oe_test_brotli_002 | Command test brotli -v -n | pre_test/run_test/post_test | 6 |  |  |  |
| oe_test_lslocks_2 | command lslocks | run_test | 5 |  |  |  |
| oe_test_lslogins_1 | command lslogins | pre_test/run_test/post_test | 5 |  |  |  |
| oe_test_more | Fincore | pre_test/run_test/post_test | 3 |  |  |  |
| oe_test_lslogins_2 | command lslogins02 | pre_test/run_test/post_test | 5 |  |  |  |
| oe_test_column | column命令-输入格式化为多个列 | run_test/post_test | 3 |  |  |  |
| oe_test_lslogins_3 | command lslogins03 | pre_test/run_test/post_test | 6 |  |  |  |
| oe_test_xrandr | Adjusting screen resolution, orientation, and multi-screen settings, among other functions. | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_as | Test gnu as | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_lslogins_4 | command lslogins04 | pre_test/run_test/post_test | 9 |  |  |  |
| oe_test_zstd01 | function verification | pre_test/run_test/post_test | 7 | ✔ |  |  |
| oe_test_lslogins_5 | command lslogins05 | pre_test/run_test/post_test | 9 |  |  |  |
| oe_test_zipgrep | zipgrep formatting test | pre_test/run_test/post_test | 8 | ✔ |  |  |
| oe_test_lslogins_6 | command lslogins06 | pre_test/run_test/post_test | 9 |  |  |  |
| oe_test_zforce | zforce formatting test | pre_test/run_test/post_test | 9 | ✔ |  |  |
| oe_test_lssubsys | command lssubsys | pre_test/run_test/post_test | 8 | ✔ |  |  |
| oe_test_zdiff | zdiff formatting test | pre_test/run_test/post_test | 6 |  |  |  |
| oe_test_ab_1 | command ab | pre_test/run_test/post_test | 8 | ✔ |  |  |
| oe_test_ab_2 | command ab02 | pre_test/run_test/post_test | 6 | ✔ |  |  |
| oe_test_ab_3 | command ab03 | pre_test/run_test/post_test | 5 | ✔ |  |  |
| oe_test_ab_4 | command ab04 | pre_test/run_test/post_test | 6 | ✔ |  |  |
| oe_test_zcmp | zcmp formatting test | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_xxd | xxd formatting test | pre_test/run_test/post_test | 5 | ✔ |  |  |
| oe_test_xmlwf | xmlwf formatting test | pre_test/run_test/post_test | 8 |  |  |  |
| oe_test_ab_5 | command ab05 | pre_test/run_test/post_test | 7 | ✔ |  |  |
| oe_test_xmllint | xmllint formatting test | pre_test/run_test/post_test | 5 |  |  |  |
| oe_test_usb-devices | usb-devices formatting test | pre_test/run_test/post_test | 6 | ✔ |  |  |
| oe_test_xml2-config | xml2-config formatting test | pre_test/run_test/post_test | 7 | ✔ |  |  |
| oe_test_certtool_1 | Command certtool01 | pre_test/run_test/post_test | 5 | ✔ |  |  |
| oe_test_certtool_2 | Command certtool02 | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_certtool_3 | Command certtool03 | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_update-crypto-policies | update-crypto-policies formatting test | pre_test/run_test/post_test | 7 | ✔ |  |  |
| oe_test_certtool_4 | Command certtool04 | pre_test/run_test/post_test | 5 | ✔ |  |  |
| oe_test_certutil | Command certutil test | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_unzstd | unzstd formatting test | pre_test/run_test/post_test | 9 |  |  |  |
| oe_test_unpigz | unpigz formatting test | pre_test/run_test/post_test | 3 |  |  |  |
| oe_test_type | type formatting test | run_test | 6 |  |  |  |
| oe_test_corelist_1 | Command corelist test01 | pre_test/run_test/post_test | 5 |  |  |  |
| oe_test_corelist_2 | Command corelist test02 | pre_test/run_test/post_test | 5 |  |  |  |
| oe_test_corelist_3 | Command corelist test03 | pre_test/run_test/post_test | 5 |  |  |  |
| oe_test_corelist_4 | Command corelist test | pre_test/run_test/post_test | 4 |  |  |  |
| oe_test_fc-list_1 | command fc-list01 | pre_test/run_test/post_test | 5 |  |  |  |
| oe_test_taskset | taskset formatting test | run_test/post_test | 5 |  |  |  |
| oe_test_false_001 | type formatting test | pre_test/run_test/post_test | 2 |  |  |  |
| oe_test_fc-list_2 | command fc-list | pre_test/run_test/post_test | 5 |  |  |  |
| oe_test_fc-list_3 | command fc-list | pre_test/run_test/post_test | 7 |  |  |  |
| oe_test_fc-list_4 | command fc-list | pre_test/run_test/post_test | 6 |  |  |  |
| oe_test_certutil_2 | Command certutil test | pre_test/run_test/post_test | 6 | ✔ |  |  |
| oe_test_declare | bash declare typed variables and integer arithmetic | run_test | 12 |  |  |  |
| oe_test_printf | bash printf formatted output for script reporting | pre_test/run_test/post_test | 5 |  |  |  |
| oe_test_libstdc++ | Basic functional verification of libstdc++ | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_disown | test disown | run_test/post_test | 4 |  |  |  |
| oe_test_echarts | package Echarts test | pre_test/run_test/post_test | 5 | ✔ |  |  |
| oe_test_getopts | bash getopts CLI argument parsing | run_test | 5 |  |  |  |
| oe_test_getconf | getconf formatting test | run_test | 2 |  |  |  |
| oe_test_setfattr | bash setfattr formatted test | pre_test/run_test/post_test | 4 |  |  |  |
| oe_test_getfattr | bash getfattr formatted test | pre_test/run_test/post_test | 4 |  |  |  |
| oe_test_zmore | Test case for zmore command | pre_test/run_test/post_test | 5 | ✔ |  |  |
| oe_test_unexpand | Test case for unexpand command | pre_test/run_test/post_test | 8 | ✔ |  |  |
| oe_test_uniq01 | Test case for uniq command | pre_test/run_test/post_test | 13 |  |  |  |

### 断言与命令明细

#### oe_test_enable_hugepage

- 描述：Test if hugepage enabled
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT "$real_pages" "$exp_pages"  0 "real pages is $real_pages, should be $exp_pages."
```

#### oe_test_cht_client_mode

- 描述：test cheat.sh client mode
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "Download failed"
  CHECK_RESULT $? 0 0 "Query pwd failed"
  CHECK_RESULT $? 0 0 "Query string failed"
  CHECK_RESULT $? 0 0 "Query reverse failed"
  CHECK_RESULT $? 0 0 "Query time failed"
```

- 涉及命令：test×1

#### oe_test_cht_ordinary_mode

- 描述：test cheat.sh Ordinary mode
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "Query pwd failed"
  CHECK_RESULT $? 0 0 "Query ~pwd failed"
  CHECK_RESULT $? 0 0 "Query API failed"
  CHECK_RESULT $? 0 1 "Query \?Q failed"
  CHECK_RESULT $? 0 0 "Query sql failed"
```

#### oe_test_who

- 描述：Command test-who -b/-s
- 函数：`config_params, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：who×2

#### oe_test_dircolors

- 描述：Command test-dircolors
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "check dircolors's version fail"
  CHECK_RESULT $? 0 0 "check command fail"
  CHECK_RESULT $? 0 0 "check command fail"
  CHECK_RESULT $? 0 0 "check command fail"
```

- 涉及命令：dircolors×2

#### oe_test_factor

- 描述：Use factor case
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Factorization failure"
  CHECK_RESULT $? 0 0  "check command fail"
  CHECK_RESULT $? 0 0  "check command fail"
```

#### oe_test_csplit

- 描述：Use csplit case
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "please check csplit language"
  CHECK_RESULT $? 0 0 "Error, please check 'csplit test'"
  CHECK_RESULT $? 0 0 "Error, please check 'csplit test'"
  CHECK_RESULT $? 0 0 "Error, please check 'csplit test'"
```

#### oe_test_expand

- 描述：Use expand case
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "Checking whether the tab key exists fails"
  CHECK_RESULT $? 1 1 "Check whether the tab key still exists"
  CHECK_RESULT $? 0 0  "check command fail"
  CHECK_RESULT $? 0 0  "check command fail"
```

#### oe_test_ctags

- 描述：Use ctags case
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "recognition language failure"
  CHECK_RESULT $? 0 0  "failed to view extended language"
  CHECK_RESULT $? 0 0  "failed to view the syntax element"
  CHECK_RESULT $? 0 0  "failed to view c++ syntax elements"
  CHECK_RESULT $? 0 0  "check command fail"
  CHECK_RESULT $? 0 0  "check version fail"
```

#### oe_test_envsubst

- 描述：Use envsubst case
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Variable resolution failure"
  CHECK_RESULT $? 0 0  "check command fail"
  CHECK_RESULT $? 0 0  "check command fail"
```

- 涉及命令：envsubst×2

#### oe_test_expr

- 描述：Command test-expr
- 函数：`pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $? 0 0 "check Tail's result fail"
  CHECK_RESULT $? 0 0 "check expr's help manual fail"
  CHECK_RESULT $? 0 0 "check expr's version fail"
  CHECK_RESULT $? 0 0 "check command fail"
  CHECK_RESULT $? 0 0 "check command fail"
  CHECK_RESULT $? 0 0 "check command fail"
  CHECK_RESULT $? 0 0 "check command fail"
```

#### oe_test_fold

- 描述：Use fold case
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "please check fold language"
  CHECK_RESULT $? 0 0 "Error, please check 'fold test'"
  CHECK_RESULT $? 0 0 "Error, please check 'fold test'"
  CHECK_RESULT $? 0 0 "Error, please check 'fold test'"
  CHECK_RESULT $? 0 0 "Error, please check 'fold test'"
  CHECK_RESULT $? 0 0 "No such file or directory"
```

- 涉及命令：fold×4

#### oe_test_comm

- 描述：Command test-comm
- 函数：`pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $? 0 0 "check create test1 fail"
  CHECK_RESULT $? 0 0 "check change test1 fail"
  CHECK_RESULT $? 0 0 "check create test2 fail"
  CHECK_RESULT $? 0 0  "failed to print the same line"
  CHECK_RESULT $? 0 0  "failed to output lines shared by two files"
  CHECK_RESULT $? 0 0  "description Failed to output the summary information"
  CHECK_RESULT $? 0 0  "check command fail"
  CHECK_RESULT $? 0 0  "check command fail"
```

- 涉及命令：comm×2

#### oe_test_dc

- 描述：Command test-dc
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "dc calculation failure"
  CHECK_RESULT $? 0 0 "file creation failure"
  CHECK_RESULT $? 0 0 "failed to calculate the value from the file"
  CHECK_RESULT $? 0 0 "description failed to view the dc help information"
  CHECK_RESULT $? 0 0 "description failed to view the dc version"
```

#### oe_test_look

- 描述：Use testfile to compile c programs
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "check look command fail"
  CHECK_RESULT $? 0 0 "check look display failed"
  CHECK_RESULT $? 0 0 "check version display failed"
```

- 涉及命令：look×1

#### oe_test_whereis

- 描述：whereis command test
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "The file content is abnormal"
  CHECK_RESULT $? 0 0 "check version display failed"
  CHECK_RESULT $? 0 0 "check pwd display failed"
  CHECK_RESULT $? 0 0 "check -l failed"
  CHECK_RESULT $? 0 0 "Failed to terminate the parameter list"
  CHECK_RESULT $? 0 0 " log search failed"
```

- 涉及命令：whereis×5

#### oe_test_base32

- 描述：Command test-base32
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "encryption failure"
  CHECK_RESULT $? 0 0  "decryption failure"
  CHECK_RESULT $? 0 0  "failed to check parameter -i"
  CHECK_RESULT $? 0 0  "check version fail"
  CHECK_RESULT $? 0 0  "check help fail"
```

#### oe_test_catman

- 描述：Command test-catman
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "failed to process Section 1"
  CHECK_RESULT $? 0 0  "description Failed to print debugging information"
  CHECK_RESULT $? 0 0  "failed to set the file using this user"
  CHECK_RESULT $? 0 0  "failed to set path"
  CHECK_RESULT $? 0 0  "check version fail"
  CHECK_RESULT $? 0 0  "check help message fail"
```

- 涉及命令：catman×4

#### oe_test_cal

- 描述：Command test-cal
- 函数：`pre_test, run_test, post_test`
- 断言（11 条）：

```
  CHECK_RESULT $? 0 0 "displays one month failure"
  CHECK_RESULT $? 0 0 "displays three month failure"
  CHECK_RESULT $? 0 0  "displays the number of months that failed starting with the month of the date"
  CHECK_RESULT $? 0 0  "failed to display date ranges for multiple months"
  CHECK_RESULT $? 0 0  "sunday fails as the first day of the week"
  CHECK_RESULT $? 0 0  "monday fails as the first day of the week"
  CHECK_RESULT $? 0 0  "show annual failure"
  CHECK_RESULT $? 0 0  "check commmand usage fail"
  CHECK_RESULT $? 0 0  "check version fail"
  CHECK_RESULT $? 0 0  "cal 2024 failed"
  CHECK_RESULT $? 0 0  "cal 7 2024 failed"
```

- 涉及命令：cal×9

#### oe_test_autoscan

- 描述：Command test-autoscan
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "processing report failure"
  CHECK_RESULT $? 0 0 "Do not fail to delete temporary files"
  CHECK_RESULT $? 0 0  "check command usage fail"
  CHECK_RESULT $? 0 0  "check version fail"
```

- 涉及命令：autoscan×4

#### oe_test_base64

- 描述：Command test-base64
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "encryption failure"
  CHECK_RESULT $? 0 0  "decryption failure"
  CHECK_RESULT $? 0 0  "failed to check parameter -i"
  CHECK_RESULT $? 0 0  "check version fail"
  CHECK_RESULT $? 0 0  "check help fail"
```

#### oe_test_sha256sum

- 描述：Command test-md5sum
- 函数：`run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "sha256sum --help exec failed"
  CHECK_RESULT $? 0 0 "check create file fail"
  CHECK_RESULT $? 0 0 "The testfile.sha256sum is not exit "
  CHECK_RESULT $? 0 0 "sha256sum check failed."
```

- 涉及命令：test×1, sha256sum×1

#### oe_test_dmraid

- 描述：Test xmllint format xml
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "failed to dmraid help"
  CHECK_RESULT $? 0 0 "Failed to version "
  CHECK_RESULT $? 0 0 "Failed to raid "
```

- 涉及命令：dmraid×3

#### oe_test_c++

- 描述：Use c++ to compile c programs
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Error, fail to create test.cpp"
  CHECK_RESULT $? 0 0 "Error, fail to create test"
  CHECK_RESULT $? 0 0 "Error, please check 'hello C++'"
```

#### oe_test_md5sum

- 描述：Command test-md5sum
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "check create file fail"
  CHECK_RESULT $? 0 0 "The testfile1.md5 is not exit "
  CHECK_RESULT $? 0 0 "md5sum check failed"
```

- 涉及命令：test×1, md5sum×1

#### oe_test_tail

- 描述：Command test-tail
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $((tail_value1)) $((tail_value2)) 0 0  "check Tail's result fail"
  CHECK_RESULT $? 0 0 "check Tail's help manual fail"
```

#### oe_test_systool

- 描述：Command test-systool
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0  "check systool result fail"
  CHECK_RESULT $? 0 0 "check systool's help manual fail"
  CHECK_RESULT $? 0 0 "Querying network devices fail"
  CHECK_RESULT $? 0 0 "Failed to query the information and attributes of the SCSI host"
  CHECK_RESULT $? 0 0 "Failed to query the specified network interface"
```

- 涉及命令：systool×4

#### oe_test_awk

- 描述：Command test-awk
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0  "check root result fail"
  CHECK_RESULT $? 0 0  "check cpuid result fail"
  CHECK_RESULT $? 0 0 "check Tail's help manual fail"
  CHECK_RESULT $? 0 0  "check count the number of rows per row after segmentation result fail"
  CHECK_RESULT $? 0 0  "check the last column of each row after segmentation result fail"
  CHECK_RESULT $? 0 0  "check print line numbers result fail"
  CHECK_RESULT $? 0 0  "check specify line content result fail"
  CHECK_RESULT $? 0 0  "check the last and first columns of each row after colon splitting result fail"
  CHECK_RESULT $? 0 0  "check the printed delimiters result fail"
```

- 涉及命令：awk×4

#### oe_test_sdiff

- 描述：Command sdiff
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "The file content is abnormal "
  CHECK_RESULT $? 0 0 "The diff.log is not exit "
  CHECK_RESULT $? 0 0 "The diff.log  is abnormal"
```

- 涉及命令：sdiff×1, test×1

#### oe_test_diff3

- 描述：diff3 function verification
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "The diff3.log is not exit "
  CHECK_RESULT $((diff3_value1)) $((diff3_value2)) 0 "diff3's result fail"
  CHECK_RESULT $? 0 0 "The relust is abnormal"
  CHECK_RESULT $? 0 0 "The file content is abnormal "
```

- 涉及命令：test×1, diff3×1

#### oe_test_fuse

- 描述：fuse function verification
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "The test is not exit "
  CHECK_RESULT $? 0 0 "The fuse test is fail"
  CHECK_RESULT $? 0 0 "The relust is abnormal"
  CHECK_RESULT $? 0 0 "The umount test is fail"
```

- 涉及命令：test×1, mount×1

#### oe_test_zstd

- 描述：function verification
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0  "check file1.zst exist fail"
  CHECK_RESULT $? 0 0 "check source file1 exist fail after compress"
  CHECK_RESULT $? 0 0  "check --rm exec fail"
  CHECK_RESULT $? 0 0  "check file2.zst exist fail"
  CHECK_RESULT $? 1 0 "check source file2 exist fail after use --rm"
  CHECK_RESULT $? 0 0 "check file1's content fail"
```

- 涉及命令：test×4

#### oe_test_auditctl

- 描述：Command test-auditctl
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0  "check auditctl fail"
  CHECK_RESULT $? 0 0  "check auditctl rule fail"
  CHECK_RESULT $? 0 0 "check remove rule fail"
  CHECK_RESULT $? 0 0  "check auditctl result fail"
```

- 涉及命令：auditctl×4

#### oe_test_accessdb

- 描述：Command test-accessdb
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "check command debug fail"
  CHECK_RESULT $? 0 0  "check command help fail"
  CHECK_RESULT $? 0 0  "check commmand usage fail"
  CHECK_RESULT $? 0 0  "check version fail"
```

#### oe_test_cksum

- 描述：Command test-cksum
- 函数：`pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $? 0 0 "check create file fail"
  CHECK_RESULT $? 0 0  "check integrity of file fail"
  CHECK_RESULT $? 0 0 "check modify file fail"
  CHECK_RESULT $? 0 1 "cksum exec error after testfile changed"
  CHECK_RESULT $? 0 0 "cksum --help command fail"
  CHECK_RESULT $? 0 0 "cksum --version command fail"
  CHECK_RESULT $? 0 0 "check delete file fail"
```

#### oe_test_paste

- 描述：Command test-paste
- 函数：`pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $? 0 0 "check create file fail"
  CHECK_RESULT $? 0 0 "check create file fail"
  CHECK_RESULT $? 0 0  "Merge file contents in parallel fail"
  CHECK_RESULT $? 0 0 "Merge file contents serially fail"
  CHECK_RESULT $? 0 0 "check create file fail"
  CHECK_RESULT $? 0 0
  CHECK_RESULT $? 0 0  "check command fail"
  CHECK_RESULT $? 0 0  "check command fail"
```

- 涉及命令：paste×2

#### oe_test_chgrp

- 描述：Command test-chgrp
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0  "file is created"
  CHECK_RESULT $? 0 0  "directory is created"
  CHECK_RESULT $? 0 0 "command executed fail"
  CHECK_RESULT $? 0 0  "check file group fail"
  CHECK_RESULT $? 0 0 "command executed fail"
  CHECK_RESULT $? 0 0 "check file group fail"
  CHECK_RESULT $? 0 0 "command executed fail"
  CHECK_RESULT $? 0 0  "check file and directory group fail"
  CHECK_RESULT $? 0 0  "check file and directory group fail"
  CHECK_RESULT $? 0 0  "check command fail"
```

- 涉及命令：chgrp×2, mkdir×1

#### oe_test_cut

- 描述：Command test-cut
- 函数：`pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $? 0 0  "file is created"
  CHECK_RESULT $? 0 0  "cut file fail"
  CHECK_RESULT $? 0 0 "cut file  fail"
  CHECK_RESULT $? 0 0  "cut file fail"
  CHECK_RESULT $? 0 0  "cut file fail"
  CHECK_RESULT $? 0 0  "cut file fail"
  CHECK_RESULT $? 0 0  "check command fail"
```

- 涉及命令：cut×5

#### oe_test_bsdcat

- 描述：Command test-bsdcat
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "check create file fail"
  CHECK_RESULT $? 0 0  "look file fail"
  CHECK_RESULT $? 0 0  "check command fail"
  CHECK_RESULT $? 0 0  "check command fail"
```

#### oe_test_b2sum

- 描述：Command test-b2sum
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "check create file fail"
  CHECK_RESULT $? 0 0  "failed to read the file in binary. procedure"
  CHECK_RESULT $? 0 0  "Summary length failure"
  CHECK_RESULT $? 0 0  "Failed to read in plain text mode"
  CHECK_RESULT $? 0 0  "check help manual fail"
  CHECK_RESULT $? 0 0  "check version fail"
```

- 涉及命令：b2sum×3

#### oe_test_ulimit

- 描述：Command test-ulimit
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0  "check max memory size unlimited result fail"
  CHECK_RESULT $((ulimit_value1)) $((ulimit_value2)) 0  "check ulimit's result fail"
  CHECK_RESULT $? 0 0 "check ulimit's help manual fail"
```

- 涉及命令：ulimit×1

#### oe_test_versioninfo

- 描述：Query system version info test
- 函数：`run_test`
- 断言（6 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：grep×5

#### oe_test_uname

- 描述：Command test-uname
- 函数：`run_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "Execution failed"
  CHECK_RESULT $? 0 0 "Execution failed"
  CHECK_RESULT $? 0 0 "Execution failed"
  CHECK_RESULT $? 0 0 "Execution failed"
  CHECK_RESULT $? 0 0 "Execution failed"
  CHECK_RESULT $? 0 0 "Execution failed"
```

- 涉及命令：uname×5

#### oe_test_timedatectl

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

- 涉及命令：date×1, hwclock×1

#### oe_test_system_monitor_reboot

- 描述：View information about recent system reboots
- 函数：`run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

#### oe_test_system_monitor_process

- 描述：The system supports monitoring and testing each process
- 函数：`run_test`
- 断言（5 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：ipcs×1

#### oe_test_system_monitor_login

- 描述：View the user's most recent log-ins
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：expect×3, useradd×1

#### oe_test_system_log_view

- 描述：Log View
- 函数：`run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：tail×1, kill×1

#### oe_test_system_log_security

- 描述：Support for the recording of information about system security
- 函数：`run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $?
```

#### oe_test_system_log_recorded

- 描述：The system log is recorded in a fixed log file
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT "$(find "${folder}" -maxdepth 1 -type f -name "*journal" | wc -l)" 1
  CHECK_RESULT $?
```

- 涉及命令：journalctl×1

#### oe_test_system_log_process

- 描述：Supports logging of scheduled task processes
- 函数：`run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $?
```

#### oe_test_system_log_dmesg

- 描述：Query boot information-dmesg
- 函数：`run_test`
- 断言（1 条）：

```
  CHECK_RESULT $?
```

- 涉及命令：grep×1

#### oe_test_system_log_device

- 描述：Supports logging of device information
- 函数：`run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $?
```

#### oe_test_system_log_basic

- 描述：Supports logging of Basic System Operation Information
- 函数：`run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $?
```

#### oe_test_server_vsftpd_transfer

- 描述：FTP Transfer file-disk full
- 函数：`config_params, pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $? 1
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：ftp×2, read×1, setsebool×1, mkdir×1

#### oe_test_server_vsftpd_restart

- 描述：Start and stop the FTP service repeatedly
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：netstat×1

#### oe_test_server_vsftpd_NKdelay

- 描述：FTP File transfer-network delay packet loss
- 函数：`config_params, pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $? 1
  CHECK_RESULT $?
```

- 涉及命令：setsebool×1, ftp×1, grep×1

#### oe_test_server_squid_proxy

- 描述：Set Squid to a cache proxy without authentication
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

- 涉及命令：test×2, sed×1, curl×1

#### oe_test_server_squid_ip

- 描述：Configuring Squid services to listen for a specific port or IP address
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

- 涉及命令：sed×2, test×2, curl×1

#### oe_test_server_squid_blacklist

- 描述：Configuring the domain blacklist in Squid
- 函数：`pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $? 56
```

- 涉及命令：sed×3, curl×1

#### oe_test_server_postgresql

- 描述：Install PostgreSQL
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：userdel×2

#### oe_test_server_openssh_verifykey

- 描述：SSH authentication using a key pair in place of a password
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $? 0 1
```

- 涉及命令：sed×2, setsebool×1

#### oe_test_server_openssh_secure

- 描述：How to make OpenSSH more secure
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
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：sed×8

#### oe_test_netscript_cfg

- 描述：network cfg file test
- 函数：`run_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "have no available net cfg file"
  CHECK_RESULT $? 0 0 "the item is use for set net NAME"
  CHECK_RESULT $? 0 0 "the item is use for set net bootproto"
  CHECK_RESULT $? 0 0 "the item is use for set automatically connect to the network upon startup"
  CHECK_RESULT $? 0 0 "the item is use for set net name"
  CHECK_RESULT $? 0 0 "the item is use for set default route"
```

- 涉及命令：grep×5

#### oe_test_server_openssh_restart

- 描述：Restart and stop the OpenSSH service repeatedly
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

#### oe_test_server_openssh_key

- 描述：Generating SSH key pairs
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 1
  CHECK_RESULT $? 1
  CHECK_RESULT $? 1
```

- 涉及命令：expect×3, grep×3

#### oe_test_server_mysql

- 描述：mysql restarts repeatedly
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：test×1, kill×1, userdel×1

#### oe_test_server_mariadb_stop

- 描述：Repeatedly starting and stopping the MARIADB database
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：mysqladmin×1, expect×1, grep×1

#### oe_test_server_mariadb_onlinebackup

- 描述：Perform a physical online backup using the Maria backup tool
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：mysqladmin×1

#### oe_test_server_mariadb_loadfile

- 描述：Load the dump file back to the server using mysqldump
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $? 1
```

- 涉及命令：expect×2, mysqladmin×1, mysqldump×1, grep×1

#### oe_test_server_mariadb_compatibilty

- 描述：MARIADB software compatibility
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：iptables-legacy×2, ping×1, mysqladmin×1, netstat×1, expect×1

#### oe_test_server_mariadb_dumpMulDB

- 描述：Dump multiple databases using mysqldump
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 1
  CHECK_RESULT $?
```

- 涉及命令：expect×2, mysqladmin×1, grep×1

#### oe_test_server_mariadb_dump

- 描述：Dump all databases with mysqldump
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：mysqladmin×1, expect×1

#### oe_test_server_mariadb_copy

- 描述：Use mysqldump to copy data between two databases
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $? 1
```

- 涉及命令：expect×2, mysqladmin×1, grep×1

#### oe_test_server_mariadb_backuptable

- 描述：Use mysqldump to back up a set of tables from a database
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 1
  CHECK_RESULT $?
```

- 涉及命令：expect×2, mysqladmin×1, grep×1

#### oe_test_server_mariadb_backupDB

- 描述：Back up the entire database using mysqldump
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 1
  CHECK_RESULT $?
```

- 涉及命令：mysqladmin×1, expect×1, grep×1

#### oe_test_server_mariadb_backup

- 描述：Perform a file system backup
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：mkdir×1

#### oe_test_server_httpd_tls

- 描述：Enable specific versions of TLSv1.x
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：sed×2

#### oe_test_server_httpd_restart

- 描述：Restarting the httpd service
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

#### oe_test_server_httpd_recover

- 描述：Profile lost / recovered
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $? 1
  CHECK_RESULT $?
```

#### oe_test_server_httpd_port

- 描述：Httpd port occupied
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 1
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：kill×1

#### oe_test_server_httpd_checkfirewall

- 描述：Check that the firewall is configured to allow services to be used
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
```

#### oe_test_server_git_install

- 描述：Use for Git installation
- 函数：`pre_test, run_test, post_test`
- 断言（14 条）：

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
  ... 共 14 条（其余见源脚本）
```

#### oe_test_sos

- 描述：Command test  sos
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "sosreport -l failed"
  CHECK_RESULT $? 0 0 "sosreport -l | grep plugins failed"
  CHECK_RESULT $? 0 0 "compression failed"
  CHECK_RESULT $? 0 0 "xz -d /var/tmp/*.tar.xz failed"
```

- 涉及命令：sosreport×2, test×1

#### oe_test_reboot

- 描述：Reboot test
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $? 1
  CHECK_RESULT $?
```

- 涉及命令：ping×1, grep×1

#### oe_test_power_powertop_startup

- 描述：Powertop service startup
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

#### oe_test_power_powertop_powerup

- 描述：Power up the POWERTOP
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $?
```

- 涉及命令：kill×1

#### oe_test_power_powertop_calibrate

- 描述：Calibrating PowerTOP
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $?
```

- 涉及命令：kill×1

#### oe_test_power_powertop2tuned_optimize

- 描述：Optimizing power consumption using the powertop2tuned utility
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：test×1

#### oe_test_power_output_HTML

- 描述：Generating HTML output
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
```

#### oe_test_power_measurement_internal

- 描述：Set the measurement interval
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $?
```

- 涉及命令：kill×1

#### oe_test_performance_monitor_pcp

- 描述：Install and enable PCP
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：grep×1

#### oe_test_password_change

- 描述：User password modification_current user
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：userdel×1

#### oe_test_password_blank

- 描述：Password setting-blank password
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $?
```

- 涉及命令：grep×1, userdel×1

#### oe_test_nmcli_vlan

- 描述：Test nmcli configuration vlan
- 函数：`config_params, run_test, post_test`
- 断言（18 条）：

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
  ... 共 18 条（其余见源脚本）
```

#### oe_test_nmcli_systemd_resolved

- 描述：Test nmcli configuration systemd-resolved
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：sed×1, netstat×1

#### oe_test_nmcli_route

- 描述：Test nmcli configure static routing
- 函数：`config_params, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT "$num" 1
  CHECK_RESULT $?
  CHECK_RESULT "$num" 2
  CHECK_RESULT $?
```

#### oe_test_nmcli_macsec

- 描述：Test nmcli configure MACsec
- 函数：`pre_test, config_params, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
```

#### oe_test_nmcli_general

- 描述：Test nmcli general
- 函数：`run_test`
- 断言（2 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
```

#### oe_test_nmcli_device

- 描述：Test nmcli device
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

- 涉及命令：nmcli×3

#### oe_test_nmcli_config_gw

- 描述：Test nmcli configure default gateway
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

#### oe_test_nmcli_config_connect

- 描述：Test nmcli configure Ethernet connection
- 函数：`config_params, run_test, post_test`
- 断言（14 条）：

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
  ... 共 14 条（其余见源脚本）
```

- 涉及命令：nmcli×2

#### oe_test_nmcli_con_reload

- 描述：Test nmcli reload
- 函数：`config_params, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：sed×3, test×1

#### oe_test_nmcli_cancel_auto

- 描述：Test nmcli cancel auto configuration /etc/resolv.conf
- 函数：`run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $? 0 1
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：test×1

#### oe_test_nmcli_bridge

- 描述：Test nmcli configuration bridge
- 函数：`config_params, run_test, post_test`
- 断言（26 条）：

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
  ... 共 26 条（其余见源脚本）
```

#### oe_test_nmcli_add_connect

- 描述：Test nmcli connection
- 函数：`config_params, run_test, post_test`
- 断言（9 条）：

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
```

#### oe_test_nmcli_Mgntconnect

- 描述：Use nmcli to manage network connections after the installation process
- 函数：`config_params, pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT "$(nmcli con show | grep -c "${con_name}")" 1
  CHECK_RESULT $?
```

- 涉及命令：nmcli×1, grep×1

#### oe_test_nmcli_8023link

- 描述：Test nmcli modify 802.3 link configuration
- 函数：`config_params, run_test, post_test`
- 断言（9 条）：

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
```

#### oe_test_USBinfo

- 描述：Query USB configure test
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：lsusb×1

#### oe_test_ProcMgmt_vmstat

- 描述：Process monitoring-vmstat
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $((swap_value1)) $((swap_value2))
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：vmstat×1

#### oe_test_ProcMgmt_top

- 描述：View process status-top
- 函数：`run_test`
- 断言（2 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：top×2

#### oe_test_ProcMgmt_start_kill

- 描述：Start process / kill process
- 函数：`pre_test, run_test, post_test`
- 断言（11 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $? 0 1
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $? 0 1
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $? 0 1
```

- 涉及命令：pgrep×5, kill×1

#### oe_test_ProcMgmt_sar

- 描述：Process monitoring -sar -b
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
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：sar×4, test×3

#### oe_test_ProcMgmt_ps

- 描述：View process status-ps
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $? 0 1
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：kill×1

#### oe_test_ProcMgmt_pgrep

- 描述：View process status-pgrep
- 函数：`run_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "The ssh related pid number could not be found"
  CHECK_RESULT $? 0 0 "The first line is not the smallest process number"
  CHECK_RESULT $? 0 0 "The last line is not the largest process number"
```

- 涉及命令：pgrep×3

#### oe_test_ProcMgmt_iostat

- 描述：Process monitoring -iostat
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

- 涉及命令：iostat×4

#### oe_test_ProcMgmt_crontab_cronfile

- 描述：User creates another cron file
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT "$ret" 1
  CHECK_RESULT $?
```

- 涉及命令：crontab×2, date×2

#### oe_test_ProcMgmt_crontab_cmd

- 描述：Crontab related commands test
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $ret 1
  CHECK_RESULT $?
```

- 涉及命令：crontab×2, date×2

#### oe_test_ProcMgmt_at

- 描述：Run a batch of programs regularly-at
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT "${new_count}" $((${old_count} + 7))
  CHECK_RESULT $?
```

- 涉及命令：date×2

#### oe_test_disk_tuned_set

- 描述：Setting up the disk scheduler using Tuned(For physical machines only)
- 函数：`config_params, pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：test×1, awk×1

#### oe_test_disk_schedule_specific

- 描述：Temporarily sets the scheduler for a specific disk
- 函数：`config_params, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $?
```

- 涉及命令：awk×1

#### oe_test_disk_schedule_udev

- 描述：Set up the disk scheduler using udev rules
- 函数：`config_params, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：awk×1

#### oe_test_disk_tuned_new

- 描述：Create a new tuned profile
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：mkdir×1, test×1

#### oe_test_disk_tuned_install

- 描述：Install and enable tuned
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
```

#### oe_test_date

- 描述：Date command line test
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：date×4, hwclock×2, grep×1

#### oe_test_cmd_su_user

- 描述：Service Management Common Command Test -su
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：userdel×1

#### oe_test_disk_tuned_modify

- 描述：Modify the existing Tunde configuration file
- 函数：`config_params, pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：test×3

#### oe_test_disk_tuned_disable

- 描述：Disable tuned
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $? 1
  CHECK_RESULT $?
```

- 涉及命令：test×2

#### oe_test_ethtool

- 描述：Verify support for hardware timestamps
- 函数：`config_params, pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT "$(ethtool -T ${local_eth1} | grep -iE "Capabilities|PTP|Hardware" | wc -l)" 4
```

#### oe_test_basic_create_group

- 描述：Create User Group test
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

- 涉及命令：grep×6, groupadd×2

#### oe_test_basic_modify_group

- 描述：Modity User Group test
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $? 1
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：grep×7, groupmod×3, usermod×1, userdel×1

#### oe_test_basic_modify_user

- 描述：Modify User test
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "check user id from /etc/passwd error"
  CHECK_RESULT $? 0 0 "modify group id error"
  CHECK_RESULT $? 0 0 "check group id from /etc/passwd error"
  CHECK_RESULT $? 0 0 "check --help msg error"
```

- 涉及命令：grep×4, usermod×2, useradd×1, groupmod×1, groupadd×1, userdel×1

#### oe_test_chrony_chronyc_cmd

- 描述：Use chronyc to control chronyd
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：expect×1, grep×1

#### oe_test_chrony_chronyc_hardwaretime

- 描述：Verify hardware timestamp
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

#### oe_test_chrony_chronyc_ntpstat

- 描述：Implement some settings previously supported by ntp in NTP
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $(chronyc -n tracking | grep -icE 'utc|RMS offset|Last offset') 3
  CHECK_RESULT $?
  CHECK_RESULT $?
```

#### oe_test_chrony_chronyd

- 描述：Use Chrony test
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 "chronyd not running"
  CHECK_RESULT $? 0 0 "chronyd not enabled"
  CHECK_RESULT $? 0 0 "/etc/chrony.conf not exists"
  CHECK_RESULT $? 0 0 "chronyc cources failed"
  CHECK_RESULT $? 0 0 "chronyc tracking failed"
  CHECK_RESULT $? 0 0 "chronyc sourcestats failed"
  CHECK_RESULT $? 0 0 "read from pipe failed"
  CHECK_RESULT $? 0 1 "failed with invalid command"
  CHECK_RESULT $? 0 1 "status should be dead"
```

- 涉及命令：test×1

#### oe_test_chrony_Manuall

- 描述：Manually adjust the system clock test-makestep
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
```

#### oe_test_cmd_id

- 描述：View user and group id
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：grep×1

#### oe_test_cmd_sudo

- 描述：Service management common command test -sudo
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：sudo×1, userdel×1

#### oe_test_hwclock

- 描述：Hwclock command line test
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：date×1, hwclock×1

#### oe_test_IOaccess_500Mfile

- 描述：500M file continuous cp,dd,zip,unzip
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

- 涉及命令：test×1

#### oe_test_group_access

- 描述：Group directory access permission settings
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：test×1, usermod×1, userdel×1

#### oe_test_kernel_sysctl

- 描述：SYSCTL modifies kernel parameters
- 函数：`run_test`
- 断言（5 条）：

```
  CHECK_RESULT "$(sysctl -a | grep -oE '^dev|^kernel|^net' | sort -u | wc -l)" 3
  CHECK_RESULT $?
  CHECK_RESULT "$(sysctl -a | grep net.ipv6.conf.lo.disable_ipv6 | awk '{print$3}')" 1
  CHECK_RESULT $?
  CHECK_RESULT "$(sysctl -a | grep net.ipv6.conf.lo.disable_ipv6 | awk '{print$3}')" 0
```

- 涉及命令：sysctl×1

#### oe_test_hostnamectl

- 描述：hostnamectl configuration hostname test
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $? 1
  CHECK_RESULT $? 1
  CHECK_RESULT $?
```

- 涉及命令：grep×1

#### oe_test_kernel_kdump

- 描述：KDUMP configuration
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：rpm×1, grub2-mkconfig×1

#### oe_test_IOaccess_100Mfile

- 描述：100M file continuous cp,dd,zip,unzip
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

#### oe_test_IOaccess_1Gfile

- 描述：1G file continuous cp,dd,zip,unzip
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

#### oe_test_kernel_module_operation

- 描述：Module operation
- 函数：`run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $? 1
```

- 涉及命令：modprobe×2

#### oe_test_kernel_cgroup

- 描述：cgroup
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：kill×1

#### oe_test_home_directory

- 描述：Modify user home directory
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $? 1
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：usermod×3, test×2, userdel×1

#### oe_test_groupdel

- 描述：Delete User Group test
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $? 1 0
  CHECK_RESULT $?
```

#### oe_test_net_IPVLAN

- 描述：Ipvlan command test
- 函数：`config_params, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

#### oe_test_net_setmode

- 描述：Set hybrid network mode
- 函数：`config_params, pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $? 1
```

- 涉及命令：grep×2

#### oe_test_net_scriprts

- 描述：network-scripts test
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
```

#### oe_test_net_cmd_ifconfig

- 描述：Network commonly used command test-ifconfig
- 函数：`config_params, pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $? 1
  CHECK_RESULT $?
  CHECK_RESULT $?
```

#### oe_test_net_VRF

- 描述：Create vrf test
- 函数：`config_params, run_test, post_test`
- 断言（9 条）：

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
```

#### oe_test_localectl

- 描述：Configure keyboard layout test
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

#### oe_test_man

- 描述：Command test-man -w
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 1
  CHECK_RESULT $?
```

- 涉及命令：man×1

#### oe_test_net_cmd_scp

- 描述：Common network command test-scp
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

#### oe_test_net_cmd_ping

- 描述：Common network command test-ping
- 函数：`run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：ping×2, sed×1

#### oe_test_net_conninfo_lsof

- 描述：View network connection information-lsof
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：lsof×3

#### oe_test_net_config

- 描述：Add/remove virtual network card
- 函数：`config_params, pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $? 1
```

- 涉及命令：ping×2

#### oe_test_net_cmd_telnet

- 描述：Common network command test-telnet
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：pgrep×1

#### oe_test_net_ncat

- 描述：Ncat communication test
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT "$(grep -icE '123|456|004' ncat_log)" 3
```

- 涉及命令：iptables×2

#### oe_test_nmcli_set_bond

- 描述：Command test-who -b/-s
- 函数：`pre_test, run_test, post_test`
- 断言（22 条）：

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
  ... 共 22 条（其余见源脚本）
```

#### oe_test_basic_UserMgmt_permission

- 描述：Command test-who -b/-s
- 函数：`pre_test, run_test, post_test`
- 断言（13 条）：

```
  CHECK_RESULT $? 1
  CHECK_RESULT $? 1
  CHECK_RESULT $? 1
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $? 1
  CHECK_RESULT $? 1
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  ... 共 13 条（其余见源脚本）
```

- 涉及命令：userdel×2, usermod×1, groupmod×1

#### oe_test_system_monitor_share_total

- 描述：system monitor share total
- 函数：`config_params, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

#### oe_test_disk_graphics_card

- 描述：Command test-who -b/-s
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $? 0 1
  CHECK_RESULT $?
```

- 涉及命令：dmidecode×2, lspci×1, usermod×1, userdel×1

#### oe_test_nmcli_set_team

- 描述：Command test-who -b/-s
- 函数：`pre_test, run_test, post_test`
- 断言（20 条）：

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
  ... 共 20 条（其余见源脚本）
```

#### oe_test_basic_set_account_expiration_time

- 描述：account_expiration time
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

- 涉及命令：grep×1, chage×1, usermod×1, userdel×1

#### oe_test_basic_set_permissions

- 描述：permissions test
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：usermod×1, userdel×1

#### oe_test_patch

- 描述：Command test patch -p0/-Rp0
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 1 0 "create foo.patch error"
  CHECK_RESULT $? 0 0 "patch -po error"
  CHECK_RESULT $? 1 0 "patch -Rpo error"
```

- 涉及命令：patch×2, diff×1

#### oe_test_exiv2

- 描述：Command test exiv2
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "view image info error"
  CHECK_RESULT $? 0 0 "view image details info error before add"
  CHECK_RESULT $? 1 0 "query image info before add"
  CHECK_RESULT $? 0 0 "add image info error"
  CHECK_RESULT $? 0 0 "view image details info error after add"
  CHECK_RESULT $? 0 0 "query image info error after add"
```

- 涉及命令：exiv2×3

#### oe_test_json-c

- 描述：Command test json-c
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "compile file error"
  CHECK_RESULT $? 0 0 "execute hello error"
  CHECK_RESULT $? 0 0 "query msg error"
```

- 涉及命令：gcc×1

#### oe_test_whoami

- 描述：whoami command
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "exec 'check user' failed"
  CHECK_RESULT $? 0 0 "exec 'check user' failed"
```

- 涉及命令：userdel×1

#### oe_test_lz4

- 描述：Command test lz4
- 函数：`pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $? 0 0 "compress file error"
  CHECK_RESULT $? 0 0 "check compress -m file1 error"
  CHECK_RESULT $? 0 0 "check compresss -m file2 error"
  CHECK_RESULT $? 0 0 "decompress file error"
  CHECK_RESULT $? 0 0 "check --rm file1 compress error"
  CHECK_RESULT $? 0 1 "check --rm file1 exist error"
  CHECK_RESULT $? 0 0 "view help msg error"
```

- 涉及命令：lz4×3

#### oe_test_zlib

- 描述：Command test zlib
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "compile file error"
  CHECK_RESULT $? 0 0 "grep msg error"
```

- 涉及命令：gcc×1, grep×1

#### oe_test_brotli

- 描述：Command test brotli
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "check brotli version error"
  CHECK_RESULT $? 0 0 "check test.tar after touch error"
  CHECK_RESULT $? 0 0 "excute brotli -q error"
  CHECK_RESULT $? 0 0 "check test.tar.br file error"
  CHECK_RESULT $? 0 0 "excute brotli -d error"
  CHECK_RESULT $? 0 0 "check test.tar file error"
```

- 涉及命令：brotli×3, test×2

#### oe_test_net_mtr

- 描述：Command test mtr
- 函数：`pre_test, run_test, post_test`
- 断言（11 条）：

```
  CHECK_RESULT $? 0 0 "check mtr version error"
  CHECK_RESULT $? 0 0 "check mtr help error"
  CHECK_RESULT $? 0 0 "execute -n -r -c cmd error"
  CHECK_RESULT "${s_value}" 15 0 "check log error after execute -n -r -c"
  CHECK_RESULT $? 0 0 "execute -n -r -s cmd error"
  CHECK_RESULT $? 0 0 "execute -n --xml cmd error"
  CHECK_RESULT $? 0 0 "check log error after execute -n --xml"
  CHECK_RESULT $? 0 0 "execute -n --csv cmd error"
  CHECK_RESULT $? 0 0 "check log error after execute --csv"
  CHECK_RESULT $? 0 0 "execute -T -r cmd error"
  CHECK_RESULT $? 0 0 "execute -u -r cmd error"
```

- 涉及命令：mtr×8, grep×2

#### oe_test_gsettings

- 描述：Command test gsettings
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "gsettings list-schemas error"
  CHECK_RESULT $? 0 0 "gsettings list-relocatable-schemas error"
  CHECK_RESULT $? 0 0 "gsettings list-recursively error"
  CHECK_RESULT $? 0 0 "gsettings list-keys error"
  CHECK_RESULT $? 0 0 "gsettings get key value error"
```

#### oe_test_pcre_use

- 描述：Test pcre use
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "Pcre is not installed"
  CHECK_RESULT $? 0 0 "check your file configuration (/etc/ld.so.conf)"
  CHECK_RESULT $? 0 0 "check your file configuration (file.c)"
  CHECK_RESULT $? 0 0 "check your file configuration"
```

- 涉及命令：gcc×1

#### oe_test_ACL_dir

- 描述：Command ACL dir
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 1 "uos can not access dir test115216，please modify"
  CHECK_RESULT $? 0 0 "setfacl set fail"
  CHECK_RESULT $? 0 0 "ace don't access test115216"
```

- 涉及命令：userdel×2

#### oe_test_du

- 描述：Du command test
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Failed to view subdirectory size"
  CHECK_RESULT $? 0 0 "Failed to view the current size"
  CHECK_RESULT $? 0 0 "Failed to view the du command help manual"
```

- 涉及命令：mkdir×1

#### oe_test_ar

- 描述：Ar command test
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "check one.bak creation fail"
  CHECK_RESULT $? 0 0 "check two.bak creation fail"
  CHECK_RESULT $? 0 0 "check file fail"
  CHECK_RESULT $? 0 0 "check file delete fail"
```

#### oe_test_vim

- 描述：vim command test
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Failed to modify the file"
  CHECK_RESULT $? 0 1 "Failed to delete the file"
```

- 涉及命令：vim×2

#### oe_test_vim_001

- 描述：vim command test
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "Failed to copy the file"
  CHECK_RESULT $? 0 0 "Failed to insert the file"
  CHECK_RESULT $? 0 0 "Failed to insert line the file"
  CHECK_RESULT $? 0 1 "Failed to delete byte the file"
```

- 涉及命令：vim×4

#### oe_test_basename

- 描述：basename command test
- 函数：`run_test`
- 断言（12 条）：

```
  CHECK_RESULT "$(basename /var/log/messages)" "messages" 0 "check file fail"
  CHECK_RESULT "$(basename /var/log/boot.log .log)" "boot" 0 "check suffix file fail"
  CHECK_RESULT "$(basename -s .log /var/log/boot.log )" "boot" 0 "check suffix file fail"
  CHECK_RESULT "$(basename /var/log)" "log" 0 "check dir fail"
  CHECK_RESULT "$(basename /etc/yum.repos.d .repos.d)" "yum" 0 "check suffix dir fail"
  CHECK_RESULT "$(basename /etc/yum.repos.d .repos)" "yum.repos.d" 0 "check suffix dir fail"
  CHECK_RESULT "$(basename testdir/testfile1 testdir/testfile2)" "testfile1" 0 "check multiple file fail"
  CHECK_RESULT "$(basename -a testdir/testfile1 testdir/testfile2)" "$(ls testdir)" 0 "check multiple file fail"
  CHECK_RESULT "$(basename -az testdir/testfile1 testdir/testfile2)" "testfile1testfile2" 0 "check zero fail"
  CHECK_RESULT $? 0 0 "check version fail"
  CHECK_RESULT "$(basename --version |head -1 |awk '{print $NF}')" "$(rpm -qi coreutils |grep -i Version |awk '{print $NF}')" 0 "check version fail"
  CHECK_RESULT $? 0 0 "check usage fail"
```

#### oe_test_groff

- 描述：Groff document format
- 函数：`run_test`
- 断言（3 条）：

```
  CHECK_RESULT $Tascii_result 66 0 "groff Tascii fail"
  CHECK_RESULT $? 0 0 "groff fail"
  CHECK_RESULT $Tutf8_result 66 0 "groff Tutf8 fail"
```

#### oe_test_whatis

- 描述：whatis command test
- 函数：`run_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "check display failed after whatis -?"
  CHECK_RESULT $? 0 0 "check display failed after whatis -V"
  CHECK_RESULT $? 0 0 "check display failed after whatis man"
  CHECK_RESULT $? 0 0 "check display failed after whatis ls"
  CHECK_RESULT $? 0 0 "check display failed after whatis -r ^lsat"
  CHECK_RESULT $? 0 0 "check display failed after whatis -w lsat*"
```

- 涉及命令：whatis×3

#### oe_test_auditc_01

- 描述：File system common command test-auditctl
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT "$out_e0" 0 0 "auditctl -e 0 setting failure"
  CHECK_RESULT "$out_s0" 0 0 "auditctl -s display failure"
  CHECK_RESULT "$out_e1" 1 0 "auditctl -e 1 setting failure"
  CHECK_RESULT "$out_s1" 1 0 "auditctl -s display failure"
  CHECK_RESULT $? 0 0 "record generation failure"
```

- 涉及命令：auditctl×1

#### oe_test_gmp

- 描述：the function of gmp
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "compilation of main.cpp is failed"
  CHECK_RESULT $? 0 0 "file main.o is not created"
  CHECK_RESULT $? 0 0 "The executable program main.o execution has failed"
```

#### oe_test_libffi

- 描述：the function of libffi
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "compilation of libffi_test.c is failed"
  CHECK_RESULT $? 0 0 "file a.out is not created"
  CHECK_RESULT $? 0 0 "The executable program a.out execution has failed"
```

- 涉及命令：gcc×1

#### oe_test_libunistring

- 描述：the function of libunistring
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT "$?" 0 0 "compilation of libunistring_test.c is failed"
  CHECK_RESULT "$?" 0 0 "file a.out is not created"
  CHECK_RESULT "$(./a.out)" "0000001000101" 0 "The executable program a.out execution has failed"
```

- 涉及命令：gcc×1

#### oe_test_shred

- 描述：File system common command shred
- 函数：`run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "echo fail"
  CHECK_RESULT $? 0 0 "Failed to smash the file"
  CHECK_RESULT $? 0 1 "Command executed successfully"
```

#### oe_test_expect

- 描述：Expect basic function verification
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "expect install failed"
  CHECK_RESULT $? 0 0 "expected version query failed"
  CHECK_RESULT $? 0 0 "execution failed"
```

- 涉及命令：rpm×1, expect×1

#### oe_test_xmlsec

- 描述：Xmlsec1 Encrypt xml
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "execution failed"
  CHECK_RESULT $? 0 0 "execution failed"
  CHECK_RESULT $? 0 0 "execution failed"
  CHECK_RESULT $? 0 0 "execution failed"
  CHECK_RESULT $? 0 0 "execution failed"
```

#### oe_test_tcl

- 描述：Use tcl case
- 函数：`run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "please check TCL language"
  CHECK_RESULT $? 0 0 "Error, fail to create hello.c"
  CHECK_RESULT $? 0 0 "Error, please check 'hello.tcl'"
```

- 涉及命令：rpm×1

#### oe_test_disk_io_sched

- 描述：package IO SCHED test
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "none is not selected by brackets"
  CHECK_RESULT $? 0 0 "mq-deadline is not selected by brackets"
  CHECK_RESULT $? 0 0 "bfq is not selected by brackets"
  CHECK_RESULT $? 0 0 "kyber is not selected by brackets"
```

- 涉及命令：sudo×1

#### oe_test_lsusb

- 描述：Command test lsusb
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "error displaying USB device information"
  CHECK_RESULT $? 0 0 "detailed display of USB device information"
  CHECK_RESULT $? 0 0 "the linked device does not exist"
  CHECK_RESULT $? 0 0 "detailed display of USB device information"
  CHECK_RESULT $? 0 0 "display lsusb tree structure error"
  CHECK_RESULT $? 0 0 "error displaying lsusb version information"
```

- 涉及命令：lsusb×4

#### oe_test_last

- 描述：test last
- 函数：`run_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "default option result fail"
  CHECK_RESULT $? 0 0 "-n option result fail"
  CHECK_RESULT $? 0 0 "last --help execute fail"
  CHECK_RESULT $? 0 0 "last --version execute fail"
  CHECK_RESULT $? 0 0 "last username option result fail"
  CHECK_RESULT $? 0 0 "last -x option result fail"
```

- 涉及命令：grep×1, lastb×1, last×1

#### oe_test_lastb

- 描述：Command test-lastb
- 函数：`run_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "default option result failed "
  CHECK_RESULT $? 0 0 "-n option result failed"
  CHECK_RESULT $? 0 0 "-h option result failed"
  CHECK_RESULT $? 0 0 "-V option result failed"
```

- 涉及命令：lastb×3, grep×1

#### oe_test_aureport

- 描述：Command aureport
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 "aureport summary fail"
  CHECK_RESULT $? 0 0 "aureport AVC fail"
  CHECK_RESULT $? 0 0 "aureport Authentication fail"
  CHECK_RESULT $? 0 0 "aureport Event fail"
  CHECK_RESULT $? 0 0 "don't dispaly Summary Report"
  CHECK_RESULT $? 0 0 "don't dispaly Login Report"
  CHECK_RESULT $? 0 0 "don't dispaly Failed Summary Report"
  CHECK_RESULT $? 0 0 "don't dispaly Success Summary Report"
  CHECK_RESULT $? 0 0 "don't dispaly usage"
```

- 涉及命令：aureport×5

#### oe_test_chsh

- 描述：Command test-chsh
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Failed to check the display of help information"
  CHECK_RESULT $? 0 0 "Failed to check shell list"
  CHECK_RESULT $? 0 0 "Shell change failed"
```

- 涉及命令：chsh×4

#### oe_test_lua

- 描述：Use lua case
- 函数：`run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "please reinstall lua"
  CHECK_RESULT $? 0 0 "please Check grammar"
  CHECK_RESULT $? 0 0 "Fail to create hello.lua"
  CHECK_RESULT $? 0 0 "check file hello.lua"
```

- 涉及命令：lua×2

#### oe_test_server_fontconfig

- 描述：外围包-fontconfig-fc-list、fontconfig-fc-match命令
- 函数：`run_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "Failed to view font"
  CHECK_RESULT $? 0 0 "Failed to view font"
  CHECK_RESULT $? 0 0 "Failed to view installed fonts"
  CHECK_RESULT $? 0 0 "Failed to display the font list"
  CHECK_RESULT $? 0 0 "Sorting list display failed"
```

- 涉及命令：fc-match×1

#### oe_test_server_libtasn1

- 描述：Test libtasn1使用
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "File creation failed"
  CHECK_RESULT $? 0 0 "File generation failed"
  CHECK_RESULT $? 0 0 "File creation failed"
  CHECK_RESULT $? 0 0 "File creation failed"
  CHECK_RESULT $? 0 0 "Failed to return the result"
```

- 涉及命令：test×2

#### oe_test_count_gperftools_function

- 描述：gperftools-功能验证
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "File creation failed"
  CHECK_RESULT $? 0 0 "File creation failed"
  CHECK_RESULT $? 0 0 "File creation failed"
  CHECK_RESULT $? 0 0 "File creation failed"
  CHECK_RESULT $? 0 0 "Output failed"
```

- 涉及命令：test×4

#### oe_test_split

- 描述：File system common command split
- 函数：`run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "create fail"
  CHECK_RESULT $? 0 0 "split fail"
  CHECK_RESULT $? 0 0 "Failed to find the file"
  CHECK_RESULT $? 0 0 "Failed to find the file"
  CHECK_RESULT $? 0 0 "merge fail"
  CHECK_RESULT $? 0 0 "Command executed successfully"
```

- 涉及命令：test×2, split×1

#### oe_test_popd_001

- 描述：File system common command popd
- 函数：`run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "create fail"
  CHECK_RESULT $? 0 0 "Failed to pushd the dirs"
  CHECK_RESULT $? 0 0 "Failed to find the dirs"
  CHECK_RESULT $? 0 0 "Failed to find the dirs"
  CHECK_RESULT $? 0 1 "Command executed successfully"
```

#### oe_test_glibc

- 描述：Use glibc case
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "Check glibc version"
  CHECK_RESULT $? 0 0 "Fail to create glibc-version.c"
  CHECK_RESULT $? 0 0 "Error,fail to create a.out"
  CHECK_RESULT $? 0 0 "Error,fail to run a.out"
```

#### oe_test_cairo

- 描述：Use cairo case
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Fail to cairo_test.c"
  CHECK_RESULT $? 0 0 "Error,check the file cairo_test.c"
  CHECK_RESULT $? 0 0 "Error,fail to create cairo_test1"
```

- 涉及命令：gcc×1

#### oe_test_c_stat

- 描述：Use c_stat case
- 函数：`pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $? 0 0 "Fail to create haha.c"
  CHECK_RESULT $? 0 0 "Fail to create teststat.c"
  CHECK_RESULT $? 0 0 "Error,fail to create haha.so"
  CHECK_RESULT $? 0 0 "Error,fail to create teststat"
  CHECK_RESULT $? 0 0 "Error,fail to create teststat64"
  CHECK_RESULT $? 0 0 "Error,check the file teststat"
  CHECK_RESULT $? 0 0 "Error,check the file teststat64"
```

- 涉及命令：gcc×2

#### oe_test_chroot

- 描述：Use chroot case
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "Error,fail to create 'bin' & 'lib' & 'lib64'"
  CHECK_RESULT $? 0 0 "Error,fail to copy /bin/bash to bin/"
  CHECK_RESULT $? 0 0 "Error,fail to copy /lib/ to lib/"
  CHECK_RESULT $? 0 0 "Error,fail to copy /lib64/ to lib64/"
  CHECK_RESULT $? 0 0 "Error,Failed to modify permissions "
```

#### oe_test_history

- 描述：Command test-history
- 函数：`run_test`
- 断言（8 条）：

```
  CHECK_RESULT $? 0 0 "check is in history failed"
  CHECK_RESULT $? 0 1 "clear history command record"
  CHECK_RESULT $? 0 0 "history write file failed"
  CHECK_RESULT $? 0 0 "history write file failed"
  CHECK_RESULT $? 0 0 "history write file failed"
  CHECK_RESULT $? 0 0 "history write file failed"
  CHECK_RESULT $? 0 1 "delete history command record 2"
  CHECK_RESULT $? 0 1 "delete history command record 2 failed"
```

- 涉及命令：history×6, uname×1

#### oe_test_virt-what

- 描述：网络-虚拟化环境检查
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "vrit-what not installed"
  CHECK_RESULT $? 0 0 "Virtualization detection failed"
  CHECK_RESULT $? 0 0 "version display incorrect"
```

- 涉及命令：rpm×1

#### oe_test_gcc_01

- 描述：File system common command test-gcc
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "Warning display failure"
  CHECK_RESULT $? 0 0 "Error display failure"
  CHECK_RESULT $? 0 0 "File does not exist"
  CHECK_RESULT $? 0 0 "gcc version not found"
```

- 涉及命令：gcc×5, test×1

#### oe_test_locate_001

- 描述：File system common command locate
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 1 "Command executed error"
  CHECK_RESULT $? 0 0 "Failed to locate the files"
  CHECK_RESULT $? 0 0 "Failed to locate the files"
  CHECK_RESULT $? 0 1 "Command executed error"
```

- 涉及命令：locate×1

#### oe_test_bzcmp

- 描述：压缩对比工具-bzcmp
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "bzcmp function error"
  CHECK_RESULT $? 0 0 "bzcmp function error"
```

- 涉及命令：bzcmp×1

#### oe_test_unlink

- 描述：删除指定文件-unlink
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 1 "unlink function error"
```

#### oe_test_xzcmp

- 描述：压缩对比工具-xzcmp
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "bzcmp function error"
```

#### oe_test_zgrep

- 描述：压缩文件搜索工具-zgrep
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "zgrep assa error"
  CHECK_RESULT $? 0 0 "zgrep tar.gz error"
  CHECK_RESULT $? 0 0 "zgrep xz error"
  CHECK_RESULT $? 0 0 "zgrep gz error"
```

- 涉及命令：zgrep×3, tar×1, gzip×1, bzip2×1

#### oe_test_server_subversion

- 描述：functional testing subversion
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "Failed to create repos"
  CHECK_RESULT $? 0 0 "Failed to create branch"
  CHECK_RESULT $? 0 0 "Failed to create label"
  CHECK_RESULT $? 0 0 "Import file failed"
  CHECK_RESULT $? 0 0 "Can't find this file"
```

- 涉及命令：mkdir×2

#### oe_test_auditctl_02

- 描述：Test auditctl-查看audit规则并验证规则
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Service startup failed"
  CHECK_RESULT $? 0 0 "Existence rule"
  CHECK_RESULT $? 0 0 "No rules"
```

- 涉及命令：auditctl×4

#### oe_test_bunzip2

- 描述：Use php case
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Error,Can't use bunzip2,please to reinstall bunzip2"
  CHECK_RESULT $? 0 0 "Error,please check test.bz2"
  CHECK_RESULT $? 0 0 "Error,Fail to decompression"
```

- 涉及命令：bzip2×1, bunzip2×1

#### oe_test_zipdetails

- 描述：显示zip文件内部结构-zipdetails
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "zipdetails function error"
  CHECK_RESULT $? 0 0 "zipdetails function error"
  CHECK_RESULT $? 0 0 "zipdetails function error"
  CHECK_RESULT $? 0 0 "zipdetails function error"
  CHECK_RESULT $? 0 0 "zipdetails function error"
```

- 涉及命令：zipdetails×1

#### oe_test_zcat

- 描述：查看压缩文件的内容-zcat
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "zcat function error"
  CHECK_RESULT $? 0 0 "zcat function error"
```

- 涉及命令：zcat×1

#### oe_test_libsecret

- 描述：secret-tool of libsecret basic function
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "store secret fail"
  CHECK_RESULT $? 0 0 "lookup secret fail"
  CHECK_RESULT $? 0 0 "search secret fail"
  CHECK_RESULT $? 0 1 "secret clear fail"
```

#### oe_test_namei

- 描述：列出路径中的成分-namei
- 函数：`run_test`
- 断言（7 条）：

```
  CHECK_RESULT $? 0 0 "namei function error"
  CHECK_RESULT $? 0 0 "namei function error"
  CHECK_RESULT $? 0 0 "namei -l function error"
  CHECK_RESULT $? 0 0 "namei -x function error"
  CHECK_RESULT $? 0 0 "namei -n function error"
  CHECK_RESULT $? 0 0 "namei -v function error"
  CHECK_RESULT $? 0 0 "namei -V function error"
```

- 涉及命令：namei×7

#### oe_test_rev

- 描述：Test rev
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "Execution require1 failure"
```

#### oe_test_uid_old_uid

- 描述：old uid function test
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "Created successfully"
  CHECK_RESULT $? 0 0 "Creation failed, uid is unique"
  CHECK_RESULT $? 0 0 "Modification successfully"
  CHECK_RESULT $? 0 0 "Modification failed, uid is unique"
```

- 涉及命令：useradd×4, userdel×4, grep×2, usermod×2

#### oe_test_python3-kmod

- 描述：Use python3-kmod case
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Error,Fail to modprobe"
  CHECK_RESULT $? 0 0 "Error, Fail to rm"
```

- 涉及命令：python3×2

#### oe_test_lsscsi_1

- 描述：command lsscsi
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "show SCSI universal device file names fail"
  CHECK_RESULT $? 0 0 "show kernel name fail"
  CHECK_RESULT $? 0 0 "show the primary and secondary numbers of device fail"
  CHECK_RESULT $? 0 0 "show the SCSI host currently connected to the system fail"
  CHECK_RESULT $? 0 0 "show the additional information for each SCSI device fail"
```

- 涉及命令：lsscsi×5

#### oe_test_seq

- 描述：Seq formatting test
- 函数：`run_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "seq default print error"
  CHECK_RESULT $? 0 0 "seq -s print error"
  CHECK_RESULT $? 0 0 "seq -w print error"
```

#### oe_test_lsscsi_2

- 描述：command lsscsi
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "show scsi device fail"
  CHECK_RESULT $? 0 0 "show additional Data integrity information fail"
  CHECK_RESULT $? 0 0 "show transmitted information fail"
  CHECK_RESULT $? 0 0 "show additional information fail"
  CHECK_RESULT $? 0 0 "show capacity size fail"
```

- 涉及命令：lsscsi×5

#### oe_test_xargs

- 描述：Xargs formatting test
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "xargs error"
  CHECK_RESULT $? 0 0 "xargs execution error"
```

#### oe_test_lsscsi_3

- 描述：command lsscsi
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "show lun number in hexadecimal fail"
  CHECK_RESULT $? 0 0 "output valid protected mode information fail"
  CHECK_RESULT $? 0 0 "show udev related attributes fail"
  CHECK_RESULT $? 0 0 "show WWN fail"
```

- 涉及命令：lsscsi×4

#### oe_test_uniq

- 描述：Uniq formatting test
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "uniq error"
  CHECK_RESULT $? 0 0 "uniq error"
  CHECK_RESULT $? 0 0 "uniq error"
```

#### oe_test_lsattr

- 描述：Using the lsattr command
- 函数：`run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "Failed to view information"
  CHECK_RESULT $? 0 0 "Unable to view version number information"
  CHECK_RESULT $? 0 0 "Unable to view attribute information"
  CHECK_RESULT $? 0 0 "Unable to view attribute information"
  CHECK_RESULT $? 0 0 "Unable to view attribute information"
  CHECK_RESULT $? 0 0 "No such file or directory"
```

- 涉及命令：lsattr×5, test×1

#### oe_test_indent

- 描述：Using the indent command
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "file does not exist "
  CHECK_RESULT $? 0 0 "file does not exist "
  CHECK_RESULT $? 0 1 "File Indent Failure"
```

- 涉及命令：test×2, indent×2

#### oe_test_xzmore

- 描述：查看xz压缩文本文件-xzmore
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "xzless function error"
```

#### oe_test_bzless

- 描述：查看bzip2压缩过的文本文件-bzless
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "bzless function error"
```

- 涉及命令：tar×1

#### oe_test_true

- 描述：验证 true 命令的返回值、重定向、管道及 shell 控制流行为
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 "true return value error"
  CHECK_RESULT $? 0 1 "true redirection behavior error"
  CHECK_RESULT $? 0 0 "file not exist after redirection"
  CHECK_RESULT $? 1 0 "file should be empty after true redirection"
  CHECK_RESULT $? 1 0 "pipe return value error (true | false)"
  CHECK_RESULT $? 0 0 "pipe return value error (true | true)"
  CHECK_RESULT $? 0 0 "&& logic failed for true"
  CHECK_RESULT $? 1 0 "|| short-circuit failed for true"
  CHECK_RESULT $? 0 1 "mixed logic failed for true"
```

#### oe_test_xzless

- 描述：查看xz压缩文本文件-xzless
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "xzless function error"
```

#### oe_test_zgrep_002

- 描述：压缩文件搜索工具-zgrep
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT "${line}" 4 0 "zgrep function error"
  CHECK_RESULT $? 0 0 "zgrep function error"
```

- 涉及命令：zgrep×1

#### oe_test_fdupes

- 描述：查找相同文件-fdupes
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "fdupes function error"
  CHECK_RESULT $? 0 0 "fdupes function error"
  CHECK_RESULT $? 0 0 "fdupes function error"
  CHECK_RESULT $? 0 0 "fdupes function error"
  CHECK_RESULT $? 0 0 "fdupes function error"
```

- 涉及命令：fdupes×4

#### oe_test_enchant2

- 描述：enchant test
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "check command fail"
  CHECK_RESULT $? 0 0 "Language module detection failed"
  CHECK_RESULT $? 0 0 "check command fail"
  CHECK_RESULT $? 0 0 "check spelling failed"
```

- 涉及命令：enchant-2×3

#### oe_test_hexdump

- 描述：Using the Hexdump command
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "File view failed"
  CHECK_RESULT $? 0 0 "File view failed"
  CHECK_RESULT $? 0 0 "File view failed"
  CHECK_RESULT $? 0 0 "File view failed"
  CHECK_RESULT $? 0 0 "File view failed"
```

- 涉及命令：hexdump×5, grep×1

#### oe_test_logsave

- 描述：Using the logsave command
- 函数：`run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "File view failed"
  CHECK_RESULT $? 0 0 "File view failed"
  CHECK_RESULT $? 0 0 "File view failed"
```

- 涉及命令：logsave×2, grep×1

#### oe_test_brotli_003

- 描述：Command test brotli
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "check test.br  delete faild"
  CHECK_RESULT $? 0 0 "check test.custom  delete faild"
  CHECK_RESULT $? 0 0 "check output.br  delete faild"
```

- 涉及命令：brotli×3, test×3

#### oe_test_libidn

- 描述：libidn编译支持
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "File compilation failed"
```

- 涉及命令：gcc×1

#### oe_test_ld

- 描述：ld command test
- 函数：`pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT "$?" 0 0 "faild to generate object file: ${i}.o"
  CHECK_RESULT "$?" 0 0 "Missing file not report."
  CHECK_RESULT $? 0 0 "Shared library build failed."
  CHECK_RESULT $? 0 0 "Shared library build failed with -Bdynamic"
  CHECK_RESULT $? 0 1 "Static link of dynamic object succeed unexpectly."
  CHECK_RESULT $? 0 0 "Shared library build failed with -Bdynamic"
  CHECK_RESULT $? 0 1 "Static link of dynamic object succeed unexpectly."
```

- 涉及命令：gcc×1

#### oe_test_dirname

- 描述：去除文件名中的非目录部分-dirname
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "dirname function error"
  CHECK_RESULT $? 0 0 "dirname function error"
  CHECK_RESULT $? 0 0 "dirname function error"
```

#### oe_test_tty

- 描述：TTY formatting test
- 函数：`run_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "tty error"
```

#### oe_test_get_module

- 描述：获取模块信息-get_module
- 函数：`run_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 1 "modinfo function error"
  CHECK_RESULT $? 0 0 "modinfo function error"
  CHECK_RESULT $? 0 1 "modinfo function error"
  CHECK_RESULT $? 0 0 "modinfo function error"
  CHECK_RESULT $? 0 0 "modinfo function error"
  CHECK_RESULT $? 0 0 "modinfo function error"
  CHECK_RESULT $? 0 0 "modinfo function error"
  CHECK_RESULT $? 0 0 "modinfo function error"
  CHECK_RESULT $? 0 0 "modinfo function error"
  CHECK_RESULT $? 0 0 "modinfo function error"
```

#### oe_test_gzexe

- 描述：压缩执行文件-gzexe
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 1 0 "gzexe function error"
  CHECK_RESULT $? 0 0 "gzexe function error"
```

- 涉及命令：gzexe×1

#### oe_test_strings

- 描述：strings查找可打印的字符串
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "gzexe function error"
  CHECK_RESULT $? 0 0 "gzexe function error"
```

- 涉及命令：strings×1

#### oe_test_zramctl

- 描述：Test zramctl function
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "zramctl error1"
  CHECK_RESULT $? 0 0 "zramctl error2"
  CHECK_RESULT $? 0 0 "zramctl error3"
```

- 涉及命令：modprobe×1

#### oe_test_znew

- 描述：Test znew function
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "znew error1"
  CHECK_RESULT $? 0 0 "znew error2"
  CHECK_RESULT $? 0 0 "znew error3"
```

- 涉及命令：gzip×2

#### oe_test_zegrep

- 描述：Test zegrep function
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT "${line}" 5 0 "zegrep function error"
  CHECK_RESULT $? 0 0 "zegrep function error"
```

- 涉及命令：zegrep×1

#### oe_test_arp

- 描述：command arp
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "show arp help fail"
  CHECK_RESULT $? 0 0 "display (all) hosts in alternative (BSD) style fail"
  CHECK_RESULT $? 0 0 "don't resolve names fail"
  CHECK_RESULT $? 0 0 "be verbose fail"
```

- 涉及命令：arp×4

#### oe_test_strace

- 描述：command strace
- 函数：`pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $? 0 0 "show version fail"
  CHECK_RESULT $? 0 0 "show help fail"
  CHECK_RESULT $? 0 0 "tracking cmd ls fail"
  CHECK_RESULT $? 0 0 "tracking the concise results fail"
  CHECK_RESULT $? 0 0 "check openat2 call type fail"
  CHECK_RESULT $? 0 0 "check openat2 call type with time fail"
  CHECK_RESULT $? 0 0 "output the tracking result to the file fail"
```

- 涉及命令：strace×6

#### oe_test_tac

- 描述：反向输出文件内容-tac
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "tac function error"
```

#### oe_test_lshw

- 描述：command lshw
- 函数：`run_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 "show lshw version fail"
  CHECK_RESULT $? 0 0 "show hardware info with html format fail"
  CHECK_RESULT $? 0 0 "show hardware info with json format fail"
  CHECK_RESULT $? 0 0 "show hardware info with xml format fail"
  CHECK_RESULT $? 0 0 "show hardware info with brief mode fail "
  CHECK_RESULT $? 0 0 "show bus info fail"
  CHECK_RESULT $? 0 0 "show memory info fail"
  CHECK_RESULT $? 0 0 "show cpu info fail"
  CHECK_RESULT $? 0 0 "show disk info fail"
```

- 涉及命令：lshw×9

#### oe_test_csplit_01

- 描述：csplit case
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0  0 "The return value is not 2"
  CHECK_RESULT $? 0 0 "The return value is not 3"
  CHECK_RESULT $? 0 0 "The return value is not 1"
```

- 涉及命令：csplit×3, test×3, mkdir×1

#### oe_test_zipnote

- 描述：Test zipnote function
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "zipnote error"
  CHECK_RESULT "${num}" 3 0 "zipnote function error"
```

- 涉及命令：zipnote×1

#### oe_test_join

- 描述：连接两个文件-join
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "join function error"
  CHECK_RESULT $? 0 0 "join function error"
  CHECK_RESULT $? 0 0 "join function error"
```

- 涉及命令：join×3

#### oe_test_genisoimage

- 描述：创建映像文件-genisoimage
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "genisoimage function error"
```

- 涉及命令：genisoimage×1

#### oe_test_zfgrep

- 描述：Test zfgrep function
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT "${line}" 6 0 "zfgrep function error"
  CHECK_RESULT $? 0 0 "zfgrep function error"
```

- 涉及命令：zfgrep×1

#### oe_test_bzgrep

- 描述：压缩文件搜索工具-bzgrep
- 函数：`pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $? 0 0 "bzgrep function error"
  CHECK_RESULT $? 0 0 "ABC not found"
  CHECK_RESULT $? 0 0 "Failed to return line number"
  CHECK_RESULT $? 0 0 "Query failure"
  CHECK_RESULT $? 0 0 "Query failure"
  CHECK_RESULT "$nums" 2 0 "Query failure"
  CHECK_RESULT "$result" "" 0 "Query failure"
```

- 涉及命令：bzgrep×4

#### oe_test_ipcs

- 描述：ipcs formatting test
- 函数：`run_test`
- 断言（15 条）：

```
  CHECK_RESULT $? 0 0 "ipcs default print error"
  CHECK_RESULT $? 0 0 "ipcs default print error"
  CHECK_RESULT $? 0 0 "ipcs default print error"
  CHECK_RESULT $? 0 0 "ipcs -a execution failure"
  CHECK_RESULT $? 0 0 "ipcs -all execution failure"
  CHECK_RESULT $? 0 0 "ipcs -m execution failure"
  CHECK_RESULT $? 0 0 "ipcs -h execution failure"
  CHECK_RESULT $? 0 0 "ipcs -V execution failure"
  CHECK_RESULT $? 0 0 "ipcs -q execution failure"
  CHECK_RESULT $? 0 0 "ipcs -s execution failure"
  CHECK_RESULT $? 0 0 "ipcs -r execution failure"
  CHECK_RESULT $? 0 0 "ipcs -p execution failure"
  ... 共 15 条（其余见源脚本）
```

- 涉及命令：ipcs×12, grep×3

#### oe_test_nl

- 描述：nl formatting test
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "nl  print error"
  CHECK_RESULT $? 0 0 "nl  print error"
  CHECK_RESULT $? 0 0 "nl  print error"
  CHECK_RESULT $? 1 0 "nl  print error"
  CHECK_RESULT $? 1 0 "nl  print error"
```

#### oe_test_nice

- 描述：nice formatting test
- 函数：`run_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "nice set error"
  CHECK_RESULT $? 0 0 "nice set error"
  CHECK_RESULT $? 0 0 "nice set error"
  CHECK_RESULT $? 0 0 "nice set error"
```

- 涉及命令：nice×1

#### oe_test_libuv

- 描述：Basic functional verification of libuv
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 " File generation failed"
  CHECK_RESULT $? 0 0 " File generation failed"
  CHECK_RESULT $? 0 0 "Execution failed"
```

- 涉及命令：test×2

#### oe_test_systemd_analyze

- 描述：Supports logging of device information
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "systemd-analyze execution failed"
  CHECK_RESULT $? 0 0 "critical-chain execution failed"
  CHECK_RESULT $? 0 0 "blame execution failed"
  CHECK_RESULT $? 0 0 "plot execution failed"
```

#### oe_test_readlink

- 描述：Command test-readlink
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "cmd readlink error"
  CHECK_RESULT $? 0 0 "cmd readlink -e error"
  CHECK_RESULT $? 0 1 "cmd readlink -e error"
  CHECK_RESULT $? 0 0 "cmd readlink -f error"
```

- 涉及命令：readlink×3, mkdir×1

#### oe_test_ul_001

- 描述：Encrypt and decrypt zip
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "ul is failed!"
```

#### oe_test_lscpu

- 描述：command lscpu
- 函数：`run_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 "shou cpu info fail"
  CHECK_RESULT $? 0 0 "show version fail"
  CHECK_RESULT $? 0 0 "print extension fail"
  CHECK_RESULT $? 0 0 "show info about a specified CPU column fail"
  CHECK_RESULT $? 0 0 "show number of logical cores fail"
  CHECK_RESULT $? 0 0 "show logical NUMA node number fail"
  CHECK_RESULT $? 0 0 "show CPU physical addres fail"
  CHECK_RESULT $? 0 0 "show maximum CPU frequency fail"
  CHECK_RESULT $? 0 0 "print both online and offline cpus fail"
```

- 涉及命令：lscpu×8

#### oe_test_lsmem_1

- 描述：command lscmem
- 函数：`pre_test, run_test`
- 断言（7 条）：

```
  CHECK_RESULT $? 0 0 "show version"
  CHECK_RESULT $? 0 0 "output with JSON format"
  CHECK_RESULT $? 0 0 "output with key of value"
  CHECK_RESULT $? 0 0 "list each individual memory block"
  CHECK_RESULT $? 0 0 "prints SIZE in bytes"
  CHECK_RESULT $? 0 0 "does not print headings"
  CHECK_RESULT $? 0 0 "use the native output format"
```

- 涉及命令：lsmem×7

#### oe_test_yumdownloader

- 描述：Test yumdownloader function
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "download error"
  CHECK_RESULT "${num}" 1 0 0 "download error"
```

- 涉及命令：mkdir×1

#### oe_test_lsmem_2

- 描述：command lscmem
- 函数：`pre_test, run_test`
- 断言（7 条）：

```
  CHECK_RESULT $? 0 0 "with start and end address of the memory range to print"
  CHECK_RESULT $? 0 0 "wirh size of the memory range  to print"
  CHECK_RESULT $? 0 0 "wirh online status of the memory range  to print"
  CHECK_RESULT $? 0 0 "wirh removable to print"
  CHECK_RESULT $? 0 0 "wirh memory block number or blocks range to print"
  CHECK_RESULT $? 0 0 "wirh numa node of memory to print"
  CHECK_RESULT $? 0 0 "wirh valid zones for the memory range to print"
```

- 涉及命令：lsmem×7

#### oe_test_fallocate

- 描述：Command test-cal
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0  "check file.txt exist"
  CHECK_RESULT $? 0 0  "check file.txt failed"
  CHECK_RESULT $? 0 0  "check file.txt 610M failed"
  CHECK_RESULT $? 0 0  "disply help failed"
  CHECK_RESULT $? 0 0  "check fallocate verison failed"
```

- 涉及命令：fallocate×4, test×1

#### oe_test_xzgrep

- 描述：Test zfgrep function
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "xzgrep function error"
  CHECK_RESULT "${line}" 5 0 "xzgrep function error"
```

#### oe_test_sfdisk

- 描述：Disk partition management tool
- 函数：`run_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Label not found"
  CHECK_RESULT $? 0 0 "Search for 'disk' failed"
```

- 涉及命令：sfdisk×2

#### oe_test_lsmem_3

- 描述：command lsmem
- 函数：`pre_test, run_test`
- 断言（7 条）：

```
  CHECK_RESULT $? 0 0 "with start and end address of the memory range to split"
  CHECK_RESULT $? 0 0 "wirh size of the memory range to split"
  CHECK_RESULT $? 0 0 "wirh online status of the memory range to split"
  CHECK_RESULT $? 0 0 "wirh removable to split"
  CHECK_RESULT $? 0 0 "wirh memory block number or blocks range to split"
  CHECK_RESULT $? 0 0 "wirh numa node of memory to split"
  CHECK_RESULT $? 0 0 "wirh valid zones for the memory range to split"
```

- 涉及命令：lsmem×7

#### oe_test_lscpu_2

- 描述：command lscpu
- 函数：`run_test`
- 断言（7 条）：

```
  CHECK_RESULT $? 0 0 "only print online cpus fail"
  CHECK_RESULT $? 0 0 "only print offline cpu fail"
  CHECK_RESULT $? 0 0 "print sizes in bytes fail"
  CHECK_RESULT $? 0 0 "show info about caches fail"
  CHECK_RESULT $? 0 0 "show info using JSON for default fail"
  CHECK_RESULT $? 0 0 "print the hexadecimal mask fail"
  CHECK_RESULT $? 0 0 "print physical ID fail"
```

- 涉及命令：lscpu×7

#### oe_test_mkfifo

- 描述：mkfifo命令 – 创建FIFO文件
- 函数：`run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "mkfifo function error"
  CHECK_RESULT $? 0 0 "mkfifo function error"
```

#### oe_test_lspci

- 描述：command lspci
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "show pci device info fail"
  CHECK_RESULT $? 0 0 "show device manufacturer and device ID fail"
  CHECK_RESULT $? 0 0 "show device driver info fail"
  CHECK_RESULT $? 0 0 "show device driver module info fail"
  CHECK_RESULT $? 0 0 "show device connection relationship info fail"
  CHECK_RESULT $? 0 0 "show pci device detail info fail"
```

- 涉及命令：lspci×5, grep×1

#### oe_test_bzcat

- 描述：bzcat命令 – 读取bzip2压缩文件的内容
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "bzcat function error"
```

- 涉及命令：bzip2×1

#### oe_test_zipinfo

- 描述：zipinfo命令 – 查看压缩文件信息
- 函数：`pre_test, run_test, post_test`
- 断言（13 条）：

```
  CHECK_RESULT $? 0 0 "zipinfo function error"
  CHECK_RESULT $? 0 0 "zipinfo function error"
  CHECK_RESULT $? 0 0 "bytes function error"
  CHECK_RESULT $? 0 0 "uncompressd function error"
  CHECK_RESULT $? 0 0 "zipinfo -l command execution failure"
  CHECK_RESULT $? 0 0 "zipinfo -v command execution failure"
  CHECK_RESULT $? 0 0 "zipinfo -l command execution failure"
  CHECK_RESULT $? 0 0 "zipinfo -z command execution failure"
  CHECK_RESULT $? 0 0 "zipinfo -C command execution failure"
  CHECK_RESULT $? 0 0 "zipinfo -t command execution failure"
  CHECK_RESULT $? 0 0 "zipinfo -M paging failed"
  CHECK_RESULT $? 0 0 "zipinfo -T timestamp format mismatch"
  ... 共 13 条（其余见源脚本）
```

- 涉及命令：zipinfo×12

#### oe_test_gunzip

- 描述：gunzip命令 – 解压提取文件内容
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "gunzip function error"
  CHECK_RESULT $? 0 0  "check test123.txt exist"
  CHECK_RESULT $? 0 0  "check test3.txt.gz test3.txt exist"
```

- 涉及命令：gunzip×3

#### oe_test_split_01

- 描述：split case
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0  0 "The return value is not 1"
  CHECK_RESULT $? 0 0 "The return value is not 2"
  CHECK_RESULT $? 0 0 "The return value is not 3"
```

- 涉及命令：split×3, test×3, mkdir×1

#### oe_test_getent

- 描述：getent命令 – 查看系统数据库中的记录信息
- 函数：`run_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 "getent function error"
  CHECK_RESULT $? 0 0 "getent function error"
  CHECK_RESULT $? 0 0 "command execution failed"
  CHECK_RESULT $? 0 0 "root group query failed"
  CHECK_RESULT $? 0 0 "version query failed"
  CHECK_RESULT $? 0 0 "help query failed"
  CHECK_RESULT $? 0 0 "nobody user query failed"
  CHECK_RESULT $? 0 0 "ssh service query failed"
  CHECK_RESULT $? 0 0 "loopback network query failed"
```

#### oe_test_fincore

- 描述：Fincore
- 函数：`pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $? 0 0 "fincore is failed!"
  CHECK_RESULT $? 0 0 "fincore function error"
  CHECK_RESULT $? 0 0 "fincore function error"
  CHECK_RESULT $? 0 0 "fincore function error"
  CHECK_RESULT $? 0 0 "fincore function error"
  CHECK_RESULT $? 0 0 "fincore verison error"
  CHECK_RESULT $? 0 0  "fincore help failed"
```

- 涉及命令：fincore×6

#### oe_test_udisksctl

- 描述：Command test-cal
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "check udisksctl inifo failed"
  CHECK_RESULT $? 0 0  "check udisks_status failed"
```

#### oe_test_c++_stl

- 描述：test c++ stl
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Error, fail to create teststl.cpp"
  CHECK_RESULT $? 0 0 "Error, fail to create teststl"
```

#### oe_test_fallocate_01

- 描述：Command test-fallocate
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0  "check test1.txt 100M failed"
  CHECK_RESULT $? 0 0  "check test2.txt 100M failed"
  CHECK_RESULT $? 0 0  "fallocate failed to execute"
  CHECK_RESULT $? 0 0  "check test2.txt failed"
  CHECK_RESULT $? 0 0  "check test2.txt 100M failed"
```

- 涉及命令：fallocate×5

#### oe_test_lslocks

- 描述：command lslocks
- 函数：`run_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "display help fail"
  CHECK_RESULT $? 0 0 "print version fail"
  CHECK_RESULT $? 0 0 "list information about all the currently held file locks fail"
  CHECK_RESULT $? 0 0 "print the sizes in bytes fail"
  CHECK_RESULT $? 0 0 "ignore lock files which are inaccessible for the current user fail"
```

- 涉及命令：lslocks×4, grep×1

#### oe_test_brotli_002

- 描述：Command test brotli -v -n
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 1 "check test.tar  delete faild"
  CHECK_RESULT $? 1 0 "check brotli without -v failed"
  CHECK_RESULT "${pre_sta}" "${after_sta}" 0 "check test.tar attr without -n failed"
  CHECK_RESULT "${after_sta}" "${after_sta_n}" 1 "check test.tar attr with -n failed"
  CHECK_RESULT $? 0 0 "check test.tar compression successful"
  CHECK_RESULT $? 0 0 "check brotli -v failed"
```

- 涉及命令：brotli×2, test×2

#### oe_test_lslocks_2

- 描述：command lslocks
- 函数：`run_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "use JSON output format fail"
  CHECK_RESULT $? 0 0 "do not print a header line fail"
  CHECK_RESULT $? 0 0 "output all available columns fail"
  CHECK_RESULT $? 0 0 "use the raw output format fail"
  CHECK_RESULT $? 0 0 "do not truncate text in columns fail"
```

- 涉及命令：lslocks×4

#### oe_test_lslogins_1

- 描述：command lslogins
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "display this help fail"
  CHECK_RESULT $? 0 0 "display version fail"
  CHECK_RESULT $? 0 0 "display user accounts fail"
  CHECK_RESULT $? 0 0 "display data about the date of last password change and the account expiration date fail"
  CHECK_RESULT $? 0 0 "use a colon instead of a newline fail"
```

- 涉及命令：lslogins×5, userdel×1

#### oe_test_more

- 描述：Fincore
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "more +6 is failed!"
  CHECK_RESULT $? 0 0 "more +20 is failed!"
  CHECK_RESULT $? 0 0 "more +30 is failed!"
```

#### oe_test_lslogins_2

- 描述：command lslogins02
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "output data in the format of NAME=VALUE fail"
  CHECK_RESULT $? 0 0 "display data about the user's last failed login attempts fail"
  CHECK_RESULT $? 0 0 "show information about supplementary groups fail"
  CHECK_RESULT $? 0 0 "display data containing information about the user's last login sessions fail"
  CHECK_RESULT $? 0 0 "only show data of users with a login specified fail"
```

- 涉及命令：lslogins×5, userdel×1

#### oe_test_column

- 描述：column命令-输入格式化为多个列
- 函数：`run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "column function error"
  CHECK_RESULT $? 0 0 "Column alignment failed. Expected: '$expected', Got: '$actual'"
  CHECK_RESULT "$line_count" 3 0 "Multi-line processing failed"
```

#### oe_test_lslogins_3

- 描述：command lslogins03
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "display each piece of information on a new line fail"
  CHECK_RESULT $? 0 0 "display information related to login by password fail"
  CHECK_RESULT $? 0 0 "raw output with no columnation fail"
  CHECK_RESULT $? 0 0 "show system accounts fail"
  CHECK_RESULT $? 0 0 "display SELinux contexts fail"
  CHECK_RESULT $? 0 0 "delimit user entries with a nul character fail"
```

- 涉及命令：lslogins×6

#### oe_test_xrandr

- 描述：Adjusting screen resolution, orientation, and multi-screen settings, among other functions.
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Screen not found"
  CHECK_RESULT $? 0 0 "No connected display found"
  CHECK_RESULT $? 0 0 "Failed to query current resolution of ${output}"
```

- 涉及命令：xrandr×1

#### oe_test_as

- 描述：Test gnu as
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "assemble failed." 1
  CHECK_RESULT $? 0 0 "link failed." 1
  CHECK_RESULT $? 0 0 "./hello execution run failed."
```

#### oe_test_lslogins_4

- 描述：command lslogins04
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 "output columns user name"
  CHECK_RESULT $? 0 0 "output columns user ID"
  CHECK_RESULT $? 0 0 "output columns full user name"
  CHECK_RESULT $? 0 0 "output columns home directory"
  CHECK_RESULT $? 0 0 "output columns login shell"
  CHECK_RESULT $? 0 0 "output columns log in disabled by nologin(8) or pam_nologin(8)
  CHECK_RESULT $? 0 0 "output columns password defined, but locked"
  CHECK_RESULT $? 0 0 "output columns password not defined"
  CHECK_RESULT $? 0 0 "output columns login by password disabled"
```

- 涉及命令：lslogins×9

#### oe_test_zstd01

- 描述：function verification
- 函数：`pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $? 0 0 "check -l option fail"
  CHECK_RESULT $? 0 0  "check file2.zst exist fail"
  CHECK_RESULT $? 0 0 "check file3.zst exist fail"
  CHECK_RESULT $? 1 0 "check file3 exist fail"
  CHECK_RESULT $? 1 0 "check file3 exist fail"
  CHECK_RESULT $? 0 0 "check file2 exist fail after decompress"
  CHECK_RESULT $? 0 0 "check -V option fail"
```

- 涉及命令：test×5, zstd×4, mkdir×2

#### oe_test_lslogins_5

- 描述：command lslogins05
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 "output columns password encryption method"
  CHECK_RESULT $? 0 0 "output columns primary group name"
  CHECK_RESULT $? 0 0 "output columns primary group ID"
  CHECK_RESULT $? 0 0 "output columns supplementary group names"
  CHECK_RESULT $? 0 0 "output columns supplementary group IDs"
  CHECK_RESULT $? 0 0 "output columns date of last login"
  CHECK_RESULT $? 0 0 "output columns last tty used"
  CHECK_RESULT $? 0 0 "output columns hostname during the last session"
  CHECK_RESULT $? 0 0 "output columns date of last failed login"
```

- 涉及命令：lslogins×9

#### oe_test_zipgrep

- 描述：zipgrep formatting test
- 函数：`pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $? 0 0 "zipgrep error"
  CHECK_RESULT $? 0 0 "zipgrep error"
  CHECK_RESULT $? 0 0 "Line number display failed"
  CHECK_RESULT $? 0 0 "count failed"
  CHECK_RESULT $? 0 0 "Empty pattern should match all lines"
  CHECK_RESULT $? 0 0 "Inverse match (-v) failed"
  CHECK_RESULT $? 0 0 "Show filename only (-l) failed"
  CHECK_RESULT $? 0 0 "Hide filename (-h) failed"
```

- 涉及命令：zipgrep×6

#### oe_test_lslogins_6

- 描述：command lslogins06
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 "where did the login fail"
  CHECK_RESULT $? 0 0 "user's hush settings"
  CHECK_RESULT $? 0 0 "days user is warned of password expiration"
  CHECK_RESULT $? 0 0 "date of last password change"
  CHECK_RESULT $? 0 0 "number of days required between changes"
  CHECK_RESULT $? 0 0 "max number of days a password may remain unchanged"
  CHECK_RESULT $? 0 0 "password expiration date"
  CHECK_RESULT $? 0 0 "the user's security context"
  CHECK_RESULT $? 0 0 "number of processes run by the user"
```

- 涉及命令：lslogins×9

#### oe_test_zforce

- 描述：zforce formatting test
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 "zforce error"
  CHECK_RESULT $? 0 0 "zforce error"
  CHECK_RESULT $? 0 0 "zforce error"
  CHECK_RESULT $? 0 0 "zforce error"
  CHECK_RESULT $? 0 0 "Failed to process .bz2 file"
  CHECK_RESULT $? 0 0 "Bz2.gz file not created"
  CHECK_RESULT $? 0 0 "Error handling existing .gz file"
  CHECK_RESULT $? 0 0 "Incorrectly double-compressed .gz file"
  CHECK_RESULT $? 0 0 "zforce verison check failed"
```

- 涉及命令：tar×1, bzip2×1

#### oe_test_lssubsys

- 描述：command lssubsys
- 函数：`pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $? 0 0 "Display information of all mounted controllers"
  CHECK_RESULT $? 0 0 "Display  help"
  CHECK_RESULT $? 0 0 "Display information about all controllers (including not mounted ones) "
  CHECK_RESULT $? 0 0 "Display information about hierarchies"
  CHECK_RESULT $? 0 0 "Display mount points"
  CHECK_RESULT $? 0 0 "Display all mount points"
  CHECK_RESULT $? 0 0 "Display the hierarchical information of all controllers"
  CHECK_RESULT $? 0 0 "Display the mount points of all controllers and the information of all mount points"
```

- 涉及命令：lssubsys×7

#### oe_test_zdiff

- 描述：zdiff formatting test
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 1 "zipgrep error"
  CHECK_RESULT $? 0 0 "zipgrep error"
  CHECK_RESULT $? 0 2 "Mixed comparison failed"
  CHECK_RESULT $? 0 0 "Help output missing"
  CHECK_RESULT $? 0 0 "Version check failed"
  CHECK_RESULT $? 0 0 "Recursive compare failed"
```

- 涉及命令：mkdir×1, zdiff×1

#### oe_test_ab_1

- 描述：command ab
- 函数：`pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $? 0 0 "Execute basic benchmark test"
  CHECK_RESULT $? 0 0 "Test concurrent requests"
  CHECK_RESULT $? 0 0 "Test Content-Type option"
  CHECK_RESULT $? 0 0 "Test KeepAlive option"
  CHECK_RESULT $? 0 0 "Test verbose output"
  CHECK_RESULT $? 0 0 "Test time limit option"
  CHECK_RESULT $? 0 1 "Handle invalid host error"
  CHECK_RESULT $? 0 1 "Handle invalid option error"
```

#### oe_test_ab_2

- 描述：command ab02
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "Test -s option (timeout)"
  CHECK_RESULT $? 0 0 "Test -b option (TCP buffer size)"
  CHECK_RESULT $? 0 0 "Test -B option (bind address)"
  CHECK_RESULT $? 0 0 "Test -p option (POST data)"
  CHECK_RESULT $? 0 0 "Test -u option (PUT data)"
  CHECK_RESULT $? 0 0 "Test -v option (verbosity)"
```

- 涉及命令：mkdir×1

#### oe_test_ab_3

- 描述：command ab03
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "Test -w option (HTML output)"
  CHECK_RESULT $? 0 0 "Test -i option (HEAD request)"
  CHECK_RESULT $? 0 0 "Test -x option (table attributes)"
  CHECK_RESULT $? 0 0 "Test -y option (tr attributes)"
  CHECK_RESULT $? 0 0 "Test -z option (td/th attributes)"
```

- 涉及命令：mkdir×1

#### oe_test_ab_4

- 描述：command ab04
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "Test -C option (cookie)"
  CHECK_RESULT $? 0 0 "Test -H option (custom header)"
  CHECK_RESULT $? 0 0 "Test -V option (version info)"
  CHECK_RESULT $? 0 0 "Test -d option (disable percentiles table)"
  CHECK_RESULT $? 0 0 "Test -S option (disable confidence estimators)"
  CHECK_RESULT $? 0 0 "Test -q option (disable progress)"
```

- 涉及命令：mkdir×1

#### oe_test_zcmp

- 描述：zcmp formatting test
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 1 "zipgrep error"
  CHECK_RESULT $? 0 0 "zipgrep error"
```

- 涉及命令：tar×3

#### oe_test_xxd

- 描述：xxd formatting test
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "test xxd error"
  CHECK_RESULT $? 0 0 "test xxd error"
  CHECK_RESULT $? 0 0 "xxd column setting failed"
  CHECK_RESULT $? 0 0 "xxd binary output failed"
  CHECK_RESULT $? 0 0 "xxd endianness setting failed"
```

#### oe_test_xmlwf

- 描述：xmlwf formatting test
- 函数：`pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $? 0 0 "xmlwf error"
  CHECK_RESULT $? 0 0 "xmlwf error"
  CHECK_RESULT $? 0 0 "xmlwf namespace bad  processing failed"
  CHECK_RESULT $? 0 0 "xmlwf namespace good processing failed"
  CHECK_RESULT $? 0 0 "xmlwf external DTD bad processing failed"
  CHECK_RESULT $? 0 0 "xmlwf external DTD good processing failed"
  CHECK_RESULT $? 0 0 "xmlwf external entities bad processing failed"
  CHECK_RESULT $? 0 0 "xmlwf external entities good processing failed"
```

- 涉及命令：xmlwf×6

#### oe_test_ab_5

- 描述：command ab05
- 函数：`pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $? 0 0 "Test -l option (variable document length)"
  CHECK_RESULT $? 0 0 "Test -g option (gnuplot output)"
  CHECK_RESULT $? 0 0 "Verify gnuplot output format"
  CHECK_RESULT $? 0 0 "Test -e option (CSV output)"
  CHECK_RESULT $? 0 0 "Verify CSV output format"
  CHECK_RESULT $? 0 0 "Test -r option (ignore socket errors)"
  CHECK_RESULT $? 0 0 "Test -m option (HTTP method)"
```

#### oe_test_xmllint

- 描述：xmllint formatting test
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 1 0 "xmllint error"
  CHECK_RESULT $? 0 0 "xmllint error"
  CHECK_RESULT $? 0 0 "xmllint format output"
  CHECK_RESULT $? 0 0 "xmllint noblanks output"
  CHECK_RESULT $? 0 0 "xmllint noent option"
```

#### oe_test_usb-devices

- 描述：usb-devices formatting test
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "usb-devices error"
  CHECK_RESULT $? 0 0 "usb-devices error"
  CHECK_RESULT $? 0 0 "usb-devices error"
  CHECK_RESULT $? 0 0 "usb-devices error"
  CHECK_RESULT $? 0 0 "usb-devices error"
  CHECK_RESULT $? 0 0 "usb-devices error"
```

#### oe_test_xml2-config

- 描述：xml2-config formatting test
- 函数：`pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $? 0 0 "xml2-config error"
  CHECK_RESULT $? 0 0 "xml2-config error"
  CHECK_RESULT $? 0 0 "xml2-config modules returned invalid value"
  CHECK_RESULT $? 0 0 "xml2-config prefix failed"
  CHECK_RESULT $? 0 0 "xml2-config exec-prefix failed"
  CHECK_RESULT $? 0 0 "xml2-config version format error"
  CHECK_RESULT $? 0 0 "xml2-config help failed"
```

#### oe_test_certtool_1

- 描述：Command certtool01
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "Certificate info test failed"
  CHECK_RESULT $? 0 0 "Public key info test failed"
  CHECK_RESULT $? 0 0 "Fingerprint test failed"
  CHECK_RESULT $? 0 0 "Key ID test failed"
  CHECK_RESULT $? 0 0 "Self-signed cert generation failed"
```

- 涉及命令：mkdir×1

#### oe_test_certtool_2

- 描述：Command certtool02
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "Certificate request info failed"
  CHECK_RESULT $? 0 0 "PKCS#12 generation failed"
  CHECK_RESULT $? 0 0 "PKCS#12 info failed"
  CHECK_RESULT $? 0 0 "Private key info failed"
```

- 涉及命令：mkdir×1

#### oe_test_certtool_3

- 描述：Command certtool03
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "EC key generation failed"
  CHECK_RESULT $? 0 0 "CRL generation failed"
  CHECK_RESULT $? 0 0 "CRL info failed"
  CHECK_RESULT $? 0 0 "RSA key generation failed"
```

- 涉及命令：mkdir×1

#### oe_test_update-crypto-policies

- 描述：update-crypto-policies formatting test
- 函数：`pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $? 0 0 "update-crypto-policies error"
  CHECK_RESULT $? 0 0 "update-crypto-policies error"
  CHECK_RESULT $? 0 0 "update-crypto-policies error"
  CHECK_RESULT $? 0 0 "Crypto policy is not applied"
  CHECK_RESULT $? 0 0 "Crypto policy files do not match"
  CHECK_RESULT $? 0 0 "update-crypto-policies set LEGACY with no-reload failed"
  CHECK_RESULT $? 0 0 "update-crypto-policies help failed"
```

#### oe_test_certtool_4

- 描述：Command certtool04
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "PKCS#7 generation failed"
  CHECK_RESULT $? 0 0 "PKCS#7 info failed"
  CHECK_RESULT $? 0 0 "DH params test failed"
  CHECK_RESULT $? 0 0 "Version test failed"
  CHECK_RESULT $? 0 0 "Help test failed"
```

- 涉及命令：mkdir×1

#### oe_test_certutil

- 描述：Command certutil test
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "Failed to create new database (-N)"
  CHECK_RESULT $? 0 0 "Failed to generate key pair (-G)"
  CHECK_RESULT $? 0 0 "Failed to add certificate (-A)"
  CHECK_RESULT $? 0 0 "Failed to add email certificate (-E)"
```

- 涉及命令：certutil×3, mkdir×1

#### oe_test_unzstd

- 描述：unzstd formatting test
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 "unzstd error"
  CHECK_RESULT $? 0 0 "unzstd error"
  CHECK_RESULT $? 0 0 "unzstd -k error"
  CHECK_RESULT $? 0 0 "unzstd -k keep error"
  CHECK_RESULT $? 0 0 "unzstd -f error"
  CHECK_RESULT $? 0 0 "unzstd -f overwrite error"
  CHECK_RESULT $? 0 0 "unzstd -o error"
  CHECK_RESULT $? 0 0 "unzstd -o output file error"
  CHECK_RESULT $? 0 0 "unzstd -o content error"
```

- 涉及命令：unzstd×3, grep×2, mkdir×1

#### oe_test_unpigz

- 描述：unpigz formatting test
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "unpigz error"
  CHECK_RESULT $? 0 0 "unpigz error"
  CHECK_RESULT $? 0 0 "unpigz error"
```

#### oe_test_type

- 描述：type formatting test
- 函数：`run_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "type error"
  CHECK_RESULT $? 0 0 "type error"
  CHECK_RESULT $? 0 0 "type error"
  CHECK_RESULT $? 0 0 "type -a error"
  CHECK_RESULT $? 0 0 "type -f error"
  CHECK_RESULT $? 0 0 "type -P error"
```

- 涉及命令：type×5

#### oe_test_corelist_1

- 描述：Command corelist test01
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "Failed to list Perl versions (-v)"
  CHECK_RESULT $? 0 0 "Failed to query Data::Dumper module"
  CHECK_RESULT $? 0 0 "Failed to list all versions of Data::Dumper (-a)"
  CHECK_RESULT $? 0 0 "Failed to find first release by date (-d)"
  CHECK_RESULT $? 0 0 "Failed to query modules by regex"
```

- 涉及命令：corelist×3, mkdir×1

#### oe_test_corelist_2

- 描述：Command corelist test02
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "Failed to list modules for specific Perl version (-v version)"
  CHECK_RESULT $? 0 0 "Failed to query module for specific Perl version"
  CHECK_RESULT $? 0 0 "Failed to list Perl release dates (-r)"
  CHECK_RESULT $? 0 0 "Failed to get release date for specific version (-r version)"
  CHECK_RESULT $? 0 0 "Failed to display help (-?)"
```

- 涉及命令：corelist×4, mkdir×1

#### oe_test_corelist_3

- 描述：Command corelist test03
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "Failed to query utility program (--utils)"
  CHECK_RESULT $? 0 0 "Failed to list utilities for specific version (--utils -v)"
  CHECK_RESULT $? 0 0 "Failed to query feature (--feature)"
  CHECK_RESULT $? 0 0 "Failed to query multiple features"
  CHECK_RESULT $? 0 0 "Failed to display help (-help)"
```

- 涉及命令：mkdir×1, corelist×1

#### oe_test_corelist_4

- 描述：Command corelist test
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "Failed to compare Perl versions (--diff)"
  CHECK_RESULT $? 0 0 "Failed to query module upstream info (--upstream)"
  CHECK_RESULT $? 0 0 "Failed to query Unicode information"
  CHECK_RESULT $? 0 0 "Failed to list all Unicode versions (-a Unicode)"
```

- 涉及命令：mkdir×1, corelist×1

#### oe_test_fc-list_1

- 描述：command fc-list01
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "Verbose output failed"
  CHECK_RESULT $? 0 0 "Brief output failed"
  CHECK_RESULT $? 0 0 "Format option failed"
  CHECK_RESULT $? 0 0 "Quiet mode failed when fonts exist"
  CHECK_RESULT $? 0 0 "Version display failed"
```

- 涉及命令：mkdir×1

#### oe_test_taskset

- 描述：taskset formatting test
- 函数：`run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "taskset error"
  CHECK_RESULT $? 0 0 "taskset error"
  CHECK_RESULT $? 0 0 "CPU mask 0x1 failed"
  CHECK_RESULT $? 0 0 "Bind to CPU 0 failed"
  CHECK_RESULT $? 0 0 "taskset -a parameter failed"    LOG_INFO "End to run test."
```

- 涉及命令：taskset×2, kill×2

#### oe_test_false_001

- 描述：type formatting test
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 1 0 "false return value error"
  CHECK_RESULT $? 1 0 "false redirection behavior error"
```

#### oe_test_fc-list_2

- 描述：command fc-list
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "Help display failed"
  CHECK_RESULT $? 0 0 "Pattern matching failed"
  CHECK_RESULT $? 0 0 "Pattern with element failed"
  CHECK_RESULT $? 0 0 "Multiple elements failed"
  CHECK_RESULT $? 0 0 "Short format option failed"
```

- 涉及命令：mkdir×1, fc-list×1

#### oe_test_fc-list_3

- 描述：command fc-list
- 函数：`pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $? 0 0 "Short quiet option failed"
  CHECK_RESULT $? 0 0 "Short help option failed"
  CHECK_RESULT $? 0 0 "Verbose with format combination failed"
  CHECK_RESULT $? 0 0 "Brief with quiet combination completed"
  CHECK_RESULT $? 1 0 "Brief with quiet combination failed"
  CHECK_RESULT $? 0 0 "Non-existent font pattern handled correctly"
  CHECK_RESULT $? 1 0 "Non-existent font pattern failed unexpectedly"
```

- 涉及命令：fc-list×4, mkdir×1

#### oe_test_fc-list_4

- 描述：command fc-list
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 1 0 "Quiet mode with non-existent font should exit with 1"
  CHECK_RESULT $? 0 0 "Complex format string failed"
  CHECK_RESULT $? 0 0 "Multiple patterns failed"
  CHECK_RESULT $? 0 0 "Pattern with wildcard failed"
  CHECK_RESULT $? 0 0 "Element filtering failed"
  CHECK_RESULT $? 0 0 "All short options combination failed"
```

- 涉及命令：fc-list×3, mkdir×1

#### oe_test_certutil_2

- 描述：Command certutil test
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "Failed to list certificates (-L)"
  CHECK_RESULT $? 0 0 "Failed to list modules (-U)"
  CHECK_RESULT $? 0 0 "Failed to modify trust attributes (-M)"
  CHECK_RESULT $? 0 0 "Failed to print certificate chain (-O)"
  CHECK_RESULT $? 0 0 "Failed to reset key database (-T)"
  CHECK_RESULT $? 0 0 "Failed to delete key and certificate (-F)"
```

- 涉及命令：certutil×9, mkdir×1

#### oe_test_declare

- 描述：bash declare typed variables and integer arithmetic
- 函数：`run_test`
- 断言（12 条）：

```
  CHECK_RESULT $? 0 0 "declare -i addition failed"
  CHECK_RESULT $? 0 0 "declare -i string-to-int should be 0"
  CHECK_RESULT $? 0 0 "declare -a index 0 failed"
  CHECK_RESULT $? 0 0 "declare -a index 2 failed"
  CHECK_RESULT $? 0 0 "declare -a array length failed"
  CHECK_RESULT $? 0 0 "declare -A hostname lookup failed"
  CHECK_RESULT $? 0 0 "declare -A ip lookup failed"
  CHECK_RESULT $? 0 0 "declare -r read failed"
  CHECK_RESULT $? 0 0 "declare -r should show -r attribute"
  CHECK_RESULT $? 0 0 "declare -l lowercase failed"
  CHECK_RESULT $? 0 0 "declare -u uppercase failed"
  CHECK_RESULT $? 0 0 "declare -x export failed"
```

- 涉及命令：declare×9, bash×1

#### oe_test_printf

- 描述：bash printf formatted output for script reporting
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "printf table formatting failed"
  CHECK_RESULT $? 0 0 "printf table content mismatch"
  CHECK_RESULT $? 0 0 "printf numeric formatting failed"
  CHECK_RESULT $? 0 0 "printf float precision mismatch"
  CHECK_RESULT $? 0 0 "printf %%q quoting failed"
```

- 涉及命令：grep×2

#### oe_test_libstdc++

- 描述：Basic functional verification of libstdc++
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 " File generation failed"
  CHECK_RESULT $? 0 0 " File generation failed"
  CHECK_RESULT $? 0 0 "Execution failed"
```

- 涉及命令：test×2

#### oe_test_disown

- 描述：test disown
- 函数：`run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "disown -a execute fail"
  CHECK_RESULT $? 0 0 "disown -r execute fail"
  CHECK_RESULT $? 0 0 "disown execute fail"
  CHECK_RESULT $? 0 0 "disown execute fail"
```

- 涉及命令：disown×3

#### oe_test_echarts

- 描述：package Echarts test
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "echarts Installation failure error"
  CHECK_RESULT $? 0 0 "ln -s  node_modules/echarts/ echarts Soft connection making failed"
  CHECK_RESULT $? 0 0 "cp index.html /var/www/html/ Copy failed"
  CHECK_RESULT $? 0 0 "httpd Start failed"
  CHECK_RESULT $? 0 0 "curl http://localhost | grep \"销售额\" | grep \"季度销量\" Access failed"
```

#### oe_test_getopts

- 描述：bash getopts CLI argument parsing
- 函数：`run_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "getopts parsing failed"
  CHECK_RESULT $? 0 0 "getopts flag -a not detected"
  CHECK_RESULT $? 0 0 "getopts -b value not captured"
  CHECK_RESULT $? 0 0 "getopts flag -c not detected"
  CHECK_RESULT $? 0 0 "getopts unknown option not caught"
```

#### oe_test_getconf

- 描述：getconf formatting test
- 函数：`run_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "getconf -a execute error"
  CHECK_RESULT $? 0 0 "getconf query error"
```

- 涉及命令：getconf×1

#### oe_test_setfattr

- 描述：bash setfattr formatted test
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "setfattr -n execute error"
  CHECK_RESULT $? 0 0 "setfattr setting error"
  CHECK_RESULT $? 0 0 "setfattr -x execute error"
  CHECK_RESULT $? 0 0 "setfattr clean error"
```

- 涉及命令：setfattr×2

#### oe_test_getfattr

- 描述：bash getfattr formatted test
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "getfattr execute error"
  CHECK_RESULT $? 0 0 "getfattr -d query error"
  CHECK_RESULT $? 0 0 "getfattr -n execute error"
  CHECK_RESULT $? 0 0 "getfattr -n query error"
```

- 涉及命令：getfattr×2, setfattr×1

#### oe_test_zmore

- 描述：Test case for zmore command
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "Failed to compress test file"
  CHECK_RESULT $? 0 0 "zmore --help exited with non-zero code"
  CHECK_RESULT $? 0 0 "zmore help output missing expected content"
  CHECK_RESULT $? 0 0 "zmore failed to extract and display content from compressed file"
  CHECK_RESULT $? 0 0 "zmore failed to display content from uncompressed file"
```

- 涉及命令：grep×1

#### oe_test_unexpand

- 描述：Test case for unexpand command
- 函数：`pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $? 0 0 "Default unexpand execution failed"
  CHECK_RESULT $? 0 0 "Default unexpand leading space conversion failed"
  CHECK_RESULT $? 0 0 "unexpand --first-only execution failed"
  CHECK_RESULT $? 0 0 "unexpand --first-only failed to only convert first space group"
  CHECK_RESULT $? 0 0 "unexpand read from stdin execution failed"
  CHECK_RESULT $? 0 0 "unexpand stdin conversion failed"
  CHECK_RESULT $? 0 0 "unexpand --version execution failed"
  CHECK_RESULT $? 0 0 "unexpand --help output check failed"
```

- 涉及命令：mkdir×1

#### oe_test_uniq01

- 描述：Test case for uniq command
- 函数：`pre_test, run_test, post_test`
- 断言（13 条）：

```
  CHECK_RESULT $? 0 0 "uniq without options failed"
  CHECK_RESULT $? 0 0 "Reading uniq output failed"
  CHECK_RESULT $? 0 0 "uniq default output mismatch"
  CHECK_RESULT $? 0 0 "uniq -c failed"
  CHECK_RESULT $? 0 0 "uniq -c output mismatch"
  CHECK_RESULT $? 0 0 "uniq -d failed"
  CHECK_RESULT $? 0 0 "uniq -d output mismatch"
  CHECK_RESULT $? 0 0 "uniq -D failed"
  CHECK_RESULT $? 0 0 "uniq -D output mismatch"
  CHECK_RESULT $? 0 0 "uniq stdin failed"
  CHECK_RESULT $? 0 0 "uniq stdin output mismatch"
  CHECK_RESULT $? 0 0 "uniq -i failed"
  ... 共 13 条（其余见源脚本）
```

- 涉及命令：uniq×4
