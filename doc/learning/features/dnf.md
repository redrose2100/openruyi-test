# dnf

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/dnf` |
| 注册用例数 | 23 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_dnf_alias | Test "dnf alias" command | pre_test/run_test/post_test | 6 | ✔ |  |  |
| oe_test_dnf_all-repos | test all oe repos | pre_test/run_test/post_test | 6 |  |  |  |
| oe_test_dnf_assumeno_autoremove | Test "--assumeno" & "-b --best" & "-C,--cacheonly" option, Test "dnf autoremove" command | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_dnf_automatic | Test dnf-automatic services | pre_test/run_test/post_test | 18 | ✔ |  |  |
| oe_test_dnf_check_diffenert-packages | Test "dnf check-update" & "dnf check" command, Install the different package by two dnf at the same time | pre_test/run_test/post_test | 9 |  |  |  |
| oe_test_dnf_makecache_clean | Test "dnf makecache" & "dnf clean" command | pre_test/run_test/post_test | 15 |  |  |  |
| oe_test_dnf_distro-sync_dnf-3 | Test "dnf distro-sync" command, check ll /usr/bin/dnf & /usr/bin/yum, Test "--downloaddir=<path>, --destdir=<path" & "--downloadonly" option | pre_test/run_test/post_test | 7 | ✔ |  |  |
| oe_test_dnf_enabled_enablerepo | Test enabled=0 & enabled=1, Test "--enablerepo=<repoid>" option | pre_test/run_test/post_test | 7 |  |  |  |
| oe_test_service_dnf-automatic-download | Test dnf-automatic-download.service restart | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_service_dnf-automatic-install | Test dnf-automatic-install.service restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_service_dnf-automatic-notifyonly | Test dnf-automatic-notifyonly.service restart | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_service_dnf-automatic | Test dnf-automatic.service restart | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_service_dnf-makecache | Test dnf-makecache.service restart | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_dnf_enhancement_exclude | Test "--enhancement" & "-x <package-file-spec>, --exclude=<package-file-spec>" & "--forcearch=<arch>" option, Test gpgcheck | pre_test/run_test/post_test | 7 |  |  |  |
| oe_test_dnf_help_history_info | Test "-h, --help, --help-cmd" option, Test "dnf help" & "dnf history" & "dnf info" command | pre_test/run_test/post_test | 6 | ✔ |  |  |
| oe_test_dnf_list_mark | Test "dnf list" & "dnf mark" command | pre_test/run_test/post_test | 14 |  |  |  |
| oe_test_dnf_nobest_nodocs_nogpgcheck | Test "--nobest" & "--nodocs" & "--nogpgcheck" option | pre_test/run_test/post_test | 6 | ✔ |  |  |
| oe_test_dnf_priority | Test priority option in configuration file | pre_test/run_test/post_test | 2 |  |  |  |
| oe_test_dnf_provides_randomwait | Random installing a package, Test "dnf provides" command, Test "-q, --quiet" & "-R <minutes>,--randomwait=<minutes>" & "--refresh" option | pre_test/run_test/post_test | 7 | ✔ |  |  |
| oe_test_dnf_reinstall_repoinfo | Test "dnf reinstall" & "dnf repoinfo" & "dnf repolist" & "dnf repoquery" & "dnf search" & "dnf upgrade-minimal" command, Test "--repo=<repoid>, --repoid=<repoid>" & "--version" option, Install the same package by two dnf at the same time | pre_test/run_test/post_test | 15 | ✔ |  |  |
| oe_test_dnf_repeat-install | Install a package which has installed | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_dnf_repeat-upgrade-downgrade | repeat upgrade and downgrade packages | pre_test/run_test/post_test | 2 |  |  |  |
| oe_test_dnf_deplist | Test "dnf deplist" command | pre_test/run_test/post_test | 1 |  |  |  |

### 断言与命令明细

#### oe_test_dnf_alias

- 描述：Test "dnf alias" command
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $? 1 0
```

- 涉及命令：dnf×1, rpm×1

#### oe_test_dnf_all-repos

- 描述：test all oe repos
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

- 涉及命令：dnf×4

#### oe_test_dnf_assumeno_autoremove

- 描述：Test "--assumeno" & "-b --best" & "-C,--cacheonly" option, Test "dnf autoremove" command
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $? 1 0
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：dnf×4, rpm×3

#### oe_test_dnf_automatic

