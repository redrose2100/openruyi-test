# secscanner

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 特性域（feature-test） |
| 套件路径 | `$OET_PATH/testcases/feature-test/secscanner` |
| 注册用例数 | 300 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_secscanner_001 | Regular users are not allowed to run secscanner | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_secscanner_002 | check permission of cvedatabase.db | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_secscanner_003 | secscanner check cve and log file check | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_secscanner_004 | secscanner check cve_t and log file check | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_secscanner_005 | check permission of secscanner.log | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_secscanner_006 | set_motd check | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_secscanner_007 | set_password_rem check | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_secscanner_008 | set_passComplex warning check | pre_test/run_test/post_test | 6 | ✔ |  |  |
| oe_test_secscanner_009 | set_passComplex fix | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_secscanner_010 | lock_attacking_user check if unlock_time not set | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_secscanner_011 | lock_attacking_user check if unlock_time!=300 | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_secscanner_012 | disable_icmp_redirect check if net.ipv4.conf.all.accept_redirects not set | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_secscanner_013 | disable_icmp_redirect check if net.ipv4.conf.all.accept_redirects=1 | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_secscanner_014 | disable_icmp_redirect=no | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_secscanner_015 | set_umask check when umask not set (extended to multiple files) | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_secscanner_016 | set_tmout test (session timeout configuration) | pre_test/run_test/post_test | 5 | ✔ |  |  |
| oe_test_secscanner_017 | set_tmout test - when set to no (should not modify TMOUT) | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_secscanner_018 | set_tmout test - when TMOUT exists (should not modify existing value) | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_secscanner_019 | set_file_property test (file and directory permissions) | pre_test/run_test/post_test | 5 | ✔ |  |  |
| oe_test_secscanner_020 | set_file_property test - when set to no (should not modify permissions) | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_secscanner_021 | Password policy configuration test (login.defs) | pre_test/run_test/post_test | 11 | ✔ |  |  |
| oe_test_secscanner_022 | Password policy test - when set to no (should not modify login.defs) | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_secscanner_023 | Password policy test - when values already exist in login.defs | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_secscanner_024 | SSH login banner test - basic functionality | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_secscanner_025 | SSH login banner test - when set to no (should not modify sshd_config) | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_secscanner_026 | SSH login banner test - when Banner already exists in sshd_config | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_secscanner_027 |  | — | 0 |  |  |  |
| oe_test_secscanner_028 | SSH algorithms test - when set to no (should not modify sshd_config) | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_secscanner_029 |  | — | 0 |  |  |  |
| oe_test_secscanner_030 |  | — | 0 |  |  |  |
| oe_test_secscanner_031 | SSH GSSAPI test - when set to no (should not modify sshd_config) | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_secscanner_032 | disable_unused_software test - telnet.socket service | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_secscanner_033 | disable_unused_software test - when set to no (should not stop services) | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_secscanner_034 |  | — | 0 |  |  |  |
| oe_test_secscanner_035 | disable_unused_user test - when set to no (should not modify users) | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_secscanner_036 | disable_unused_user test - when user shell is /bin/bash | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_secscanner_037 | Log recording test - login events, kernel warn, error events, auth events | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_secscanner_038 | Log recording test - when set to no (should not modify rsyslog.conf) | pre_test/run_test/post_test | 5 | ✔ |  |  |
| oe_test_secscanner_039 | Log recording test - when configurations already exist | pre_test/run_test/post_test | 13 | ✔ |  |  |
| oe_test_secscanner_040 | Log recording test - when some configurations exist | pre_test/run_test/post_test | 11 | ✔ |  |  |
| oe_test_secscanner_041 |  | — | 0 |  |  |  |
| oe_test_secscanner_042 |  | — | 0 |  |  |  |
| oe_test_secscanner_043 |  | — | 0 |  |  |  |
| oe_test_secscanner_044 |  | — | 0 |  |  |  |
| oe_test_secscanner_045 | FTP configuration test - banner (ftpd_banner) when set to yes | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_secscanner_046 | FTP configuration test - anonymous access (anonymous_enable) when set to yes | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_secscanner_047 | FTP configuration test - restrict directory (chroot_local_user) when set to no | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_secscanner_048 | FTP configuration test - banner (ftpd_banner) when set to no | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_secscanner_049 | FTP configuration test - anonymous access (anonymous_enable) when set to no | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_secscanner_050 | deny_root_login test | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_secscanner_051 | deny_root_login test with PermitRootLogin=yes | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_secscanner_052 | hide_issue_info test | pre_test/run_test/post_test | 8 | ✔ |  |  |
| oe_test_secscanner_053 | hide_issue_info test with both issue files | pre_test/run_test/post_test | 8 | ✔ |  |  |
| oe_test_secscanner_054 | hide_issue_info test with only issue file | pre_test/run_test/post_test | 6 | ✔ |  |  |
| oe_test_secscanner_055 | hide_issue_info test with only issue.net file | pre_test/run_test/post_test | 8 | ✔ |  |  |
| oe_test_secscanner_056 | hide_issue_info test with no issue files | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_secscanner_057 | hide_issue_info=no test with both issue files | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_secscanner_058 | forbidden_to_su=yes test | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_secscanner_059 | forbidden_to_su=no test | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_secscanner_060 | set_bashrc_alias=yes test | pre_test/run_test/post_test | 5 | ✔ |  |  |
| oe_test_secscanner_061 | set_bashrc_alias=no test | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_secscanner_062 |  | — | 0 |  |  |  |
| oe_test_secscanner_063 |  | — | 0 |  |  |  |
| oe_test_secscanner_064 | set_log_file_property test | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_secscanner_065 | set_log_file_property=no test | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_secscanner_066 | set_ssh_syslogfacility test | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_secscanner_067 | set_ssh_syslogfacility=no test | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_secscanner_068 | set_ssh_loglevel test | pre_test/run_test/post_test | 5 | ✔ |  |  |
| oe_test_secscanner_069 | set_ssh_loglevel=no test | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_secscanner_070 | set_always_set_path test | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_secscanner_071 | set_always_set_path=no test | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_secscanner_072 | set_rp_filter test | pre_test/run_test/post_test | 7 | ✔ |  |  |
| oe_test_secscanner_073 | set_rp_filter=no test | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_secscanner_074 | set_ssh_permitemptypasswd test | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_secscanner_075 | set_ssh_permitemptypasswd=no test | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_secscanner_076 | set_ssh_permitemptypasswd test (existing no config) | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_secscanner_077 | set_ssh_permitemptypasswd=no test (empty config) | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_secscanner_078 | set_kernel_oops test | pre_test/run_test/post_test | 12 | ✔ |  |  |
| oe_test_secscanner_079 | set_kernel_oops=no test | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_secscanner_080 | set_prohibit_ctrlaltdel test | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_secscanner_081 | set_prohibit_ctrlaltdel=no test | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_secscanner_082 | set_disable_magickeys test | pre_test/run_test/post_test | 5 | ✔ |  |  |
| oe_test_secscanner_083 | set_disable_magickeys=no test | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_secscanner_084 | set_nologin_list test | pre_test/run_test/post_test | 7 | ✔ |  |  |
| oe_test_secscanner_085 | set_nologin_list=no test | pre_test/run_test/post_test | 5 | ✔ |  |  |
| oe_test_secscanner_086 | set_limit_resources test | pre_test/run_test/post_test | 9 | ✔ |  |  |
| oe_test_secscanner_087 | set_limit_resources=no test | pre_test/run_test/post_test | 7 | ✔ |  |  |
| oe_test_secscanner_088 | set_nologin_list=yes test (password-auth) | pre_test/run_test/post_test | 5 | ✔ |  |  |
| oe_test_secscanner_089 | set_nologin_list=yes test (system-auth) | pre_test/run_test/post_test | 5 | ✔ |  |  |
| oe_test_secscanner_090 | set_nologin_list=no test (password-auth) | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_secscanner_091 | set_nologin_list=no test (system-auth) | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_secscanner_092 | password policy test | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_secscanner_093 | password policy test (set_*=no) | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_secscanner_094 | password complexity test | pre_test/run_test/post_test | 11 | ✔ |  |  |
| oe_test_secscanner_095 | password complexity test (set_passComplex=no) | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_secscanner_096 | ssh_login_tmout test (set to yes) | pre_test/run_test/post_test | 6 | ✔ |  |  |
| oe_test_secscanner_097 | ssh_login_tmout test (set to no) | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_secscanner_098 | ssh_login_tmout test with existing ClientAliveCountMax (set to yes) | pre_test/run_test/post_test | 5 | ✔ |  |  |
| oe_test_secscanner_099 | ssh_login_tmout test with existing both ClientAliveInterval and ClientAliveCountMax (set to yes) | pre_test/run_test/post_test | 5 | ✔ |  |  |
| oe_test_secscanner_100 | set_tmout test (set to yes) | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_secscanner_101 | set_tmout test (set to no) | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_secscanner_102 | set_tmout test with existing TMOUT configuration (set to yes) | pre_test/run_test/post_test | 6 | ✔ |  |  |
| oe_test_secscanner_103 | enable_ssh test (set to yes, service running) | pre_test/run_test/post_test | 5 | ✔ |  |  |
| oe_test_secscanner_104 | disable_telnet test (set to yes) | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_secscanner_105 | remove_http test (set to yes) | pre_test/run_test/post_test | 5 | ✔ |  |  |
| oe_test_secscanner_106 | disable_telnet test (set to no) | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_secscanner_107 | remove_http test (set to no) | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_secscanner_108 | remove_tftp test (set to yes) | pre_test/run_test/post_test | 5 | ✔ |  |  |
| oe_test_secscanner_109 | remove_tftp test (set to no) | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_secscanner_110 | ssh_protocol test (set to yes) | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_secscanner_111 | ssh_protocol test (set to no) | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_secscanner_112 | ssh_protocol test (Protocol set to 1) | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_secscanner_113 | rootUID_unique test (set to yes) | pre_test/run_test/post_test | 5 | ✔ |  |  |
| oe_test_secscanner_114 | rootUID_unique test (set to no) | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_secscanner_115 | overdue_passwd test (set to yes) | pre_test/run_test/post_test | 7 | ✔ |  |  |
| oe_test_secscanner_116 | overdue_passwd test (set to no) | pre_test/run_test/post_test | 6 | ✔ |  |  |
| oe_test_secscanner_117 | set_umask test (set to yes) | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_secscanner_118 | set_umask test (set to no) | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_secscanner_119 | deny_root_login test (set to yes) | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_secscanner_120 | deny_root_login test (set to no) | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_secscanner_121 | disable_unused_user test (set to yes, level3) | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_secscanner_122 | disable_unused_user test (set to no, level3) | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_secscanner_123 | disable_unused_user test - when user shell is /bin/bash, level3 | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_secscanner_124 | expired_account test (set to yes, level3) | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_secscanner_125 | expired_account test (set to no, level3) | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_secscanner_126 | forbidden_to_su test (set to yes, level3) | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_secscanner_127 | forbidden_to_su test (set to no, level3) | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_secscanner_128 | passwd_property test (set to yes, level3) | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_secscanner_129 | passwd_property test (set to no, level3) | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_secscanner_130 | shadow_property test (set to yes, level3) | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_secscanner_131 | shadow_property test (set to no, level3) | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_secscanner_132 | group_property test (set to yes, level3) | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_secscanner_133 | group_property test (set to no, level3) | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_secscanner_134 | gshadow_property test (set to yes, level3) | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_secscanner_135 | gshadow_property test (set to no, level3) | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_secscanner_136 | passwdx_property test (set to yes, level3) | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_secscanner_137 | passwdx_property test (set to no, level3) | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_secscanner_138 | shadowx_property test (set to yes, level3) | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_secscanner_139 | shadowx_property test (set to no, level3) | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_secscanner_140 | groupx_property test (set to yes, level3) | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_secscanner_141 | groupx_property test (set to no, level3) | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_secscanner_142 | gshadowx_property test (set to yes, level3) | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_secscanner_143 | gshadowx_property test (set to no, level3) | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_secscanner_144 | set_selinux test (set to yes, level3) | pre_test/run_test/post_test | 5 | ✔ |  |  |
| oe_test_secscanner_145 | set_selinux test (set to no, level3) | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_secscanner_146 | set_selinux test (SELINUX=enforcing, set to yes, level3) | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_secscanner_147 | set_selinux test (SELINUX=permissive, set to yes, level3) | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_secscanner_148 | set_audit test (set to yes, level3) | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_secscanner_149 | set_audit test (set to no, level3) | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_secscanner_150 | set_audit test (auditd not installed, set to yes, level3) | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_secscanner_151 | set_audit test (auditd already enabled, set to yes, level3) | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_secscanner_152 | set_tmout test with no existing TMOUT configuration (set to yes) | pre_test/run_test/post_test | 7 | ✔ |  |  |
| oe_test_secscanner_153 | enable_ssh test (set to no, service running) | pre_test/run_test/post_test | 6 | ✔ |  |  |
| oe_test_secscanner_154 | set_tmout test (set to no, level3) | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_secscanner_155 | set_rsyslog test (set to yes, service disabled, level3) | pre_test/run_test/post_test | 5 | ✔ |  |  |
| oe_test_secscanner_156 | set_rsyslog test (set to yes, service already enabled, level3) | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_secscanner_157 | set_rsyslog test (set to no, service disabled, level3) | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_secscanner_158 | set_rsyslog test (set to yes, service disabled, level3) | pre_test/run_test/post_test | 5 | ✔ |  |  |
| oe_test_secscanner_159 | set_auditrules test (set to yes, level3) | pre_test/run_test/post_test | 6 | ✔ |  |  |
| oe_test_secscanner_160 | set_auditrules test (set to yes, level3) | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_secscanner_161 | set_auditrules test (set to no, level3) | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_secscanner_162 | set_ftp_install test (set to yes, level3) | pre_test/run_test/post_test | 5 | ✔ |  |  |
| oe_test_secscanner_163 | set_ftp_install test (set to no, level3) | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_secscanner_164 | set_ypbind_install test (set to yes, level3) | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_secscanner_165 | set_ypbind_install test (set to no, level3) | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_secscanner_166 | set_ypbind_install test (set to yes, level3) | pre_test/run_test/post_test | 5 | ✔ |  |  |
| oe_test_secscanner_167 | set_ypbind_install test (set to no, level3) | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_secscanner_168 | set_tftp test (set to yes, level3) | pre_test/run_test/post_test | 5 | ✔ |  |  |
| oe_test_secscanner_169 | set_tftp test (set to no, level3) | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_secscanner_170 | set_aide test (set to yes, aide not installed, level3) | pre_test/run_test/post_test | 6 | ✔ |  |  |
| oe_test_secscanner_171 | set_aide test (set to no, aide not installed, level3) | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_secscanner_172 | set_aide test (set to yes, aide already installed, level3) | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_secscanner_173 | set_aide test (set to no, aide already installed, level3) | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_secscanner_174 | set_chrony test (set to yes, chrony not installed, level3) | pre_test/run_test/post_test | 5 | ✔ |  |  |
| oe_test_secscanner_175 | set_chrony test (set to no, chrony not installed, level3) | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_secscanner_176 | set_chrony test (set to yes, chrony already installed, level3) | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_secscanner_177 | set_chrony test (set to no, chrony already installed, level3) | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_secscanner_178 | set_disabled_NfsServer test (set to yes, nfs-server enabled, level3) | pre_test/run_test/post_test | 6 | ✔ |  |  |
| oe_test_secscanner_179 | set_disabled_NfsServer test (set to no, nfs-server enabled, level3) | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_secscanner_180 | set_disabled_NfsServer test (set to yes, nfs-server already disabled, level3) | pre_test/run_test/post_test | 5 | ✔ |  |  |
| oe_test_secscanner_181 | set_disabled_NfsServer test (set to no, nfs-server already disabled, level3) | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_secscanner_182 | set_disabled_DNSserver test (set to yes, DNS service already enabled, level3) | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_secscanner_183 | set_disabled_DNSserver test (set to no, DNS service already enabled, level3) | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_secscanner_184 | set_disabled_DNSserver test (set to yes, DNS service already disabled, level3) | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_secscanner_185 | set_disabled_DNSserver test (set to no, DNS service already disabled, level3) | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_secscanner_186 | set_dhcp test (set to yes, dhcp service already enabled, level3) | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_secscanner_187 | set_dhcp test (set to no, dhcp service already enabled, level3) | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_secscanner_188 | set_dhcp test (set to yes, dhcp service already disabled, level3) | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_secscanner_189 | set_dhcp test (set to no, dhcp service already disabled, level3) | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_secscanner_190 | set_rpc test (set to yes, rpcbind service already enabled, level3) | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_secscanner_191 | set_rpc test (set to no, rpcbind service already enabled, level3) | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_secscanner_192 | set_rpc test (set to yes, rpcbind service already disabled, level3) | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_secscanner_193 | set_rpc test (set to no, rpcbind service already disabled, level3) | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_secscanner_194 | set_samba test (set to yes, smb service already enabled, level3) | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_secscanner_195 | set_samba test (set to no, smb service already enabled, level3) | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_secscanner_196 | set_samba test (set to yes, smb service already disabled, level3) | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_secscanner_197 | set_samba test (set to no, smb service already disabled, level3) | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_secscanner_198 | set_snmp test (set to yes, snmpd service already enabled, level3) | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_secscanner_199 | set_snmp test (set to no, snmpd service already enabled, level3) | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_secscanner_200 | set_snmp test (set to yes, snmpd service already disabled, level3) | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_secscanner_201 | set_snmp test (set to no, snmpd service already disabled, level3) | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_secscanner_202 | set_dovecot test (set to yes, dovecot service already enabled, level3) | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_secscanner_203 | set_dovecot test (set to no, dovecot service already enabled, level3) | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_secscanner_204 | set_dovecot test (set to yes, dovecot service already disabled, level3) | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_secscanner_205 | set_dovecot test (set to no, dovecot service already disabled, level3) | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_secscanner_206 | set_dovecot test (set to yes, dovecot service masked, level3) | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_secscanner_207 | set_dovecot test (set to yes, dovecot not installed, level3) | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_secscanner_208 | set_dovecot test (set to no, dovecot service masked, level3) | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_secscanner_209 | set_dovecot test (set to no, dovecot not installed, level3) | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_secscanner_210 | set_link_protection test (set to yes, both protections disabled, euler) | pre_test/run_test/post_test | 5 | ✔ |  |  |
| oe_test_secscanner_211 | set_link_protection test (set to no, both protections disabled, euler) | pre_test/run_test/post_test | 5 | ✔ |  |  |
| oe_test_secscanner_212 | set_link_protection test (set to yes, both protections enabled, euler) | pre_test/run_test/post_test | 5 | ✔ |  |  |
| oe_test_secscanner_213 | set_link_protection test (set to no, both protections enabled, euler) | pre_test/run_test/post_test | 5 | ✔ |  |  |
| oe_test_secscanner_214 | set_link_protection test (set to yes, symlink enabled, hardlink disabled, euler) | pre_test/run_test/post_test | 5 | ✔ |  |  |
| oe_test_secscanner_215 | set_link_protection test (set to yes, symlink disabled, hardlink enabled, euler) | pre_test/run_test/post_test | 5 | ✔ |  |  |
| oe_test_secscanner_216 | set_prohibition_usb test (set to yes, USB storage not prohibited, euler) | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_secscanner_217 | set_prohibition_usb test (set to no, USB storage not prohibited, euler) | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_secscanner_218 | set_prohibition_usb test (set to yes, USB storage already prohibited, euler) | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_secscanner_219 | set_prohibition_usb test (set to no, USB storage already prohibited, euler) | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_secscanner_220 | set_remove_ftp test (set to yes, ftp installed, euler) | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_secscanner_221 | set_remove_ftp test (set to no, ftp installed, euler) | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_secscanner_222 | set_remove_ftp test (set to yes, ftp not installed, euler) | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_secscanner_223 | set_remove_ftp test (set to no, ftp not installed, euler) | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_secscanner_224 | set_remove_tftp test (set to yes, tftp installed, euler) | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_secscanner_225 | set_remove_tftp test (set to no, tftp installed, euler) | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_secscanner_226 | set_remove_tftp test (set to yes, tftp not installed, euler) | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_secscanner_227 | set_remove_tftp test (set to no, tftp not installed, euler) | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_secscanner_228 | set_remove_telnet test (set to no, telnet already installed, euler) | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_secscanner_229 | set_remove_telnet test (set to yes, telnet not installed, euler) | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_secscanner_230 | set_remove_telnet test (set to yes, telnet already installed, euler) | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_secscanner_231 | set_remove_telnet test (set to no, telnet not installed, euler) | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_secscanner_232 | set_remove_snmp test (set to yes, net-snmp already installed, euler) | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_secscanner_233 | set_remove_snmp test (set to no, net-snmp already installed, euler) | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_secscanner_234 | set_remove_snmp test (set to yes, net-snmp not installed, euler) | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_secscanner_235 | set_remove_snmp test (set to no, net-snmp not installed, euler) | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_secscanner_236 | set_remove_python2 test (set to yes, python2 not installed, euler) | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_secscanner_237 | set_remove_python2 test (set to no, python2 not installed, euler) | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_secscanner_238 | set_remove_python2 test (set to yes, python2 already installed, euler) | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_secscanner_239 | set_remove_python2 test (set to no, python2 already installed, euler) | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_secscanner_240 | set_remove_LdapServer test (set to yes, openldap-servers already installed, euler) | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_secscanner_241 | set_remove_LdapServer test (set to no, openldap-servers already installed, euler) | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_secscanner_242 | set_remove_LdapServer test (set to yes, openldap-servers not installed, euler) | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_secscanner_243 | set_remove_LdapServer test (set to no, openldap-servers not installed, euler) | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_secscanner_244 | set_disable_debugShell test (set to yes, debug-shell enabled, euler) | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_secscanner_245 | set_disable_debugShell test (set to no, debug-shell enabled, euler) | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_secscanner_246 | set_disable_debugShell test (set to yes, debug-shell disabled, euler) | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_secscanner_247 | set_disable_debugShell test (set to no, debug-shell disabled, euler) | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_secscanner_248 | set_disable_Rsync test (set to yes, rsyncd enabled, euler) | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_secscanner_249 | set_disable_Rsync test (set to no, rsyncd enabled, euler) | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_secscanner_250 | set_disable_Rsync test (set to yes, rsyncd disabled, euler) | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_secscanner_251 | set_disable_Rsync test (set to no, rsyncd disabled, euler) | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_secscanner_252 | set_remove_Cups test (set to yes, cups installed, euler) | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_secscanner_253 | set_remove_Cups test (set to no, cups installed, euler) | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_secscanner_254 | set_remove_Cups test (set to yes, cups not installed, euler) | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_secscanner_255 | set_remove_Cups test (set to no, cups not installed, euler) | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_secscanner_256 | set_remove_Ypserv test (set to yes, ypserv installed, euler) | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_secscanner_257 | set_remove_Ypserv test (set to no, ypserv installed, euler) | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_secscanner_258 | set_remove_Ypserv test (set to yes, ypserv not installed, euler) | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_secscanner_259 | set_remove_Ypserv test (set to no, ypserv not installed, euler) | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_secscanner_260 | set_remove_ypbind test (set to yes, ypbind installed, euler) | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_secscanner_261 | set_remove_ypbind test (set to no, ypbind installed, euler) | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_secscanner_262 | set_remove_ypbind test (set to yes, ypbind not installed, euler) | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_secscanner_263 | set_remove_ypbind test (set to no, ypbind not installed, euler) | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_secscanner_264 | set_remove_LdapClient test (set to yes, openldap-clients installed, euler) | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_secscanner_265 | set_remove_LdapClient test (set to no, openldap-clients installed, euler) | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_secscanner_266 | set_remove_LdapClient test (set to yes, openldap-clients not installed, euler) | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_secscanner_267 | set_remove_LdapClient test (set to no, openldap-clients not installed, euler) | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_secscanner_268 | set_remove_Xwindows test (set to yes, xorg-x11 installed, euler) | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_secscanner_269 | set_remove_Xwindows test (set to no, xorg-x11 installed, euler) | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_secscanner_270 | set_remove_Xwindows test (set to yes, xorg-x11 not installed, euler) | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_secscanner_271 |  | — | 0 |  |  |  |
| oe_test_secscanner_272 |  | — | 0 |  |  |  |
| oe_test_secscanner_273 |  | — | 0 |  |  |  |
| oe_test_secscanner_274 |  | — | 0 |  |  |  |
| oe_test_secscanner_275 |  | — | 0 |  |  |  |
| oe_test_secscanner_276 |  | — | 0 |  |  |  |
| oe_test_secscanner_277 |  | — | 0 |  |  |  |
| oe_test_secscanner_278 |  | — | 0 |  |  |  |
| oe_test_secscanner_279 |  | — | 0 |  |  |  |
| oe_test_secscanner_280 |  | — | 0 |  |  |  |
| oe_test_secscanner_281 |  | — | 0 |  |  |  |
| oe_test_secscanner_282 |  | — | 0 |  |  |  |
| oe_test_secscanner_283 |  | — | 0 |  |  |  |
| oe_test_secscanner_284 |  | — | 0 |  |  |  |
| oe_test_secscanner_285 |  | — | 0 |  |  |  |
| oe_test_secscanner_286 |  | — | 0 |  |  |  |
| oe_test_secscanner_287 |  | — | 0 |  |  |  |
| oe_test_secscanner_288 |  | — | 0 |  |  |  |
| oe_test_secscanner_289 |  | — | 0 |  |  |  |
| oe_test_secscanner_290 |  | — | 0 |  |  |  |
| oe_test_secscanner_291 |  | — | 0 |  |  |  |
| oe_test_secscanner_292 |  | — | 0 |  |  |  |
| oe_test_secscanner_293 |  | — | 0 |  |  |  |
| oe_test_secscanner_294 |  | — | 0 |  |  |  |
| oe_test_secscanner_295 |  | — | 0 |  |  |  |
| oe_test_secscanner_296 |  | — | 0 |  |  |  |
| oe_test_secscanner_297 |  | — | 0 |  |  |  |
| oe_test_secscanner_298 |  | — | 0 |  |  |  |
| oe_test_secscanner_299 |  | — | 0 |  |  |  |
| oe_test_secscanner_300 |  | — | 0 |  |  |  |

