# smoke

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 冒烟域（smoke-test） |
| 套件路径 | `$OET_PATH/testcases/smoke-test` |
| 注册用例数 | 274 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_OVS | Test OVS | pre_test/run_test/post_test | 31 | ✔ |  |  |
| oe_test_module | Test SSH link | pre_test/run_test | 6 |  |  |  |
| oe_test_baseinfo | Basic information of test system | pre_test/run_test/post_test | 16 |  |  |  |
| oe_test_firewalld | Test firewalld and iptables | pre_test/run_test/post_test | 11 | ✔ |  |  |
| oe_test_partition | View partition information | run_test | 7 |  |  |  |
| oe_test_system_level | Test system level | pre_test/run_test | 6 |  |  |  |
| oe_test_ssh | Test SSH link | run_test/post_test | 4 |  |  |  |
| oe_test_acl_001 | File system common command test-acl | pre_test/run_test/post_test | 10 |  |  |  |
| oe_test_basic_ssh_001 | test ssh | pre_test/run_test/post_test | 1 |  |  |  |
| oe_test_cat_001 | File system common command test-cat | pre_test/run_test/post_test | 4 |  |  |  |
| oe_test_cd_002 | File system common command test-cd | pre_test/run_test/post_test | 8 |  |  |  |
| oe_test_chattr | File system common command test-chattr | pre_test/run_test/post_test | 8 |  |  |  |
| oe_test_chmod_001 | File system common command test-chmod | pre_test/run_test/post_test | 6 |  |  |  |
| oe_test_chown_001 | File system common command test-chown | pre_test/run_test/post_test | 6 |  |  |  |
| oe_test_cp_001 | File system common command test-cp | pre_test/run_test/post_test | 5 |  |  |  |
| oe_test_criu | criu test | config_params/pre_test/run_test/post_test | 5 | ✔ |  |  |
| oe_test_dateinfo_001 | test timedatectl command and date command | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_dd_001 | File system common command test-dd | pre_test/run_test/post_test | 3 |  |  |  |
| oe_test_df | File system common command test-df | run_test | 10 |  |  |  |
| oe_test_file_001 | File system common command test-file | run_test | 3 |  |  |  |
| oe_test_glib2_001 | package glib2 test | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_golang | smoke basic os test-golang | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_grep_001 | File system common command test-grep | pre_test/run_test/post_test | 9 |  |  |  |
| oe_test_group_001 | Create User Group test | pre_test/run_test | 9 |  |  |  |
| oe_test_group_002 | Modity User Group test | pre_test/run_test/post_test | 8 |  |  |  |
| oe_test_haproxy | haproxy test | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_hdparm | hdparm test | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_httpd | httpd test | pre_test/run_test/post_test | 6 | ✔ |  |  |
| oe_test_iscsi | open-iscsi & multipath-tools & target test | config_params/pre_test/run_test/post_test | 8 | ✔ |  |  |
| oe_test_journalctl | 可维护性——journalctl命令 | run_test/post_test | 12 |  |  |  |
| oe_test_krb5 | smoke basic os test-krb5 | pre_test/run_test/post_test | 5 | ✔ |  |  |
| oe_test_ln_001 | File system common command test-ln | pre_test/run_test/post_test | 3 |  |  |  |
| oe_test_less_001 | smoke basic os test-less | run_test | 2 |  |  |  |
| oe_test_localectl_001 | Locale setting test | run_test/post_test | 3 |  |  |  |
| oe_test_logrotate_002 | smoke basic os test-logrotate | pre_test/run_test/post_test | 5 | ✔ |  |  |
| oe_test_logrotate_001 | smoke basic os test-logrotate | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_logrotate_003 | smoke basic os test-logrotate | pre_test/run_test/post_test | 8 | ✔ |  |  |
| oe_test_ls_001 | File system common command test -ls | pre_test/run_test/post_test | 3 |  |  |  |
| oe_test_lsscsi | lsscsi test | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_lzo | lzo test | pre_test/run_test/post_test | 5 | ✔ |  |  |
| oe_test_MEMinfo_001 | Query MEM configure test-lshw -c | pre_test/run_test/post_test | 8 | ✔ |  |  |
| oe_test_mkdir_001 | File system common command test-mkdir | pre_test/run_test/post_test | 5 |  |  |  |
| oe_test_mv_001 | File system common command test-mv | pre_test/run_test/post_test | 4 |  |  |  |
| oe_test_ndctl | ndctl test | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_network_001 | nmcli, ip link, route, ip, ethtool, ifconfig command test | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_nfs | nfs test | config_params/pre_test/run_test/post_test | 11 | ✔ |  |  |
| oe_test_openssl | openssl test | config_params/pre_test/run_test/post_test | 5 | ✔ |  |  |
| oe_test_pciutils | pciutils test | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_perf | perf test | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_pwd_001 | File system common command test-pwd | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_rmdir_001 | File system common command test-rmdir | pre_test/run_test/post_test | 4 |  |  |  |
| oe_test_rsync | rsync test | pre_test/run_test/post_test | 5 | ✔ |  |  |
| oe_test_sevice_001 | View the services provided by the system | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_sort | File system common command test-sort | pre_test/run_test/post_test | 10 |  |  |  |
| oe_test_skopeo | skopeo test | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_syslog_dmesg_001 | Query boot information-dmesg | run_test | 4 |  |  |  |
| oe_test_syslog_journalctl_001 | Supports logging of Basic System Operation Information | run_test/post_test | 1 |  |  |  |
| oe_test_syslog_journalctl_002 | Supports logging of device information | run_test/post_test | 1 |  |  |  |
| oe_test_syslog_journald_001 | The system log is recorded in a fixed log file | config_params/run_test/post_test | 4 |  |  |  |
| oe_test_syslog_logrotate_001 | test syslog dump-logrotate | run_test/post_test | 3 |  |  |  |
| oe_test_tar_001 | File system common command test-tar | pre_test/run_test/post_test | 6 | ✔ |  |  |
| oe_test_touch_001 | File system common command test-touch | pre_test/run_test/post_test | 4 |  |  |  |
| oe_test_umask_001 | Umask default configuration check | run_test/post_test | 3 |  |  |  |
| oe_test_user_001 | Add User test | pre_test/run_test/post_test | 9 |  |  |  |
| oe_test_user_002 | test -g -s -m and delete user | pre_test/run_test/post_test | 7 |  |  |  |
| oe_test_user_003 | Modity User test | pre_test/run_test/post_test | 5 |  |  |  |
| oe_test_rm_001 | File system common command test-rm | run_test | 5 |  |  |  |
| oe_test_which | File system common command test-which | run_test | 3 |  |  |  |
| oe_test_yumgroup_001 | install Software Group | pre_test/run_test/post_test | 5 |  |  |  |
| oe_test_mv_002 | File system common command test-mv | pre_test/run_test/post_test | 4 |  |  |  |
| oe_test_uname | File system common command test-uname | run_test | 10 |  |  |  |
| oe_test_wc | File system common command test-wc | pre_test/run_test/post_test | 6 |  |  |  |
| oe_test_chrony_001 | Chrony Manually synchronizes the time | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_diffstat_001 | diffstat function verification | pre_test/run_test/post_test | 6 | ✔ |  |  |
| oe_test_rollback | yum rollback | pre_test/run_test/post_test | 5 | ✔ |  |  |
| oe_test_gcc | File system common command test-gcc | pre_test/run_test/post_test | 13 | ✔ |  |  |
| oe_test_cmp | add test cmp | pre_test/run_test/post_test | 5 | ✔ |  |  |
| oe_test_umask_002 | add test umask | pre_test/run_test/post_test | 6 | ✔ |  |  |
| oe_test_llvm | File system common command test-llvm | pre_test/run_test/post_test | 8 | ✔ |  |  |
| oe_test_acpid | Test acpi help | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_aide_compare_database | Test aide compare database | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_aide_update_database | Test aide update database | pre_test/run_test/post_test | 4 | ✔ |  | 180m |
| oe_test_arping | Test the basic functions of arping | pre_test/run_test/post_test | 2 |  |  |  |
| oe_test_atd | Test the basic functions of | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_augeas_augtool | Test the basic functions of augeas | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_bc | Test the basic functions of bc | pre_test/run_test/post_test | 6 | ✔ |  |  |
| oe_test_bc_01 | File system common command test-top | pre_test/run_test/post_test | 6 | ✔ |  |  |
| oe_test_bridge-utils_01 | Test the basic functions of brctl | pre_test/run_test/post_test | 7 | ✔ |  |  |
| oe_test_chkconfig | Test the basic functions of chkconfig | pre_test/run_test/post_test | 3 |  |  |  |
| oe_test_chrt | Test the basic functions of chrt | pre_test/run_test/post_test | 4 |  |  |  |
| oe_test_cifsclient | Test the basic functions of cifs client | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_cpio | Test the basic functions of cpio | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_curl_01 | Test curl upload file | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_curl_02 | Test strace curl | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_curl_03 | Test the basic functions of curl | run_test/post_test | 2 |  |  |  |
| oe_test_dbus-binging-tool | Test the basic functions of dbus-binding-tool | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_dbus-cleanup-sockets | Test the basic functions of dbus-cleanup-sockets | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_dbus-daemon | Test the basic functions of dbus-daemon | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_dbus-monitor | Test the basic functions of dbus-monitor | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_dbus-send | Test the basic functions of dbus-send | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_dbus | Test the basic functions of dbus | pre_test/run_test/post_test | 5 | ✔ |  |  |
| oe_test_dbus-uuidgen | Test the basic functions of dbus-uuidgen | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_dhclient_01 | Test the basic functions of dhclient | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_dracut | Test the basic functions of dracut | pre_test/run_test/post_test | 2 |  |  |  |
| oe_test_ebtables | Test the basic functions of ebtables | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_ethtool_01 | Test the basic functions of ethool | pre_test/run_test/post_test | 20 | ✔ |  |  |
| oe_test_firewalld_server | Test the basic functions of firewalld | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_glibc_getaddrinfo_01 | Test to get web address information | pre_test/run_test/post_test | 8 | ✔ |  |  |
| oe_test_glibc_getaddrinfo_02 | Test the basic functions of wget | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_grub2_mkconfig | Test the basic functions of grub2-mkconfig | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_gzip | Test the basic functions of gzip | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_hwclock | Test the basic functions of hwclock | pre_test/run_test/post_test | 1 |  |  |  |
| oe_test_hwdata | Test hwdata | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_ifconfig_ipv6_01 | Test the basic functions of ifconfig | pre_test/run_test/post_test | 7 | ✔ |  |  |
| oe_test_ip6tables_01 | Test ip6tables add rule | pre_test/run_test/post_test | 12 | ✔ |  |  |
| oe_test_ip6tables_02 | Test the basic functions of ip6tables | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_ip_ipv6_01 | Test add ipv6 | run_test/post_test | 13 |  |  |  |
| oe_test_ip_ipv6_02 | IP add IPv6 address in multiple configuration formats | run_test/post_test | 16 |  |  |  |
| oe_test_ip_ipv6_03 | Test ip show ipv6 config | run_test/post_test | 10 |  |  |  |
| oe_test_ip_ipv6_04 | Test ifconfig add ipv6 | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_iproute_ipv6_01 | Test ip add ipv6 route | run_test/post_test | 8 |  |  |  |
| oe_test_iproute | Test the basic functions of ip | run_test | 2 |  |  |  |
| oe_test_ip_rule_01 | Test ip rule list and show | run_test | 3 |  |  |  |
| oe_test_ip_rule_02 | IP add IPv6 rule | run_test/post_test | 6 |  |  |  |
| oe_test_iptables-save | Test the basic functions of iptables-save | pre_test/run_test/post_test | 7 | ✔ |  |  |
| oe_test_iptables | Test iptables add rule | pre_test/run_test/post_test | 12 | ✔ |  |  |
| oe_test_ipv6_BRIDGE | Test bridge | pre_test/run_test/post_test | 12 | ✔ |  |  |
| oe_test_ipv6_dnsmasq | Test the basic functions of dnsmasq | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_IPV6_traceroute6_01 | Test the basic functions of traceroute6 | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_IPV6_traceroute6_02 | Test the basic functions of traceroute6 -n | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_IPV6_traceroute6_tracepath6 | Test tracepath6 | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_ipv6_VLAN_01 | Test add ipv6 vlan | run_test | 4 |  |  |  |
| oe_test_ipv6_VLAN_02 | Test configure ipv6 vlan | pre_test/run_test/post_test | 8 |  |  |  |
| oe_test_lldpad | Test the basic functions of lldpad | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_iscsid | Test the basic functions of open-iscsi | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_less | Test the basic functions of less | run_test/post_test | 2 |  |  |  |
| oe_test_libcgroup_01 | Test cgcreate and cgdelete | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_libcgroup_02 | Test cgget and cgset | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_libcgroup_03 | Test cgexec | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_libcgroup_04 | Test cgsnapshot | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_libuser_sm | Test the basic functions of libuser | pre_test/run_test/post_test | 9 |  |  |  |
| oe_test_losetup | Test the basic functions of losetup | pre_test/run_test/post_test | 6 |  |  |  |
| oe_test_lsof | Test the basic functions of lsof | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_lz4_01 | Test lz4 compression and decompression | pre_test/run_test/post_test | 6 |  |  |  |
| oe_test_lz4_02 | Test repeated compression | pre_test/run_test/post_test | 4 |  |  |  |
| oe_test_maildrop_delivery_agent | Test the basic functions of maildrop | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_mktemp | Test the basic functions of mktemp | run_test/post_test | 7 |  |  |  |
| oe_test_ncurses | Test the basic functions of infocmp | pre_test/run_test/post_test | 5 |  |  |  |
| oe_test_nfs_01 | Test the basic functions of exportfs | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_nfs_02 | Test showmount -e | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_nfs_03 | Test the mount function of NFS | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_pcre_001 | Use pcre to compile c programs | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_nmap | Test the basic functions of nmap | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_normal_tcpdump_03 | Test the basic functions of tcpdump | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_ntp_01 | Test the basic functions of ntp | pre_test/run_test/post_test | 6 | ✔ |  |  |
| oe_test_ntp_02 | Test the basic functions of sntp | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_os-prober_01 | Test the basic functions of os-prober | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_os-prober_02 | Test the basic functions of linux-boot-prober | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_perl | Test the basic functions of perl | run_test/post_test | 4 |  |  |  |
| oe_test_python_01 | Test the basic functions of python | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_python_pip_install | Test the basic functions of pip3 | pre_test/run_test/post_test | 13 | ✔ |  |  |
| oe_test_python_subprocess_01 | Test subprocess.Popen | run_test/post_test | 1 |  |  |  |
| oe_test_python_subprocess_02 | Test subprocess.Popen | run_test/post_test | 1 |  |  |  |
| oe_test_python_subprocess_03 | Test subprocess.Popen | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_gettext | gettext Basic Functions test | pre_test/run_test/post_test | 7 | ✔ |  |  |
| oe_test_python_urllib3_urlopen_01 | Test urllib.request.urlopen | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_python_urllib3_urlopen_02 | Test response.getcode | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_python_urllib3_urlopen_03 | Test request timeout | run_test/post_test | 2 |  |  |  |
| oe_test_route_ipv4 | Test route add ipv4 route | pre_test/run_test/post_test | 6 | ✔ |  |  |
| oe_test_route_ipv6 | Test route add ipv6 route | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_rpcbind | Test the basic functions of rpcbind | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_rpm_cmd | Test the basic functions of rpm | pre_test/run_test/post_test | 7 | ✔ |  |  |
| oe_test_rpmrebuild | Test the basic functions of rpmrebuild | pre_test/run_test/post_test | 6 | ✔ |  |  |
| oe_test_rsyslog_01 | Test the basic functions of rsyslog | pre_test/run_test/post_test | 5 | ✔ |  |  |
| oe_test_rsyslog_02 | Test the basic functions of rsyslog | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_rsyslog_03 | Test the basic functions of rsyslog | pre_test/run_test/post_test | 5 | ✔ |  |  |
| oe_test_rsyslog_04 | Test the basic functions of rsyslog | pre_test/run_test/post_test | 5 | ✔ |  |  |
| oe_test_rsyslog_05 | Test the basic functions of rsyslog | pre_test/run_test/post_test | 5 | ✔ |  |  |
| oe_test_rsyslog_06 | Test the basic functions of rsyslog | pre_test/run_test/post_test | 6 | ✔ |  |  |
| oe_test_rsyslog_07 | Test the basic functions of rsyslog | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_rsyslog_08 | Test the basic functions of rsyslog | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_rsyslog_09 | Test the basic functions of rsyslog | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_rsyslog_10 | Test the basic functions of rsyslog | pre_test/run_test/post_test | 5 | ✔ |  |  |
| oe_test_rule_ipv6 | Test ip add ipv6 rule | run_test | 4 |  |  |  |
| oe_test_service | Test sshd service | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_setools | Test the basic functions of setools-console | pre_test/run_test/post_test | 5 | ✔ |  |  |
| oe_test_shadow | Test shadow file | pre_test/run_test/post_test | 4 |  |  |  |
| oe_test_sshd | Test the basic functions of sshd | run_test | 4 |  |  |  |
| oe_test_stat | Test the basic functions of stat | run_test/post_test | 7 |  |  |  |
| oe_test_sudo_E | Test sudo -E | pre_test/run_test/post_test | 1 |  |  |  |
| oe_test_sudo_maxseq | Test sudo maxseq | pre_test/run_test/post_test | 1 |  |  |  |
| oe_test_sudo | Test the basic functions of sudo | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_sudo_U | Test sudo -U | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_systemd_journald | Test the basic functions of journalctl | run_test/post_test | 9 |  |  |  |
| oe_test_systemd-update-utmp | Test systemd-update-utmp | run_test | 1 |  |  |  |
| oe_test_tcpdump | Test the basic functions of tcpdump | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_tftp_ipv6 | Test tftp | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_expat | package expat test | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_attr_001 | attr add attributes | pre_test/run_test/post_test | 6 | ✔ |  |  |
| oe_test_procps-ng-uptime | package procps-ng-uptime test | run_test | 5 |  |  |  |
| oe_test_unalias_001 | File system common command unalias | run_test | 3 |  |  |  |
| oe_test_time_01 | Test the basic functions of time | pre_test/run_test/post_test | 5 | ✔ |  |  |
| oe_test_time_02 | Test /usr/bin/time | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_wget | Test the basic functions of wget | pre_test/run_test/post_test | 11 | ✔ |  |  |
| oe_test_systemd_SCEN_01 | Test the basic functions of systemd | pre_test/run_test/post_test | 6 |  |  |  |
| oe_test_systemd_SCEN_02 | Test the basic functions of systemd | pre_test/run_test/post_test | 6 |  |  |  |
| oe_test_systemd_SCEN_03 | Test the basic functions of systemd | pre_test/run_test/post_test | 6 |  |  |  |
| oe_test_systemd_SCEN_04 | Test the basic functions of systemd | pre_test/run_test/post_test | 6 |  |  |  |
| oe_test_systemd_SCEN_05 | Test the basic functions of systemd | pre_test/run_test/post_test | 6 |  |  |  |
| oe_test_systemd_SCEN_06 | Test the basic functions of systemd | pre_test/run_test/post_test | 8 |  |  |  |
| oe_test_systemd_SCEN_07 | Test the basic functions of systemd | pre_test/run_test/post_test | 6 |  |  |  |
| oe_test_systemd_SCEN_08 | Test the basic functions of systemd | pre_test/run_test/post_test | 6 |  |  |  |
| oe_test_systemd_SCEN_09 | Test the basic functions of systemd | pre_test/run_test/post_test | 6 |  |  |  |
| oe_test_systemd_SCEN_10 | Test the basic functions of systemd | pre_test/run_test/post_test | 7 |  |  |  |
| oe_test_systemd_SCEN_11 | Test the basic functions of systemd | pre_test/run_test/post_test | 6 |  |  |  |
| oe_test_systemd_SCEN_12 | Test the basic functions of systemd | pre_test/run_test/post_test | 8 |  |  |  |
| oe_test_systemd_SCEN_13 | Test the basic functions of systemd | pre_test/run_test/post_test | 6 |  |  |  |
| oe_test_systemd_SCEN_14 | Test the basic functions of systemd | pre_test/run_test/post_test | 6 |  |  |  |
| oe_test_systemd_SCEN_15 | Test the basic functions of systemd | pre_test/run_test/post_test | 6 |  |  |  |
| oe_test_find | test find | pre_test/run_test/post_test | 5 |  |  |  |
| oe_test_source | test source | pre_test/run_test/post_test | 2 |  |  |  |
| oe_test_pwd_002 | File system common command builtin | run_test | 2 |  |  |  |
| oe_test_mtr | test mtr | pre_test/run_test/post_test | 5 | ✔ |  |  |
| oe_test_sadf_001 | File system common command test-sadf | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_pstree | test pstree | run_test | 8 |  |  |  |
| oe_test_vmstat | test vmstat | run_test | 8 |  |  |  |
| oe_test_let | File system common command builtin | run_test | 3 |  |  |  |
| oe_test_unset_001 | File system common command builtin | run_test | 3 |  |  |  |
| oe_test_aide_config_cfgfile | Get configuration properties from cfgfile configuration file | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_aide_config_check | Detect whether there is a problem with the configuration file | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_aide_basic_info | Display aide version | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_aide_init_database | Aide init database | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_aide_security | Security test | pre_test/run_test/post_test | 6 | ✔ |  |  |
| oe_test_audit_abnormal_kill | Check the audit service after killing the audit process abnormally | pre_test/run_test/post_test | 6 | ✔ |  |  |
| oe_test_audit_fixed_memory_01 | Kill -19 audit process, execute audit log script and check the status of auditd | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_audit_fixed_memory_02 | Kill -19 audit process, execute C script and check the status of auditd | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_bbr_02 | Turn on BBR algorithm | pre_test/run_test/post_test | 2 |  |  |  |
| oe_test_bbr_04 | modprobe/rmmod sch_fq | pre_test/run_test/post_test | 5 | ✔ |  |  |
| oe_test_bonding_SCEN_05 | Add the macvlan device created on bond to the network namespace verification | pre_test/run_test/post_test | 7 | ✔ |  |  |
| oe_test_ima_v2_manual_gen_digest_01 | Generate and check digest files and TLV files | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_ipv6_sysctl_01 | Enable/Disable Ipv6 | run_test | 12 |  |  |  |
| oe_test_ipv6_sysctl_02 | Enable/Disable Ipv6 in conf file | run_test/post_test | 6 |  |  |  |
| oe_test_IPVLAN_07 | The ipvlan driver is unloaded and loaded normally | pre_test/run_test/post_test | 6 | ✔ |  |  |
| oe_test_mpstat_01 | Get CPU overhead | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_mtr_01 | Check the number of packets sent by mtr | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_Netlink_ip_01 | Hulk supports ipv4\ipv6 network netlink interface | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_netstat_01 | Check the status of current net by netstat | pre_test/run_test/post_test | 7 | ✔ |  |  |
| oe_test_normal_tcpdump_02 | Add the macvlan device created on bond to the network namespace verification | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_normal_tcpdump_04 | Confirm numad -m parameter function | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_Numad_01 | Confirm numad -m parameter function | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_perf_top_01 | Verify output readability of perf top | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_sar_01 | Brazil daylight time rules are normal | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_user_debug_iotop_03 | Displays the i/o that the process or thread is actually doing | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_user_debug_iotop_SCEN_01 | Execute the iotop command and observe the output "prio" information | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_sed_001 | File system common command test-sed | pre_test/run_test/post_test | 12 |  |  |  |
| oe_test_xz | Command test-xz | pre_test/run_test/post_test | 7 | ✔ |  |  |
| oe_test_tr | File system common command test-tr | pre_test/run_test/post_test | 6 |  |  |  |
| oe_test_popt | 使用popt库输出命令的帮助信息 | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_chkconfig_01 | File system common command test-chkconfig | pre_test/run_test/post_test | 6 | ✔ |  |  |
| oe_test_libxml2_001 | File system common command test-libxml2 | pre_test/run_test/post_test | 6 | ✔ |  |  |
| oe_test_libxml2_002 | File system common command test-libxml2 | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_libxml2_003 | test the xml2-config can be used regularly | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_libxml2_004 | test the xmlcatalog can be used regularly | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_logrotate_004 | Test logrotate partition | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_gcc_001 | File system common command test-gcc | pre_test/run_test/post_test | 6 | ✔ |  |  |
| oe_test_gcc_002 | Dynamic Compilation Test for gcc Command | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_od | Command test-od | pre_test/run_test/post_test | 5 |  |  |  |
| oe_test_od_001 | File system common command test-top | pre_test/run_test/post_test | 8 |  |  |  |
| oe_test_top | File system common command test-top | pre_test/run_test/post_test | 4 |  |  |  |
| oe_test_nmap_001 | Use nmap case | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_sysstat_01 | test mpstat command | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_sysstat_02 | test sysstat packages | pre_test/run_test/post_test | 9 | ✔ |  |  |
| oe_test_sysstat_03 | test sysstat package | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_zlib_001 | Test calls zlib compression and decompression interface | pre_test/run_test/post_test | 4 | ✔ |  |  |