- 描述：Test dnf-automatic services
- 函数：`pre_test, run_test, post_test`
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

#### oe_test_dnf_check_diffenert-packages

- 描述：Test "dnf check-update" & "dnf check" command, Install the different package by two dnf at the same time
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $ret 0 0
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：dnf×2, rpm×2

#### oe_test_dnf_makecache_clean

- 描述：Test "dnf makecache" & "dnf clean" command
- 函数：`pre_test, run_test, post_test`
- 断言（15 条）：

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
  CHECK_RESULT $? 1 0
  CHECK_RESULT $?
  ... 共 15 条（其余见源脚本）
```

#### oe_test_dnf_distro-sync_dnf-3

- 描述：Test "dnf distro-sync" command, check ll /usr/bin/dnf & /usr/bin/yum, Test "--downloaddir=<path>, --destdir=<path" & "--downloadonly" option
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

#### oe_test_dnf_enabled_enablerepo

- 描述：Test enabled=0 & enabled=1, Test "--enablerepo=<repoid>" option
- 函数：`pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $? 1 0 "disable repo failed"
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：grep×2

#### oe_test_service_dnf-automatic-download

- 描述：Test dnf-automatic-download.service restart
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 1 "There is an error for the status of ${service}"
  CHECK_RESULT $? 0 1 "There is an error message for the log of ${service}"
```

#### oe_test_service_dnf-automatic-install

- 描述：Test dnf-automatic-install.service restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_service_dnf-automatic-notifyonly

- 描述：Test dnf-automatic-notifyonly.service restart
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 1 "There is an error for the status of ${service}"
  CHECK_RESULT $? 0 1 "There is an error message for the log of ${service}"
```

#### oe_test_service_dnf-automatic

- 描述：Test dnf-automatic.service restart
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 1 "There is an error for the status of ${service}"
  CHECK_RESULT $? 0 1 "There is an error message for the log of ${service}"
```

#### oe_test_service_dnf-makecache

- 描述：Test dnf-makecache.service restart
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 1 "There is an error for the status of ${service}"
  CHECK_RESULT $? 0 1 "There is an error message for the log of ${service}"
```

#### oe_test_dnf_enhancement_exclude

- 描述：Test "--enhancement" & "-x <package-file-spec>, --exclude=<package-file-spec>" & "--forcearch=<arch>" option, Test gpgcheck
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

- 涉及命令：sed×2, dnf×1, rpm×1

#### oe_test_dnf_help_history_info

- 描述：Test "-h, --help, --help-cmd" option, Test "dnf help" & "dnf history" & "dnf info" command
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

- 涉及命令：dnf×2

#### oe_test_dnf_list_mark

- 描述：Test "dnf list" & "dnf mark" command
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

- 涉及命令：dnf×2

#### oe_test_dnf_nobest_nodocs_nogpgcheck

- 描述：Test "--nobest" & "--nodocs" & "--nogpgcheck" option
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $? 1 0
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：rpm×2, dnf×2, test×1

#### oe_test_dnf_priority

- 描述：Test priority option in configuration file
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：sed×3, dnf×1

#### oe_test_dnf_provides_randomwait

- 描述：Random installing a package, Test "dnf provides" command, Test "-q, --quiet" & "-R <minutes>,--randomwait=<minutes>" & "--refresh" option
- 函数：`pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $? 1 0
  CHECK_RESULT $? 1 0
  CHECK_RESULT $?
  CHECK_RESULT "${ret}" 1 0
  CHECK_RESULT $?
```

- 涉及命令：rpm×1, dnf×1

#### oe_test_dnf_reinstall_repoinfo

- 描述：Test "dnf reinstall" & "dnf repoinfo" & "dnf repolist" & "dnf repoquery" & "dnf search" & "dnf upgrade-minimal" command, Test "--repo=<repoid>, --repoid=<repoid>" & "--version" option, Install the same package by two dnf at the same time
- 函数：`pre_test, run_test, post_test`
- 断言（15 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT "$ret" 2 0
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  ... 共 15 条（其余见源脚本）
```

- 涉及命令：dnf×2, rpm×2

#### oe_test_dnf_repeat-install

- 描述：Install a package which has installed
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：dnf×3

#### oe_test_dnf_repeat-upgrade-downgrade

- 描述：repeat upgrade and downgrade packages
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：dnf×3

#### oe_test_dnf_deplist

- 描述：Test "dnf deplist" command
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "dnf deplist $pkg_name failed."
```