### 断言与命令明细

#### oe_test_secscanner_001

- 描述：Regular users are not allowed to run secscanner
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 1 0 "Regular users are not allowed to run secscanner."
```

- 涉及命令：userdel×1

#### oe_test_secscanner_002

- 描述：check permission of cvedatabase.db
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT "$per" 600 0 "Regular users should not have permission to cve database."
```

#### oe_test_secscanner_003

- 描述：secscanner check cve and log file check
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0
  CHECK_RESULT $? 0 0
```

- 涉及命令：test×1

#### oe_test_secscanner_004

- 描述：secscanner check cve_t and log file check
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0
  CHECK_RESULT $? 0 0
```

- 涉及命令：test×1

#### oe_test_secscanner_005

- 描述：check permission of secscanner.log
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT "$per" 600 0
```

#### oe_test_secscanner_006

- 描述：set_motd check
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0
  CHECK_RESULT $? 0 0
  CHECK_RESULT $? 0 0
  CHECK_RESULT $? 0 0
```

- 涉及命令：sed×1, test×1

#### oe_test_secscanner_007

- 描述：set_password_rem check
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0
  CHECK_RESULT $? 0 0
  CHECK_RESULT $? 0 0
  CHECK_RESULT $? 0 0
```

- 涉及命令：sed×2, grep×2

#### oe_test_secscanner_008

- 描述：set_passComplex warning check
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0
  CHECK_RESULT $? 0 0
  CHECK_RESULT $? 0 0
  CHECK_RESULT $? 0 0
  CHECK_RESULT $? 0 0
  CHECK_RESULT $? 0 0
```

- 涉及命令：sed×2

#### oe_test_secscanner_009

- 描述：set_passComplex fix
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0
  CHECK_RESULT $? 0 0
  CHECK_RESULT $? 0 0
  CHECK_RESULT $? 0 0
  CHECK_RESULT $? 0 0
  CHECK_RESULT $? 0 0
  CHECK_RESULT $? 0 0
  CHECK_RESULT $? 0 0
  CHECK_RESULT $? 0 0
  CHECK_RESULT $? 0 0
```

- 涉及命令：sed×2, grep×2

#### oe_test_secscanner_010

- 描述：lock_attacking_user check if unlock_time not set
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0
  CHECK_RESULT $? 0 0
  CHECK_RESULT $? 0 0
  CHECK_RESULT $? 0 0
```

- 涉及命令：grep×4, sed×3

#### oe_test_secscanner_011

- 描述：lock_attacking_user check if unlock_time!=300
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0
  CHECK_RESULT $? 0 0
  CHECK_RESULT $? 0 0
  CHECK_RESULT $? 0 0
```

- 涉及命令：grep×4, sed×3

#### oe_test_secscanner_012

- 描述：disable_icmp_redirect check if net.ipv4.conf.all.accept_redirects not set
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0
  CHECK_RESULT $? 0 0
```

- 涉及命令：grep×3, sed×2

#### oe_test_secscanner_013

- 描述：disable_icmp_redirect check if net.ipv4.conf.all.accept_redirects=1
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0
  CHECK_RESULT $? 0 0
  CHECK_RESULT $? 0 0
  CHECK_RESULT $? 0 0
```

- 涉及命令：grep×3, sed×2

#### oe_test_secscanner_014

- 描述：disable_icmp_redirect=no
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0
  CHECK_RESULT $? 0 1
  CHECK_RESULT $? 0 1
  CHECK_RESULT $? 0 1
```

- 涉及命令：grep×3, sed×2

#### oe_test_secscanner_015

- 描述：set_umask check when umask not set (extended to multiple files)
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Overall umask WARNING check failed"
  CHECK_RESULT $? 0 0 "File $file missing 'umask 027' after fix"
```

- 涉及命令：sed×2, grep×1

#### oe_test_secscanner_016

- 描述：set_tmout test (session timeout configuration)
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "Failed to set set_tmout=yes"
  CHECK_RESULT $? 0 0 "Profile file missing 'TMOUT=180' after fix"
  CHECK_RESULT $? 0 0 "Profile file missing 'export TMOUT' after fix"
  CHECK_RESULT $? 0 0 "TMOUT check did not show OK status"
  CHECK_RESULT $? 0 0 "Restore output missing for $PROFILE_FILE"
```

- 涉及命令：sed×3, grep×1

#### oe_test_secscanner_017

- 描述：set_tmout test - when set to no (should not modify TMOUT)
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Failed to set set_tmout=no"
  CHECK_RESULT $? 1 0 "Profile file should not contain 'TMOUT=180' when set_tmout=no"
  CHECK_RESULT $? 1 0 "Profile file should not contain 'export TMOUT' when set_tmout=no"
```

- 涉及命令：sed×3

#### oe_test_secscanner_018

- 描述：set_tmout test - when TMOUT exists (should not modify existing value)
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "Failed to set set_tmout=yes"
  CHECK_RESULT $? 0 0 "Profile file should still contain 'TMOUT=300' (should not be modified)"
  CHECK_RESULT $? 0 0 "Profile file should contain 'export TMOUT'"
  CHECK_RESULT $? 1 0 "Profile file should not contain 'TMOUT=180' when TMOUT already exists"
```

- 涉及命令：sed×3

#### oe_test_secscanner_019

- 描述：set_file_property test (file and directory permissions)
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "Failed to set set_file_property=yes"
  CHECK_RESULT "$current_perm" "$expected_perm" 0 "Permission for $file is $current_perm, expected $expected_perm"
  CHECK_RESULT $? 0 0 "Check output missing for $file"
  CHECK_RESULT $? 0 0 "Restore output missing for $file"
  CHECK_RESULT "$current_perm" "$original_perm" 0 "Permission for $file is $current_perm, expected original $original_perm"
```

- 涉及命令：declare×2, grep×2, sed×1

#### oe_test_secscanner_020

- 描述：set_file_property test - when set to no (should not modify permissions)
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Failed to set set_file_property=no"
  CHECK_RESULT "$current_perm" "$original_perm" 0 "Permission for $file should not be modified when set_file_property=no"
```

- 涉及命令：declare×1, sed×1

#### oe_test_secscanner_021

- 描述：Password policy configuration test (login.defs)
- 函数：`pre_test, run_test, post_test`
- 断言（11 条）：

```
  CHECK_RESULT $? 0 0 "Failed to set password policy configuration"
  CHECK_RESULT $? 0 0 "login.defs missing PASS_MAX_DAYS 90"
  CHECK_RESULT $? 0 0 "login.defs missing PASS_MIN_DAYS 6"
  CHECK_RESULT $? 0 0 "login.defs missing PASS_MIN_LEN 10"
  CHECK_RESULT $? 0 0 "login.defs missing PASS_WARN_AGE 30"
  CHECK_RESULT $? 0 0 "Check output missing password lifetime section"
  CHECK_RESULT $? 0 0 "Check output missing PASS_MAX_DAYS OK"
  CHECK_RESULT $? 0 0 "Check output missing PASS_MIN_DAYS OK"
  CHECK_RESULT $? 0 0 "Check output missing PASS_MIN_LEN OK"
  CHECK_RESULT $? 0 0 "Check output missing PASS_WARN_AGE OK"
  CHECK_RESULT $? 0 0 "Restore output missing for $LOGIN_DEFS_FILE"
```

- 涉及命令：sed×8, grep×5

#### oe_test_secscanner_022

- 描述：Password policy test - when set to no (should not modify login.defs)
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Failed to set password policy configuration to no"
  CHECK_RESULT $? 0 0 "Restore output missing for $LOGIN_DEFS_FILE"
```

- 涉及命令：sed×4, declare×1

#### oe_test_secscanner_023

- 描述：Password policy test - when values already exist in login.defs
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Failed to set password policy configuration"
  CHECK_RESULT $? 0 0 "login.defs missing PASS_MAX_DAYS 90"
  CHECK_RESULT $? 0 0 "login.defs missing PASS_MIN_DAYS 6"
  CHECK_RESULT $? 0 0 "login.defs missing PASS_MIN_LEN 10"
  CHECK_RESULT $? 0 0 "login.defs missing PASS_WARN_AGE 30"
  CHECK_RESULT $? 1 0 "login.defs should not contain PASS_MAX_DAYS 180"
  CHECK_RESULT $? 1 0 "login.defs should not contain PASS_MIN_DAYS 3"
  CHECK_RESULT $? 1 0 "login.defs should not contain PASS_MIN_LEN 8"
  CHECK_RESULT $? 1 0 "login.defs should not contain PASS_WARN_AGE 14"
  CHECK_RESULT $? 0 0 "Restore output missing for $LOGIN_DEFS_FILE"
```