### 断言与命令明细

#### oe_test_OVS

- 描述：Test OVS
- 函数：`pre_test, run_test, post_test`
- 断言（31 条）：

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
  CHECK_RESULT $? 1
  CHECK_RESULT $?
  CHECK_RESULT $?
  ... 共 31 条（其余见源脚本）
```

#### oe_test_module

- 描述：Test SSH link
- 函数：`pre_test, run_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "Failed to delete ${mod}"
  CHECK_RESULT $? 1 0 "Failed to delete ${mod}"
  CHECK_RESULT $? 0 0 "Failed to load ${mod}"
  CHECK_RESULT $? 0 0 "Failed to load ${mod}"
  CHECK_RESULT $? 0 0 "Failed to load ${mod}"
  CHECK_RESULT $? 0 0 "Failed to load ${mod}"
```

- 涉及命令：grep×3, modprobe×1

#### oe_test_baseinfo

- 描述：Basic information of test system
- 函数：`pre_test, run_test, post_test`
- 断言（16 条）：

```
  CHECK_RESULT $? 0 0 "Failed command: free"
  CHECK_RESULT $? 0 0 "Failed command: lscpu"
  CHECK_RESULT $? 0 0 "Failed command: fdisk"
  CHECK_RESULT $? 0 0 "/etc/os-release file view failed"
  CHECK_RESULT $? 0 0 "Failed command: timedatectl"
  CHECK_RESULT $? 0 0 "Time zone information display failed"
  CHECK_RESULT $? 1 0 "The time zone is Tokyo"
  CHECK_RESULT $? 0 0 "Failed to set time zone"
  CHECK_RESULT $? 0 0 "The time zone isn't Tokyo"
  CHECK_RESULT $? 0 0 "Failed to recover time zone"
  CHECK_RESULT $? 0 0 "The system language does not belong to us"
  CHECK_RESULT $? 0 0 "The system language does not contain Chinese"
  ... 共 16 条（其余见源脚本）
```

- 涉及命令：grep×3, fdisk×1

#### oe_test_firewalld

- 描述：Test firewalld and iptables
- 函数：`pre_test, run_test, post_test`
- 断言（11 条）：

```
  CHECK_RESULT $? 0 0 "Iptables execution failed"
  CHECK_RESULT $? 0 0 "Failed to stop cockpit service"
  CHECK_RESULT $? 0 0 "Failed to stop cockpit service"
  CHECK_RESULT $? 0 0 "Iptables execution failed"
  CHECK_RESULT $? 0 0 "Failed to restart cockpit service"
  CHECK_RESULT $? 0 0 "Failed to restart cockpit service"
  CHECK_RESULT $? 0 0 "Iptables execution failed"
  CHECK_RESULT $? 0 0 "Iptables execution failed"
  CHECK_RESULT $? 0 0 "Failed to start cockpit service"
  CHECK_RESULT $? 0 0 "Failed to start cockpit service"
  CHECK_RESULT $? 0 0 "Iptables execution failed"
```

- 涉及命令：iptables×4, ip6tables×4

#### oe_test_partition

- 描述：View partition information
- 函数：`run_test`
- 断言（7 条）：

```
  CHECK_RESULT $? 0 0 "No / partition"
  CHECK_RESULT $? 0 0 "No boot partition"
  CHECK_RESULT $? 0 0 "No swap partition"
  CHECK_RESULT $? 0 0 "lsblk -h info error"
  CHECK_RESULT $? 0 0 "lsblk -t info error"
  CHECK_RESULT $? 0 0 "lsblk -m info error"
  CHECK_RESULT $? 0 0 "lsblk -b info error"
```

- 涉及命令：lsblk×3

#### oe_test_system_level

- 描述：Test system level
- 函数：`pre_test, run_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "set-default execution failed"
  CHECK_RESULT $? 0 0 "list-units execution failed"
  CHECK_RESULT $? 0 0 "isolate execution failed"
  CHECK_RESULT $? 0 0 "list-units execution failed"
  CHECK_RESULT $? 0 0 "isolate execution failed"
  CHECK_RESULT $? 1 0 "list-units execution failed"
```

#### oe_test_ssh

- 描述：Test SSH link
- 函数：`run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "Failed to start sshd service"
  CHECK_RESULT $? 0 0 "Failed to start sshd service"
  CHECK_RESULT $? 0 0 "uanme -a execution failed"
  CHECK_RESULT $? 0 0 "ip a execution failed"
```

#### oe_test_acl_001

- 描述：File system common command test-acl
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 1
  CHECK_RESULT $? 0 0
  CHECK_RESULT $? 0 1
  CHECK_RESULT $? 0 0
  CHECK_RESULT $? 0 0
  CHECK_RESULT $? 0 1
  CHECK_RESULT $? 0 0
  CHECK_RESULT $? 0 1
  CHECK_RESULT $? 0 1
  CHECK_RESULT $? 0 0
```

- 涉及命令：getfacl×10, setfacl×4, mkdir×1, userdel×1

#### oe_test_basic_ssh_001

- 描述：test ssh
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $?
```

- 涉及命令：usermod×1, userdel×1

#### oe_test_cat_001

- 描述：File system common command test-cat
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

#### oe_test_cd_002

- 描述：File system common command test-cd
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

- 涉及命令：test×1

#### oe_test_chattr

- 描述：File system common command test-chattr
- 函数：`pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $? 0 0 "lsattr failed"
  CHECK_RESULT $? 1 0 "rm success"
  CHECK_RESULT $? 1 0 "mv success"
  CHECK_RESULT $? 0 0 "lsattr -R testdir1/|grep testdir1/testdir2/testfile2  failed"
  CHECK_RESULT $? 0 0 "lsattr -R testdir1/ | grep testdir1/testdir2/testdir3/testfile3 failed"
  CHECK_RESULT $? 0 1 "lsattr -R testdir1/|grep testdir1/testdir2/testfile2  success"
  CHECK_RESULT $? 0 0 "chattr -V +i testdir1/testfile1 failed"
  CHECK_RESULT $? 0 1 "chattr -V -i testdir1/testfile1 success"