- 涉及命令：sed×12

#### oe_test_secscanner_024

- 描述：SSH login banner test - basic functionality
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "Failed to set set_ssh_login_banner=yes"
  CHECK_RESULT $? 0 0 "Check output missing WARNING about no ssh banner config"
  CHECK_RESULT $? 0 0 "sshd_config missing Banner /etc/sshbanner"
  CHECK_RESULT $? 0 0 "Restore output missing for $SSHD_CONFIG_FILE"
```

- 涉及命令：sed×2, grep×1

#### oe_test_secscanner_025

- 描述：SSH login banner test - when set to no (should not modify sshd_config)
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Failed to set set_ssh_login_banner=no"
  CHECK_RESULT $? 1 0 "sshd_config should not contain Banner when set_ssh_login_banner=no"
```

- 涉及命令：sed×2

#### oe_test_secscanner_026

- 描述：SSH login banner test - when Banner already exists in sshd_config
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Failed to set set_ssh_login_banner=yes"
  CHECK_RESULT $? 0 0 "sshd_config should not change Banner /etc/custom_banner"
```

- 涉及命令：sed×2

#### oe_test_secscanner_027

- 描述：
#### oe_test_secscanner_028

- 描述：SSH algorithms test - when set to no (should not modify sshd_config)
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "Failed to set set_ssh_algorithms=no"
  CHECK_RESULT $? 1 0 "sshd_config should not contain KexAlgorithms when set_ssh_algorithms=no"
  CHECK_RESULT $? 1 0 "sshd_config should not contain Ciphers when set_ssh_algorithms=no"
  CHECK_RESULT $? 1 0 "sshd_config should not contain MACs when set_ssh_algorithms=no"
```

- 涉及命令：sed×4

#### oe_test_secscanner_029

- 描述：
#### oe_test_secscanner_030

- 描述：
#### oe_test_secscanner_031

- 描述：SSH GSSAPI test - when set to no (should not modify sshd_config)
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Failed to set set_ssh_gssapi=no"
  CHECK_RESULT $? 0 0 "sshd_config should not be modified when set_ssh_gssapi=no"
```

- 涉及命令：sed×2

#### oe_test_secscanner_032

- 描述：disable_unused_software test - telnet.socket service
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Failed to set disable_unused_software=yes"
  CHECK_RESULT $? 0 0 "$SERVICE_NAME should be stopped"
```

- 涉及命令：sed×1

#### oe_test_secscanner_033

- 描述：disable_unused_software test - when set to no (should not stop services)
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Failed to set disable_unused_software=no"
  CHECK_RESULT $? 0 0 "$SERVICE_NAME should still be running when disable_unused_software=no"
```

- 涉及命令：sed×1

#### oe_test_secscanner_034

- 描述：
#### oe_test_secscanner_035

- 描述：disable_unused_user test - when set to no (should not modify users)
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "Failed to set disable_unused_user=no"
```

- 涉及命令：sed×1

#### oe_test_secscanner_036

- 描述：disable_unused_user test - when user shell is /bin/bash
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Failed to set disable_unused_user=yes"
  CHECK_RESULT 1 0 "$TEST_USER shell should be changed to /bin/false"
```

- 涉及命令：usermod×1, sed×1

#### oe_test_secscanner_037

- 描述：Log recording test - login events, kernel warn, error events, auth events
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Failed to set log recording options"
  CHECK_RESULT $? 0 0 "Check output should show WARNING for authpriv.info before fix"
  CHECK_RESULT $? 0 0 "Check output should show WARNING for kern.warn before fix"
  CHECK_RESULT $? 0 0 "Check output should show WARNING for *.err before fix"
  CHECK_RESULT $? 0 0 "Check output should show WARNING for auth.none before fix"
  CHECK_RESULT $? 0 0 "rsyslog.conf missing authpriv.info configuration"
  CHECK_RESULT $? 0 0 "rsyslog.conf missing kern.warning configuration"
  CHECK_RESULT $? 0 0 "rsyslog.conf missing *.err configuration"
  CHECK_RESULT $? 0 0 "rsyslog.conf missing auth.none configuration"
  CHECK_RESULT $? 0 0 "Restore output missing for $RSYSLOG_CONFIG_FILE"
```

- 涉及命令：sed×8, grep×4

#### oe_test_secscanner_038

- 描述：Log recording test - when set to no (should not modify rsyslog.conf)
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "Failed to set log recording options to no"
  CHECK_RESULT $? 0 0 "rsyslog.conf should not contain authpriv.info when set to no"
  CHECK_RESULT $? 0 0 "rsyslog.conf should not contain kern.warning when set to no"
  CHECK_RESULT $? 0 0 "rsyslog.conf should not contain *.err when set to no"
  CHECK_RESULT $? 0 0 "rsyslog.conf should not contain auth.none when set to no"
```

- 涉及命令：sed×8

#### oe_test_secscanner_039

- 描述：Log recording test - when configurations already exist
- 函数：`pre_test, run_test, post_test`
- 断言（13 条）：

```
  CHECK_RESULT $? 0 0 "Failed to set log recording options"
  CHECK_RESULT $? 0 0 "Check output should show OK for existing authpriv.info configuration"
  CHECK_RESULT $? 0 0 "Check output should show OK for existing kern.warn configuration"
  CHECK_RESULT $? 0 0 "Check output should show OK for existing *.err configuration"
  CHECK_RESULT $? 0 0 "Check output should show OK for existing auth.none configuration"
  CHECK_RESULT $? 0 0 "rsyslog.conf missing authpriv.info configuration"
  CHECK_RESULT $? 0 0 "rsyslog.conf missing kern.warning configuration"
  CHECK_RESULT $? 0 0 "rsyslog.conf missing *.err configuration"
  CHECK_RESULT $? 0 0 "rsyslog.conf missing auth.none configuration"
  CHECK_RESULT $? 0 0 "Check output should show OK for authpriv.info after fix"
  CHECK_RESULT $? 0 0 "Check output should show OK for kern.warn after fix"
  CHECK_RESULT $? 0 0 "Check output should show OK for *.err after fix"
  ... 共 13 条（其余见源脚本）
```

- 涉及命令：sed×8, grep×8

#### oe_test_secscanner_040

- 描述：Log recording test - when some configurations exist
- 函数：`pre_test, run_test, post_test`
- 断言（11 条）：

```
  CHECK_RESULT $? 0 0 "Failed to set log recording options"
  CHECK_RESULT $? 0 0 "Check output should show WARNING for kern.warn before fix"
  CHECK_RESULT $? 0 0 "Check output should show WARNING for auth.none before fix"
  CHECK_RESULT $? 0 0 "rsyslog.conf missing authpriv.info configuration"
  CHECK_RESULT $? 0 0 "rsyslog.conf missing *.err configuration"
  CHECK_RESULT $? 0 0 "rsyslog.conf missing kern.warning configuration"
  CHECK_RESULT $? 0 0 "rsyslog.conf missing auth.none configuration"
  CHECK_RESULT $? 0 0 "Check output should show OK for authpriv.info after fix"
  CHECK_RESULT $? 0 0 "Check output should show OK for kern.warn after fix"
  CHECK_RESULT $? 0 0 "Check output should show OK for *.err after fix"
  CHECK_RESULT $? 0 0 "Check output should show OK for auth.none after fix"
```

- 涉及命令：sed×8, grep×6

#### oe_test_secscanner_041

- 描述：
#### oe_test_secscanner_042

- 描述：
#### oe_test_secscanner_043

- 描述：
#### oe_test_secscanner_044

- 描述：
#### oe_test_secscanner_045

- 描述：FTP configuration test - banner (ftpd_banner) when set to yes
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "Failed to set FTP banner option"
  CHECK_RESULT $? 0 0 "Check output should show WARNING for FTP before fix"
  CHECK_RESULT $? 0 0 "vsftpd.conf missing ftpd_banner configuration"
  CHECK_RESULT $? 0 0 "Restore output missing for $VSFTPD_CONFIG_FILE"
```

- 涉及命令：sed×2, grep×1

#### oe_test_secscanner_046

- 描述：FTP configuration test - anonymous access (anonymous_enable) when set to yes
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "Failed to set FTP anonymous access option"
  CHECK_RESULT $? 0 0 "Check output should show WARNING for FTP before fix"
  CHECK_RESULT $? 0 0 "vsftpd.conf missing anonymous_enable=NO configuration"
  CHECK_RESULT $? 0 0 "Restore output missing for $VSFTPD_CONFIG_FILE"
```

- 涉及命令：sed×2, grep×1

#### oe_test_secscanner_047

- 描述：FTP configuration test - restrict directory (chroot_local_user) when set to no
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Failed to set FTP restrict directory option to no"
  CHECK_RESULT $? 0 0 "vsftpd.conf should not contain chroot_local_user configuration when set to no"
```

- 涉及命令：sed×2

#### oe_test_secscanner_048

- 描述：FTP configuration test - banner (ftpd_banner) when set to no
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Failed to set FTP banner option to no"
  CHECK_RESULT $? 0 0 "vsftpd.conf should not contain ftpd_banner configuration when set to no"
```

- 涉及命令：sed×2

#### oe_test_secscanner_049

- 描述：FTP configuration test - anonymous access (anonymous_enable) when set to no
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Failed to set FTP anonymous access option to no"
  CHECK_RESULT $? 0 0 "vsftpd.conf should not contain anonymous_enable configuration when set to no"
```

- 涉及命令：sed×2

#### oe_test_secscanner_050

- 描述：deny_root_login test
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Initial root login WARNING check failed"
  CHECK_RESULT $? 0 0 "Root login fix failed"
  CHECK_RESULT $? 0 0 "PermitRootLogin not set to no"
```

- 涉及命令：sed×2, grep×2

#### oe_test_secscanner_051

- 描述：deny_root_login test with PermitRootLogin=yes
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Root login WARNING check failed with PermitRootLogin=yes"
  CHECK_RESULT $? 0 0 "Root login fix failed with PermitRootLogin=yes"
  CHECK_RESULT $? 0 0 "PermitRootLogin not set to no after fix"
```

- 涉及命令：sed×2, grep×2

#### oe_test_secscanner_052

- 描述：hide_issue_info test
- 函数：`pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $? 0 0 "Issue info WARNING check failed on physical machine"
  CHECK_RESULT $? 0 0 "Issue info SKIPPED check failed on virtual machine"
  CHECK_RESULT $? 0 0 "Issue info fix failed on physical machine"
  CHECK_RESULT $? 1 0 "Issue file was not deleted on physical machine"
  CHECK_RESULT $? 1 0 "Issue.net file was not deleted on physical machine"
  CHECK_RESULT $? 1 0 "Issue files were deleted on virtual machine"
  CHECK_RESULT $? 0 1 "Issue info WARNING check failed after fix on physical machine"
  CHECK_RESULT $? 0 0 "Issue info SKIPPED check failed after fix on virtual machine"
```

- 涉及命令：grep×5, test×2, sed×1

#### oe_test_secscanner_053

- 描述：hide_issue_info test with both issue files
- 函数：`pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $? 0 0 "Issue info WARNING check failed on physical machine"
  CHECK_RESULT $? 0 0 "Issue info SKIPPED check failed on virtual machine"
  CHECK_RESULT $? 0 0 "Issue info fix failed on physical machine"
  CHECK_RESULT $? 1 0 "Issue file was not deleted on physical machine"
  CHECK_RESULT $? 1 0 "Issue.net file was not deleted on physical machine"
  CHECK_RESULT $? 1 0 "Issue files were deleted on virtual machine"
  CHECK_RESULT $? 0 1 "Issue info WARNING check failed after fix on physical machine"
  CHECK_RESULT $? 0 0 "Issue info SKIPPED check failed after fix on virtual machine"
```

- 涉及命令：grep×5, test×2, sed×1

#### oe_test_secscanner_054

- 描述：hide_issue_info test with only issue file
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "Issue info WARNING check failed on physical machine"
  CHECK_RESULT $? 0 0 "Issue info SKIPPED check failed on virtual machine"
  CHECK_RESULT $? 0 0 "Issue info fix failed on physical machine"
  CHECK_RESULT $? 1 0 "Issue file was not deleted on physical machine"
  CHECK_RESULT $? 1 0 "Issue file was not deleted on physical machine"
  CHECK_RESULT $? 1 0 "Issue file was deleted on virtual machine"
```

- 涉及命令：grep×3, test×2, sed×1

#### oe_test_secscanner_055

- 描述：hide_issue_info test with only issue.net file
- 函数：`pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $? 0 0 "Issue info WARNING check failed on physical machine"
  CHECK_RESULT $? 0 0 "Issue info SKIPPED check failed on virtual machine"
  CHECK_RESULT $? 0 0 "Issue info fix failed on physical machine"
  CHECK_RESULT $? 1 0 "Issue file was not deleted on physical machine"
  CHECK_RESULT $? 1 0 "Issue.net file was not deleted on physical machine"
  CHECK_RESULT $? 1 0 "Issue.net file was deleted on virtual machine"
  CHECK_RESULT $? 0 1 "Issue info WARNING check failed after fix on physical machine"
  CHECK_RESULT $? 0 0 "Issue info SKIPPED check failed after fix on virtual machine"
```

- 涉及命令：grep×5, test×2, sed×1

#### oe_test_secscanner_056

- 描述：hide_issue_info test with no issue files
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "Issue info WARNING check failed on physical machine"
  CHECK_RESULT $? 0 0 "Issue info SKIPPED check failed on virtual machine"
  CHECK_RESULT $? 1 0 "Issue file was created when it shouldn't be"
  CHECK_RESULT $? 1 0 "Issue.net file was created when it shouldn't be"
```

- 涉及命令：grep×2, test×2, sed×1

#### oe_test_secscanner_057

- 描述：hide_issue_info=no test with both issue files
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 1 0 "Issue info check should not show WARNING or SKIPPED when hide_issue_info=no"
  CHECK_RESULT $? 0 0 "Issue file should not be deleted when hide_issue_info=no"
  CHECK_RESULT $? 0 0 "Issue.net file should not be deleted when hide_issue_info=no"
```

- 涉及命令：test×2, sed×1, grep×1

#### oe_test_secscanner_058

- 描述：forbidden_to_su=yes test
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Failed to set forbidden_to_su=yes"
  CHECK_RESULT $? 0 0 "Step 3: WARNING message not found"
  CHECK_RESULT $? 0 0 "Step 4: pam_wheel configuration not found"
```

- 涉及命令：sed×2, grep×2

#### oe_test_secscanner_059

- 描述：forbidden_to_su=no test
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Failed to set forbidden_to_su=no"
  CHECK_RESULT $? 1 0 "Step 4: pam_wheel configuration should remain"
```

- 涉及命令：sed×2, grep×1

#### oe_test_secscanner_060

- 描述：set_bashrc_alias=yes test
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "Failed to set set_bashrc_alias=yes"
  CHECK_RESULT $? 0 0 "Step 3: WARNING message not found"
  CHECK_RESULT $? 0 0 "Step 3: alias ls not found"
  CHECK_RESULT $? 0 0 "Step 3: alias rm not found"
  CHECK_RESULT $? 0 0 "Step 6: Restore message not found"
```

- 涉及命令：grep×4, sed×3

#### oe_test_secscanner_061

- 描述：set_bashrc_alias=no test
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Failed to set set_bashrc_alias=no"
  CHECK_RESULT $? 1 0 "Step 3: alias ls should not be added"
  CHECK_RESULT $? 1 0 "Step 3: alias rm should not be added"
```

- 涉及命令：sed×3, grep×2

#### oe_test_secscanner_062

- 描述：
#### oe_test_secscanner_063

- 描述：
#### oe_test_secscanner_064

- 描述：set_log_file_property test
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "Failed to set set_log_file_property=yes"
  CHECK_RESULT 1 0 "Step 2: $file permission is not 600, got $current_perm"
  CHECK_RESULT $? 0 0 "Step 4: log file property check not found"
  CHECK_RESULT $? 0 0 "Step 4: $filename check not found"
```

- 涉及命令：grep×2, sed×1

#### oe_test_secscanner_065

- 描述：set_log_file_property=no test
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "Failed to set set_log_file_property=no"
  CHECK_RESULT 1 0 "Step 2: $file permission changed from $original_perm to $current_perm"
  CHECK_RESULT $? 0 0 "Step 4: log file property check not found"
  CHECK_RESULT $? 0 0 "Step 4: $filename check not found"
```

- 涉及命令：grep×2, sed×1

#### oe_test_secscanner_066

- 描述：set_ssh_syslogfacility test
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "Failed to set set_ssh_syslogfacility=yes"
  CHECK_RESULT $? 0 0 "Step 2: WARNING message not found"
  CHECK_RESULT $? 0 0 "Step 3: SyslogFacility not set to AUTH"
  CHECK_RESULT $? 0 0 "Step 5: Restore message not found"
```

- 涉及命令：grep×3, sed×2

#### oe_test_secscanner_067

- 描述：set_ssh_syslogfacility=no test
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Failed to set set_ssh_syslogfacility=no"
  CHECK_RESULT $? 0 0 "Step 3: SyslogFacility should remain AUTHPRIV"
```

- 涉及命令：sed×2, grep×1

#### oe_test_secscanner_068

- 描述：set_ssh_loglevel test
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "Failed to set set_ssh_loglevel=yes"
  CHECK_RESULT $? 0 0 "Step 2: WARNING message not found"
  CHECK_RESULT $? 0 0 "Step 3: LogLevel not set to VERBOSE"
  CHECK_RESULT $? 0 0 "Step 4: OK message not found"
  CHECK_RESULT $? 0 0 "Step 5: Restore message not found"
```

- 涉及命令：grep×4, sed×2

#### oe_test_secscanner_069

- 描述：set_ssh_loglevel=no test
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Failed to set set_ssh_loglevel=no"
  CHECK_RESULT $? 0 0 "Step 3: LogLevel should remain INFO"
  CHECK_RESULT $? 0
```

- 涉及命令：sed×2, grep×1

#### oe_test_secscanner_070

- 描述：set_always_set_path test
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "Failed to set set_always_set_path=yes"
  CHECK_RESULT $? 0 0 "Step 2: WARNING message not found"
  CHECK_RESULT $? 0 0 "Step 3: ALWAYS_SET_PATH not set to yes"
  CHECK_RESULT $? 0 0 "Step 5: Restore message not found"
```

- 涉及命令：grep×3, sed×2

#### oe_test_secscanner_071

- 描述：set_always_set_path=no test
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Failed to set set_always_set_path=no"
  CHECK_RESULT $? 1 0 "Step 3: ALWAYS_SET_PATH should not be added"
  CHECK_RESULT $? 0 0 "Step 5: Restore message not found"
```

- 涉及命令：sed×2, grep×2

#### oe_test_secscanner_072

- 描述：set_rp_filter test
- 函数：`pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $? 0 0 "Failed to set set_rp_filter=yes"
  CHECK_RESULT $? 0 0 "Step 2: WARNING message not found"
  CHECK_RESULT $? 0 0 "Step 3: net.ipv4.conf.all.rp_filter not set to 1"
  CHECK_RESULT $? 0 0 "Step 3: net.ipv4.conf.default.rp_filter not set to 1"
  CHECK_RESULT $? 0 0 "Step 4: net.ipv4.conf.all.rp_filter value is not 1"
  CHECK_RESULT $? 0 0 "Step 4: net.ipv4.conf.default.rp_filter value is not 1"
  CHECK_RESULT $? 0 0 "Step 5: Restore message not found"
```

- 涉及命令：sysctl×4, grep×4, sed×3

#### oe_test_secscanner_073

- 描述：set_rp_filter=no test
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Failed to set set_rp_filter=no"
  CHECK_RESULT $? 1 0 "Step 3: net.ipv4.conf.all.rp_filter should not be added"
  CHECK_RESULT $? 1 0 "Step 3: net.ipv4.conf.default.rp_filter should not be added"
```

- 涉及命令：sed×3, sysctl×2, grep×2

#### oe_test_secscanner_074

- 描述：set_ssh_permitemptypasswd test
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "Failed to set set_ssh_permitemptypasswd=yes"
  CHECK_RESULT $? 0 0 "Step 2: WARNING message not found"
  CHECK_RESULT $? 0 0 "Step 3: PermitEmptyPasswords not set to yes"
  CHECK_RESULT $? 0 0 "Step 4: Restore message not found"
```

- 涉及命令：grep×3, sed×2

#### oe_test_secscanner_075

- 描述：set_ssh_permitemptypasswd=no test
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Failed to set set_ssh_permitemptypasswd=no"
  CHECK_RESULT $? 0 0 "Step 3: PermitEmptyPasswords should remain yes"
```

- 涉及命令：sed×2, grep×2

#### oe_test_secscanner_076

- 描述：set_ssh_permitemptypasswd test (existing no config)
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Failed to set set_ssh_permitemptypasswd=yes"
  CHECK_RESULT $? 0 0 "Step 3: PermitEmptyPasswords not set to no"
```

- 涉及命令：sed×2, grep×2

#### oe_test_secscanner_077

- 描述：set_ssh_permitemptypasswd=no test (empty config)
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Failed to set set_ssh_permitemptypasswd=no"
  CHECK_RESULT $? 1 0 "Step 3: PermitEmptyPasswords should not be added"
```

- 涉及命令：sed×2, grep×2

#### oe_test_secscanner_078

- 描述：set_kernel_oops test
- 函数：`pre_test, run_test, post_test`
- 断言（12 条）：

```
  CHECK_RESULT $? 0 0 "Failed to set set_kernel_oops=yes"
  CHECK_RESULT $? 0 0 "Step 2: WARNING message not found"
  CHECK_RESULT $? 0 0 "Step 3: kernel.panic_on_oops not set to 1"
  CHECK_RESULT $? 0 0 "Step 3: [install] section not added to rc-local.service"
  CHECK_RESULT $? 0 0 "Step 3: #!/bin/sh -e not added to rc.local"
  CHECK_RESULT $? 0 0 "Step 3: kernel.panic_on_oops not added to rc.local"
  CHECK_RESULT $? 0 0 "Step 3: ctrl-alt-del.target removal not added to rc.local"
  CHECK_RESULT $? 0 0 "Step 3: exit 0 not added to rc.local"
  CHECK_RESULT $? 0 0 "Step 3: /etc/rc.d/rc.local permissions not set to 755"
  CHECK_RESULT $? 0 0 "Step 4: OK message not found"
  CHECK_RESULT $? 0 0 "Step 5: rc.local restore message not found"
  CHECK_RESULT $? 0 0 "Step 5: rc-local.service restore message not found"
```

- 涉及命令：grep×11, sed×2, stat×2

#### oe_test_secscanner_079

- 描述：set_kernel_oops=no test
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Failed to set set_kernel_oops=no"
  CHECK_RESULT $? 1 0 "Step 3: kernel.panic_on_oops should not be added"
  CHECK_RESULT $? 0 0 "Step 4: kernel panic on oops check not found"
```

- 涉及命令：grep×3, sed×2

#### oe_test_secscanner_080

- 描述：set_prohibit_ctrlaltdel test
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "Failed to set set_prohibit_ctrlaltdel=yes"
  CHECK_RESULT $? 0 0 "Step 2: WARNING message not found"
  CHECK_RESULT $? 0 0 "Step 3: CtrlAltDelBurstAction not set to none"
  CHECK_RESULT $? 0 0 "Step 4: Restore message not found"
```

- 涉及命令：grep×4, sed×2

#### oe_test_secscanner_081

- 描述：set_prohibit_ctrlaltdel=no test
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Failed to set set_prohibit_ctrlaltdel=no"
  CHECK_RESULT $? 1 0 "Step 3: CtrlAltDelBurstAction should not be added"
  CHECK_RESULT $? 0 0 "Step 4: system ctrlaltdel burst action check not found"
```

- 涉及命令：grep×3, sed×2

#### oe_test_secscanner_082

- 描述：set_disable_magickeys test
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "Failed to set set_disable_magickeys=yes"
  CHECK_RESULT $? 0 0 "Step 2: WARNING message not found"
  CHECK_RESULT $? 0 0 "Step 3: kernel.sysrq not set to 0"
  CHECK_RESULT $? 0 0 "Step 4: OK message not found"
  CHECK_RESULT $? 0 0 "Step 5: Restore message not found"
```

- 涉及命令：grep×5, sed×2

#### oe_test_secscanner_083

- 描述：set_disable_magickeys=no test
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Failed to set set_disable_magickeys=no"
  CHECK_RESULT $? 1 0 "Step 3: kernel.sysrq should not be added"
  CHECK_RESULT $? 0 0 "Step 4: disable magic keys check not found"
```

- 涉及命令：grep×3, sed×2

#### oe_test_secscanner_084

- 描述：set_nologin_list test
- 函数：`pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $? 0 0 "Failed to set set_nologin_list=yes"
  CHECK_RESULT $? 0 0 "Step 2: WARNING message not found"
  CHECK_RESULT $? 0 0 "Step 3: pam_listfile not added to system-auth"
  CHECK_RESULT $? 0 0 "Step 3: pam_listfile not added to password-auth"
  CHECK_RESULT $? 0 0 "Step 4: OK message not found"
  CHECK_RESULT $? 0 0 "Step 5: system-auth restore message not found"
  CHECK_RESULT $? 0 0 "Step 5: password-auth restore message not found"
```

- 涉及命令：grep×8, sed×3

#### oe_test_secscanner_085

- 描述：set_nologin_list=no test
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "Failed to set set_nologin_list=no"
  CHECK_RESULT $? 1 0 "Step 3: pam_listfile should not be added to system-auth"
  CHECK_RESULT $? 1 0 "Step 3: pam_listfile should not be added to password-auth"
  CHECK_RESULT $? 1 0 "Step 3: /etc/login.user.deny should not be created"
  CHECK_RESULT $? 0 0 "Step 4: list of users prohibited from login check not found"
```

- 涉及命令：grep×5, sed×3, test×1

#### oe_test_secscanner_086

- 描述：set_limit_resources test
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 "Failed to set set_limit_resources=yes"
  CHECK_RESULT $? 0 0 "Step 2: WARNING message not found"
  CHECK_RESULT $? 0 0 "Step 3: soft stack limit not set"
  CHECK_RESULT $? 0 0 "Step 3: hard stack limit not set"
  CHECK_RESULT $? 0 0 "Step 3: hard rss limit not set"
  CHECK_RESULT $? 0 0 "Step 3: hard nproc limit not set"
  CHECK_RESULT $? 0 0 "Step 3: hard maxlogins limit not set"
  CHECK_RESULT $? 0 0 "Step 4: OK message not found"
  CHECK_RESULT $? 0 0 "Step 5: Restore message not found"
```

- 涉及命令：grep×9, sed×6

#### oe_test_secscanner_087

- 描述：set_limit_resources=no test
- 函数：`pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $? 0 0 "Failed to set set_limit_resources=no"
  CHECK_RESULT $? 1 0 "Step 3: soft stack limit should not be added"
  CHECK_RESULT $? 1 0 "Step 3: hard stack limit should not be added"
  CHECK_RESULT $? 1 0 "Step 3: hard rss limit should not be added"
  CHECK_RESULT $? 1 0 "Step 3: hard nproc limit should not be added"
  CHECK_RESULT $? 1 0 "Step 3: hard maxlogins limit should not be added"
  CHECK_RESULT $? 0 0 "Step 4: limit of system resources check not found"
```

- 涉及命令：grep×7, sed×6

#### oe_test_secscanner_088

- 描述：set_nologin_list=yes test (password-auth)
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "Failed to set set_nologin_list=yes"
  CHECK_RESULT $? 0 0 "Step 2: WARNING message not found"
  CHECK_RESULT $? 0 0 "Step 3: pam_listfile not added to password-auth"
  CHECK_RESULT $? 0 0 "Step 4: OK message not found"
  CHECK_RESULT $? 0 0 "Step 5: password-auth restore message not found"
```

- 涉及命令：grep×5, sed×2

#### oe_test_secscanner_089

- 描述：set_nologin_list=yes test (system-auth)
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "Failed to set set_nologin_list=yes"
  CHECK_RESULT $? 0 0 "Step 2: WARNING message not found"
  CHECK_RESULT $? 0 0 "Step 3: pam_listfile not added to system-auth"
  CHECK_RESULT $? 0 0 "Step 4: OK message not found"
  CHECK_RESULT $? 0 0 "Step 5: system-auth restore message not found"
```

- 涉及命令：grep×5, sed×2

#### oe_test_secscanner_090

- 描述：set_nologin_list=no test (password-auth)
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Failed to set set_nologin_list=no"
  CHECK_RESULT $? 1 0 "Step 3: pam_listfile should not be added to password-auth"
  CHECK_RESULT $? 0 0 "Step 4: list of users prohibited from login check not found"
```

- 涉及命令：grep×3, sed×2

#### oe_test_secscanner_091

- 描述：set_nologin_list=no test (system-auth)
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Failed to set set_nologin_list=no"
  CHECK_RESULT $? 1 0 "Step 3: pam_listfile should not be added to system-auth"
  CHECK_RESULT $? 0 0 "Step 4: list of users prohibited from login check not found"
```

- 涉及命令：grep×3, sed×2

#### oe_test_secscanner_092

- 描述：password policy test
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Failed to set password policy configurations"
  CHECK_RESULT $? 0 0 "Step 2: PASS_MAX_DAYS WARNING message not found"
  CHECK_RESULT $? 0 0 "Step 2: PASS_MIN_LEN WARNING message not found"
  CHECK_RESULT $? 0 0 "Step 2: PASS_MIN_DAYS WARNING message not found"
  CHECK_RESULT $? 0 0 "Step 2: PASS_WARN_AGE WARNING message not found"
  CHECK_RESULT $? 0 0 "Step 3: PASS_MAX_DAYS not set to 90"
  CHECK_RESULT $? 0 0 "Step 3: PASS_MIN_DAYS not set to 6"
  CHECK_RESULT $? 0 0 "Step 3: PASS_MIN_LEN not set to 10"
  CHECK_RESULT $? 0 0 "Step 3: PASS_WARN_AGE not set to 30"
  CHECK_RESULT $? 0 0 "Step 5: Restore message not found"
```

- 涉及命令：sed×12, grep×10

#### oe_test_secscanner_093

- 描述：password policy test (set_*=no)
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Failed to set password policy configurations to no"
  CHECK_RESULT $? 1 0 "Step 3: Password policy configurations should not be added"
  CHECK_RESULT $? 0 0 "Step 4: password lifetime check not found"
```

- 涉及命令：sed×8, grep×3

#### oe_test_secscanner_094

- 描述：password complexity test
- 函数：`pre_test, run_test, post_test`
- 断言（11 条）：

```
  CHECK_RESULT $? 0 0 "Failed to set set_passComplex=yes"
  CHECK_RESULT $? 0 0 "Step 2: WARNING message not found"
  CHECK_RESULT $? 0 0 "Step 3: pam_pwquality.so not configured correctly"
  CHECK_RESULT $? 1 0 "Step 4: pam_cracklib.so should not be used"
  CHECK_RESULT $? 0 0 "Step 5: Password MinLen check not found"
  CHECK_RESULT $? 0 0 "Step 5: Password Minclass check not found"
  CHECK_RESULT $? 0 0 "Step 5: Password ucredit check not found"
  CHECK_RESULT $? 0 0 "Step 5: Password lcredit check not found"
  CHECK_RESULT $? 0 0 "Step 5: Password dcredit check not found"
  CHECK_RESULT $? 0 0 "Step 5: Password ocredit check not found"
  CHECK_RESULT $? 0 0 "Step 6: Restore message not found"
```

- 涉及命令：grep×11, sed×3

#### oe_test_secscanner_095

- 描述：password complexity test (set_passComplex=no)
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Failed to set set_passComplex=no"
  CHECK_RESULT $? 1 0 "Step 3: pam_pwquality.so should not be added"
  CHECK_RESULT $? 0 0 "Step 4: password check not found"
```

- 涉及命令：sed×3, grep×3

#### oe_test_secscanner_096

- 描述：ssh_login_tmout test (set to yes)
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "Failed to set ssh_login_tmout=yes"
  CHECK_RESULT $? 0 0 "Step 2: WARNING message not found"
  CHECK_RESULT $? 0 0 "Step 3: ClientAliveInterval not set to 900"
  CHECK_RESULT $? 0 0 "Step 3: ClientAliveCountMax not set to 0"
  CHECK_RESULT $? 0 0 "Step 4: OK message not found"
  CHECK_RESULT $? 0 0 "Step 5: Restore message not found"
```

- 涉及命令：grep×6, sed×3

#### oe_test_secscanner_097

- 描述：ssh_login_tmout test (set to no)
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "Failed to set ssh_login_tmout=no"
  CHECK_RESULT $? 1 0 "Step 3: ClientAliveInterval should not be added"
  CHECK_RESULT $? 1 0 "Step 3: ClientAliveCountMax should not be added"
  CHECK_RESULT $? 0 0 "Step 4: SSH login timeout check not found"
```

- 涉及命令：grep×4, sed×3

#### oe_test_secscanner_098

- 描述：ssh_login_tmout test with existing ClientAliveCountMax (set to yes)
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "Failed to set ssh_login_tmout=yes"
  CHECK_RESULT $? 0 0 "Step 2: WARNING message not found"
  CHECK_RESULT $? 0 0 "Step 3: ClientAliveInterval not set to 900"
  CHECK_RESULT $? 0 0 "Step 3: ClientAliveCountMax not overwritten to 0"
  CHECK_RESULT $? 0 0 "Step 4: Restore message not found"
```

- 涉及命令：grep×5, sed×3

#### oe_test_secscanner_099

- 描述：ssh_login_tmout test with existing both ClientAliveInterval and ClientAliveCountMax (set to yes)
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "Failed to set ssh_login_tmout=yes"
  CHECK_RESULT $? 0 0 "Step 2: WARNING message not found"
  CHECK_RESULT $? 0 0 "Step 3: ClientAliveInterval not overwritten to 900"
  CHECK_RESULT $? 0 0 "Step 3: ClientAliveCountMax not overwritten to 0"
  CHECK_RESULT $? 0 0 "Step 4: Restore message not found"
```

- 涉及命令：grep×5, sed×3

#### oe_test_secscanner_100

- 描述：set_tmout test (set to yes)
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "Failed to set set_tmout=yes"
  CHECK_RESULT $? 0 0 "Step 2: TMOUT not set to 180"
  CHECK_RESULT $? 0 0 "Step 2: export TMOUT not found"
  CHECK_RESULT $? 0 0 "Step 5: Restore message not found"