```

- 涉及命令：chattr×5, lsattr×3, mkdir×1

#### oe_test_chmod_001

- 描述：File system common command test-chmod
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

- 涉及命令：mkdir×1, chmod×1

#### oe_test_chown_001

- 描述：File system common command test-chown
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

- 涉及命令：mkdir×1, chown×1, userdel×1

#### oe_test_cp_001

- 描述：File system common command test-cp
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

#### oe_test_criu

- 描述：criu test
- 函数：`config_params, pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $? 1
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：grep×2, gcc×1, pgrep×1

#### oe_test_dateinfo_001

- 描述：test timedatectl command and date command
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
```

#### oe_test_dd_001

- 描述：File system common command test-dd
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

#### oe_test_df

- 描述：File system common command test-df
- 函数：`run_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "df display error"
  CHECK_RESULT $? 1 0 "df default display error"
  CHECK_RESULT $? 0 0 "df -h didn't find G|M|K"
  CHECK_RESULT $? 0 0 "df --help error"
  CHECK_RESULT $? 0 0 "df -i error"
  CHECK_RESULT $? 0 0 "df --total error"
  CHECK_RESULT $? 0 0 "df -m error"
  CHECK_RESULT $? 0 0 "df --type error"
  CHECK_RESULT $? 0 0 "df -T didn't find ext4|tmpfs|devtmpfs"
  CHECK_RESULT $? 0 0 "df --sync didn't find %"
```

#### oe_test_file_001

- 描述：File system common command test-file
- 函数：`run_test`
- 断言（3 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：file×1

#### oe_test_glib2_001

- 描述：package glib2 test
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "The system does not install glib2"
  CHECK_RESULT $? 0 0 "Test. c write error"
  CHECK_RESULT $? 0 0 "Compilation failed, no hello binary is generated"
  CHECK_RESULT $? 0 0 "not Print Hello, world!"
```

- 涉及命令：rpm×1

#### oe_test_golang

- 描述：smoke basic os test-golang
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "build hello.go failed"
  CHECK_RESULT $? 0 0 "./hello failed"
```

#### oe_test_grep_001

- 描述：File system common command test-grep
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

- 涉及命令：grep×7

#### oe_test_group_001

- 描述：Create User Group test
- 函数：`pre_test, run_test`
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

- 涉及命令：groupadd×2

#### oe_test_group_002

- 描述：Modity User Group test
- 函数：`pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $? 1
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：groupmod×3, usermod×1, userdel×1

#### oe_test_haproxy

- 描述：haproxy test
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：curl×2, sed×1, grep×1

#### oe_test_hdparm

- 描述：hdparm test
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：hdparm×3

#### oe_test_httpd

- 描述：httpd test
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "httpd start fail"
  CHECK_RESULT $? 0 0 "curl -o index.html fail"
  CHECK_RESULT $? 0 0 "grep -q 'Test Page' fail"
  CHECK_RESULT $? 0 0 "httpd status fail"
  CHECK_RESULT $? 0 0 "httpd version fail"
  CHECK_RESULT $? 0 0 "httpd config syntax fail"
```

- 涉及命令：httpd×2, curl×1, grep×1

#### oe_test_iscsi

- 描述：open-iscsi & multipath-tools & target test
- 函数：`config_params, pre_test, run_test, post_test`
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

- 涉及命令：iscsiadm×6, multipath×3, test×2, mkfs.ext4×2

#### oe_test_journalctl

- 描述：可维护性——journalctl命令
- 函数：`run_test, post_test`
- 断言（12 条）：

```
  CHECK_RESULT $? 0 0 "journalctl --no-pager failed"
  CHECK_RESULT $? 0 0 "grep LVM|NetworkManager failed"
  CHECK_RESULT $? 0 0 "journalctl -k -no-pager failed"
  CHECK_RESULT $? 0 0 "grep kernel|systemd failed"
  CHECK_RESULT $? 0 0 "journalctl -b failed"
  CHECK_RESULT $? 0 0 "boot log content check failed"
  CHECK_RESULT $? 0 0 "journalctl time filter failed"
  CHECK_RESULT $? 0 0 "time filter log content check failed"
  CHECK_RESULT $? 0 0 "journalctl priority filter failed"
  CHECK_RESULT $? 0 0 "priority filter log content check failed"
  CHECK_RESULT $? 0 0 "journalctl json output failed"
  CHECK_RESULT $? 0 0 "json format check failed"
```

- 涉及命令：grep×4, journalctl×4

#### oe_test_krb5

- 描述：smoke basic os test-krb5
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "krbekdc status abnormal"
  CHECK_RESULT ${re} 4 0 "krb5kdc config fail"
  CHECK_RESULT $? 0 0 "krb5kdc start success"
  CHECK_RESULT $? 0 0 "kadmin start success"
  CHECK_RESULT $? 0 0 "kadmin config success"
```

- 涉及命令：sed×1

#### oe_test_ln_001

- 描述：File system common command test-ln
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

#### oe_test_less_001

- 描述：smoke basic os test-less
- 函数：`run_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "less not install"
  CHECK_RESULT $? 0 0 "check version failed"
```

- 涉及命令：command×1

#### oe_test_localectl_001

- 描述：Locale setting test
- 函数：`run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

#### oe_test_logrotate_002

- 描述：smoke basic os test-logrotate
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "logrotate failed"
  CHECK_RESULT $? 0 1 "file exit"
  CHECK_RESULT $? 0 0 "file limit failed"
  CHECK_RESULT $? 0 0 "logrotate failed"
  CHECK_RESULT $? 0 0 "file not exit"
```

- 涉及命令：test×3, head×1

#### oe_test_logrotate_001

- 描述：smoke basic os test-logrotate
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "logrotate --force failed"
  CHECK_RESULT $? 0 0 "file no exit"
```

- 涉及命令：test×2

#### oe_test_logrotate_003

- 描述：smoke basic os test-logrotate
- 函数：`pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $? 0 0 "logrotate failed"
  CHECK_RESULT $? 0 0 "file exit"
  CHECK_RESULT $? 0 0 "logrotate failed"
  CHECK_RESULT $? 0 0 "file exit"
  CHECK_RESULT $? 0 0 "logrotate failed"
  CHECK_RESULT $? 0 0 "file exit"
  CHECK_RESULT $? 0 0 "logrotate failed"
  CHECK_RESULT $? 1 0 "file not exit"
```

- 涉及命令：test×5

#### oe_test_ls_001

- 描述：File system common command test -ls
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

#### oe_test_lsscsi

- 描述：lsscsi test
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $?
```

- 涉及命令：test×1

#### oe_test_lzo

- 描述：lzo test
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 1
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：lzop×4

#### oe_test_MEMinfo_001

- 描述：Query MEM configure test-lshw -c
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

- 涉及命令：lshw×7

#### oe_test_mkdir_001

- 描述：File system common command test-mkdir
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：test×7, mkdir×3

#### oe_test_mv_001

- 描述：File system common command test-mv
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

#### oe_test_ndctl

- 描述：ndctl test
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
```

#### oe_test_network_001

- 描述：nmcli, ip link, route, ip, ethtool, ifconfig command test
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

#### oe_test_nfs

- 描述：nfs test
- 函数：`config_params, pre_test, run_test, post_test`
- 断言（11 条）：

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
```

- 涉及命令：test×2, sudo×2, exportfs×1, showmount×1, mount×1, nfs4_setfacl×1, userdel×1

#### oe_test_openssl

- 描述：openssl test
- 函数：`config_params, pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

#### oe_test_pciutils

- 描述：pciutils test
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "check update-pciids fail"
  CHECK_RESULT $? 0 0 "check lspci fail"
```

- 涉及命令：test×2

#### oe_test_perf

- 描述：perf test
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：test×1, timeout×1

#### oe_test_pwd_001

- 描述：File system common command test-pwd
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $?
```

#### oe_test_rmdir_001

- 描述：File system common command test-rmdir
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 1
  CHECK_RESULT $? 0 1
  CHECK_RESULT $? 0 1
  CHECK_RESULT $?
```

- 涉及命令：rmdir×2, mkdir×1

#### oe_test_rsync

- 描述：rsync test
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：rsync×2, mkdir×1

#### oe_test_sevice_001

- 描述：View the services provided by the system
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $?
```

- 涉及命令：systemctl×1

#### oe_test_sort

- 描述：File system common command test-sort
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "sort faild"
  CHECK_RESULT $? 0 0 "sort -d faild"
  CHECK_RESULT $? 0 0 "sort -g faild"
  CHECK_RESULT $? 0 0 "sort -d faild"
  CHECK_RESULT $? 0 0 "sort faild"
  CHECK_RESULT $? 0 0 "sort -g faild"
  CHECK_RESULT "$res" 66 0 "sort faild"
  CHECK_RESULT $? 0 0 "sort -g faild"
  CHECK_RESULT $? 1 0 "sort -c faild"
  CHECK_RESULT $? 0 0 "sort help faild"
```

- 涉及命令：sort×6

#### oe_test_skopeo

- 描述：skopeo test
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $flag_result 1
  CHECK_RESULT $flag_result 1
```

#### oe_test_syslog_dmesg_001

- 描述：Query boot information-dmesg
- 函数：`run_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "Failed to execute dmesg --help"
  CHECK_RESULT $? 0 0 "Failed to execute dmesg -V"
  CHECK_RESULT $? 0 0 "Failed to execute dmesg --kernel"
  CHECK_RESULT $?
```

- 涉及命令：dmesg×1, grep×1

#### oe_test_syslog_journalctl_001

- 描述：Supports logging of Basic System Operation Information
- 函数：`run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $?
```

#### oe_test_syslog_journalctl_002

- 描述：Supports logging of device information
- 函数：`run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $?
```

#### oe_test_syslog_journald_001

- 描述：The system log is recorded in a fixed log file
- 函数：`config_params, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT 0 1
  CHECK_RESULT "${check_file}" 1
  CHECK_RESULT $?
```

- 涉及命令：grep×1

#### oe_test_syslog_logrotate_001

- 描述：test syslog dump-logrotate
- 函数：`run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：logrotate×1

#### oe_test_tar_001

- 描述：File system common command test-tar
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "tar -cf execute fail"
  CHECK_RESULT $? 0 0 "tar -tvf execute fail"
  CHECK_RESULT $? 0 0 "tar --help execute fail"
  CHECK_RESULT $? 0 0 "tar --usage execute fail"
  CHECK_RESULT $? 0 0 "tar -rvf execute fail"
  CHECK_RESULT $? 0 0 "tar --list execute fail"
```

- 涉及命令：tar×3, mkdir×1

#### oe_test_touch_001

- 描述：File system common command test-touch
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：touch×2

#### oe_test_umask_001

- 描述：Umask default configuration check
- 函数：`run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

#### oe_test_user_001

- 描述：Add User test
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

- 涉及命令：chage×3, userdel×3, useradd×1, test×1

#### oe_test_user_002

- 描述：test -g -s -m and delete user
- 函数：`pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $? 1
  CHECK_RESULT $? 1
```

- 涉及命令：test×2, useradd×1, userdel×1

#### oe_test_user_003

- 描述：Modity User test
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：usermod×2, useradd×1, groupmod×1, groupadd×1, userdel×1

#### oe_test_rm_001

- 描述：File system common command test-rm
- 函数：`run_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "File creation failed"
  CHECK_RESULT $? 0 0 "Directory creation failed"
  CHECK_RESULT $? 0 0 "Failed to delete files"
  CHECK_RESULT $? 0 0 "Failed to delete directory"
  CHECK_RESULT $? 0 0 "rm --help failed"
```

#### oe_test_which

- 描述：File system common command test-which
- 函数：`run_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "which not install"
  CHECK_RESULT $? 0 0 "check version failed"
  CHECK_RESULT $? 0 0 "which function failed"
```

- 涉及命令：rpm×1, which×1

#### oe_test_yumgroup_001

- 描述：install Software Group
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：rpm×1

#### oe_test_mv_002

- 描述：File system common command test-mv
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

#### oe_test_uname

- 描述：File system common command test-uname
- 函数：`run_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "uname -s display error"
  CHECK_RESULT $? 0 0 "uname -r display error"
  CHECK_RESULT $? 0 0 "uname -m display error"
  CHECK_RESULT $? 0 0 "uname -a display error"
  CHECK_RESULT $? 0 0 "uname -n display error"
  CHECK_RESULT $? 0 0 "uname -n display error"
  CHECK_RESULT $? 0 0 "uname --help display error"
  CHECK_RESULT $? 0 0 "uname -o display error"
  CHECK_RESULT $? 0 0 "uname -p display error"
  CHECK_RESULT $? 0 0 "uname -n display error"
```

- 涉及命令：uname×9

#### oe_test_wc

- 描述：File system common command test-wc
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "Return value error"
  CHECK_RESULT $? 0 0 "Error number of rows returned"
  CHECK_RESULT $? 0 0 "Return word error"
  CHECK_RESULT $? 0 0 "Error number of bytes returned"
  CHECK_RESULT $? 0 0 "Error number of character returned"
  CHECK_RESULT $? 0 0 "Error number of newline returned"
```

#### oe_test_chrony_001

- 描述：Chrony Manually synchronizes the time
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Start chrony fail"
  CHECK_RESULT $? 0 0 "Start chronyd.service fail"
  CHECK_RESULT $? 0 0 "Failure to synchronize time"
```

#### oe_test_diffstat_001

- 描述：diffstat function verification
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "The file content is abnormal"
  CHECK_RESULT $? 0 0 "The file content is abnormal"
  CHECK_RESULT $? 0 0 "diffstat -l 输出异常"
  CHECK_RESULT $? 0 0 "diffstat -p1 输出异常"
  CHECK_RESULT $? 0 0 "diffstat 空输入输出异常"
  CHECK_RESULT $? 0 0 "diffstat 未能正确处理无效参数"
```

#### oe_test_rollback

- 描述：yum rollback
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "install fail"
  CHECK_RESULT $? 0 0 "remove fail"
  CHECK_RESULT $? 0 1 "remove fail"
  CHECK_RESULT $? 0 0 "install fail"
  CHECK_RESULT $? 0 0 "install fail"
```

- 涉及命令：rpm×2

#### oe_test_gcc

- 描述：File system common command test-gcc
- 函数：`pre_test, run_test, post_test`
- 断言（13 条）：

```
  CHECK_RESULT $? 0 0 "gcc file fails"
  CHECK_RESULT $? 0 0 "Compilation fails"
  CHECK_RESULT $? 0 0 "Compilation fails"
  CHECK_RESULT $? 0 0 "gcc -o file fails"
  CHECK_RESULT $? 0 0 "test2 Compilation fails"
  CHECK_RESULT $? 0 0 "nothingness hello word"
  CHECK_RESULT $? 0 0 "gcc -E file fails"
  CHECK_RESULT $? 0 0 "gcc -S file fails"
  CHECK_RESULT $? 0 0 "gcc -c file fails"
  CHECK_RESULT $? 0 0 "tset1 Generate failure"
  CHECK_RESULT $? 0 0 "test1 Compilation fails"
  CHECK_RESULT $? 0 0 "test1 Compilation fails"
  ... 共 13 条（其余见源脚本）
```

- 涉及命令：gcc×5

#### oe_test_cmp

- 描述：add test cmp
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "The version information cannot be queried"
  CHECK_RESULT $? 0 0 "Failed to create a file"
  CHECK_RESULT $? 0 0 "The two files have the same content,but the detection fails"
  CHECK_RESULT $? 0 0 "The contents of the files are different,but no difference is detected"
  CHECK_RESULT $? 1 0 "Unable to display details"
```

- 涉及命令：cmp×1

#### oe_test_umask_002

- 描述：add test umask
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "The umask permission of the root is incorrect"
  CHECK_RESULT $? 0 0 "The umask permission of common users is incorrect"
  CHECK_RESULT $? 0 0 "The root user has incorrect permission to create a folder."
  CHECK_RESULT $? 0 0 "The root user has incorrect permission to create files."
  CHECK_RESULT $? 0 0 "Common users have incorrect permission to create folders."
  CHECK_RESULT $? 0 0 "The permission for common users to create files is incorrect."
```