```

- 涉及命令：sed×3, grep×3

#### oe_test_secscanner_101

- 描述：set_tmout test (set to no)
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Failed to set set_tmout=no"
  CHECK_RESULT $? 1 0 "Step 2: TMOUT should not be added"
  CHECK_RESULT $? 1 0 "Step 2: export TMOUT should not be added"
```

- 涉及命令：sed×3, grep×2

#### oe_test_secscanner_102

- 描述：set_tmout test with existing TMOUT configuration (set to yes)
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "Failed to set set_tmout=yes"
  CHECK_RESULT $? 0 0 "Step 2: TMOUT not overwritten to 180"
  CHECK_RESULT $? 0 0 "Step 2: export TMOUT not found"
  CHECK_RESULT $? 0 0 "Step 3: OK message not found"
  CHECK_RESULT $? 0 0 "Step 5: Restore message not found"
  CHECK_RESULT $? 0 0 "Step 6: profile not restored"
```

- 涉及命令：grep×5, sed×3

#### oe_test_secscanner_103

- 描述：enable_ssh test (set to yes, service running)
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "sshd service should be running"
  CHECK_RESULT $? 0 0 "Failed to set enable_ssh=yes"
  CHECK_RESULT $? 0 0 "sshd service should be stopped"
  CHECK_RESULT $? 0 0 "Step 3: Service start message not found"
  CHECK_RESULT $? 0 0 "sshd service should be running after fix"
```

- 涉及命令：sed×1, grep×1

#### oe_test_secscanner_104

- 描述：disable_telnet test (set to yes)
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "telnet.socket should be running"
  CHECK_RESULT $? 0 0 "Failed to set disable_telnet=yes"
  CHECK_RESULT $? 1 0 "Step 4: telnet.socket should be stopped"
```

- 涉及命令：sed×1

#### oe_test_secscanner_105

- 描述：remove_http test (set to yes)
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "httpd should be installed"
  CHECK_RESULT $? 0 0 "Failed to set remove_http=yes"
  CHECK_RESULT $? 0 0 "Step 2: httpd should be installed"
  CHECK_RESULT $? 0 0 "Step 3: Remove httpd message not found"
  CHECK_RESULT $? 1 0 "Step 4: httpd should be uninstalled"
```

- 涉及命令：rpm×3, sed×1, grep×1

#### oe_test_secscanner_106

- 描述：disable_telnet test (set to no)
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "telnet.socket should be running"
  CHECK_RESULT $? 0 0 "Failed to set disable_telnet=no"
  CHECK_RESULT $? 0 0 "Step 3: telnet.socket should remain running"
  CHECK_RESULT $? 0 0 "Step 4: Telnet check message not found"
```

- 涉及命令：sed×1, grep×1

#### oe_test_secscanner_107

- 描述：remove_http test (set to no)
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "httpd should be installed"
  CHECK_RESULT $? 0 0 "Failed to set remove_http=no"
  CHECK_RESULT $? 0 0 "Step 2: httpd should be installed"
  CHECK_RESULT $? 0 0 "Step 3: httpd should remain installed"
```

- 涉及命令：rpm×3, sed×1

#### oe_test_secscanner_108

- 描述：remove_tftp test (set to yes)
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "tftp should be installed"
  CHECK_RESULT $? 0 0 "Failed to set remove_tftp=yes"
  CHECK_RESULT $? 0 0 "tftp should be installed"
  CHECK_RESULT $? 0 0 "Remove tftp message not found"
  CHECK_RESULT $? 1 0 "tftp should be uninstalled"
```

- 涉及命令：rpm×3, sed×1, grep×1

#### oe_test_secscanner_109

- 描述：remove_tftp test (set to no)
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "tftp should be installed"
  CHECK_RESULT $? 0 0 "Failed to set remove_tftp=no"
  CHECK_RESULT $? 0 0 "tftp should be installed"
  CHECK_RESULT $? 0 0 "tftp should remain installed"
```

- 涉及命令：rpm×3, sed×1

#### oe_test_secscanner_110

- 描述：ssh_protocol test (set to yes)
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Failed to set ssh_protocol=yes"
  CHECK_RESULT $? 0 0 "Protocol 2 not set"
```

- 涉及命令：sed×2, grep×1

#### oe_test_secscanner_111

- 描述：ssh_protocol test (set to no)
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Failed to set ssh_protocol=no"
  CHECK_RESULT $? 1 0 "Protocol 2 should not be set when ssh_protocol=no"
```

- 涉及命令：sed×2, grep×1

#### oe_test_secscanner_112

- 描述：ssh_protocol test (Protocol set to 1)
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Failed to set ssh_protocol=yes"
  CHECK_RESULT $? 0 0 "Protocol should be changed to 2"
```

- 涉及命令：sed×2, grep×1

#### oe_test_secscanner_113

- 描述：rootUID_unique test (set to yes)
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "Failed to check UID 0 users"
  CHECK_RESULT $? 0 0 "Failed to set rootUID_unique=yes"
  CHECK_RESULT $? 0 0 "Failed to add test user"
  CHECK_RESULT $? 0 0 "Test user not found"
  CHECK_RESULT $? 1 0 "Test user should be removed"
```

- 涉及命令：userdel×2, awk×1, sed×1

#### oe_test_secscanner_114

- 描述：rootUID_unique test (set to no)
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "Failed to set rootUID_unique=no"
  CHECK_RESULT $? 0 0 "Failed to add test user"
  CHECK_RESULT $? 0 0 "Test user not found"
  CHECK_RESULT $? 0 0 "Test user should not be removed when rootUID_unique=no"
```

- 涉及命令：userdel×2, sed×1

#### oe_test_secscanner_115

- 描述：overdue_passwd test (set to yes)
- 函数：`pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $? 0 0 "Failed to set overdue_passwd=yes"
  CHECK_RESULT $? 0 0 "Failed to create test user"
  CHECK_RESULT $? 0 0 "Failed to set password"
  CHECK_RESULT $? 0 0 "Failed to set password change date"
  CHECK_RESULT $? 0 0 "Failed to set password to expire"
  CHECK_RESULT $? 0 0 "Test user not found in shadow"
  CHECK_RESULT $? 1 0 "Test user should be removed"
```

- 涉及命令：sed×5, chage×3, userdel×2

#### oe_test_secscanner_116

- 描述：overdue_passwd test (set to no)
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "Failed to set overdue_passwd=no"
  CHECK_RESULT $? 0 0 "Failed to create test user"
  CHECK_RESULT $? 0 0 "Failed to set password"
  CHECK_RESULT $? 0 0 "Failed to set password to expire"
  CHECK_RESULT $? 0 0 "Test user not found in shadow"
  CHECK_RESULT $? 0 0 "Test user should not be removed when overdue_passwd=no"
```

- 涉及命令：sed×5, userdel×2, chage×1

#### oe_test_secscanner_117

- 描述：set_umask test (set to yes)
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Failed to set set_umask=yes"
  CHECK_RESULT $? 0 0 "umask 027 not set in $file"
  CHECK_RESULT $? 0 0 "OK message not found"
```

- 涉及命令：sed×2, grep×2

#### oe_test_secscanner_118

- 描述：set_umask test (set to no)
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Failed to set set_umask=no"
  CHECK_RESULT $? 1 0 "umask 027 should not be set in $file when set_umask=no"
```

- 涉及命令：sed×2, grep×1

#### oe_test_secscanner_119

- 描述：deny_root_login test (set to yes)
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "Failed to set deny_root_login=yes"
  CHECK_RESULT $? 0 0 "Warning message not found"
  CHECK_RESULT $? 0 0 "PermitRootLogin not set to no"
  CHECK_RESULT $? 0 0 "OK message not found"
```

- 涉及命令：grep×3, sed×2

#### oe_test_secscanner_120

- 描述：deny_root_login test (set to no)
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Failed to set deny_root_login=no"
  CHECK_RESULT $? 0 0 "PermitRootLogin should remain yes when deny_root_login=no"
```

- 涉及命令：sed×2, grep×1

#### oe_test_secscanner_121

- 描述：disable_unused_user test (set to yes, level3)
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Failed to set disable_unused_user=yes"
  CHECK_RESULT $? 0 0 "OK message not found"
```

- 涉及命令：sed×1, grep×1

#### oe_test_secscanner_122

- 描述：disable_unused_user test (set to no, level3)
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "Failed to set disable_unused_user=no"
```

- 涉及命令：sed×1

#### oe_test_secscanner_123

- 描述：disable_unused_user test - when user shell is /bin/bash, level3
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Failed to set disable_unused_user=yes"
  CHECK_RESULT 1 0 "$TEST_USER shell should be changed to /bin/false"
```

- 涉及命令：usermod×1, sed×1

#### oe_test_secscanner_124

- 描述：expired_account test (set to yes, level3)
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Failed to set expired_account=yes"
  CHECK_RESULT $? 0 0 "OK message not found"
```

- 涉及命令：sed×5, chage×1, grep×1, userdel×1

#### oe_test_secscanner_125

- 描述：expired_account test (set to no, level3)
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "Failed to set expired_account=no"
```

- 涉及命令：chage×1, sed×1, userdel×1

#### oe_test_secscanner_126

- 描述：forbidden_to_su test (set to yes, level3)
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Failed to set forbidden_to_su=yes"
  CHECK_RESULT $? 0 0 "Step 3: WARNING message not found"
  CHECK_RESULT $? 0 0 "Step 4: pam_wheel configuration not found"
```

- 涉及命令：sed×2, grep×2

#### oe_test_secscanner_127

- 描述：forbidden_to_su test (set to no, level3)
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Failed to set forbidden_to_su=no"
  CHECK_RESULT $? 0 0 "pam_wheel configuration was added (unexpected"
```

- 涉及命令：sed×2, grep×1

#### oe_test_secscanner_128

- 描述：passwd_property test (set to yes, level3)
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Failed to set passwd_property=yes"
  CHECK_RESULT $? 0 0 "WARNING message not found"
```

- 涉及命令：sed×1, grep×1

#### oe_test_secscanner_129

- 描述：passwd_property test (set to no, level3)
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "Failed to set passwd_property=no"
```

- 涉及命令：sed×1

#### oe_test_secscanner_130

- 描述：shadow_property test (set to yes, level3)
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Failed to set shadow_property=yes"
  CHECK_RESULT $? 0 0 "Failed to change /etc/shadow permission to 444"
  CHECK_RESULT $? 0 0 "WARNING message not found"
```

- 涉及命令：sed×1, grep×1

#### oe_test_secscanner_131

- 描述：shadow_property test (set to no, level3)
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Failed to set shadow_property=no"
  CHECK_RESULT $? 0 0 "Failed to change /etc/shadow permission to 444"
```

- 涉及命令：sed×1

#### oe_test_secscanner_132

- 描述：group_property test (set to yes, level3)
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Failed to set group_property=yes"
  CHECK_RESULT $? 0 0 "Failed to change /etc/group permission to 444"
  CHECK_RESULT $? 0 0 "WARNING message not found"
```

- 涉及命令：sed×1, grep×1

#### oe_test_secscanner_133

- 描述：group_property test (set to no, level3)
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Failed to set group_property=no"
  CHECK_RESULT $? 0 0 "Failed to change /etc/group permission to 444"
```

- 涉及命令：sed×1

#### oe_test_secscanner_134

- 描述：gshadow_property test (set to yes, level3)
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Failed to set gshadow_property=yes"
  CHECK_RESULT $? 0 0 "Failed to change /etc/gshadow permission to 444"
  CHECK_RESULT $? 0 0 "WARNING message not found"
```

- 涉及命令：sed×1, grep×1

#### oe_test_secscanner_135

- 描述：gshadow_property test (set to no, level3)
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Failed to set gshadow_property=no"
  CHECK_RESULT $? 0 0 "Failed to change /etc/gshadow permission to 444"
```

- 涉及命令：sed×1

#### oe_test_secscanner_136

- 描述：passwdx_property test (set to yes, level3)
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Failed to set passwdx_property=yes"
  CHECK_RESULT $? 0 0 "Failed to change /etc/passwd- permission to 444"
  CHECK_RESULT $? 0 0 "WARNING message not found"
```

- 涉及命令：sed×1, grep×1

#### oe_test_secscanner_137

- 描述：passwdx_property test (set to no, level3)
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Failed to set passwdx_property=no"
  CHECK_RESULT $? 0 0 "Failed to change /etc/passwd- permission to 444"
```

- 涉及命令：sed×1

#### oe_test_secscanner_138

- 描述：shadowx_property test (set to yes, level3)
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Failed to set shadowx_property=yes"
  CHECK_RESULT $? 0 0 "Failed to change /etc/shadow- permission to 444"
  CHECK_RESULT $? 0 0 "WARNING message not found"
```

- 涉及命令：sed×1, grep×1

#### oe_test_secscanner_139

- 描述：shadowx_property test (set to no, level3)
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Failed to set shadowx_property=no"
  CHECK_RESULT $? 0 0 "Failed to change /etc/shadow- permission to 444"
```

- 涉及命令：sed×1

#### oe_test_secscanner_140

- 描述：groupx_property test (set to yes, level3)
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Failed to set groupx_property=yes"
  CHECK_RESULT $? 0 0 "Failed to change /etc/group- permission to 444"
  CHECK_RESULT $? 0 0 "WARNING message not found"
```

- 涉及命令：sed×1, grep×1

#### oe_test_secscanner_141

- 描述：groupx_property test (set to no, level3)
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Failed to set groupx_property=no"
  CHECK_RESULT $? 0 0 "Failed to change /etc/group- permission to 444"
```

- 涉及命令：sed×1

#### oe_test_secscanner_142

- 描述：gshadowx_property test (set to yes, level3)
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Failed to set gshadowx_property=yes"
  CHECK_RESULT $? 0 0 "Failed to change /etc/gshadow- permission to 444"
  CHECK_RESULT $? 0 0 "WARNING message not found"
```

- 涉及命令：sed×1, grep×1

#### oe_test_secscanner_143

- 描述：gshadowx_property test (set to no, level3)
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Failed to set gshadowx_property=no"
  CHECK_RESULT $? 0 0 "Failed to change /etc/gshadow- permission to 444"
```

- 涉及命令：sed×1

#### oe_test_secscanner_144

- 描述：set_selinux test (set to yes, level3)
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "Failed to set set_selinux=yes"
  CHECK_RESULT $? 0 0 "Failed to set SELINUX=disabled"
  CHECK_RESULT $? 0 0 "WARNING message not found"
  CHECK_RESULT 0 0 0 "SELINUX is set to $current_selinux"
  CHECK_RESULT 1 0 0 "SELINUX is not set to enforcing or permissive, current value: $current_selinux"
```

- 涉及命令：sed×2, grep×1

#### oe_test_secscanner_145

- 描述：set_selinux test (set to no, level3)
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Failed to set set_selinux=no"
  CHECK_RESULT $? 0 0 "Failed to set SELINUX=disabled"
  CHECK_RESULT 1 0 0 "SELINUX is not set to disabled, current value: $current_selinux"
```

- 涉及命令：sed×2

#### oe_test_secscanner_146

- 描述：set_selinux test (SELINUX=enforcing, set to yes, level3)
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "Failed to set set_selinux=yes"
  CHECK_RESULT $? 0 0 "Failed to set SELINUX=enforcing"
  CHECK_RESULT $? 0 0 "OK message not found"
  CHECK_RESULT 1 0 0 "SELINUX is not set to enforcing, current value: $current_selinux"
```

- 涉及命令：sed×2, grep×1

#### oe_test_secscanner_147

- 描述：set_selinux test (SELINUX=permissive, set to yes, level3)
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "Failed to set set_selinux=yes"
  CHECK_RESULT $? 0 0 "Failed to set SELINUX=permissive"
  CHECK_RESULT $? 0 0 "OK message not found"
  CHECK_RESULT 1 0 0 "SELINUX is not set to permissive, current value: $current_selinux"
```

- 涉及命令：sed×2, grep×1

#### oe_test_secscanner_148

- 描述：set_audit test (set to yes, level3)
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Failed to set set_audit=yes"
  CHECK_RESULT $? 0 0 "WARNING message not found"
  CHECK_RESULT 1 0 0 "auditd is not enabled, current status: $auditd_status"
```

- 涉及命令：sed×1, grep×1

#### oe_test_secscanner_149

- 描述：set_audit test (set to no, level3)
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "Failed to set set_audit=no"
```

- 涉及命令：sed×1

#### oe_test_secscanner_150

- 描述：set_audit test (auditd not installed, set to yes, level3)
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Failed to set set_audit=yes"
  CHECK_RESULT $? 0 0 "Step 3: auditd should be installed"
  CHECK_RESULT 1 0 0 "auditd is not enabled, current status: $auditd_status"
```

- 涉及命令：sed×1, rpm×1

#### oe_test_secscanner_151

- 描述：set_audit test (auditd already enabled, set to yes, level3)
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Failed to set set_audit=yes"
  CHECK_RESULT 1 0 0 "auditd is not enabled, current status: $auditd_status"
```

- 涉及命令：sed×1

#### oe_test_secscanner_152

- 描述：set_tmout test with no existing TMOUT configuration (set to yes)
- 函数：`pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $? 0 0 "Failed to set set_tmout=yes"
  CHECK_RESULT $? 0 0 "WARNING message not found"
  CHECK_RESULT $? 0 0 "Step 3: TMOUT not set to 180"
  CHECK_RESULT $? 0 0 "Step 3: export TMOUT not found"
  CHECK_RESULT $? 0 0 "Step 4: OK message not found"
  CHECK_RESULT $? 0 0 "Step 5: Restore message not found"
  CHECK_RESULT $? 1 0 "Step 6: TMOUT configuration not removed"
```

- 涉及命令：grep×6, sed×3

#### oe_test_secscanner_153

- 描述：enable_ssh test (set to no, service running)
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "sshd service should be running"
  CHECK_RESULT $? 0 0 "Failed to set enable_ssh=no"
  CHECK_RESULT $? 0 0 "sshd service should remain running when enable_ssh=no"
  CHECK_RESULT $? 0 0 "sshd service should be stopped"
  CHECK_RESULT $? 0 0 "sshd service should remain stopped when enable_ssh=no"
  CHECK_RESULT $? 0 0 "sshd service should be running after restore"
```

- 涉及命令：sed×1

#### oe_test_secscanner_154

- 描述：set_tmout test (set to no, level3)
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Failed to set set_tmout=no"
  CHECK_RESULT $? 0 0 "Step 3: TMOUT configuration should remain unchanged when set_tmout=no"
  CHECK_RESULT $? 0 0 "Step 3: export TMOUT should remain unchanged when set_tmout=no"
```

- 涉及命令：sed×3, grep×2

#### oe_test_secscanner_155

- 描述：set_rsyslog test (set to yes, service disabled, level3)
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "Failed to set set_rsyslog=yes"
  CHECK_RESULT $? 0 0 "Step 2: WARNING message not found"
  CHECK_RESULT $? 0 0 "Step 3: Fix message not found"
  CHECK_RESULT $? 0 0 "Step 4: OK message not found"
  CHECK_RESULT $? 0 0 "Step 5: rsyslog should be enabled"
```

- 涉及命令：grep×3, sed×1

#### oe_test_secscanner_156

- 描述：set_rsyslog test (set to yes, service already enabled, level3)
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Failed to set set_rsyslog=yes"
  CHECK_RESULT $? 0 0 "Step 2: OK message not found"
  CHECK_RESULT $? 0 0 "Step 4: rsyslog should remain enabled"
```

- 涉及命令：sed×1, grep×1

#### oe_test_secscanner_157

- 描述：set_rsyslog test (set to no, service disabled, level3)
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Failed to set set_rsyslog=no"
  CHECK_RESULT $? 1 0 "Step 4: rsyslog should remain disabled when set_rsyslog=no"
```

- 涉及命令：sed×1

#### oe_test_secscanner_158

- 描述：set_rsyslog test (set to yes, service disabled, level3)
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "Failed to set set_rsyslog=yes"
  CHECK_RESULT $? 0 0 "Step 2: WARNING message not found"
  CHECK_RESULT $? 0 0 "Step 3: Fix message not found"
  CHECK_RESULT $? 0 0 "Step 4: OK message not found"
  CHECK_RESULT $? 0 0 "Step 5: rsyslog should be enabled"
```

- 涉及命令：grep×3, sed×1

#### oe_test_secscanner_159

- 描述：set_auditrules test (set to yes, level3)
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "Failed to set set_auditrules=yes"
  CHECK_RESULT $? 0 0 "Step 2: WARNING message not found"
  CHECK_RESULT $? 0 0 "Step 3: Fix message not found"
  CHECK_RESULT $? 0 0 "Step 4: Audit rules content does not match expected"
  CHECK_RESULT $? 0 0 "Step 5: OK message not found"
  CHECK_RESULT $? 0 0 "Step 6: Restore message not found"
```

- 涉及命令：grep×4, sed×1

#### oe_test_secscanner_160

- 描述：set_auditrules test (set to yes, level3)
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Failed to set set_auditrules=yes"
  CHECK_RESULT $? 0 0 "Step 4: Audit rules content does not match expected"
```

- 涉及命令：sed×1

#### oe_test_secscanner_161

- 描述：set_auditrules test (set to no, level3)
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Failed to set set_auditrules=no"
  CHECK_RESULT $? 0 0 "Step 2: OK message not found"
  CHECK_RESULT $? 0 0 "Step 4: Audit rules file should remain the same when set_auditrules=no"
```

- 涉及命令：sed×1, grep×1

#### oe_test_secscanner_162

- 描述：set_ftp_install test (set to yes, level3)
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "Step 2: ftp should be installed"
  CHECK_RESULT $? 0 0 "Failed to set set_ftp_install=yes"
  CHECK_RESULT $? 0 0 "Step 3: WARNING message not found"
  CHECK_RESULT $? 0 0 "Step 3: Fix message not found"
  CHECK_RESULT $? 1 0 "Step 4: ftp should be uninstalled"
```

- 涉及命令：rpm×2, grep×2, sed×1

#### oe_test_secscanner_163

- 描述：set_ftp_install test (set to no, level3)
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "ftp should be installed"
  CHECK_RESULT $? 0 0 "Failed to set set_ftp_install=no"
  CHECK_RESULT $? 0 0 "Step 4: ftp should remain installed when set_ftp_install=no"
```

- 涉及命令：rpm×2, sed×1

#### oe_test_secscanner_164

- 描述：set_ypbind_install test (set to yes, level3)
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "Failed to set set_ypbind_install=yes"
  CHECK_RESULT $? 0 0 "Step 2: ypbind should be installed"
  CHECK_RESULT $? 0 0 "Step 4: Fix message not found"
  CHECK_RESULT $? 1 0 "Step 5: ypbind should be uninstalled"
```

- 涉及命令：rpm×2, sed×1, grep×1

#### oe_test_secscanner_165

- 描述：set_ypbind_install test (set to no, level3)
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Failed to set set_ypbind_install=no"
  CHECK_RESULT $? 0 0 "Step 2: ypbind should be installed"
  CHECK_RESULT $? 0 0 "Step 5: ypbind should remain installed when set_ypbind_install=no"
```

- 涉及命令：rpm×2, sed×1

#### oe_test_secscanner_166

- 描述：set_ypbind_install test (set to yes, level3)
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "ypbind should be installed"
  CHECK_RESULT $? 0 0 "Failed to set set_ypbind_install=yes"
  CHECK_RESULT $? 0 0 "Step 2: ypbind should be installed"
  CHECK_RESULT $? 0 0 "Step 4: Fix message not found"
  CHECK_RESULT $? 1 0 "Step 5: ypbind should be uninstalled"
```

- 涉及命令：rpm×3, sed×1, grep×1

#### oe_test_secscanner_167

- 描述：set_ypbind_install test (set to no, level3)
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "ypbind should be installed"
  CHECK_RESULT $? 0 0 "Failed to set set_ypbind_install=no"
  CHECK_RESULT $? 0 0 "Step 2: ypbind should be installed"
  CHECK_RESULT $? 0 0 "Step 5: ypbind should remain installed when set_ypbind_install=no"
```

- 涉及命令：rpm×3, sed×1

#### oe_test_secscanner_168

- 描述：set_tftp test (set to yes, level3)
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "tftp should be installed"
  CHECK_RESULT $? 0 0 "Failed to set remove_tftp=yes"
  CHECK_RESULT $? 0 0 "Step 2: tftp should be installed"
  CHECK_RESULT $? 0 0 "Step 4: Fix message not found"
  CHECK_RESULT $? 1 0 "Step 5: tftp should be uninstalled"
```

- 涉及命令：rpm×3, sed×1, grep×1

#### oe_test_secscanner_169

- 描述：set_tftp test (set to no, level3)
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "tftp should be installed"
  CHECK_RESULT $? 0 0 "Failed to set remove_tftp=no"
  CHECK_RESULT $? 0 0 "Step 2: tftp should be installed"
  CHECK_RESULT $? 0 0 "Step 5: tftp should remain installed when set_tftp=no"
```

- 涉及命令：rpm×3, sed×1

#### oe_test_secscanner_170

- 描述：set_aide test (set to yes, aide not installed, level3)
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 1 0 "aide should not be installed"
  CHECK_RESULT $? 0 0 "Failed to set set_aide=yes"
  CHECK_RESULT $? 0 0 "Step 2: WARNING message not found"
  CHECK_RESULT $? 0 0 "Step 3: Fix message not found"
  CHECK_RESULT $? 0 0 "Step 4: aide should be installed"
  CHECK_RESULT $? 0 0 "Step 5: OK message not found"
```

- 涉及命令：grep×3, rpm×2, sed×1

#### oe_test_secscanner_171

- 描述：set_aide test (set to no, aide not installed, level3)
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 1 0 "aide should not be installed"
  CHECK_RESULT $? 0 0 "Failed to set set_aide=no"
  CHECK_RESULT $? 1 0 "Step 4: aide should remain not installed when set_aide=no"
```

- 涉及命令：rpm×2, sed×1

#### oe_test_secscanner_172

- 描述：set_aide test (set to yes, aide already installed, level3)
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "aide should be installed"
  CHECK_RESULT $? 0 0 "Failed to set set_aide=yes"
  CHECK_RESULT $? 0 0 "Step 2: OK message not found"
  CHECK_RESULT $? 0 0 "Step 4: aide should remain installed when set_aide=yes"
```

- 涉及命令：rpm×2, sed×1, grep×1

#### oe_test_secscanner_173

- 描述：set_aide test (set to no, aide already installed, level3)
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "aide should be installed"
  CHECK_RESULT $? 0 0 "Failed to set set_aide=no"
  CHECK_RESULT $? 0 0 "Step 4: aide should remain installed when set_aide=no"
```

- 涉及命令：rpm×2, sed×1

#### oe_test_secscanner_174

- 描述：set_chrony test (set to yes, chrony not installed, level3)
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 1 0 "chrony should not be installed"
  CHECK_RESULT $? 0 0 "Failed to set set_chrony=yes"
  CHECK_RESULT $? 0 0 "Step 2: WARNING message not found"
  CHECK_RESULT $? 0 0 "Step 3: Fix message not found"
  CHECK_RESULT $? 0 0 "Step 4: chrony should be installed"
```

- 涉及命令：rpm×2, grep×2, sed×1

#### oe_test_secscanner_175

- 描述：set_chrony test (set to no, chrony not installed, level3)
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 1 0 "chrony should not be installed"
  CHECK_RESULT $? 0 0 "Failed to set set_chrony=no"
  CHECK_RESULT $? 1 0 "Step 4: chrony should remain not installed when set_chrony=no"
```

- 涉及命令：rpm×2, sed×1

#### oe_test_secscanner_176

- 描述：set_chrony test (set to yes, chrony already installed, level3)
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "chrony should be installed"
  CHECK_RESULT $? 0 0 "Failed to set set_chrony=yes"
  CHECK_RESULT $? 0 0 "Step 2: OK message not found"
  CHECK_RESULT $? 0 0 "Step 4: chrony should remain installed when set_chrony=yes"
```

- 涉及命令：rpm×2, sed×1, grep×1

#### oe_test_secscanner_177

- 描述：set_chrony test (set to no, chrony already installed, level3)
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "chrony should be installed"
  CHECK_RESULT $? 0 0 "Failed to set set_chrony=no"
  CHECK_RESULT $? 0 0 "Step 4: chrony should remain installed when set_chrony=no"
```

- 涉及命令：rpm×2, sed×1

#### oe_test_secscanner_178

- 描述：set_disabled_NfsServer test (set to yes, nfs-server enabled, level3)
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "nfs-server should be enabled"
  CHECK_RESULT $? 0 0 "Failed to set set_disabled_NfsServer=yes"
  CHECK_RESULT $? 0 0 "Step 2: nfs-server should be enabled"
  CHECK_RESULT $? 0 0 "Step 4: Fix message not found"
  CHECK_RESULT $? 1 0 "Step 5: nfs-server should be disabled"
  CHECK_RESULT $? 0 0 "Step 6: OK message not found"
```

- 涉及命令：grep×2, sed×1

#### oe_test_secscanner_179

- 描述：set_disabled_NfsServer test (set to no, nfs-server enabled, level3)
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "nfs-server should be enabled"
  CHECK_RESULT $? 0 0 "Failed to set set_disabled_NfsServer=no"
  CHECK_RESULT $? 0 0 "Step 2: nfs-server should be enabled"
  CHECK_RESULT $? 0 0 "Step 5: nfs-server should remain enabled when set_disabled_NfsServer=no"
```

- 涉及命令：sed×1

#### oe_test_secscanner_180

- 描述：set_disabled_NfsServer test (set to yes, nfs-server already disabled, level3)
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 1 0 "nfs-server should be disabled"
  CHECK_RESULT $? 0 0 "Failed to set set_disabled_NfsServer=yes"
  CHECK_RESULT $? 1 0 "Step 2: nfs-server should be disabled"
  CHECK_RESULT $? 0 0 "Step 3: OK message not found"
  CHECK_RESULT $? 1 0 "Step 5: nfs-server should remain disabled when set_disabled_NfsServer=yes"
```

- 涉及命令：sed×1, grep×1

#### oe_test_secscanner_181

- 描述：set_disabled_NfsServer test (set to no, nfs-server already disabled, level3)
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 1 0 "nfs-server should be disabled"
  CHECK_RESULT $? 0 0 "Failed to set set_disabled_NfsServer=no"
  CHECK_RESULT $? 1 0 "Step 2: nfs-server should be disabled"
  CHECK_RESULT $? 1 0 "Step 5: nfs-server should remain disabled when set_disabled_NfsServer=no"
```

- 涉及命令：sed×1

#### oe_test_secscanner_182

- 描述：set_disabled_DNSserver test (set to yes, DNS service already enabled, level3)
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "named should be enabled"
  CHECK_RESULT $? 0 0 "Failed to set set_disabled_DNSserver=yes"
  CHECK_RESULT $? 1 0 "named should be disabled after fix"
```

- 涉及命令：sed×1

#### oe_test_secscanner_183

- 描述：set_disabled_DNSserver test (set to no, DNS service already enabled, level3)
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "named should be enabled"
  CHECK_RESULT $? 0 0 "Failed to set set_disabled_DNSserver=no"
  CHECK_RESULT $? 0 0 "named should be enabled before fix"
  CHECK_RESULT $? 0 0 "named should remain enabled when set_disabled_DNSserver=no"
```

- 涉及命令：sed×1

#### oe_test_secscanner_184

- 描述：set_disabled_DNSserver test (set to yes, DNS service already disabled, level3)
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 1 0 "named should be disabled"
  CHECK_RESULT $? 0 0 "Failed to set set_disabled_DNSserver=yes"
  CHECK_RESULT $? 1 0 "named should be disabled before fix"
  CHECK_RESULT $? 1 0 "named should remain disabled when set_disabled_DNSserver=yes"
```

- 涉及命令：sed×1

#### oe_test_secscanner_185

- 描述：set_disabled_DNSserver test (set to no, DNS service already disabled, level3)
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 1 0 "named should be disabled"
  CHECK_RESULT $? 0 0 "Failed to set set_disabled_DNSserver=no"
  CHECK_RESULT $? 1 0 "named should be disabled before fix"
  CHECK_RESULT $? 1 0 "named should not be enabled when set_disabled_DNSserver=no"
```

- 涉及命令：sed×1

#### oe_test_secscanner_186

- 描述：set_dhcp test (set to yes, dhcp service already enabled, level3)
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "dhcpd should be enabled"
  CHECK_RESULT $? 0 0 "Failed to set set_dhcp=yes"
  CHECK_RESULT $? 0 0 "dhcpd should be enabled before fix"
  CHECK_RESULT $? 1 0 "dhcpd should be disabled after fix"
```

- 涉及命令：sed×1

#### oe_test_secscanner_187

- 描述：set_dhcp test (set to no, dhcp service already enabled, level3)
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "dhcpd should be enabled"
  CHECK_RESULT $? 0 0 "Failed to set set_dhcp=no"
  CHECK_RESULT $? 0 0 "dhcpd should be enabled before fix"
  CHECK_RESULT $? 0 0 "dhcpd should remain enabled when set_dhcp=no"
```

- 涉及命令：sed×1

#### oe_test_secscanner_188

- 描述：set_dhcp test (set to yes, dhcp service already disabled, level3)
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 1 0 "dhcpd should be disabled"
  CHECK_RESULT $? 0 0 "Failed to set set_dhcp=yes"
  CHECK_RESULT $? 1 0 "dhcpd should be disabled before fix"
  CHECK_RESULT $? 1 0 "dhcpd should remain disabled when set_dhcp=yes"
```

- 涉及命令：sed×1

#### oe_test_secscanner_189

- 描述：set_dhcp test (set to no, dhcp service already disabled, level3)
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 1 0 "dhcpd should be disabled"
  CHECK_RESULT $? 0 0 "Failed to set set_dhcp=no"
  CHECK_RESULT $? 1 0 "dhcpd should be disabled before fix"
  CHECK_RESULT $? 1 0 "dhcpd should be not enabled when set_dhcp=no"
```

- 涉及命令：sed×1

#### oe_test_secscanner_190

- 描述：set_rpc test (set to yes, rpcbind service already enabled, level3)
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "rpcbind should be enabled"
  CHECK_RESULT $? 0 0 "Failed to set set_rpc=yes"
  CHECK_RESULT $? 0 0 "rpcbind should be enabled before fix"
  CHECK_RESULT $? 1 0 "rpcbind should be disabled after fix"