- 涉及命令：useradd×1, userdel×1

#### oe_test_llvm

- 描述：File system common command test-llvm
- 函数：`pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $? 0 0 "Installation failed"
  CHECK_RESULT $? 0 0 "No path is queried"
  CHECK_RESULT $? 0 0 "compilation fails"
  CHECK_RESULT $? 0 0 "test does not exist"
  CHECK_RESULT $? 0 0 "compilation fails"
  CHECK_RESULT $? 0 0 "test.bc does not exist"
  CHECK_RESULT $? 0 0 "test on failure"
  CHECK_RESULT $? 0 0 "test.bc on failure"
```

- 涉及命令：rpm×2, clang×1

#### oe_test_acpid

- 描述：Test acpi help
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "Failed to execute help"
```

#### oe_test_aide_compare_database

- 描述：Test aide compare database
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "initialization failed"
  CHECK_RESULT $? 0 0 "Comparison execution failed"
  CHECK_RESULT $? 0 0 "Comparison execution failed"
  CHECK_RESULT $? 0 0 "Different file contents"
```

- 涉及命令：sed×1, grep×1

#### oe_test_aide_update_database

- 描述：Test aide update database
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "initialization failed"
  CHECK_RESULT $? 0 0 "Update execution failed"
  CHECK_RESULT $? 0 0 "Update execution failed"
  CHECK_RESULT $? 0 1 "Check execution failed"
```

- 涉及命令：sed×1, aide×1, test×1, userdel×1

#### oe_test_arping

- 描述：Test the basic functions of arping
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Failed to execute arping"
  CHECK_RESULT $? 0 0 "Failed to execute arping"
```

#### oe_test_atd

- 描述：Test the basic functions of
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "Failed to execute at"
```

- 涉及命令：mkdir×1

#### oe_test_augeas_augtool

- 描述：Test the basic functions of augeas
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "Failed to execute augtool"
```

#### oe_test_bc

- 描述：Test the basic functions of bc
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "Failed calculations"
  CHECK_RESULT $? 0 0 "Failed calculations"
  CHECK_RESULT $? 0 0 "Failed calculations"
  CHECK_RESULT $? 0 0 "Failed calculations"
  CHECK_RESULT $? 0 0 "Failed calculations"
  CHECK_RESULT $? 0 0 "Failed calculations"
```

#### oe_test_bc_01

- 描述：File system common command test-top
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "Natural logarithm calculation failed"
  CHECK_RESULT $? 0 0 "Variable assignment and usage failed"
  CHECK_RESULT $? 0 0 "Output format control failed"
  CHECK_RESULT $? 0 0 "Division by zero failed"
  CHECK_RESULT $? 0 0 "Complex expression with parentheses failed"
  CHECK_RESULT $? 0 0 "High precision calculation failed"
```

#### oe_test_bridge-utils_01

- 描述：Test the basic functions of brctl
- 函数：`pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $? 0 0 "br0 setting failed"
  CHECK_RESULT $? 0 0 "ip setting failed"
  CHECK_RESULT $? 0 0 "br0 setting failed"
  CHECK_RESULT $? 0 0 "ip setting failed"
  CHECK_RESULT $? 0 0 "ip setting failed"
  CHECK_RESULT $? 0 0 "br0 setting failed"
  CHECK_RESULT $? 0 0 "ip setting failed"
```

#### oe_test_chkconfig

- 描述：Test the basic functions of chkconfig
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "chkconfig package does not exist"
  CHECK_RESULT $? 0 0 "chkconfig command does not exist"
  CHECK_RESULT $? 0 0 "alternatives command does not exist"
```

- 涉及命令：rpm×1

#### oe_test_chrt

- 描述：Test the basic functions of chrt
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "Failed to execute chrt"
  CHECK_RESULT $? 0 0 "Failed to execute chrt"
  CHECK_RESULT $? 0 0 "Failed to execute chrt"
  CHECK_RESULT $? 0 0 "Failed to execute chrt"
```

- 涉及命令：chrt×4, ping×1

#### oe_test_cifsclient

- 描述：Test the basic functions of cifs client
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "Cifs service deployment failed"
```

- 涉及命令：smbpasswd×1, userdel×1

#### oe_test_cpio

- 描述：Test the basic functions of cpio
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Failed to execute cpio"
  CHECK_RESULT $? 0 0 "Failed to find Hello"
  CHECK_RESULT $? 0 0 "Failed to find block"
```

- 涉及命令：grep×2

#### oe_test_curl_01

- 描述：Test curl upload file
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Failed to execute curl"
  CHECK_RESULT $? 0 0 "Failed to execute curl"
```

- 涉及命令：iptables×4, sed×3, test×1, userdel×1

#### oe_test_curl_02

- 描述：Test strace curl
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Failed to execute curl"
  CHECK_RESULT $? 0 0 "Failed to execute curl"
```

- 涉及命令：sed×2

#### oe_test_curl_03

- 描述：Test the basic functions of curl
- 函数：`run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Failed to execute curl"
  CHECK_RESULT $? 0 0 "Failed to execute curl"
```

- 涉及命令：grep×1

#### oe_test_dbus-binging-tool

- 描述：Test the basic functions of dbus-binding-tool
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "Failed to display version information"
```

#### oe_test_dbus-cleanup-sockets

- 描述：Test the basic functions of dbus-cleanup-sockets
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "Failed to cleaned up sockets"
```

#### oe_test_dbus-daemon

- 描述：Test the basic functions of dbus-daemon
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "Failed to display version information"
```

#### oe_test_dbus-monitor

- 描述：Test the basic functions of dbus-monitor
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Failed to execute dbus-monitor"
  CHECK_RESULT $? 0 0 "Failed to check dbus-monitor"
```

- 涉及命令：kill×1

#### oe_test_dbus-send

- 描述：Test the basic functions of dbus-send
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Failed to execute dbus-send"
  CHECK_RESULT $? 0 0 "Failed to check dbus-send"
```

#### oe_test_dbus

- 描述：Test the basic functions of dbus
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "Failed to run dbus service"
  CHECK_RESULT $? 0 0 "Failed to kill the dbus process"
  CHECK_RESULT $? 0 0 "Failed to exist dbus service"
  CHECK_RESULT $? 0 0 "Failed to execute dbus-send"
  CHECK_RESULT $? 0 0 "Failed to check dbus service"
```

- 涉及命令：kill×1, pgrep×1

#### oe_test_dbus-uuidgen

- 描述：Test the basic functions of dbus-uuidgen
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Failed to execute dbus-uuidgen"
  CHECK_RESULT $? 0 0 "Failed to get the number of uuids"
```

#### oe_test_dhclient_01

- 描述：Test the basic functions of dhclient
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "There are multiple ports"
  CHECK_RESULT $? 0 0 "Different files"
  CHECK_RESULT $? 0 0 "Not just one ports"
```

- 涉及命令：netstat×2

#### oe_test_dracut

- 描述：Test the basic functions of dracut
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Failed to execute dracut"
  CHECK_RESULT $? 0 0 "Failed to check dracut"
```

- 涉及命令：test×1

#### oe_test_ebtables

- 描述：Test the basic functions of ebtables
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "Failed to execute ebtables"
```

#### oe_test_ethtool_01

- 描述：Test the basic functions of ethool
- 函数：`pre_test, run_test, post_test`
- 断言（20 条）：

```
  CHECK_RESULT $? 0 0 "GSO open failed"
  CHECK_RESULT $? 0 0 "Check GSO open failed"
  CHECK_RESULT $? 0 0 "GSO shut off failed"
  CHECK_RESULT $? 0 0 "Check GSO shut off failed"
  CHECK_RESULT $? 0 0 "GRO open failed"
  CHECK_RESULT $? 0 0 "Check GRO open failed"
  CHECK_RESULT $? 0 0 "GRO shut off failed"
  CHECK_RESULT $? 0 0 "Check GRO shut off failed"
  CHECK_RESULT $? 0 0 "TSO open failed"
  CHECK_RESULT $? 0 0 "Check TSO open failed"
  CHECK_RESULT $? 0 0 "TSO shut off failed"
  CHECK_RESULT $? 0 0 "Check TSO shut off failed"
  ... 共 20 条（其余见源脚本）
```

- 涉及命令：ethtool×27

#### oe_test_firewalld_server

- 描述：Test the basic functions of firewalld
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "Failed to execute firewall-cmd"
```

#### oe_test_glibc_getaddrinfo_01

- 描述：Test to get web address information
- 函数：`pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $? 0 0 "Failed to execute wget"
  CHECK_RESULT $? 0 0 "Failed to execute wget"
  CHECK_RESULT $? 0 0 "Failed to execute curl"
  CHECK_RESULT $? 0 0 "Failed to execute ping"
  CHECK_RESULT $? 0 0 "Failed to execute host"
  CHECK_RESULT $? 0 0 "Failed to execute nslookup"
  CHECK_RESULT $? 0 0 "Failed to execute traceroute"
  CHECK_RESULT $? 0 0 "Failed to execute mtr"
```

- 涉及命令：test×1, ping×1, mtr×1

#### oe_test_glibc_getaddrinfo_02

- 描述：Test the basic functions of wget
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Wget executed successfully"
  CHECK_RESULT $? 0 0 "Failed to execute wget"
  CHECK_RESULT $? 0 0 "Failed to check wget"
```

- 涉及命令：test×1

#### oe_test_grub2_mkconfig

- 描述：Test the basic functions of grub2-mkconfig
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "Failed to execute grub2-mkconfig"
  CHECK_RESULT $? 0 0 "Failed to find vmlinuz in tmp_grub_cfg"
  CHECK_RESULT $? 0 0 "Failed to find vmlinuz in /boot"
  CHECK_RESULT $? 0 0 "Files are different"
```

- 涉及命令：grub2-mkconfig×1, grep×1, diff×1

#### oe_test_gzip

- 描述：Test the basic functions of gzip
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 1 0 "Failed to execute cmp"
  CHECK_RESULT $? 1 0 "Failed to execute zcmp"
  CHECK_RESULT $? 0 0 "File is different"
```

- 涉及命令：cmp×1, diff×1

#### oe_test_hwclock

- 描述：Test the basic functions of hwclock
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "Failed to execute hwclock"
```

- 涉及命令：kill×1

#### oe_test_hwdata

- 描述：Test hwdata
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "Failed to execute hwdata"
```

- 涉及命令：grep×1

#### oe_test_ifconfig_ipv6_01

- 描述：Test the basic functions of ifconfig
- 函数：`pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $? 0 0 "Failed to add mtu 1279"
  CHECK_RESULT $? 0 0 "Failed to check mtu 1279"
  CHECK_RESULT $? 0 0 "Successfully add ipv6"
  CHECK_RESULT $? 0 0 "Failed to add mtu 1280"
  CHECK_RESULT $? 0 0 "Failed to check mtu 1280"
  CHECK_RESULT $? 0 0 "Failed to add ipv6"
  CHECK_RESULT $? 0 0 "Failed to check ipv6"
```

#### oe_test_ip6tables_01

- 描述：Test ip6tables add rule
- 函数：`pre_test, run_test, post_test`
- 断言（12 条）：

```
  CHECK_RESULT $? 0 0 "Failed to add rule INPUT"
  CHECK_RESULT $? 0 0 "Failed to show rule INPUT"
  CHECK_RESULT $? 0 0 "Failed to add rule OUTPUT"
  CHECK_RESULT $? 0 0 "Failed to show rule OUTPUT"
  CHECK_RESULT $? 0 0 "Failed to add rule INPUT eth0"
  CHECK_RESULT $? 0 0 "Failed to show rule INPUT eth0"
  CHECK_RESULT $? 0 0 "Failed to add rule OUTPUT eth0"
  CHECK_RESULT $? 0 0 "Failed to show rule OUTPUT eth0"
  CHECK_RESULT $? 0 0 "Failed to add rule FORWARD INPUT"
  CHECK_RESULT $? 0 0 "Failed to show rule FORWARD INPUT"
  CHECK_RESULT $? 0 0 "Failed to add rule FORWARD OUTPUT"
  CHECK_RESULT $? 0 0 "Failed to show rule FORWARD OUTPUT"
```

- 涉及命令：ip6tables×18

#### oe_test_ip6tables_02

- 描述：Test the basic functions of ip6tables
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "Failed to add testchain"
  CHECK_RESULT $? 0 0 "Failed to display testchain display"
  CHECK_RESULT $? 0 0 "Failed to delete testchain"
  CHECK_RESULT $? 0 1 "Failed to show testchain"
```

- 涉及命令：ip6tables×4

#### oe_test_ip_ipv6_01

- 描述：Test add ipv6
- 函数：`run_test, post_test`
- 断言（13 条）：

```
  CHECK_RESULT $? 0 0 "Failed to add ipv6 1001::1"
  CHECK_RESULT $? 0 0 "Failed to show ipv6 1001::1"
  CHECK_RESULT $? 0 0 "Failed to delete ipv6 ::1"
  CHECK_RESULT $? 0 0 "Failed to add ipv6 ::1"
  CHECK_RESULT $? 0 0 "Failed to show ipv6 ::1"
  CHECK_RESULT $? 0 0 "Failed to add ipv6 fe80::"
  CHECK_RESULT $? 0 0 "Failed to show ipv6 fe80::"
  CHECK_RESULT $? 0 0 "Failed to add valid_lft"
  CHECK_RESULT $? 0 0 "Failed to show valid_lft"
  CHECK_RESULT $? 0 0 "Failed to add home"
  CHECK_RESULT $? 0 0 "Failed to show home"
  CHECK_RESULT $? 0 0 "Failed to add nodad"
  ... 共 13 条（其余见源脚本）
```

#### oe_test_ip_ipv6_02

- 描述：IP add IPv6 address in multiple configuration formats
- 函数：`run_test, post_test`
- 断言（16 条）：

```
  CHECK_RESULT $? 0 0 "Failed to add ipv6 4::4"
  CHECK_RESULT $? 0 0 "Failed to show ipv6 4::4"
  CHECK_RESULT $? 0 0 "Failed to add ipv6 ::7"
  CHECK_RESULT $? 0 0 "Failed to show ipv6 ::7"
  CHECK_RESULT $? 0 0 "Failed to add ipv6 1111:"
  CHECK_RESULT $? 0 0 "Failed to show ipv6 1111:"
  CHECK_RESULT $? 0 0 "Failed to add ipv6 2001:"
  CHECK_RESULT $? 0 0 "Failed to show ipv6 2001:"
  CHECK_RESULT $? 0 0 "Failed to add ipv6 9000:"
  CHECK_RESULT $? 0 0 "Failed to show ipv6 9000:"
  CHECK_RESULT $? 0 0 "Failed to add ipv6 2000::"
  CHECK_RESULT $? 0 0 "Failed to show ipv6 2000::"
  ... 共 16 条（其余见源脚本）
```

#### oe_test_ip_ipv6_03

- 描述：Test ip show ipv6 config
- 函数：`run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Failed to show permanent"
  CHECK_RESULT $? 0 0 "Failed to show dynamic"
  CHECK_RESULT $? 0 0 "Failed to show tentative"
  CHECK_RESULT $? 0 0 "Failed to show deprecated"
  CHECK_RESULT $? 0 0 "Failed to show ${NODE1_NIC}"
  CHECK_RESULT $? 0 0 "Successd to show"
  CHECK_RESULT $? 0 0 "Failed to show host"
  CHECK_RESULT $? 0 0 "Failed to show link"
  CHECK_RESULT $? 0 0 "Failed to show global"
  CHECK_RESULT $? 0 0 "Failed to show inet6"