```

- 涉及命令：sed×1

#### oe_test_secscanner_191

- 描述：set_rpc test (set to no, rpcbind service already enabled, level3)
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "rpcbind should be enabled"
  CHECK_RESULT $? 0 0 "Failed to set set_rpc=no"
  CHECK_RESULT $? 0 0 "rpcbind should be enabled before fix"
  CHECK_RESULT $? 0 0 "rpcbind should remain enabled when set_rpc=no"
```

- 涉及命令：sed×1

#### oe_test_secscanner_192

- 描述：set_rpc test (set to yes, rpcbind service already disabled, level3)
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 1 0 "rpcbind should be disabled"
  CHECK_RESULT $? 0 0 "Failed to set set_rpc=yes"
  CHECK_RESULT $? 1 0 "rpcbind should be disabled before fix"
  CHECK_RESULT $? 1 0 "rpcbind should remain disabled when set_rpc=yes"
```

- 涉及命令：sed×1

#### oe_test_secscanner_193

- 描述：set_rpc test (set to no, rpcbind service already disabled, level3)
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 1 0 "rpcbind should be disabled"
  CHECK_RESULT $? 0 0 "Failed to set set_rpc=no"
  CHECK_RESULT $? 1 0 "rpcbind should be disabled before fix"
  CHECK_RESULT $? 1 0 "rpcbind should be not enabled when set_rpc=no"
```

- 涉及命令：sed×1

#### oe_test_secscanner_194

- 描述：set_samba test (set to yes, smb service already enabled, level3)
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "smb should be enabled"
  CHECK_RESULT $? 0 0 "Failed to set set_samba=yes"
  CHECK_RESULT $? 0 0 "smb should be enabled before fix"
  CHECK_RESULT $? 1 0 "smb should be disabled after fix"
```

- 涉及命令：sed×1

#### oe_test_secscanner_195

- 描述：set_samba test (set to no, smb service already enabled, level3)
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "smb should be enabled"
  CHECK_RESULT $? 0 0 "Failed to set set_samba=no"
  CHECK_RESULT $? 0 0 "smb should be enabled before fix"
  CHECK_RESULT $? 0 0 "smb should remain enabled when set_samba=no"
```

- 涉及命令：sed×1

#### oe_test_secscanner_196

- 描述：set_samba test (set to yes, smb service already disabled, level3)
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 1 0 "smb should be disabled"
  CHECK_RESULT $? 0 0 "Failed to set set_samba=yes"
  CHECK_RESULT $? 1 0 "smb should be disabled before fix"
  CHECK_RESULT $? 1 0 "smb should remain disabled when set_samba=yes"
```

- 涉及命令：sed×1

#### oe_test_secscanner_197

- 描述：set_samba test (set to no, smb service already disabled, level3)
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 1 0 "smb should be disabled"
  CHECK_RESULT $? 0 0 "Failed to set set_samba=no"
  CHECK_RESULT $? 1 0 "smb should be disabled before fix"
  CHECK_RESULT $? 1 0 "smb should be disabled"
```

- 涉及命令：sed×1

#### oe_test_secscanner_198

- 描述：set_snmp test (set to yes, snmpd service already enabled, level3)
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "snmpd should be enabled"
  CHECK_RESULT $? 0 0 "Failed to set set_snmp=yes"
  CHECK_RESULT $? 0 0 "snmpd should be enabled before fix"
  CHECK_RESULT $? 1 0 "snmpd should be disabled after fix"
```

- 涉及命令：sed×1

#### oe_test_secscanner_199

- 描述：set_snmp test (set to no, snmpd service already enabled, level3)
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "snmpd should be enabled"
  CHECK_RESULT $? 0 0 "Failed to set set_snmp=no"
  CHECK_RESULT $? 0 0 "snmpd should be enabled before fix"
  CHECK_RESULT $? 0 0 "snmpd should remain enabled when set_snmp=no"
```

- 涉及命令：sed×1

#### oe_test_secscanner_200

- 描述：set_snmp test (set to yes, snmpd service already disabled, level3)
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 1 0 "snmpd should be disabled"
  CHECK_RESULT $? 0 0 "Failed to set set_snmp=yes"
  CHECK_RESULT $? 1 0 "snmpd should be disabled before fix"
  CHECK_RESULT $? 1 0 "snmpd should remain disabled when set_snmp=yes"
```

- 涉及命令：sed×1

#### oe_test_secscanner_201

- 描述：set_snmp test (set to no, snmpd service already disabled, level3)
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 1 0 "snmpd should be disabled"
  CHECK_RESULT $? 0 0 "Failed to set set_snmp=no"
  CHECK_RESULT $? 1 0 "snmpd should be disabled before fix"
  CHECK_RESULT $? 1 0 "snmpd should be not enabled when set_snmp=no"
```

- 涉及命令：sed×1

#### oe_test_secscanner_202

- 描述：set_dovecot test (set to yes, dovecot service already enabled, level3)
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "dovecot should be enabled"
  CHECK_RESULT $? 0 0 "Failed to set set_dovecot=yes"
  CHECK_RESULT $? 0 0 "dovecot should be enabled before fix"
  CHECK_RESULT $? 1 0 "dovecot should be disabled after fix"
```

- 涉及命令：sed×1

#### oe_test_secscanner_203

- 描述：set_dovecot test (set to no, dovecot service already enabled, level3)
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "dovecot should be enabled"
  CHECK_RESULT $? 0 0 "Failed to set set_dovecot=no"
  CHECK_RESULT $? 0 0 "dovecot should be enabled before fix"
  CHECK_RESULT $? 0 0 "dovecot should remain enabled when set_dovecot=no"
```

- 涉及命令：sed×1

#### oe_test_secscanner_204

- 描述：set_dovecot test (set to yes, dovecot service already disabled, level3)
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 1 0 "dovecot should be disabled"
  CHECK_RESULT $? 0 0 "Failed to set set_dovecot=yes"
  CHECK_RESULT $? 1 0 "dovecot should be disabled before fix"
  CHECK_RESULT $? 1 0 "dovecot should remain disabled when set_dovecot=yes"
```

- 涉及命令：sed×1

#### oe_test_secscanner_205

- 描述：set_dovecot test (set to no, dovecot service already disabled, level3)
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 1 0 "dovecot should be disabled"
  CHECK_RESULT $? 0 0 "Failed to set set_dovecot=no"
  CHECK_RESULT $? 1 0 "dovecot should be disabled before fix"
  CHECK_RESULT $? 1 0 "dovecot should be not enabled when set_dovecot=no"
```

- 涉及命令：sed×1

#### oe_test_secscanner_206

- 描述：set_dovecot test (set to yes, dovecot service masked, level3)
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 1 0 "dovecot should be masked"
  CHECK_RESULT $? 0 0 "Failed to set set_dovecot=yes"
  CHECK_RESULT $? 1 0 "dovecot should be masked before fix"
  CHECK_RESULT $? 1 0 "dovecot should be masked after fix"
```

- 涉及命令：sed×1

#### oe_test_secscanner_207

- 描述：set_dovecot test (set to yes, dovecot not installed, level3)
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Failed to set set_dovecot=yes"
  CHECK_RESULT $? 1 0 "dovecot should not be installed"
  CHECK_RESULT $? 1 0 "dovecot should not be installed after fix"
```

- 涉及命令：rpm×2, sed×1

#### oe_test_secscanner_208

- 描述：set_dovecot test (set to no, dovecot service masked, level3)
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 1 0 "dovecot should be masked"
  CHECK_RESULT $? 0 0 "Failed to set set_dovecot=no"
  CHECK_RESULT $? 1 0 "dovecot should be masked before fix"
  CHECK_RESULT $? 1 0 "dovecot should be masked after fix"
```

- 涉及命令：sed×1

#### oe_test_secscanner_209

- 描述：set_dovecot test (set to no, dovecot not installed, level3)
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Failed to set set_dovecot=no"
  CHECK_RESULT $? 1 0 "dovecot should not be installed"
  CHECK_RESULT $? 1 0 "dovecot should not be installed after fix"
```

- 涉及命令：rpm×2, sed×1

#### oe_test_secscanner_210

- 描述：set_link_protection test (set to yes, both protections disabled, euler)
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "Failed to set set_link_protection=yes"
  CHECK_RESULT "$SYMLINK_STATUS" "0" 0 "Symlink protection should be disabled before fix"
  CHECK_RESULT "$HARDlink_STATUS" "0" 0 "Hardlink protection should be disabled before fix"
  CHECK_RESULT "$SYMLINK_STATUS" "1" 0 "Symlink protection should be enabled after fix"
  CHECK_RESULT "$HARDlink_STATUS" "1" 0 "Hardlink protection should be enabled after fix"
```

- 涉及命令：sysctl×4, sed×1

#### oe_test_secscanner_211

- 描述：set_link_protection test (set to no, both protections disabled, euler)
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "Failed to set set_link_protection=no"
  CHECK_RESULT "$SYMLINK_STATUS" "0" 0 "Symlink protection should be disabled before fix"
  CHECK_RESULT "$HARDlink_STATUS" "0" 0 "Hardlink protection should be disabled before fix"
  CHECK_RESULT "$SYMLINK_STATUS" "0" 0 "Symlink protection should be disabled after fix"
  CHECK_RESULT "$HARDlink_STATUS" "0" 0 "Hardlink protection should be disabled after fix"
```

- 涉及命令：sysctl×4, sed×1

#### oe_test_secscanner_212

- 描述：set_link_protection test (set to yes, both protections enabled, euler)
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "Failed to set set_link_protection=yes"
  CHECK_RESULT "$SYMLINK_STATUS" "1" 0 "Symlink protection should be enabled before fix"
  CHECK_RESULT "$HARDlink_STATUS" "1" 0 "Hardlink protection should be enabled before fix"
  CHECK_RESULT "$SYMLINK_STATUS" "1" 0 "Symlink protection should be enabled after fix"
  CHECK_RESULT "$HARDlink_STATUS" "1" 0 "Hardlink protection should be enabled after fix"
```

- 涉及命令：sysctl×4, sed×1

#### oe_test_secscanner_213

- 描述：set_link_protection test (set to no, both protections enabled, euler)
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "Failed to set set_link_protection=no"
  CHECK_RESULT "$SYMLINK_STATUS" "1" 0 "Symlink protection should be enabled before fix"
  CHECK_RESULT "$HARDlink_STATUS" "1" 0 "Hardlink protection should be enabled before fix"
  CHECK_RESULT "$SYMLINK_STATUS" "1" 0 "Symlink protection should be enabled after fix"
  CHECK_RESULT "$HARDlink_STATUS" "1" 0 "Hardlink protection should be enabled after fix"
```

- 涉及命令：sysctl×4, sed×1

#### oe_test_secscanner_214

- 描述：set_link_protection test (set to yes, symlink enabled, hardlink disabled, euler)
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "Failed to set set_link_protection=yes"
  CHECK_RESULT "$SYMLINK_STATUS" "1" 0 "Symlink protection should be enabled before fix"
  CHECK_RESULT "$HARDlink_STATUS" "0" 0 "Hardlink protection should be disabled before fix"
  CHECK_RESULT "$SYMLINK_STATUS" "1" 0 "Symlink protection should be enabled after fix"
  CHECK_RESULT "$HARDlink_STATUS" "1" 0 "Hardlink protection should be enabled after fix"
```

- 涉及命令：sysctl×4, sed×1

#### oe_test_secscanner_215

- 描述：set_link_protection test (set to yes, symlink disabled, hardlink enabled, euler)
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "Failed to set set_link_protection=yes"
  CHECK_RESULT "$SYMLINK_STATUS" "0" 0 "Symlink protection should be disabled before fix"
  CHECK_RESULT "$HARDlink_STATUS" "1" 0 "Hardlink protection should be enabled before fix"
  CHECK_RESULT "$SYMLINK_STATUS" "1" 0 "Symlink protection should be enabled after fix"
  CHECK_RESULT "$HARDlink_STATUS" "1" 0 "Hardlink protection should be enabled after fix"
```

- 涉及命令：sysctl×4, sed×1

#### oe_test_secscanner_216

- 描述：set_prohibition_usb test (set to yes, USB storage not prohibited, euler)
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Failed to set set_prohibition_usb=yes"
  CHECK_RESULT $? 0 0 "当set_prohibition_usb=yes时，USB存储应该被禁止，应该输出包含install"
  CHECK_RESULT $? 0 0 "当set_prohibition_usb=yes时，应该存在USB禁止配置文件"
```

- 涉及命令：modprobe×1, sed×1, test×1

#### oe_test_secscanner_217

- 描述：set_prohibition_usb test (set to no, USB storage not prohibited, euler)
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Failed to set set_prohibition_usb=no"
  CHECK_RESULT $? 0 0 "当set_prohibition_usb=no时，USB存储不应该被禁止，应该输出包含insmod"
  CHECK_RESULT $? 0 0 "当set_prohibition_usb=no时，不应该存在USB禁止配置文件"
```

- 涉及命令：modprobe×3, sed×1

#### oe_test_secscanner_218

- 描述：set_prohibition_usb test (set to yes, USB storage already prohibited, euler)
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Failed to set set_prohibition_usb=yes"
  CHECK_RESULT $? 0 0 "当set_prohibition_usb=yes时，USB存储应该被禁止，应该输出包含install"
  CHECK_RESULT $? 0 0 "当set_prohibition_usb=yes时，应该存在USB禁止配置文件"
```

- 涉及命令：modprobe×1, sed×1, test×1

#### oe_test_secscanner_219

- 描述：set_prohibition_usb test (set to no, USB storage already prohibited, euler)
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Failed to set set_prohibition_usb=no"
  CHECK_RESULT $? 0 0 "当set_prohibition_usb=no时，USB存储不应该被禁止，应该输出包含insmod"
  CHECK_RESULT $? 0 0 "当set_prohibition_usb=no时，不应该存在USB禁止配置文件"
```

- 涉及命令：modprobe×1, sed×1

#### oe_test_secscanner_220

- 描述：set_remove_ftp test (set to yes, ftp installed, euler)
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "ftp should be installed"
  CHECK_RESULT $? 0 0 "Failed to set set_remove_ftp=yes"
  CHECK_RESULT $? 1 0 "ftp should not be installed after fix"
```

- 涉及命令：rpm×2, sed×1

#### oe_test_secscanner_221

- 描述：set_remove_ftp test (set to no, ftp installed, euler)
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "ftp should be installed"
  CHECK_RESULT $? 0 0 "Failed to set set_remove_ftp=no"
  CHECK_RESULT $? 0 0 "ftp should be installed before fix"
  CHECK_RESULT $? 0 0 "ftp should be installed after fix"
```

- 涉及命令：rpm×3, sed×1

#### oe_test_secscanner_222

- 描述：set_remove_ftp test (set to yes, ftp not installed, euler)
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 1 0 "ftp should not be installed"
  CHECK_RESULT $? 0 0 "Failed to set set_remove_ftp=yes"
  CHECK_RESULT $? 1 0 "ftp should not be installed before fix"
  CHECK_RESULT $? 1 0 "ftp should not be installed after fix"
```

- 涉及命令：rpm×3, sed×1

#### oe_test_secscanner_223

- 描述：set_remove_ftp test (set to no, ftp not installed, euler)
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 1 0 "ftp should not be installed"
  CHECK_RESULT $? 0 0 "Failed to set set_remove_ftp=no"
  CHECK_RESULT $? 1 0 "ftp should not be installed before fix"
  CHECK_RESULT $? 1 0 "ftp should not be installed after fix"
```

- 涉及命令：rpm×3, sed×1

#### oe_test_secscanner_224

- 描述：set_remove_tftp test (set to yes, tftp installed, euler)
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "tftp should be installed"
  CHECK_RESULT $? 0 0 "Failed to set set_remove_tftp=yes"
  CHECK_RESULT $? 0 0 "tftp should be installed before fix"
  CHECK_RESULT $? 1 0 "tftp should not be installed after fix"
```

- 涉及命令：rpm×3, sed×1

#### oe_test_secscanner_225

- 描述：set_remove_tftp test (set to no, tftp installed, euler)
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "tftp should be installed"
  CHECK_RESULT $? 0 0 "Failed to set set_remove_tftp=no"
  CHECK_RESULT $? 0 0 "tftp should be installed before fix"
  CHECK_RESULT $? 0 0 "tftp should be installed after fix"
```

- 涉及命令：rpm×3, sed×1

#### oe_test_secscanner_226

- 描述：set_remove_tftp test (set to yes, tftp not installed, euler)
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 1 0 "tftp should not be installed"
  CHECK_RESULT $? 0 0 "Failed to set set_remove_tftp=yes"
  CHECK_RESULT $? 1 0 "tftp should not be installed before fix"
  CHECK_RESULT $? 1 0 "tftp should not be installed after fix"
```

- 涉及命令：rpm×3, sed×1

#### oe_test_secscanner_227

- 描述：set_remove_tftp test (set to no, tftp not installed, euler)
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 1 0 "tftp should not be installed"
  CHECK_RESULT $? 0 0 "Failed to set set_remove_tftp=no"
  CHECK_RESULT $? 1 0 "tftp should not be installed before fix"
  CHECK_RESULT $? 1 0 "tftp should not be installed after fix"
```

- 涉及命令：rpm×3, sed×1

#### oe_test_secscanner_228