```

#### oe_test_ip_ipv6_04

- 描述：Test ifconfig add ipv6
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Failed to add ipv6 4::4"
  CHECK_RESULT $? 0 0 "Failed to show ipv6 4::4"
  CHECK_RESULT $? 0 0 "Failed to add ipv6 1111:"
  CHECK_RESULT $? 0 0 "Failed to show ipv6 1111:"
  CHECK_RESULT $? 0 0 "Failed to add ipv6 2001:"
  CHECK_RESULT $? 0 0 "Failed to show ipv6 2001:"
  CHECK_RESULT $? 0 0 "Failed to add ipv6 7::7"
  CHECK_RESULT $? 0 0 "Failed to show ipv6 7::7"
  CHECK_RESULT $? 0 0 "Failed to add ipv6 9000:"
  CHECK_RESULT $? 0 0 "Failed to show ipv6 9000:"
```

#### oe_test_iproute_ipv6_01

- 描述：Test ip add ipv6 route
- 函数：`run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $? 0 0 "Failed to add ipv6 route 1001::2"
  CHECK_RESULT $? 0 0 "Failed to show ipv6 route 1001::2"
  CHECK_RESULT $? 0 0 "Failed to add ipv6 route 1002::2"
  CHECK_RESULT $? 0 0 "Failed to show ipv6 route 1002::2"
  CHECK_RESULT $? 0 0 "Failed to add ipv6 route 1003::2"
  CHECK_RESULT $? 0 0 "Failed to show ipv6 route 1003::2"
  CHECK_RESULT $? 0 0 "Failed to add ipv6 route fe80::"
  CHECK_RESULT $? 0 0 "Failed to show ipv6 fe80::"
```

#### oe_test_iproute

- 描述：Test the basic functions of ip
- 函数：`run_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 1 "Set successfully"
  CHECK_RESULT $? 0 0 "Invalid ipv4 set successfully"
```

#### oe_test_ip_rule_01

- 描述：Test ip rule list and show
- 函数：`run_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Failed to display main"
  CHECK_RESULT $? 0 1 "Not just the main list"
  CHECK_RESULT $? 0 0 "Incomplete display"
```

#### oe_test_ip_rule_02

- 描述：IP add IPv6 rule
- 函数：`run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "Failed to add ipv4"
  CHECK_RESULT $? 0 0 "Failed to show ipv4"
  CHECK_RESULT $? 0 0 "IPV4 does not exist"
  CHECK_RESULT $? 0 0 "Failed to add ipv6"
  CHECK_RESULT $? 0 0 "Failed to show ipv6"
  CHECK_RESULT $? 0 0 "IPV6 does not exist"
```

#### oe_test_iptables-save

- 描述：Test the basic functions of iptables-save
- 函数：`pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $? 0 0 "Incomplete display nat"
  CHECK_RESULT $? 0 0 "Incomplete display mangle"
  CHECK_RESULT $? 0 0 "Incomplete display raw"
  CHECK_RESULT $? 0 0 "Incomplete display security"
  CHECK_RESULT $? 0 0 "Incomplete display filter"
  CHECK_RESULT $? 0 0 "Failed to display filter"
  CHECK_RESULT $? 0 1 "Not just filter"
```

- 涉及命令：iptables-save×6

#### oe_test_iptables

- 描述：Test iptables add rule
- 函数：`pre_test, run_test, post_test`
- 断言（12 条）：

```
  CHECK_RESULT $? 0 0 "Failed to add rule INPUT"
  CHECK_RESULT $? 0 0 "Failed to show rule INPUT"
  CHECK_RESULT $? 0 0 "Failed to add rule OUTPUT"
  CHECK_RESULT $? 0 0 "Failed to show rule OUTPUT"
  CHECK_RESULT $? 0 0 "Failed to add rule eth0 INPUT"
  CHECK_RESULT $? 0 0 "Failed to show rule eth0 INPUT"
  CHECK_RESULT $? 0 0 "Failed to add rule eth0 OUTPUT"
  CHECK_RESULT $? 0 0 "Failed to show rule eth0 OUTPUT"
  CHECK_RESULT $? 0 0 "Failed to add rule eth1 INPUT"
  CHECK_RESULT $? 0 0 "Failed to show rule eth1 INPUT"
  CHECK_RESULT $? 0 0 "Failed to add rule eth1 OUTPUT"
  CHECK_RESULT $? 0 0 "Failed to show rule eth1 OUTPUT"
```

- 涉及命令：iptables×18

#### oe_test_ipv6_BRIDGE

- 描述：Test bridge
- 函数：`pre_test, run_test, post_test`
- 断言（12 条）：

```
  CHECK_RESULT $? 0 0 "Failed to add br0"
  CHECK_RESULT $? 0 0 "Failed to show br0"
  CHECK_RESULT $? 0 0 "Failed to add ipv4 127.127.0.1"
  CHECK_RESULT $? 0 0 "Failed to show ipv4 127.127.0.1"
  CHECK_RESULT $? 0 0 "Failed to add ipv6 ::3"
  CHECK_RESULT $? 0 0 "Failed to show ipv6 ::3"
  CHECK_RESULT $? 0 0 "Failed to delete ipv4 127.127.0.1"
  CHECK_RESULT $? 0 1 "Successfully display ipv4 127.127.0.1"
  CHECK_RESULT $? 0 0 "Failed to delete ipv6 ::3"
  CHECK_RESULT $? 0 1 "Successfully display ipv6 ::3"
  CHECK_RESULT $? 0 0 "Failed to delete br0"
  CHECK_RESULT $? 0 1 "Failed to delete br0"
```

#### oe_test_ipv6_dnsmasq

- 描述：Test the basic functions of dnsmasq
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Service startup failed"
  CHECK_RESULT $? 0 0 "Failed to execute dig"
```

- 涉及命令：sed×1

#### oe_test_IPV6_traceroute6_01

- 描述：Test the basic functions of traceroute6
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "Failed to executetraceroute6"
```

#### oe_test_IPV6_traceroute6_02

- 描述：Test the basic functions of traceroute6 -n
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Failed to execute traceroute6"
  CHECK_RESULT $? 0 0 "Failed to repeat execute traceroute6"
```

- 涉及命令：traceroute6×2

#### oe_test_IPV6_traceroute6_tracepath6

- 描述：Test tracepath6
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Failed to execute traceroute6"
  CHECK_RESULT $? 0 0 "Failed to repeat execute tracepath6"
```

#### oe_test_ipv6_VLAN_01

- 描述：Test add ipv6 vlan
- 函数：`run_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "Failed to add VLAN"
  CHECK_RESULT $? 0 0 "Failed to show VLAN"
  CHECK_RESULT $? 0 0 "Failed to delete VLAN"
  CHECK_RESULT $? 0 1 "Succeed to show VLAN"
```

#### oe_test_ipv6_VLAN_02

- 描述：Test configure ipv6 vlan
- 函数：`pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $? 0 0 "Failed to add ipv4"
  CHECK_RESULT $? 0 0 "Failed to show ipv4"
  CHECK_RESULT $? 0 0 "Failed to add ipv6"
  CHECK_RESULT $? 0 0 "Failed to show ipv6"
  CHECK_RESULT $? 0 0 "Failed to delete ipv4"
  CHECK_RESULT $? 0 1 "Succeed to show ipv4"
  CHECK_RESULT $? 0 0 "Failed to delete ipv6"
  CHECK_RESULT $? 0 1 "Succeed to show ipv6"
```

#### oe_test_lldpad

- 描述：Test the basic functions of lldpad
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "Failed to execute lldpad -v"
  CHECK_RESULT $? 0 0 "Failed to execute lldpad -h"
  CHECK_RESULT $? 0 0 "Failed to execute lldpad -d"
  CHECK_RESULT $? 0 0 "Failed to display lld"
```

- 涉及命令：lldpad×3, pgrep×1, kill×1

#### oe_test_iscsid

- 描述：Test the basic functions of open-iscsi
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "Failed to start iscsid"
  CHECK_RESULT $? 0 0 "Service status not start"
  CHECK_RESULT $? 0 0 "Failed to stop iscsid"
  CHECK_RESULT $? 0 0 "Service status not stop"
```

#### oe_test_less

- 描述：Test the basic functions of less
- 函数：`run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Failed to execute less"
  CHECK_RESULT $? 0 0 "File testlog not exist"
```

- 涉及命令：test×1

#### oe_test_libcgroup_01

- 描述：Test cgcreate and cgdelete
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "Failed to execute cgcreate"
  CHECK_RESULT $? 0 0 "File not exist"
  CHECK_RESULT $? 0 0 "Failed to execute cgdelete"
  CHECK_RESULT $? 0 1 "File exist"
```

- 涉及命令：test×2, cgcreate×1, cgdelete×1

#### oe_test_libcgroup_02

- 描述：Test cgget and cgset
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Failed to execute cgget"
  CHECK_RESULT $? 0 0 "Failed to execute cgset"
  CHECK_RESULT $? 0 0 "Failed to display cpu.shares"
```

- 涉及命令：cgget×2, cgcreate×1, cgset×1, cgdelete×1

#### oe_test_libcgroup_03

- 描述：Test cgexec
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "Failed to execute cgexec"
  CHECK_RESULT $? 0 0 "Failed to execute cgclassify"
  CHECK_RESULT $? 0 0 "Failed to display pid"
  CHECK_RESULT $? 0 1 "File is not empty"
```

- 涉及命令：cgcreate×1, cgexec×1, ping×1, cgclassify×1, kill×1, cgdelete×1

#### oe_test_libcgroup_04

- 描述：Test cgsnapshot
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Failed to execute cgsnapshot"
  CHECK_RESULT $? 0 0 "Failed to execute lscgroup"
```

- 涉及命令：cgcreate×1, cgdelete×1

#### oe_test_libuser_sm

- 描述：Test the basic functions of libuser
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 "Failed to execute luseradd"
  CHECK_RESULT $? 0 0 "Failed to execute lpasswd"
  CHECK_RESULT $? 0 0 "Failed to display user"
  CHECK_RESULT $? 0 0 "Failed to display ltestuser"
  CHECK_RESULT $? 0 0 "Failed to execute sed"
  CHECK_RESULT $? 0 0 "Failed to execute useradd"
  CHECK_RESULT $? 0 0 "Failed to execute lpasswd testuser"
  CHECK_RESULT $? 0 0 "Failed to display sm3"
  CHECK_RESULT $? 0 0 "Failed to display testuser"
```

- 涉及命令：sed×2, grep×1, luserdel×1, userdel×1

#### oe_test_losetup

- 描述：Test the basic functions of losetup
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "Failed to mount /dev/loop0"
  CHECK_RESULT $? 0 0 "Failed to display floppy.img"
  CHECK_RESULT $? 0 1 "Succeed to display  /dev/loop0"
  CHECK_RESULT $? 0 0 "Failed to umount /dev/loop0"
  CHECK_RESULT $? 0 1 "Succeed to display floppy.img"
  CHECK_RESULT $? 0 0 "Failed to display  /dev/loop0"
```

- 涉及命令：losetup×5

#### oe_test_lsof

- 描述：Test the basic functions of lsof
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Failed to display bash"
  CHECK_RESULT $? 0 0 "Failed to execute lsof"
  CHECK_RESULT $? 0 0 "Failed to list pid"
```

- 涉及命令：lsof×1, grep×1, kill×1

#### oe_test_lz4_01

- 描述：Test lz4 compression and decompression
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "Failed to execute lz4 --help"
  CHECK_RESULT $? 0 0 "Failed to execute lz4 -V"
  CHECK_RESULT $? 0 0 "Failed to execute lz4 -q"
  CHECK_RESULT $? 0 0 "Failed to compress file"
  CHECK_RESULT $? 0 0 "Failed to execute lz4 -d"
  CHECK_RESULT $? 0 0 "Failed to decompress file"
```

- 涉及命令：lz4×3, test×1

#### oe_test_lz4_02

- 描述：Test repeated compression
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "Failed to execute lz4 -z"
  CHECK_RESULT $? 0 0 "Failed to find file"
  CHECK_RESULT $? 0 0 "Failed to execute lz4 -f"
  CHECK_RESULT $? 0 1 "Succeed to force repeat compress"
```

- 涉及命令：lz4×3, test×1

#### oe_test_maildrop_delivery_agent

- 描述：Test the basic functions of maildrop
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Service not started"
  CHECK_RESULT $? 0 0 "Failed to display hello"
```

- 涉及命令：grep×1

#### oe_test_mktemp

- 描述：Test the basic functions of mktemp
- 函数：`run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $? 0 0 "Failed to execute mktemp"
  CHECK_RESULT $? 0 0 "File does not exist in tmp"
  CHECK_RESULT $? 0 0 "Failed to execute mktemp -V"
  CHECK_RESULT $? 0 0 "Failed to execute mktemp -p"
  CHECK_RESULT $? 0 0 "File does not exist in testdir"
  CHECK_RESULT $? 0 0 "Failed to execute mktemp -d"
  CHECK_RESULT $? 0 0 "Directory does not exist"
```

- 涉及命令：test×3, mktemp×3

#### oe_test_ncurses

- 描述：Test the basic functions of infocmp
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "Failed to execute xterm"
  CHECK_RESULT $? 0 0 "Failed to execute infocmp"
  CHECK_RESULT $? 0 0 "Failed to execute infotocap"
  CHECK_RESULT $? 0 0 "Failed to execute run-term"
  CHECK_RESULT $? 0 0 "Failed to display term"
```

- 涉及命令：sed×2

#### oe_test_nfs_01

- 描述：Test the basic functions of exportfs
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "Load failed"
  CHECK_RESULT $? 0 0 "Failed to display ipv4"
  CHECK_RESULT $? 0 0 "Unload failed"
  CHECK_RESULT $? 0 1 "Succeed to display ipv4"
```

- 涉及命令：exportfs×6

#### oe_test_nfs_02

- 描述：Test showmount -e
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Load failed"
  CHECK_RESULT $? 0 0 "Service restart failed"
  CHECK_RESULT $? 0 0 "Failed to execute showmount"
```

- 涉及命令：exportfs×2, showmount×1

#### oe_test_nfs_03

- 描述：Test the mount function of NFS
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "Mount failed"
  CHECK_RESULT $? 0 1 "Folder is not read-only"
  CHECK_RESULT $? 0 0 "Failed to modify permission"
  CHECK_RESULT $? 0 0 "Folder is not write"
```

- 涉及命令：exportfs×2, mount×2

#### oe_test_pcre_001

- 描述：Use pcre to compile c programs
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "The current pcre version cannot be recognized. Please download it again"
  CHECK_RESULT $? 0 0 "Import library files into cache"
  CHECK_RESULT $? 0 0 "Run failed from ldconfig"
  CHECK_RESULT $? 0 0 "Compilation fails"
```

- 涉及命令：gcc×1, sed×1

#### oe_test_nmap

- 描述：Test the basic functions of nmap
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "System display error"
  CHECK_RESULT $? 0 0 "Version display error"
```

- 涉及命令：nmap×2

#### oe_test_normal_tcpdump_03

- 描述：Test the basic functions of tcpdump
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "Failed to execute tcpdump -w"
  CHECK_RESULT $? 0 0 "Failed to find test.pcap"
  CHECK_RESULT $? 0 0 "Failed to execute tcpdump -r"
  CHECK_RESULT $? 0 0 "Failed to display IP"
```

- 涉及命令：tcpdump×3, ping×1, test×1, kill×1

#### oe_test_ntp_01

- 描述：Test the basic functions of ntp
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "Service not started"
  CHECK_RESULT $? 0 0 "Service status not running"
  CHECK_RESULT $? 0 0 "Service not stoped"
  CHECK_RESULT $? 0 0 "Service status not dead"
  CHECK_RESULT $? 0 0 "Service not restarted"
  CHECK_RESULT $? 0 0 "ntpd.service status not running"
```

#### oe_test_ntp_02

- 描述：Test the basic functions of sntp
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Failed to execute sntp"
  CHECK_RESULT $? 0 1 "Process of sntp exist"
```

- 涉及命令：sntp×1

#### oe_test_os-prober_01

- 描述：Test the basic functions of os-prober
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "Failed to execute os-prober"
```

#### oe_test_os-prober_02

- 描述：Test the basic functions of linux-boot-prober
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Failed to execute linux-boot-prober"
  CHECK_RESULT $? 0 0 "linux-boot-prober not installed"
  CHECK_RESULT $? 0 0 "linux-boot-prober should return empty output for invalid device"
```

#### oe_test_perl

- 描述：Test the basic functions of perl
- 函数：`run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "Failed to execute perl"
  CHECK_RESULT $? 0 0 "perl -v command execution failed"
  CHECK_RESULT $? 0 0 "perl -V command execution failed"
  CHECK_RESULT $? 0 0 "not found hello world !"
```

- 涉及命令：perl×3

#### oe_test_python_01

- 描述：Test the basic functions of python
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "system_name display failed"
  CHECK_RESULT $? 0 0 "system_version display failed"
  CHECK_RESULT $? 0 0 "kernel_version display failed"
```

- 涉及命令：grep×1

#### oe_test_python_pip_install

- 描述：Test the basic functions of pip3
- 函数：`pre_test, run_test, post_test`
- 断言（13 条）：

```
  CHECK_RESULT $? 0 0 "Failed to execute pip3 install --user"
  CHECK_RESULT $? 0 0 "Failed to find site-packages/requests in /root"
  CHECK_RESULT $? 0 0 "Failed to execute pip3 install --root"
  CHECK_RESULT $? 0 0 "Failed to find site-packages/requests in /tmp"
  CHECK_RESULT $? 0 0 "Failed to execute pip3 install --prefix"
  CHECK_RESULT $? 0 0 "Failed to find requests in /tmp"
  CHECK_RESULT $? 0 0 "Failed to execute pip3 list"
  CHECK_RESULT $? 0 0 "Failed to execute pip3 install --no-deps"
  CHECK_RESULT $? 0 1 "Succeed to execute pip3 list"
  CHECK_RESULT $? 0 0 "Failed to execute pip3 install --force-reinstall"
  CHECK_RESULT $? 0 0 "Failed to execute pip3 install --upgrade"
  CHECK_RESULT $? 0 0 "Failed to repead execute pip3 install --upgrade"
  ... 共 13 条（其余见源脚本）
```

- 涉及命令：test×3

#### oe_test_python_subprocess_01

- 描述：Test subprocess.Popen
- 函数：`run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "Failed to execute close_fds=False"
```

#### oe_test_python_subprocess_02

- 描述：Test subprocess.Popen
- 函数：`run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "Failed to execute close_fds=True"
```

#### oe_test_python_subprocess_03

- 描述：Test subprocess.Popen
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "Failed to execute preexec_fn=os.setsid"
```

#### oe_test_gettext

- 描述：gettext Basic Functions test
- 函数：`pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $? 0 0 "Failed to execute the python file"
  CHECK_RESULT $? 0 0 "Description Failed to modify the test.po file"
  CHECK_RESULT $? 0 0 "Can't generate mo file"
  CHECK_RESULT $? 0 0 "test.py cannot be executed properly or Unable to filter necessary characters"
  CHECK_RESULT $? 0 0 "Unable to generate us.po"
  CHECK_RESULT $? 0 0 ".mo files cannot be generated using us.po"
  CHECK_RESULT $? 0 0 "test.py cannot be executed properly or Unable to filter necessary characters"
```

- 涉及命令：sed×4, xgettext×2, mkdir×2, msgfmt×2

#### oe_test_python_urllib3_urlopen_01

- 描述：Test urllib.request.urlopen
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Status 200 code return failed"
  CHECK_RESULT $? 0 0 "Status 400 code return failed"
```

#### oe_test_python_urllib3_urlopen_02

- 描述：Test response.getcode
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Data return failed"
  CHECK_RESULT $? 0 0 "Status code return failed"
```

- 涉及命令：grep×2

#### oe_test_python_urllib3_urlopen_03

- 描述：Test request timeout
- 函数：`run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "No timeout"
  CHECK_RESULT $? 0 0 "Parsing failed"
```

- 涉及命令：grep×1

#### oe_test_route_ipv4

- 描述：Test route add ipv4 route
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "Failed to add route"
  CHECK_RESULT $? 0 0 "Failed to show route"
  CHECK_RESULT $? 0 0 "Failed to del route"
  CHECK_RESULT $? 0 1 "Succeed to show route"
  CHECK_RESULT $? 0 0 "Failed to add default route"
  CHECK_RESULT $? 0 0 "Failed to show default route"
```

- 涉及命令：route×1

#### oe_test_route_ipv6

- 描述：Test route add ipv6 route
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "Failed to add route 5001::"
  CHECK_RESULT $? 0 0 "Failed to show route 5001::"
  CHECK_RESULT $? 0 0 "Failed to add route 1112::"
  CHECK_RESULT $? 0 0 "Failed to show route 1112::"
```

- 涉及命令：route×6

#### oe_test_rpcbind

- 描述：Test the basic functions of rpcbind
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "Failed to check rpcbind"
  CHECK_RESULT $? 0 0 "Failed to execute netstat"
  CHECK_RESULT $? 0 0 "Failed to execute rpcbind"
  CHECK_RESULT $? 0 0 "Failed to display rpcbind"
```

- 涉及命令：netstat×1, rpcinfo×1

#### oe_test_rpm_cmd

- 描述：Test the basic functions of rpm
- 函数：`pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $? 0 0 "Failed to execute rpm -qip"
  CHECK_RESULT $? 0 0 "Failed to execute rpm -ivh"
  CHECK_RESULT $? 0 0 "Failed to execute rpm -qa"
  CHECK_RESULT $? 0 0 "Failed to execute rpm -qi"
  CHECK_RESULT $? 0 0 "Failed to execute rpm -ql"
  CHECK_RESULT $? 0 0 "Failed to execute rpm -e"
  CHECK_RESULT $? 0 1 "Succeed to display tcllib"
```

- 涉及命令：rpm×7

#### oe_test_rpmrebuild

- 描述：Test the basic functions of rpmrebuild
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "Failed to execute rpmrebuild"
  CHECK_RESULT $? 0 0 "Failed to find curl"
  CHECK_RESULT $? 0 0 "Failed to execute rpm2cpio"
  CHECK_RESULT $? 0 0 "Failed to  find /usr/bin/curl"
  CHECK_RESULT $? 0 0 "Failed to execute diff"
  CHECK_RESULT $? 0 0 "The two files have different permissions"
```

- 涉及命令：test×2

#### oe_test_rsyslog_01

- 描述：Test the basic functions of rsyslog
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "Service not started"
  CHECK_RESULT $? 0 0 "The service was not pulled up again"
  CHECK_RESULT $? 0 0 "Service not started"
  CHECK_RESULT $? 0 0 "Quantity is greater than 100"
  CHECK_RESULT $? 0 0 "Pid unchanged"
```

- 涉及命令：kill×2

#### oe_test_rsyslog_02

- 描述：Test the basic functions of rsyslog
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "imjournalRatelimitInterval does not exist"
  CHECK_RESULT $? 0 0 "StateFile does not exist"
```

#### oe_test_rsyslog_03

- 描述：Test the basic functions of rsyslog
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "Systemd-journald not started"
  CHECK_RESULT $? 0 0 "Rsyslog not started"
  CHECK_RESULT $? 0 0 "Failed to find system.journal"
  CHECK_RESULT $? 0 0 "Failed to find system.journal"
  CHECK_RESULT $? 0 0 "File has no content"
```

#### oe_test_rsyslog_04

- 描述：Test the basic functions of rsyslog
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "Failed to stop service"
  CHECK_RESULT $? 0 0 "Failed to start service"
  CHECK_RESULT $? 0 0 "Log not recorded"
  CHECK_RESULT $? 0 0 "Failed to restart service"
  CHECK_RESULT $? 0 0 "The pid not recorded"
```

#### oe_test_rsyslog_05

- 描述：Test the basic functions of rsyslog
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "Service not stoped"
  CHECK_RESULT $? 0 0 "Service not start"
  CHECK_RESULT $? 0 0 "Service not restart"
  CHECK_RESULT $? 0 0 "Failed to find imjournal.state"
  CHECK_RESULT $? 0 0 "Failed to find main_pid"
```

- 涉及命令：test×1

#### oe_test_rsyslog_06

- 描述：Test the basic functions of rsyslog
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "Failed to execute logger -p"
  CHECK_RESULT $? 0 0 "Failed to execute add local0.info"
  CHECK_RESULT $? 0 0 "Failed to execute add local0.warning"
  CHECK_RESULT $? 0 0 "Failed to execute add local0.debug"
  CHECK_RESULT $? 0 0 "No 3 keywords"
  CHECK_RESULT $? 0 0 "No 2 keywords"
```

- 涉及命令：logger×4, grep×2, tail×2

#### oe_test_rsyslog_07

- 描述：Test the basic functions of rsyslog
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Service not started"
  CHECK_RESULT $? 0 0 "Service status not running"
```

#### oe_test_rsyslog_08

- 描述：Test the basic functions of rsyslog
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Start time exceeds 0.1s"
  CHECK_RESULT $? 0 0 "Service not started"
```

#### oe_test_rsyslog_09

- 描述：Test the basic functions of rsyslog
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Failed to restart rsyslog"
  CHECK_RESULT $? 0 1 "Failure information exists in the log"
```

- 涉及命令：tail×1

#### oe_test_rsyslog_10

- 描述：Test the basic functions of rsyslog
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "Failed to execute cp"
  CHECK_RESULT $? 0 1 "Time zone changed"
  CHECK_RESULT $? 0 1 "Pid not changed"
  CHECK_RESULT $? 0 0 "Time zone not changed"
  CHECK_RESULT $? 0 0 "/var/log/messages not logged"
```

- 涉及命令：grep×1

#### oe_test_rule_ipv6

- 描述：Test ip add ipv6 rule
- 函数：`run_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "Failed to add route"
  CHECK_RESULT $? 0 0 "Failed to show route"
  CHECK_RESULT $? 0 0 "Failed to delete route"
  CHECK_RESULT $? 0 1 "Succeed to show route"
```

#### oe_test_service

- 描述：Test sshd service
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Service not started"
  CHECK_RESULT $? 0 0 "service not stop"
  CHECK_RESULT $? 0 0 "service not started"
```

#### oe_test_setools

- 描述：Test the basic functions of setools-console
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "Failed to execute seinfo -c"
  CHECK_RESULT $? 0 0 "Failed to display x_selection"
  CHECK_RESULT $? 0 0 "Failed to display rules about httpd"
  CHECK_RESULT $? 0 0 "Failed to display types about NetworkManager"
  CHECK_RESULT $? 0 0 "Failed to display all types with domain attribute"
```

- 涉及命令：seinfo×5

#### oe_test_shadow

- 描述：Test shadow file
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "Failed to execute useradd"
  CHECK_RESULT $? 0 0 "Failed to execute chage -l"
  CHECK_RESULT $? 0 0 "Failed to execute chage -M"
  CHECK_RESULT $? 0 0 "Failed to change rpctest"
```

- 涉及命令：chage×3, grep×1, groupadd×1, useradd×1, groupdel×1, userdel×1

#### oe_test_sshd

- 描述：Test the basic functions of sshd
- 函数：`run_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "Failed to start sshd"
  CHECK_RESULT $? 0 0 "Failed to restart sshd"
  CHECK_RESULT $? 0 0 "Failed to check sshd"
  CHECK_RESULT $? 0 0 "Failed to find pid in /var/run/sshd.pid"
```

#### oe_test_stat

- 描述：Test the basic functions of stat
- 函数：`run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $? 0 0 "Failed to execute stat --help"
  CHECK_RESULT $? 0 0 "Failed to execute stat --version"
  CHECK_RESULT $? 0 0 "Failed to execute stat -c"
  CHECK_RESULT $? 0 0 "Failed to execute stat --format"
  CHECK_RESULT $? 1 0 "Failed to test broken link with -L option"
  CHECK_RESULT $? 0 0 "Failed to test directory link with -L option"
  CHECK_RESULT "${attr_1}" "${attr_2}" 1 "Failed to test access for file and dir with -L option"
```

- 涉及命令：stat×3

#### oe_test_sudo_E

- 描述：Test sudo -E
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "Failed to execute sudo"
```

- 涉及命令：userdel×1

#### oe_test_sudo_maxseq

- 描述：Test sudo maxseq
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT "${count}" 100 0 "Failed to execute sudo"
```

- 涉及命令：usermod×1, sed×1, userdel×1

#### oe_test_sudo

- 描述：Test the basic functions of sudo
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Failed to execute sudo"
  CHECK_RESULT $? 1 0 "Folder exist"
```

- 涉及命令：test×1, userdel×1

#### oe_test_sudo_U

- 描述：Test sudo -U
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "Failed to execute sudo"
```

- 涉及命令：useradd×2, userdel×2

#### oe_test_systemd_journald

- 描述：Test the basic functions of journalctl
- 函数：`run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 "Failed to execute journalctl -f"
  CHECK_RESULT $? 0 0 "Failed to find begin"
  CHECK_RESULT $? 0 0 "Failed to execute journalctl --lines"
  CHECK_RESULT $? 0 0 "Failed to execute journalctl -show-cursor"
  CHECK_RESULT $? 0 0 "Failed to execute journalctl --directory"
  CHECK_RESULT $? 0 0 "Failed to execute journalctl"
  CHECK_RESULT $? 0 1 "Succeed to execute journalctl"
  CHECK_RESULT $? 0 0 "Failed to execute journalctl disk"
  CHECK_RESULT $? 0 1 "Succeed to execute journalctl disk"
```

- 涉及命令：journalctl×1, grep×1, kill×1

#### oe_test_systemd-update-utmp

- 描述：Test systemd-update-utmp
- 函数：`run_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "systemd-update-utmp-runlevel.service non-existent"
```

#### oe_test_tcpdump

- 描述：Test the basic functions of tcpdump
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "Failed to execute tcpdump -r"
```

- 涉及命令：ping×1, tcpdump×1

#### oe_test_tftp_ipv6

- 描述：Test tftp
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "Failed to execute tftp get"
  CHECK_RESULT $? 0 0 "Failed to find hello1"
  CHECK_RESULT $? 0 0 "Failed to execute put"
  CHECK_RESULT $? 0 0 "Failed to find hello2"
```

- 涉及命令：sed×3, route×2, tftp×2, ping6×1

#### oe_test_expat

- 描述：package expat test
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "test1.xml failed to add content"
  CHECK_RESULT $? 0 0 "xmlwf test1 failed"
  CHECK_RESULT $? 0 0 "test2.xml failed to add content"
  CHECK_RESULT $? 2 0 "Invalid xml execution result error"
```

#### oe_test_attr_001

- 描述：attr add attributes
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "Failed to set the EA extended properties"
  CHECK_RESULT $? 0 0 "The newly added property cannot be queried"
  CHECK_RESULT $? 0 0 "Unable to query user.foo add property"
  CHECK_RESULT $? 0 0 "Unable to display EA properties in hexadecimal"
  CHECK_RESULT $? 0 0 "Cannot display EA attributes in base64"
  CHECK_RESULT $? 0 1 "Failed to delete attributes"
```

- 涉及命令：getfattr×5, setfattr×2, attr×1

#### oe_test_procps-ng-uptime