- 描述：set_remove_telnet test (set to no, telnet already installed, euler)
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Failed to set set_remove_telnet=no"
  CHECK_RESULT $? 0 0 "Telnet should be installed before fix"
  CHECK_RESULT $? 0 0 "Telnet should still be installed after fix if set_remove_telnet=no"
```

- 涉及命令：rpm×2, sed×1

#### oe_test_secscanner_229

- 描述：set_remove_telnet test (set to yes, telnet not installed, euler)
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Failed to set set_remove_telnet=yes"
  CHECK_RESULT $? 1 0 "Telnet should not be installed before fix"
  CHECK_RESULT $? 1 0 "Telnet should still not be installed after fix if set_remove_telnet=yes"
```

- 涉及命令：rpm×2, sed×1

#### oe_test_secscanner_230

- 描述：set_remove_telnet test (set to yes, telnet already installed, euler)
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Failed to set set_remove_telnet=yes"
  CHECK_RESULT $? 0 0 "Telnet should be installed before fix"
  CHECK_RESULT $? 1 0 "Telnet should be removed after fix"
```

- 涉及命令：rpm×2, sed×1

#### oe_test_secscanner_231

- 描述：set_remove_telnet test (set to no, telnet not installed, euler)
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Failed to set set_remove_telnet=no"
  CHECK_RESULT $? 1 0 "Telnet should not be installed before fix"
  CHECK_RESULT $? 1 0 "Telnet should still not be installed after fix"
```

- 涉及命令：rpm×2, sed×1

#### oe_test_secscanner_232

- 描述：set_remove_snmp test (set to yes, net-snmp already installed, euler)
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Failed to set set_remove_snmp=yes"
  CHECK_RESULT $? 0 0 "Net-snmp should be installed before fix"
  CHECK_RESULT $? 1 0 "Net-snmp should be removed after fix"
```

- 涉及命令：rpm×2, sed×1

#### oe_test_secscanner_233

- 描述：set_remove_snmp test (set to no, net-snmp already installed, euler)
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Failed to set set_remove_snmp=no"
  CHECK_RESULT $? 0 0 "Net-snmp should be installed before fix"
  CHECK_RESULT $? 0 0 "Net-snmp should still be installed after fix"
```

- 涉及命令：rpm×2, sed×1

#### oe_test_secscanner_234

- 描述：set_remove_snmp test (set to yes, net-snmp not installed, euler)
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Failed to set set_remove_snmp=yes"
  CHECK_RESULT $? 1 0 "Net-snmp should not be installed before fix"
  CHECK_RESULT $? 1 0 "Net-snmp should still not be installed after fix"
```

- 涉及命令：rpm×2, sed×1

#### oe_test_secscanner_235

- 描述：set_remove_snmp test (set to no, net-snmp not installed, euler)
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Failed to set set_remove_snmp=no"
  CHECK_RESULT $? 1 0 "Net-snmp should not be installed before fix"
  CHECK_RESULT $? 1 0 "Net-snmp should still not be installed after fix"
```

- 涉及命令：rpm×2, sed×1

#### oe_test_secscanner_236

- 描述：set_remove_python2 test (set to yes, python2 not installed, euler)
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Failed to set set_remove_python2=yes"
  CHECK_RESULT $? 1 0 "Python2 should not be installed before fix"
  CHECK_RESULT $? 1 0 "Python2 should still not be installed after fix"
```

- 涉及命令：rpm×2, sed×1

#### oe_test_secscanner_237

- 描述：set_remove_python2 test (set to no, python2 not installed, euler)
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Failed to set set_remove_python2=no"
  CHECK_RESULT $? 1 0 "Python2 should not be installed before fix"
  CHECK_RESULT $? 1 0 "Python2 should still not be installed after fix"
```

- 涉及命令：rpm×2, sed×1

#### oe_test_secscanner_238

- 描述：set_remove_python2 test (set to yes, python2 already installed, euler)
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Failed to set set_remove_python2=yes"
  CHECK_RESULT $? 0 0 "Python2 should be installed before fix"
  CHECK_RESULT $? 1 0 "Python2 should be removed after fix"
```

- 涉及命令：rpm×2, sed×1

#### oe_test_secscanner_239

- 描述：set_remove_python2 test (set to no, python2 already installed, euler)
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "Failed to set set_remove_python2=no"
  CHECK_RESULT $? 0 0 "Python2 should be installed before fix"
  CHECK_RESULT $? 0 0 "Python2 should still be installed after fix"
  CHECK_RESULT $? 1 0 "Python2 should remain not installed after fix"
```

- 涉及命令：rpm×2, sed×1

#### oe_test_secscanner_240

- 描述：set_remove_LdapServer test (set to yes, openldap-servers already installed, euler)
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Failed to set set_remove_LdapServer=yes"
  CHECK_RESULT $? 0 0 "openldap-servers should be installed before fix"
  CHECK_RESULT $? 1 0 "openldap-servers should be removed after fix"
```

- 涉及命令：rpm×2, sed×1

#### oe_test_secscanner_241

- 描述：set_remove_LdapServer test (set to no, openldap-servers already installed, euler)
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Failed to set set_remove_LdapServer=no"
  CHECK_RESULT $? 0 0 "openldap-servers should be installed before fix"
  CHECK_RESULT $? 0 0 "openldap-servers should still be installed after fix"
```

- 涉及命令：rpm×2, sed×1

#### oe_test_secscanner_242

- 描述：set_remove_LdapServer test (set to yes, openldap-servers not installed, euler)
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Failed to set set_remove_LdapServer=yes"
  CHECK_RESULT $? 1 0 "openldap-servers should not be installed before fix"
  CHECK_RESULT $? 1 0 "openldap-servers should still not be installed after fix"
```

- 涉及命令：rpm×2, sed×1

#### oe_test_secscanner_243

- 描述：set_remove_LdapServer test (set to no, openldap-servers not installed, euler)
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Failed to set set_remove_LdapServer=no"
  CHECK_RESULT $? 1 0 "openldap-servers should not be installed before fix"
  CHECK_RESULT $? 1 0 "openldap-servers should still not be installed after fix"
```

- 涉及命令：rpm×2, sed×1

#### oe_test_secscanner_244

- 描述：set_disable_debugShell test (set to yes, debug-shell enabled, euler)
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Failed to set set_disable_debugShell=yes"
  CHECK_RESULT $? 0 0 "debug-shell should be enabled before fix"
  CHECK_RESULT $? 1 0 "debug-shell should be disabled after fix"
```

- 涉及命令：sed×1

#### oe_test_secscanner_245

- 描述：set_disable_debugShell test (set to no, debug-shell enabled, euler)
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Failed to set set_disable_debugShell=no"
  CHECK_RESULT $? 0 0 "debug-shell should be enabled before fix"
  CHECK_RESULT $? 0 0 "debug-shell should still be enabled after fix"
```

- 涉及命令：sed×1

#### oe_test_secscanner_246

- 描述：set_disable_debugShell test (set to yes, debug-shell disabled, euler)
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Failed to set set_disable_debugShell=yes"
  CHECK_RESULT $? 1 0 "debug-shell should be disabled before fix"
  CHECK_RESULT $? 1 0 "debug-shell should still be disabled after fix"
```

- 涉及命令：sed×1

#### oe_test_secscanner_247

- 描述：set_disable_debugShell test (set to no, debug-shell disabled, euler)
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Failed to set set_disable_debugShell=no"
  CHECK_RESULT $? 1 0 "debug-shell should be disabled before fix"
  CHECK_RESULT $? 1 0 "debug-shell should still be disabled after fix"
```

- 涉及命令：sed×1

#### oe_test_secscanner_248

- 描述：set_disable_Rsync test (set to yes, rsyncd enabled, euler)
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Failed to set set_disable_Rsync=yes"
  CHECK_RESULT $? 0 0 "rsyncd should be enabled before fix"
  CHECK_RESULT $? 1 0 "rsyncd should be disabled after fix"
```

- 涉及命令：sed×1

#### oe_test_secscanner_249

- 描述：set_disable_Rsync test (set to no, rsyncd enabled, euler)
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Failed to set set_disable_Rsync=no"
  CHECK_RESULT $? 0 0 "rsyncd should be enabled before fix"
  CHECK_RESULT $? 0 0 "rsyncd should still be enabled after fix"
```

- 涉及命令：sed×1

#### oe_test_secscanner_250

- 描述：set_disable_Rsync test (set to yes, rsyncd disabled, euler)
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Failed to set set_disable_Rsync=yes"
  CHECK_RESULT $? 1 0 "rsyncd should be disabled before fix"
  CHECK_RESULT $? 1 0 "rsyncd should still be disabled after fix"
```

- 涉及命令：sed×1

#### oe_test_secscanner_251

- 描述：set_disable_Rsync test (set to no, rsyncd disabled, euler)
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Failed to set set_disable_Rsync=no"
  CHECK_RESULT $? 1 0 "rsyncd should be disabled before fix"
  CHECK_RESULT $? 1 0 "rsyncd should still be disabled after fix"
```

- 涉及命令：sed×1

#### oe_test_secscanner_252

- 描述：set_remove_Cups test (set to yes, cups installed, euler)
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Failed to set set_remove_Cups=yes"
  CHECK_RESULT $? 0 0 "cups should be installed before fix"
  CHECK_RESULT $? 1 0 "cups should be removed after fix"
```

- 涉及命令：rpm×2, sed×1

#### oe_test_secscanner_253

- 描述：set_remove_Cups test (set to no, cups installed, euler)
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Failed to set set_remove_Cups=no"
  CHECK_RESULT $? 0 0 "cups should be installed before fix"
  CHECK_RESULT $? 0 0 "cups should still be installed after fix"
```

- 涉及命令：rpm×2, sed×1

#### oe_test_secscanner_254

- 描述：set_remove_Cups test (set to yes, cups not installed, euler)
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Failed to set set_remove_Cups=yes"
  CHECK_RESULT $? 1 0 "cups should not be installed before fix"
  CHECK_RESULT $? 1 0 "cups should still not be installed after fix"
```

- 涉及命令：rpm×2, sed×1

#### oe_test_secscanner_255

- 描述：set_remove_Cups test (set to no, cups not installed, euler)
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Failed to set set_remove_Cups=no"
  CHECK_RESULT $? 1 0 "cups should not be installed before fix"
  CHECK_RESULT $? 1 0 "cups should still not be installed after fix"
```

- 涉及命令：rpm×2, sed×1

#### oe_test_secscanner_256

- 描述：set_remove_Ypserv test (set to yes, ypserv installed, euler)
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Failed to set set_remove_Ypserv=yes"
  CHECK_RESULT $? 0 0 "ypserv should be installed before fix"
  CHECK_RESULT $? 1 0 "ypserv should be removed after fix"
```

- 涉及命令：rpm×2, sed×1

#### oe_test_secscanner_257

- 描述：set_remove_Ypserv test (set to no, ypserv installed, euler)
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Failed to set set_remove_Ypserv=no"
  CHECK_RESULT $? 0 0 "ypserv should be installed before fix"
  CHECK_RESULT $? 0 0 "ypserv should still be installed after fix"
```

- 涉及命令：rpm×2, sed×1

#### oe_test_secscanner_258

- 描述：set_remove_Ypserv test (set to yes, ypserv not installed, euler)
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Failed to set set_remove_Ypserv=yes"
  CHECK_RESULT $? 1 0 "ypserv should not be installed before fix"
  CHECK_RESULT $? 1 0 "ypserv should be removed after fix"
```

- 涉及命令：rpm×2, sed×1

#### oe_test_secscanner_259

- 描述：set_remove_Ypserv test (set to no, ypserv not installed, euler)
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Failed to set set_remove_Ypserv=no"
  CHECK_RESULT $? 1 0 "ypserv should not be installed before fix"
  CHECK_RESULT $? 1 0 "ypserv should still not be installed after fix"
```

- 涉及命令：rpm×2, sed×1

#### oe_test_secscanner_260

- 描述：set_remove_ypbind test (set to yes, ypbind installed, euler)
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Failed to set set_remove_ypbind=yes"
  CHECK_RESULT $? 0 0 "ypbind should be installed before fix"
  CHECK_RESULT $? 1 0 "ypbind should be uninstalled after fix"
```

- 涉及命令：rpm×2, sed×1

#### oe_test_secscanner_261

- 描述：set_remove_ypbind test (set to no, ypbind installed, euler)
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Failed to set set_remove_ypbind=no"
  CHECK_RESULT $? 0 0 "ypbind should be installed before fix"
  CHECK_RESULT $? 0 0 "ypbind should still be installed after fix"
```

- 涉及命令：rpm×2, sed×1

#### oe_test_secscanner_262

- 描述：set_remove_ypbind test (set to yes, ypbind not installed, euler)
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Failed to set set_remove_ypbind=yes"
  CHECK_RESULT $? 1 0 "ypbind should not be installed before fix"
  CHECK_RESULT $? 1 0 "ypbind should still not be installed after fix"
```

- 涉及命令：rpm×2, sed×1

#### oe_test_secscanner_263

- 描述：set_remove_ypbind test (set to no, ypbind not installed, euler)
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Failed to set set_remove_ypbind=no"
  CHECK_RESULT $? 1 0 "ypbind should not be installed before fix"
  CHECK_RESULT $? 1 0 "ypbind should still not be installed after fix"
```

- 涉及命令：rpm×2, sed×1

#### oe_test_secscanner_264

- 描述：set_remove_LdapClient test (set to yes, openldap-clients installed, euler)
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Failed to set set_remove_LdapClient=yes"
  CHECK_RESULT $? 0 0 "openldap-clients should be installed before fix"
  CHECK_RESULT $? 1 0 "openldap-clients should be uninstalled after fix"
```

- 涉及命令：rpm×2, sed×1

#### oe_test_secscanner_265

- 描述：set_remove_LdapClient test (set to no, openldap-clients installed, euler)
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Failed to set set_remove_LdapClient=no"
  CHECK_RESULT $? 0 0 "openldap-clients should be installed before fix"
  CHECK_RESULT $? 0 0 "openldap-clients should still be installed after fix"
```

- 涉及命令：rpm×2, sed×1

#### oe_test_secscanner_266

- 描述：set_remove_LdapClient test (set to yes, openldap-clients not installed, euler)
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Failed to set set_remove_LdapClient=yes"
  CHECK_RESULT $? 1 0 "openldap-clients should not be installed before fix"
  CHECK_RESULT $? 1 0 "openldap-clients should still not be installed after fix"
```

- 涉及命令：rpm×2, sed×1

#### oe_test_secscanner_267

- 描述：set_remove_LdapClient test (set to no, openldap-clients not installed, euler)
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Failed to set set_remove_LdapClient=no"
  CHECK_RESULT $? 1 0 "openldap-clients should not be installed before fix"
  CHECK_RESULT $? 1 0 "openldap-clients should still not be installed after fix"
```

- 涉及命令：rpm×2, sed×1

#### oe_test_secscanner_268

- 描述：set_remove_Xwindows test (set to yes, xorg-x11 installed, euler)
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Failed to set set_remove_Xwindows=yes"
  CHECK_RESULT $? 0 0 "xorg-x11 should be installed before fix"
  CHECK_RESULT $? 1 0 "xorg-x11 should be uninstalled after fix"
```

- 涉及命令：rpm×2, sed×1

#### oe_test_secscanner_269

- 描述：set_remove_Xwindows test (set to no, xorg-x11 installed, euler)
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Failed to set set_remove_Xwindows=no"
  CHECK_RESULT $? 0 0 "xorg-x11 should be installed before fix"
  CHECK_RESULT $? 0 0 "xorg-x11 should still be installed after fix"
```

- 涉及命令：rpm×2, sed×1

#### oe_test_secscanner_270

- 描述：set_remove_Xwindows test (set to yes, xorg-x11 not installed, euler)
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Failed to set set_remove_Xwindows=yes"
  CHECK_RESULT $? 1 0 "xorg-x11 should not be installed before fix"
  CHECK_RESULT $? 1 0 "xorg-x11 should not be installed after fix"
```

- 涉及命令：rpm×2, sed×1

#### oe_test_secscanner_271

- 描述：
#### oe_test_secscanner_272

- 描述：
#### oe_test_secscanner_273

- 描述：
#### oe_test_secscanner_274

- 描述：
#### oe_test_secscanner_275

- 描述：
#### oe_test_secscanner_276

- 描述：
#### oe_test_secscanner_277

- 描述：
#### oe_test_secscanner_278

- 描述：
#### oe_test_secscanner_279

- 描述：
#### oe_test_secscanner_280

- 描述：
#### oe_test_secscanner_281

- 描述：
#### oe_test_secscanner_282

- 描述：
#### oe_test_secscanner_283

- 描述：
#### oe_test_secscanner_284

- 描述：
#### oe_test_secscanner_285

- 描述：
#### oe_test_secscanner_286

- 描述：
#### oe_test_secscanner_287

- 描述：
#### oe_test_secscanner_288

- 描述：
#### oe_test_secscanner_289

- 描述：
#### oe_test_secscanner_290

- 描述：
#### oe_test_secscanner_291

- 描述：
#### oe_test_secscanner_292

- 描述：
#### oe_test_secscanner_293

- 描述：
#### oe_test_secscanner_294

- 描述：
#### oe_test_secscanner_295

- 描述：
#### oe_test_secscanner_296

- 描述：
#### oe_test_secscanner_297

- 描述：
#### oe_test_secscanner_298

- 描述：
#### oe_test_secscanner_299

- 描述：
#### oe_test_secscanner_300

- 描述：