- 描述：package procps-ng-uptime test
- 函数：`run_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "uptime -V Echo information error"
  CHECK_RESULT $? 0 0 "uptime -h Echo information error"
  CHECK_RESULT $? 0 0 "uptime -s Echo information error"
  CHECK_RESULT $? 0 0 "uptime -p Echo information error"
  CHECK_RESULT $? 0 0 "uptime  Echo information error"
```

- 涉及命令：uptime×4

#### oe_test_unalias_001

- 描述：File system common command unalias
- 函数：`run_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Failure to Collect Information"
  CHECK_RESULT $? 0 0 "Failure to Collect Information"
  CHECK_RESULT $? 0 1 "Command executed successfully"
```

#### oe_test_time_01

- 描述：Test the basic functions of time
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "Failed to execute time"
  CHECK_RESULT $? 0 0 "Failed to find time record"
  CHECK_RESULT $? 0 0 "Failed to execute time -p"
  CHECK_RESULT $? 0 1 "Succeed to find time record"
  CHECK_RESULT $? 0 1 "Failed to execute /usr/bin/time"
```

- 涉及命令：time×1

#### oe_test_time_02

- 描述：Test /usr/bin/time
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "Failed to execute time -o"
  CHECK_RESULT $? 0 0 "Failed to find testlog"
  CHECK_RESULT $? 0 0 "Failed to execute time --output"
  CHECK_RESULT $? 0 0 "Failed to find pagefaults"
```

#### oe_test_wget

- 描述：Test the basic functions of wget
- 函数：`pre_test, run_test, post_test`
- 断言（11 条）：

```
  CHECK_RESULT $? 0 0 "Failed to execute wget"
  CHECK_RESULT $? 0 0 "Failed to download"
  CHECK_RESULT $? 0 0 "Failed to execute wget -O"
  CHECK_RESULT $? 0 0 "Failed to find test.tar.gz"
  CHECK_RESULT $? 0 1 "Failed to execute wget --limit"
  CHECK_RESULT $? 0 0 "Failed to limit download rate"
  CHECK_RESULT $? 0 0 "Failed to execute wget on backgroud"
  CHECK_RESULT $? 0 0 "Failed to kill wget"
  CHECK_RESULT $? 0 0 "Failed to execute wget -c"
  CHECK_RESULT $? 0 0 "Failed to kill -9 wget"
  CHECK_RESULT $? 0 0 "Failed to continue execute wget"
```

- 涉及命令：wget×2, kill×2

#### oe_test_systemd_SCEN_01

- 描述：Test the basic functions of systemd
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "TestA.service start failed"
  CHECK_RESULT $? 0 0 "TestA.service is not running"
  CHECK_RESULT $? 0 0 "TestB.service start failed"
  CHECK_RESULT $? 0 0 "TestB.service is not running"
  CHECK_RESULT $? 0 0 "TestB.service restart failed"
  CHECK_RESULT $? 0 0 "TestA.service restart failed"
```

#### oe_test_systemd_SCEN_02

- 描述：Test the basic functions of systemd
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "TestB.service start success"
  CHECK_RESULT $? 0 0 "TestB.service is not failed"
  CHECK_RESULT $? 0 0 "TestA.service start failed"
  CHECK_RESULT $? 0 0 "TestA.service is not running"
  CHECK_RESULT $? 0 0 "TestB.service restart failed"
  CHECK_RESULT $? 0 0 "TestA.service restart failed"
```

- 涉及命令：sed×1

#### oe_test_systemd_SCEN_03

- 描述：Test the basic functions of systemd
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "TestB.service start success"
  CHECK_RESULT $? 0 0 "TestB.service is not failed"
  CHECK_RESULT $? 0 0 "TestA.service start failed"
  CHECK_RESULT $? 0 0 "TestA.service is not running"
  CHECK_RESULT $? 0 0 "TestB.service start failed"
  CHECK_RESULT $? 0 1 "TestA.service start success"
```

- 涉及命令：sed×1

#### oe_test_systemd_SCEN_04

- 描述：Test the basic functions of systemd
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "TestB.service start failed"
  CHECK_RESULT $? 0 0 "TestB.service is not running"
  CHECK_RESULT $? 0 0 "TestA.service stop failed"
  CHECK_RESULT $? 0 0 "TestA.service is not dead"
  CHECK_RESULT $? 0 0 "TestB.service restart failed"
  CHECK_RESULT $? 0 0 "TestA.service is still not stopped"
```

#### oe_test_systemd_SCEN_05

- 描述：Test the basic functions of systemd
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "TestA.service start failed"
  CHECK_RESULT $? 0 0 "TestA.service is not running"
  CHECK_RESULT $? 0 0 "TestB.service start failed"
  CHECK_RESULT $? 0 0 "TestB.service is not running"
  CHECK_RESULT $? 0 0 "TestB.service stop failed"
  CHECK_RESULT $? 0 0 "TestA.service stop failed"
```

#### oe_test_systemd_SCEN_06

- 描述：Test the basic functions of systemd
- 函数：`pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $? 0 0 "TestA.service start failed"
  CHECK_RESULT $? 0 0 "TestA.service is not running"
  CHECK_RESULT $? 0 0 "TestB.service start failed"
  CHECK_RESULT $? 0 0 "TestB.service is not running"
  CHECK_RESULT $? 0 0 "TestB.service reload success"
  CHECK_RESULT $? 0 0 "TestB.service restart success"
  CHECK_RESULT $? 0 0 "TestB.service is not failed"
  CHECK_RESULT $? 0 0 "TestA.service is still not running"
```

- 涉及命令：sed×2

#### oe_test_systemd_SCEN_07

- 描述：Test the basic functions of systemd
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "TestB.service start failed"
  CHECK_RESULT $? 0 0 "TestB.service is not running"
  CHECK_RESULT $? 0 0 "TestA.service start failed"
  CHECK_RESULT $? 0 0 "TestA.service is not running"
  CHECK_RESULT $? 0 0 "TestA.service restart failed"
  CHECK_RESULT $? 0 1 "TestB.service restart success"
```

#### oe_test_systemd_SCEN_08

- 描述：Test the basic functions of systemd
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "TestA.service start success"
  CHECK_RESULT $? 0 0 "TestA.service is not failed"
  CHECK_RESULT $? 0 0 "TestB.service start failed"
  CHECK_RESULT $? 0 0 "TestB.service is not running"
  CHECK_RESULT $? 0 0 "TestA.service restart failed"
  CHECK_RESULT $? 0 1 "TestB.service restart succeed"
```

- 涉及命令：sed×1

#### oe_test_systemd_SCEN_09

- 描述：Test the basic functions of systemd
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "TestA.service start failed"
  CHECK_RESULT $? 0 0 "TestA.service is not running"
  CHECK_RESULT $? 0 0 "TestB.service start success"
  CHECK_RESULT $? 0 0 "TestB.service is not failed"
  CHECK_RESULT $? 0 0 "TestA.service restart failed"
  CHECK_RESULT $? 0 0 "TestB.service restart failed"
```

- 涉及命令：sed×1

#### oe_test_systemd_SCEN_10

- 描述：Test the basic functions of systemd
- 函数：`pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $? 0 0 "TestA.service start failed"
  CHECK_RESULT $? 0 0 "TestA.service is not running"
  CHECK_RESULT $? 0 0 "TestB.service start success"
  CHECK_RESULT $? 0 0 "TestB.service is not failed"
  CHECK_RESULT $? 0 0 "TestA.service stop failed"
  CHECK_RESULT $? 0 0 "TestA.service start failed"
  CHECK_RESULT $? 0 0 "TestB.service restart success"
```

- 涉及命令：sed×1

#### oe_test_systemd_SCEN_11

- 描述：Test the basic functions of systemd
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "TestB.service start failed"
  CHECK_RESULT $? 0 0 "TestB.service is not running"
  CHECK_RESULT $? 0 0 "TestA.service start failed"
  CHECK_RESULT $? 0 0 "TestA.service is not running"
  CHECK_RESULT $? 0 0 "TestA.service stop failed"
  CHECK_RESULT $? 0 0 "TestB.service is still not running"
```

#### oe_test_systemd_SCEN_12

- 描述：Test the basic functions of systemd
- 函数：`pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $? 0 0 "TestA.service start failed"
  CHECK_RESULT $? 0 0 "TestA.service is not running"
  CHECK_RESULT $? 0 0 "TestB.service start failed"
  CHECK_RESULT $? 0 0 "TestB.service is not running"
  CHECK_RESULT $? 0 0 "TestA.service reload success"
  CHECK_RESULT $? 0 0 "TestA.service restart success"
  CHECK_RESULT $? 0 0 "TestA.service is not failed"
  CHECK_RESULT $? 0 0 "TestB.service is still not running"
```

- 涉及命令：sed×2

#### oe_test_systemd_SCEN_13

- 描述：Test the basic functions of systemd
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "TestA.service start success"
  CHECK_RESULT $? 0 0 "TestA.service is not failed"
  CHECK_RESULT $? 0 0 "TestB.service stop failed"
  CHECK_RESULT $? 0 0 "TestB.service is not dead"
  CHECK_RESULT $? 0 0 "TestB.service start failed"
  CHECK_RESULT $? 0 0 "TestA.service is still not failed"
```

- 涉及命令：sed×1

#### oe_test_systemd_SCEN_14

- 描述：Test the basic functions of systemd
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "TestA.service start success"
  CHECK_RESULT $? 0 0 "TestA.service is not failed"
  CHECK_RESULT $? 0 0 "TestB.service stop failed"
  CHECK_RESULT $? 0 0 "TestB.service is not dead"
  CHECK_RESULT $? 0 0 "TestB.service restart failed"
  CHECK_RESULT $? 0 0 "TestA.service is still not failed"
```

- 涉及命令：sed×1

#### oe_test_systemd_SCEN_15

- 描述：Test the basic functions of systemd
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "TestA.service start success"
  CHECK_RESULT $? 0 0 "TestA.service is not failed"
  CHECK_RESULT $? 0 0 "TestB.service start failed"
  CHECK_RESULT $? 0 0 "TestB.service is not running"
  CHECK_RESULT $? 0 0 "TestB.service restart failed"
  CHECK_RESULT $? 0 0 "TestA.service is still not failed"
```

- 涉及命令：sed×1

#### oe_test_find

- 描述：test find
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "find fail"
  CHECK_RESULT $? 0 0 "useradd fail"
  CHECK_RESULT $? 0 0 "find fail"
  CHECK_RESULT $? 0 0 "find fail"
  CHECK_RESULT $? 0 0 "find fail"
```

- 涉及命令：useradd×1

#### oe_test_source

- 描述：test source
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "test fail"
  CHECK_RESULT $? 0 0 "source fail"
```

#### oe_test_pwd_002

- 描述：File system common command builtin
- 函数：`run_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Command executed fail"
  CHECK_RESULT $? 0 0 "Command executed fail"
```

- 涉及命令：pwd×2

#### oe_test_mtr

- 描述：test mtr
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "mtr -v fail"
  CHECK_RESULT $? 0 0 "mtr -h fail"
  CHECK_RESULT $? 0 0 "mtr -r dns fail"
  CHECK_RESULT $? 0 0 "mtr -e fail"
  CHECK_RESULT $? 0 0 "mtr -u fail"
```

- 涉及命令：mtr×5

#### oe_test_sadf_001

- 描述：File system common command test-sadf
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Failure to Collect Information"
  CHECK_RESULT $? 0 0 "Failed to generate a file"
  CHECK_RESULT $? 0 0 "Failed to parse the file"
```

- 涉及命令：test×1

#### oe_test_pstree

- 描述：test pstree
- 函数：`run_test`
- 断言（8 条）：

```
  CHECK_RESULT $? 0 0 "pstree -V fail"
  CHECK_RESULT $? 0 0 "pstree -a fail"
  CHECK_RESULT $? 0 0 "pstree -A fail"
  CHECK_RESULT $? 0 0 "pstree -p fail"
  CHECK_RESULT $? 0 0 "pstree -g fail"
  CHECK_RESULT $? 0 0 "pstree -s fail"
  CHECK_RESULT $? 0 0 "pstree -t fail"
  CHECK_RESULT $? 0 0 "pstree -u fail"
```

- 涉及命令：pstree×8

#### oe_test_vmstat

- 描述：test vmstat
- 函数：`run_test`
- 断言（8 条）：

```
  CHECK_RESULT $? 0 0 "vmstat -h fail"
  CHECK_RESULT $? 0 0 "vmstat -V fail"
  CHECK_RESULT $? 0 0 "vmstat fail"
  CHECK_RESULT $? 0 0 "vmstat -f fail"
  CHECK_RESULT $? 0 0 "vmstat -w fail"
  CHECK_RESULT $? 0 0 "vmstat -t fail"
  CHECK_RESULT $? 0 0 "vmstat -s fail"
  CHECK_RESULT $? 0 0 "vmstat -d fail"
```

- 涉及命令：vmstat×7

#### oe_test_let

- 描述：File system common command builtin
- 函数：`run_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Command executed fail"
  CHECK_RESULT $? 0 0 "Command executed fail"
  CHECK_RESULT $? 0 0 "Command executed fail"
```

#### oe_test_unset_001

- 描述：File system common command builtin
- 函数：`run_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Command executed fail"
  CHECK_RESULT $? 0 0 "Command executed fail"
  CHECK_RESULT $? 0 1 "Command executed fail"
```

- 涉及命令：unset×1

#### oe_test_aide_config_cfgfile

- 描述：Get configuration properties from cfgfile configuration file
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "Get aide configuration items: failed!"
```

- 涉及命令：sed×1

#### oe_test_aide_config_check

- 描述：Detect whether there is a problem with the configuration file
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "Modify aide configuration items: failed!"
  CHECK_RESULT $? 0 0 "Check aide configuration contain error: failed!"
  CHECK_RESULT $? 0 0 "Delete aide configuration items: failed!"
  CHECK_RESULT $? 1 0 "Check aide configuration not contain error: failed!"
```

- 涉及命令：sed×3

#### oe_test_aide_basic_info

- 描述：Display aide version
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Check aide version: failed!"
  CHECK_RESULT $? 0 0 "Check aide help: failed!"
```

#### oe_test_aide_init_database

- 描述：Aide init database
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "Aide init datebase: failed!"
```

#### oe_test_aide_security

- 描述：Security test
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "Check aide.conf file owner failed!"
  CHECK_RESULT $? 0 0 "Check aide.conf file group failed!"
  CHECK_RESULT $? 0 0 "Check aide.conf file permission failed!"
  CHECK_RESULT $? 0 0 "Check aide.log file owner failed!"
  CHECK_RESULT $? 0 0 "Check aide.log file group failed!"
  CHECK_RESULT $? 0 0 "Check aide.log file permission failed!"
```

- 涉及命令：sed×1

#### oe_test_audit_abnormal_kill

- 描述：Check the audit service after killing the audit process abnormally
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "Start audit: failed!"
  CHECK_RESULT $? 0 0 "Check audit status: failed!"
  CHECK_RESULT $? 0 0 "View auditd.service file: failed!"
  CHECK_RESULT $? 0 0 "Kill auditd.service server: failed!"
  CHECK_RESULT $? 0 0 "Stop audit process and get audit status:  failed!"
  CHECK_RESULT $? 0 0 "Check whether the two pid are the same:  failed!"
```

- 涉及命令：kill×2

#### oe_test_audit_fixed_memory_01

- 描述：Kill -19 audit process, execute audit log script and check the status of auditd
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Check auditctl -s: failed!"
  CHECK_RESULT $? 0 0 "Backlog not increase indefinitely: failed!"
```

- 涉及命令：kill×2, auditctl×1

#### oe_test_audit_fixed_memory_02

- 描述：Kill -19 audit process, execute C script and check the status of auditd
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Get a.out: failed!"
  CHECK_RESULT $? 0 0 "Get backlog: failed!"
```

- 涉及命令：gcc×1, auditctl×1, kill×1

#### oe_test_bbr_02

- 描述：Turn on BBR algorithm
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Turn on BBR algorithm: failed!"
  CHECK_RESULT $? 0 0 "Check BBR is added to the tcp_congestion_control: failed!"
```

#### oe_test_bbr_04

- 描述：modprobe/rmmod sch_fq
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "Display sch_fq info: failed!"
  CHECK_RESULT $? 0 0 "Modprobe sch_fq: failed!"
  CHECK_RESULT $? 0 0 "Check sch_fq exist: failed!"
  CHECK_RESULT $? 0 0 "Remove sch_fq: failed!"
  CHECK_RESULT $? 1 0 "Check sch_fq not exist: failed!"
```

- 涉及命令：grep×2

#### oe_test_bonding_SCEN_05

- 描述：Add the macvlan device created on bond to the network namespace verification
- 函数：`pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $? 0 0 "Load bond module: failed!"
  CHECK_RESULT $? 0 0 "Restart net: failed!"
  CHECK_RESULT $? 0 0 "Set bond0: failed!"
  CHECK_RESULT $? 0 0 "Add the macvlan device name1: failed!"
  CHECK_RESULT $? 0 0 "Add the macvlan device bond0_local: failed!"
  CHECK_RESULT $? 0 0 "Set bond0_local up : failed!"
  CHECK_RESULT $? 0 0 "Set bond0_local netns name1: failed!"
```

- 涉及命令：sed×1, modprobe×1

#### oe_test_ima_v2_manual_gen_digest_01

- 描述：Generate and check digest files and TLV files
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "Set digest file: failed!"
  CHECK_RESULT $? 0 0 "Check digest file: failed!"
  CHECK_RESULT $? 0 0 "Set tlv file: failed!"
  CHECK_RESULT $? 0 0 "Check tlv file: failed!"
```

- 涉及命令：gen_digest_lists×2, test×2, mkdir×1

#### oe_test_ipv6_sysctl_01

- 描述：Enable/Disable Ipv6
- 函数：`run_test`
- 断言（12 条）：

```
  CHECK_RESULT $? 0 0 "Check default disable ipv6 is 0: failed!"
  CHECK_RESULT $? 0 0 "Check all disable_ipv6 is 0: failed!"
  CHECK_RESULT $? 0 0 "Disable all ipv6: failed!"
  CHECK_RESULT $? 0 0 "Disable default ipv6: failed!"
  CHECK_RESULT $? 0 0 "Check default disable ipv6 is 1: failed!"
  CHECK_RESULT $? 0 0 "Check all disable_ipv6 is 1: failed!"
  CHECK_RESULT $? 1 0 "Get inet6: failed!"
  CHECK_RESULT $? 0 0 "Set net.ipv6.conf.all.disable_ipv6=0: failed!"
  CHECK_RESULT $? 0 0 "net.ipv6.conf.default.disable_ipv6=0: failed!"
  CHECK_RESULT $? 0 0 "Check default disable ipv6 is 0: failed!"
  CHECK_RESULT $? 0 0 "Check all disable ipv6 is 0: failed!"
  CHECK_RESULT $? 0 0 "Enable all ipv6: failed!"
```

- 涉及命令：sysctl×4

#### oe_test_ipv6_sysctl_02

- 描述：Enable/Disable Ipv6 in conf file
- 函数：`run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "Set disable ipv6: failed!"
  CHECK_RESULT $? 0 0 "Check disable ipv6: failed!"
  CHECK_RESULT $? 1 0 "Check all ipv6: failed!"
  CHECK_RESULT $? 0 0 "Enable all ipv6: failed!"
  CHECK_RESULT $? 0 0 "Set enable ipv6: failed!"
  CHECK_RESULT $? 0 0 "Check all ipv6 is enable: failed!"
```

- 涉及命令：sed×3, sysctl×2

#### oe_test_IPVLAN_07

- 描述：The ipvlan driver is unloaded and loaded normally
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 1 0 "ipvlan is not loaded: failed!"
  CHECK_RESULT $? 0 0 "Modprobe ipvlan: failed!"
  CHECK_RESULT $? 0 0 "Load ipvlan: failed!"
  CHECK_RESULT $? 0 0 "Display ipvlan mode info: failed!"
  CHECK_RESULT $? 0 0 "Remove ipvlan mode: failed!"
  CHECK_RESULT $? 1 0 "ipvlan is not loaded after lsmod: failed!"
```

#### oe_test_mpstat_01

- 描述：Get CPU overhead
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Get cpu overhead: failed"
  CHECK_RESULT ${#date_list[*]} 2 0 "Get cpu overhead twice: failed!"
  CHECK_RESULT $(${date_list[1]} - ${date_list[0]}) 3 0 "The cpu overhead s obtained every 3s: failed!"
```

- 涉及命令：sed×1

#### oe_test_mtr_01

- 描述：Check the number of packets sent by mtr
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Check the number of packets sent per second 15: failed!"
  CHECK_RESULT $? 0 0 "Check mtr -h: failed!"
```

- 涉及命令：mtr×2

#### oe_test_Netlink_ip_01

- 描述：Hulk supports ipv4\ipv6 network netlink interface
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Set ipv6: failed!"
  CHECK_RESULT $? 0 0 "Set ipv4: failed!"
```

#### oe_test_netstat_01

- 描述：Check the status of current net by netstat
- 函数：`pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $? 0 0 "invalid option: -nap"
  CHECK_RESULT $? 0 0 "invalid option: -g"
  CHECK_RESULT $? 1 0 "invalid option:-jjj"
  CHECK_RESULT $? 0 0 "invalid option: -u"
  CHECK_RESULT $? 0 0 "invalid option: --tcp"
  CHECK_RESULT $? 0 0 "invalid option: --programs"
  CHECK_RESULT $? 0 0 "invalid option: -lntup"
```

- 涉及命令：netstat×5

#### oe_test_normal_tcpdump_02

- 描述：Add the macvlan device created on bond to the network namespace verification
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "ping -I  ${NODE1_NIC} baidu.com:failed"
  CHECK_RESULT $? 0 0 "tcpdump -i: failed!"
```

- 涉及命令：kill×2, ping×1

#### oe_test_normal_tcpdump_04

- 描述：Confirm numad -m parameter function
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "ping -I  ${NODE1_NIC} baidu.com:failed"
  CHECK_RESULT $? 0 0 "tcpdump -i ${NODE1_NIC} -c 10:failed"
```

- 涉及命令：ping×1, tcpdump×1, kill×1

#### oe_test_Numad_01

- 描述：Confirm numad -m parameter function
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "Confirm numad -m: failed!"
```

- 涉及命令：numad×1

#### oe_test_perf_top_01

- 描述：Verify output readability of perf top
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "perf top:failed"
  CHECK_RESULT $? 0 0 "Verify output readability of perf top:failed!"
```

- 涉及命令：pgrep×1

#### oe_test_sar_01

- 描述：Brazil daylight time rules are normal
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Using ‘sar’ to check CPU information: failed!"
  CHECK_RESULT $? 0 0 "Check CPU information: failed!"
  CHECK_RESULT $? 0 0 "Check 5 times : failed!"
```

- 涉及命令：sar×1, grep×1

#### oe_test_user_debug_iotop_03

- 描述：Displays the i/o that the process or thread is actually doing
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Execute i/o process:failed"
  CHECK_RESULT $? 0 0 "Failed to check the running i/o process"
  CHECK_RESULT $? 0 0 "Failed to check the all i/o process!"
```

- 涉及命令：iotop×1, kill×1

#### oe_test_user_debug_iotop_SCEN_01

- 描述：Execute the iotop command and observe the output "prio" information
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 1 0 "Verify PRIO:failed!"
```

- 涉及命令：iotop×1

#### oe_test_sed_001

- 描述：File system common command test-sed
- 函数：`pre_test, run_test, post_test`
- 断言（12 条）：

```
  CHECK_RESULT $? 0 0 "Return value error"
  CHECK_RESULT $? 0 0 "Version is error"
  CHECK_RESULT $? 0 0 "sed --help fail"
  CHECK_RESULT $? 0 0 "set testline fail"
  CHECK_RESULT $? 1 0 "delete firstline fail"
  CHECK_RESULT $? 0 0 "lookup firstline error"
  CHECK_RESULT $? 0 0 "print 2~3 fail"
  CHECK_RESULT $? 0 0 "replace aaaa fail"
  CHECK_RESULT $? 0 0 "sed '1,4d'execute fail"
  CHECK_RESULT $? 0 0 "set ffff fail"
  CHECK_RESULT $? 0 1 "set hello fail"
  CHECK_RESULT $? 0 1 "sed -i '1,5d' execute fail"
```

- 涉及命令：sed×8, rpm×1

#### oe_test_xz

- 描述：Command test-xz
- 函数：`pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $? 0 0 "Return value error"
  CHECK_RESULT $? 0 0 "Version is error"
  CHECK_RESULT $? 0 0 "Help value error"
  CHECK_RESULT $? 0 0  "testfile.xz is right"
  CHECK_RESULT $? 0 0  "testfile is exist"
  CHECK_RESULT $? 0 0  "testfile.xz is success"
  CHECK_RESULT $? 0 0  "testfile.xz unxz success"
```

- 涉及命令：test×4, rpm×1

#### oe_test_tr

- 描述：File system common command test-tr
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "Version is error"
  CHECK_RESULT $? 1 0 "delete testfile fail"
  CHECK_RESULT $? 0 0 "cover testfile fail"
  CHECK_RESULT $? 0 0 "duplicate removal error"
  CHECK_RESULT $? 0 0 "replace testfile fail"
  CHECK_RESULT $? 0 0 "upper testfile fail"
```

#### oe_test_popt

- 描述：使用popt库输出命令的帮助信息
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "c file failed to compile"
  CHECK_RESULT $? 0 0 "Unable to view parse usage"
  CHECK_RESULT $? 0 0 "The parse usage fails to be applied"
```

- 涉及命令：gcc×1

#### oe_test_chkconfig_01

- 描述：File system common command test-chkconfig
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "version display failure"
  CHECK_RESULT $? 0 0 "help information fails to be displayed"
  CHECK_RESULT $? 1 0 "service deletion failure"
  CHECK_RESULT $? 0 0 "service added failure"
  CHECK_RESULT $? 0 0 "on status setting failure"
  CHECK_RESULT $? 0 0 "off status setting failure"
```

- 涉及命令：chkconfig×2

#### oe_test_libxml2_001

- 描述：File system common command test-libxml2
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "Return value error"
  CHECK_RESULT $? 0 0 "compile testfile fail"
  CHECK_RESULT $? 0 0 "Generate CreatedXml.xml fail "
  CHECK_RESULT $? 0 0 "CreatedXml.xml information is error"
  CHECK_RESULT $? 0 0 "Generate createxml.xml fail"
  CHECK_RESULT $? 0 0 "createxml.xml information error"
```

- 涉及命令：test×2, rpm×1

#### oe_test_libxml2_002

- 描述：File system common command test-libxml2
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Return value error"
  CHECK_RESULT $? 0 0 "compile testfile fail"
  CHECK_RESULT $? 0 0 "libxml2 information error "
```

- 涉及命令：return×3, rpm×1, test×1

#### oe_test_libxml2_003

- 描述：test the xml2-config can be used regularly
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "Return value error"
  CHECK_RESULT $? 0 0 "Return value error"
  CHECK_RESULT $? 0 0 "Return value error"
  CHECK_RESULT $? 0 0 "Return value error"
```

#### oe_test_libxml2_004

- 描述：test the xmlcatalog can be used regularly
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Return value error"
  CHECK_RESULT $? 0 0 "Return value error"
```

#### oe_test_logrotate_004

- 描述：Test logrotate partition
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Partition failure"
  CHECK_RESULT $? 0 0 "File does not exist"
  CHECK_RESULT $? 0 0 "File does not exist"
```

- 涉及命令：test×2, head×1, logrotate×1

#### oe_test_gcc_001

- 描述：File system common command test-gcc
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "person file fails"
  CHECK_RESULT $? 0 0 "main file fails"
  CHECK_RESULT $? 0 0 "main.txt file fails"
  CHECK_RESULT $? 0 0 "ldd main file fails"
  CHECK_RESULT $? 0 0 "main_static file fails"
  CHECK_RESULT $? 0 0 "ldd main_static file fails"
```

- 涉及命令：test×3, mkdir×1

#### oe_test_gcc_002

- 描述：Dynamic Compilation Test for gcc Command
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "libperson file fails"
  CHECK_RESULT $? 0 0 "main file fails"
  CHECK_RESULT $? 0 0 "main.txt file fails"
  CHECK_RESULT $? 0 0 "lddmain.txt file fails"
```

- 涉及命令：test×2, mkdir×1

#### oe_test_od

- 描述：Command test-od
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "run od -b failed"
  CHECK_RESULT $? 0 0 "run od -c failed"
  CHECK_RESULT $? 0 1 "run od -j 2 -c failed"
  CHECK_RESULT $? 0 0 "run od -j 2 -c failed"
  CHECK_RESULT $? 0 0 "run od --help failed"
```

#### oe_test_od_001

- 描述：File system common command test-top
- 函数：`pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $? 0 0 "run od -t x1 failed"
  CHECK_RESULT $? 0 0 "run od -t o1 failed"
  CHECK_RESULT $? 0 0 "run od -t d1 failed"
  CHECK_RESULT $? 0 0 "run od -N 6 -c failed"
  CHECK_RESULT $? 0 0 "run od -j 2 -c failed"
  CHECK_RESULT $? 0 0 "run od -t d2 -s failed"
  CHECK_RESULT $? 0 0 "run od -v -t f4 failed"
  CHECK_RESULT $? 0 0 "--help fail"
```

#### oe_test_top

- 描述：File system common command test-top
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：top×4, mkdir×1

#### oe_test_nmap_001

- 描述：Use nmap case
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Error,Fail to create /tmp/ncat_log"
  CHECK_RESULT $? 0 0 "Error, please check port:8080"
  CHECK_RESULT $? 0 0 "Error, please check /tmp/ncat_log"
```

- 涉及命令：iptables×1, ncat×1, grep×1

#### oe_test_sysstat_01

- 描述：test mpstat command
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "mpstat 1 3 -A failed"
  CHECK_RESULT $? 0 0  "test1 content error"
  CHECK_RESULT $? 0 0 "mpstat 1 3 -P failed"
  CHECK_RESULT $? 0 0  "test2 content error"
```

#### oe_test_sysstat_02

- 描述：test sysstat packages
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 "sysstat service start failed"
  CHECK_RESULT $? 0 0 "sar --help failed"
  CHECK_RESULT $? 0 0 "sar command failed"
  CHECK_RESULT $? 0 0 "sar -u -o failed"
  CHECK_RESULT $? 0 0 "not found testcpulog"
  CHECK_RESULT $? 0 0 "sar -r -o failed"
  CHECK_RESULT $? 0 0 "not found testmemlog"
  CHECK_RESULT $? 0 0 "sar -b -o failed"
  CHECK_RESULT $? 0 0 "not found testiolog"
```

- 涉及命令：sar×3, test×3

#### oe_test_sysstat_03

- 描述：test sysstat package
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "iostat 1 10 failed"
  CHECK_RESULT $? 0 0 "dd command failed"
  CHECK_RESULT $? 0 0 "iostat 1 2 failed"
```

#### oe_test_zlib_001

- 描述：Test calls zlib compression and decompression interface
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "compile succeed"
  CHECK_RESULT $? 0 0 "The lengths before and after compression are not equal"
  CHECK_RESULT $? 0 0 "Data is inconsistent before and after compression"
  CHECK_RESULT $? 0 0 "Data is inconsistent before and after compression"
```

- 涉及命令：gcc×1
