# 389-ds-base

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/389-ds-base` |
| 注册用例数 | 62 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_dsconf | Test "dsconf" command | pre_test/run_test/post_test | 9 | ✔ |  |  |
| oe_test_dsconf_backend_01 | Test "dsconf" command | pre_test/run_test/post_test | 22 | ✔ |  |  |
| oe_test_dsconf_backend_02 | Test "dsconf" command | pre_test/run_test/post_test | 20 | ✔ |  |  |
| oe_test_dsconf_backend_03 | Test "dsconf" command | pre_test/run_test/post_test | 24 | ✔ |  |  |
| oe_test_dsconf_backend_04 | Test "dsconf" command | pre_test/run_test/post_test | 24 | ✔ |  |  |
| oe_test_dsconf_backend_05 | Test "dsconf" command | pre_test/run_test/post_test | 17 | ✔ |  |  |
| oe_test_dsconf_backup | Test "dsconf" command | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_dsconf_chaining_01 | Test "dsconf" command | pre_test/run_test/post_test | 28 | ✔ |  |  |
| oe_test_dsconf_chaining_02 | Test "dsconf" command | pre_test/run_test/post_test | 13 | ✔ |  |  |
| oe_test_dsconf_config | Test "dsconf" command | pre_test/run_test/post_test | 7 | ✔ |  |  |
| oe_test_dsconf_monitor | Test "dsconf" command | pre_test/run_test/post_test | 15 | ✔ |  |  |
| oe_test_dsconf_plugin_01 | Test "dsconf" command | pre_test/run_test/post_test | 22 | ✔ |  |  |
| oe_test_dsconf_plugin_02 | Test "dsconf" command | pre_test/run_test/post_test | 111 | ✔ |  | 50m |
| oe_test_dsconf_plugin_03 | Test "dsconf" command | pre_test/run_test/post_test | 62 | ✔ |  |  |
| oe_test_dsconf_plugin_04 | Test "dsconf" command | pre_test/run_test/post_test | 12 | ✔ |  |  |
| oe_test_dsconf_plugin_05 | Test "dsconf" command | pre_test/run_test/post_test | 11 | ✔ |  |  |
| oe_test_dsconf_plugin_06 | Test "dsconf" command | pre_test/run_test/post_test | 13 | ✔ |  |  |
| oe_test_dsconf_plugin_07 | Test "dsconf" command | pre_test/run_test/post_test | 6 | ✔ |  |  |
| oe_test_dsconf_pwpolicy | Test "dsconf" command | pre_test/run_test/post_test | 16 | ✔ |  |  |
| oe_test_dsconf_repl-agmt | Test "dsconf" command | pre_test/run_test/post_test | 21 | ✔ |  |  |
| oe_test_dsconf_repl-conflict_01 | Test "dsconf" command | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_dsconf_repl-conflict_02 | Test "dsconf" command | pre_test/run_test/post_test | 6 | ✔ |  |  |
| oe_test_dsconf_repl-tasks | Test "dsconf" command | pre_test/run_test/post_test | 9 | ✔ |  |  |
| oe_test_dsconf_repl-winsync-agmt | Test "dsconf" command | pre_test/run_test/post_test | 23 | ✔ |  |  |
| oe_test_dsconf_replication | Test "dsconf" command | pre_test/run_test/post_test | 30 | ✔ |  |  |
| oe_test_dsconf_sasl | Test "dsconf" command | pre_test/run_test/post_test | 12 | ✔ |  |  |
| oe_test_dsconf_schema_01 | Test "dsconf" command | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_dsconf_schema_02 | Test "dsconf" command | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_dsconf_schema_03 | Test "dsconf" command | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_dsconf_schema_04 | Test "dsconf" command | pre_test/run_test/post_test | 6 | ✔ |  |  |
| oe_test_dsconf_security_01 | Test "dsconf security" command | pre_test/run_test/post_test | 16 | ✔ |  |  |
| oe_test_dsconf_security_02 | Test "dsconf security" command | pre_test/run_test/post_test | 9 | ✔ |  |  |
| oe_test_dsconf_security_03 | Test "dsconf security" command | pre_test/run_test/post_test | 9 | ✔ |  |  |
| oe_test_dsconf_security_04 | Test "dsconf security" command | pre_test/run_test/post_test | 9 | ✔ |  |  |
| oe_test_dsconf_security_05 | Test "dsconf security" command | pre_test/run_test/post_test | 11 | ✔ |  |  |
| oe_test_dsconf_security_06 | Test "dsconf security" command | pre_test/run_test/post_test | 14 | ✔ |  |  |
| oe_test_dscreate | Test "dscreate" command | pre_test/run_test/post_test | 6 | ✔ |  |  |
| oe_test_dsctl_01 | Test "dsctl" command | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_dsctl_02 | Test "dsctl" command | pre_test/run_test/post_test | 11 | ✔ |  |  |
| oe_test_dsctl_03 | Test "dsctl" command | pre_test/run_test/post_test | 9 | ✔ |  |  |
| oe_test_dsctl_04 | Test "dsctl" command | pre_test/run_test/post_test | 8 | ✔ |  |  |
| oe_test_dsctl_cockpit | Test "dsctl" command | pre_test/run_test/post_test | 5 | ✔ |  |  |
| oe_test_dsctl_dsrc | Test "dsctl" command | pre_test/run_test/post_test | 9 | ✔ |  |  |
| oe_test_dsctl_ldifgen | Test "dsctl" command | pre_test/run_test/post_test | 15 | ✔ |  |  |
| oe_test_dsctl_tls | Test "dsctl" command | pre_test/run_test/post_test | 7 | ✔ |  |  |
| oe_test_dsidm | Test "dsidm" command | pre_test/run_test/post_test | 9 | ✔ |  |  |
| oe_test_dsidm_account | Test "dsidm" command | pre_test/run_test/post_test | 23 | ✔ |  |  |
| oe_test_dsidm_client_config | Test "dsidm" command | pre_test/run_test/post_test | 7 | ✔ |  |  |
| oe_test_dsidm_group | Test "dsctk" command | pre_test/run_test/post_test | 21 | ✔ |  |  |
| oe_test_dsidm_organizationalunit | Test "dsidm" command | pre_test/run_test/post_test | 15 | ✔ |  |  |
| oe_test_dsidm_posixgroup | Test "dsidm" command | pre_test/run_test/post_test | 15 | ✔ |  |  |
| oe_test_dsidm_role | Test "dsidm" command | pre_test/run_test/post_test | 17 | ✔ |  |  |
| oe_test_dsidm_user | Test "dsctk" command | pre_test/run_test/post_test | 14 | ✔ |  |  |
| oe_test_service_dirsrv-snmp | Test dirsrv-snmp.service restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_target_dirsrv | Test dirsrv.target restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_dbscan | Test "dbscan" command | pre_test/run_test/post_test | 8 | ✔ |  |  |
| oe_test_ds-logpipe | Test "dbscan" command | pre_test/run_test/post_test | 6 | ✔ |  |  |
| oe_test_ldclt | Test "ldclt" command | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_logconv | Test "logconv" command | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_ns-slapd | Test "ns-slapd" command | pre_test/run_test/post_test | 5 | ✔ |  |  |
| oe_test_pwdhash | Test "pwdhash" command | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_ds-replcheck | Test "oe_ds-replcheck" command | pre_test/run_test/post_test | 1 | ✔ |  |  |

### 断言与命令明细

#### oe_test_dsconf

- 描述：Test "dsconf" command
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 "Check: -h No Pass"
  CHECK_RESULT $? 0 0 "Check: -v No Pass"
  CHECK_RESULT $? 0 0 "Check: -D No Pass"
  CHECK_RESULT $? 0 0 "Check: -w No Pass"
  CHECK_RESULT $? 0 0 "Check: -W No Pass"
  CHECK_RESULT $? 0 0 "Check: -y No Pass"
  CHECK_RESULT $? 0 0 "Check: -b No Pass"
  CHECK_RESULT $? 0 0 "Check: -Z No Pass"
  CHECK_RESULT $? 0 0 "Check: -j No Pass"
```

- 涉及命令：dsconf×8

#### oe_test_dsconf_backend_01

- 描述：Test "dsconf" command
- 函数：`pre_test, run_test, post_test`
- 断言（22 条）：

```
  CHECK_RESULT $? 0 0 "Check: backend suffix list No Pass"
  CHECK_RESULT $? 0 0 "Check: backend suffix list No Pass"
  CHECK_RESULT $? 0 0 "Check: backend suffix list -suffix No Pass"
  CHECK_RESULT $? 0 0 "Check: backend suffix list -skip-subsuffixes No Pass"
  CHECK_RESULT $? 0 0 "Check: backend suffix get -h No Pass"
  CHECK_RESULT $? 0 0 "Check: backend suffix get selector No Pass"
  CHECK_RESULT $? 0 0 "Check: backend suffix get-dn -h No Pass"
  CHECK_RESULT $? 0 0 "Check: backend suffix get-dn dn No Pass"
  CHECK_RESULT $? 0 0 "Check: backend suffix get-sub-suffixes -h No Pass"
  CHECK_RESULT $? 0 0 "Check: backend suffix get-sub-suffixes --suffix No Pass"
  CHECK_RESULT $? 0 0 "Check: backend suffix set No Pass"
  CHECK_RESULT $? 0 0 "Check: backend suffix set  --enable-readonly No Pass"
  ... 共 22 条（其余见源脚本）
```

#### oe_test_dsconf_backend_02

- 描述：Test "dsconf" command
- 函数：`pre_test, run_test, post_test`
- 断言（20 条）：

```
  CHECK_RESULT $? 0 0 "Check: backend index -h No Pass"
  CHECK_RESULT $? 0 0 "Check: backend index add -h No Pass"
  CHECK_RESULT $? 0 0 "Check: backend index add --index-type  No Pass"
  CHECK_RESULT $? 0 0 "Check: backend index add --matching-rule No Pass"
  CHECK_RESULT $? 0 0 "Check: backend index --reindex No Pass"
  CHECK_RESULT $? 0 0 "Check: backend index set -h No Pass"
  CHECK_RESULT $? 0 0 "Check: backend index set --add-type No Pass"
  CHECK_RESULT $? 0 0 "Check: backend index set --del-type No Pass"
  CHECK_RESULT $? 0 0 "Check: backend index set --add-mrx No Pass"
  CHECK_RESULT $? 0 0 "Check: backend index set --add-mr No Pass"
  CHECK_RESULT $? 0 0 "Check: backend index aset --reindex No Pass"
  CHECK_RESULT $? 0 0 "Check: backend index get -h No Pass"
  ... 共 20 条（其余见源脚本）
```

#### oe_test_dsconf_backend_03

- 描述：Test "dsconf" command
- 函数：`pre_test, run_test, post_test`
- 断言（24 条）：

```
  CHECK_RESULT $? 0 0 "Check: backend vlv-index -h No Pass"
  CHECK_RESULT $? 0 0 "Check: backend vlv-index list -h No Pass"
  CHECK_RESULT $? 0 0 "Check: backend vlv-index list --just-names  No Pass"
  CHECK_RESULT $? 0 0 "Check: backend vlv-index get -h No Pass"
  CHECK_RESULT $? 0 0 "Check: backend vlv-index get --name  No Pass"
  CHECK_RESULT $? 0 0 "Check: backend vlv-index add-search -h  No Pass"
  CHECK_RESULT $? 0 0 "Check: backend vlv-index --just-names  No Pass"
  CHECK_RESULT $? 0 0 "Check: backend vlv-index edit-search -h  No Pass"
  CHECK_RESULT $? 0 0 "Check: backend vlv-index edit-search --search-base  No Pass"
  CHECK_RESULT $? 0 0 "Check: backend vlv-index edit-search --search-scope  No Pass"
  CHECK_RESULT $? 0 0 "Check: backend vlv-index edit-search --search-scope  No Pass"
  CHECK_RESULT $? 0 0 "Check: backend vlv-index add-index -h  No Pass"
  ... 共 24 条（其余见源脚本）
```

#### oe_test_dsconf_backend_04

- 描述：Test "dsconf" command
- 函数：`pre_test, run_test, post_test`
- 断言（24 条）：

```
  CHECK_RESULT $? 0 0 "Check: backend config -h No Pass"
  CHECK_RESULT $? 0 0 "Check: backend config get -h No Pass"
  CHECK_RESULT $? 0 0 "Check: backend config set -h No Pass"
  CHECK_RESULT $? 0 0 "Check: backend config set --lookthroughlimit No Pass"
  CHECK_RESULT $? 0 0 "Check: backend config set --mode No Pass"
  CHECK_RESULT $? 0 0 "Check: backend config set --idlistscanlimit  No Pass"
  CHECK_RESULT $? 0 0 "Check: backend config set --directory  No Pass"
  CHECK_RESULT $? 0 0 "Check: backend config set --txn-wait No Pass"
  CHECK_RESULT $? 0 0 "Check: backend config set --checkpoint-interval No Pass"
  CHECK_RESULT $? 0 0 "Check: backend config set --compactdb-interval No Pass"
  CHECK_RESULT $? 0 0 "Check: backend config set --txn-batch-val No Pass"
  CHECK_RESULT $? 0 0 "Check: backend config set --txn-batch-min No Pass"
  ... 共 24 条（其余见源脚本）
```

#### oe_test_dsconf_backend_05

- 描述：Test "dsconf" command
- 函数：`pre_test, run_test, post_test`
- 断言（17 条）：

```
  CHECK_RESULT $? 0 0 "Check: backend import -h No Pass"
  CHECK_RESULT $? 0 0 "Check: backend import -h No Pass"
  CHECK_RESULT $? 0 0 "Check: backend import -E No Pass"
  CHECK_RESULT $? 0 0 "Check: backend import -O No Pass"
  CHECK_RESULT $? 0 0 "Check: backend export -h No Pass"
  CHECK_RESULT $? 0 0 "Check: backend export -l No Pass"
  CHECK_RESULT $? 0 0 "Check: backend export -C No Pass"
  CHECK_RESULT $? 0 0 "Check: backend export -E No Pass"
  CHECK_RESULT $? 0 0 "Check: backend export -m No Pass"
  CHECK_RESULT $? 0 0 "Check: backend export -N No Pass"
  CHECK_RESULT $? 0 0 "Check: backend export -r No Pass"
  CHECK_RESULT $? 0 0 "Check: backend export -u No Pass"
  ... 共 17 条（其余见源脚本）
```

#### oe_test_dsconf_backup

- 描述：Test "dsconf" command
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Check: backup -h No Pass"
  CHECK_RESULT $? 0 0 "Check: backup create -h No Pass"
  CHECK_RESULT $? 0 0 "Check: backup restore -h No Pass"
```

#### oe_test_dsconf_chaining_01

- 描述：Test "dsconf" command
- 函数：`pre_test, run_test, post_test`
- 断言（28 条）：

```
  CHECK_RESULT $? 0 0 "Check: chaining -h No Pass"
  CHECK_RESULT $? 0 0 "Check: chaining config-get -h No Pass"
  CHECK_RESULT $? 0 0 "Check: chaining config-get --avail-controls No Pass"
  CHECK_RESULT $? 0 0 "Check: chaining config-get --avail-comps No Pass"
  CHECK_RESULT $? 0 0 "Check: chaining config-set -h No Pass"
  CHECK_RESULT $? 0 0 "Check: chaining config-set -add-control No Pass"
  CHECK_RESULT $? 0 0 "Check: chaining config-set --del-control No Pass"
  CHECK_RESULT $? 0 0 "Check: chaining config-set ---add-comp chain_component1 No Pass"
  CHECK_RESULT $? 0 0 "Check: chaining config-set ---del-comp chain_component1 No Pass"
  CHECK_RESULT $? 0 0 "Check: chaining config-get-def -h No Pass"
  CHECK_RESULT $? 0 0 "Check: chaining config-set-def -h No Pass"
  CHECK_RESULT $? 0 0 "Check: chaining config-set-def --conn-bind-limit No Pass"
  ... 共 28 条（其余见源脚本）
```

#### oe_test_dsconf_chaining_02

- 描述：Test "dsconf" command
- 函数：`pre_test, run_test, post_test`
- 断言（13 条）：

```
  CHECK_RESULT $? 0 0 "Check: chaining link-create -h No Pass"
  CHECK_RESULT $? 0 0 "Check: chaining link-create all No Pass"
  CHECK_RESULT $? 0 0 "Check: chaining link-get -h No Pass"
  CHECK_RESULT $? 0 0 "Check: chaining link-set -h No Pass"
  CHECK_RESULT $? 0 0 "Check: chaining link-set --conn-bind-limit No Pass"
  CHECK_RESULT $? 0 0 "Check: chaining link-get -h No Pass"
  CHECK_RESULT $? 0 0 "Check: chaining link-get  No Pass"
  CHECK_RESULT $? 0 0 "Check: chaining link-list -h No Pass"
  CHECK_RESULT $? 0 0 "Check: chaining link-list  No Pass"
  CHECK_RESULT $? 0 0 "Check: chaining monitor -h No Pass"
  CHECK_RESULT $? 0 0 "Check: chaining monitor  No Pass"
  CHECK_RESULT $? 0 0 "Check: chaining link-delete -h No Pass"
  ... 共 13 条（其余见源脚本）
```

#### oe_test_dsconf_config

- 描述：Test "dsconf" command
- 函数：`pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $? 0 0 "Check: config -h No Pass"
  CHECK_RESULT $? 0 0 "Check: config get -h No Pass"
  CHECK_RESULT $? 0 0 "Check: config get  No Pass"
  CHECK_RESULT $? 0 0 "Check: config add -h No Pass"
  CHECK_RESULT $? 0 0 "Check: config replace -h No Pass"
  CHECK_RESULT $? 0 0 "Check: config delete -h No Pass"
  CHECK_RESULT $? 0 0 "Check: config get  No Pass"
```

- 涉及命令：dsconf×1

#### oe_test_dsconf_monitor

- 描述：Test "dsconf" command
- 函数：`pre_test, run_test, post_test`
- 断言（15 条）：

```
  CHECK_RESULT $? 0 0 "Check: backend directory_manager -h No Pass"
  CHECK_RESULT $? 0 0 "Check: backend directory_manager password_change -h No Pass"
  CHECK_RESULT $? 0 0 "Check: backend directory_manager password_change  No Pass"
  CHECK_RESULT $? 0 0 "Check: backend monitor -h No Pass"
  CHECK_RESULT $? 0 0 "Check: backend monitor server-h No Pass"
  CHECK_RESULT $? 0 0 "Check: backend monitor dbmon -h No Pass"
  CHECK_RESULT $? 0 0 "Check: backend monitor dbmon -b No Pass"
  CHECK_RESULT $? 0 0 "Check: backend monitor dbmon -x No Pass"
  CHECK_RESULT $? 0 0 "Check: backend monitor ldbm -h No Pass"
  CHECK_RESULT $? 0 0 "Check: backend monitor backend -h No Pass"
  CHECK_RESULT $? 0 0 "Check: backend monitor backend [backend] No Pass"
  CHECK_RESULT $? 0 0 "Check: backend monitor snmp -h No Pass"
  ... 共 15 条（其余见源脚本）
```

#### oe_test_dsconf_plugin_01

- 描述：Test "dsconf" command
- 函数：`pre_test, run_test, post_test`
- 断言（22 条）：

```
  CHECK_RESULT $? 0 0 "Check: plugin -h No Pass"
  CHECK_RESULT $? 0 0 "Check: plugin memberof -h No Pass"
  CHECK_RESULT $? 0 0 "Check: plugin memberof show -h No Pass"
  CHECK_RESULT $? 0 0 "Check: plugin memberof show No Pass"
  CHECK_RESULT $? 0 0 "Check: plugin memberof disable -h No Pass"
  CHECK_RESULT $? 0 0 "Check: plugin memberof disable dn No Pass"
  CHECK_RESULT $? 0 0 "Check: plugin memberof enable -h No Pass"
  CHECK_RESULT $? 0 0 "Check: plugin memberof enable dn No Pass"
  CHECK_RESULT $? 0 0 "Check: plugin memberof enable -h No Pass"
  CHECK_RESULT $? 0 0 "Check: plugin memberof status dn No Pass"
  CHECK_RESULT $? 0 0 "Check: plugin memberof set -h No Pass"
  CHECK_RESULT $? 0 0 "Check: plugin memberof set --attr No Pass"
  ... 共 22 条（其余见源脚本）
```

#### oe_test_dsconf_plugin_02

- 描述：Test "dsconf" command
- 函数：`pre_test, run_test, post_test`
- 断言（111 条）：

```
  CHECK_RESULT $? 0 0 "Check: plugin automember show -h No Pass"
  CHECK_RESULT $? 0 0 "Check: plugin automember enable -h No Pass"
  CHECK_RESULT $? 0 0 "Check: plugin automember disable -h No Pass"
  CHECK_RESULT $? 0 0 "Check: plugin automember status -h No Pass"
  CHECK_RESULT $? 0 0 "Check: plugin automember list -h No Pass"
  CHECK_RESULT $? 0 0 "Check: plugin automember list definitions -h No Pass"
  CHECK_RESULT $? 0 0 "Check: plugin automember list regexes -h No Pass"
  CHECK_RESULT $? 0 0 "Check: plugin automember definition -h No Pass"
  CHECK_RESULT $? 0 0 "Check: plugin automember definition DEFNAME add -h No Pass"
  CHECK_RESULT $? 0 0 "Check: plugin automember definition DEFNAME set -h No Pass"
  CHECK_RESULT $? 0 0 "Check: plugin automember definition DEFNAME delete -h No Pass"
  CHECK_RESULT $? 0 0 "Check: plugin automember definition DEFNAME show -h No Pass"
  ... 共 111 条（其余见源脚本）
```

#### oe_test_dsconf_plugin_03

- 描述：Test "dsconf" command
- 函数：`pre_test, run_test, post_test`
- 断言（62 条）：

```
  CHECK_RESULT $? 0 0 "Check: plugin referential-integrity set all No Pass"
  CHECK_RESULT $? 0 0 "Check: plugin root-dn show No Pass"
  CHECK_RESULT $? 0 0 "Check: plugin root-dn enable No Pass"
  CHECK_RESULT $? 0 0 "Check: plugin root-dn disable No Pass"
  CHECK_RESULT $? 0 0 "Check: plugin root-dn status No Pass"
  CHECK_RESULT $? 0 0 "Check: plugin root-dn set all No Pass"
  CHECK_RESULT $? 0 0 "Check: plugin usn show No Pass"
  CHECK_RESULT $? 0 0 "Check: plugin usn enable No Pass"
  CHECK_RESULT $? 0 0 "Check: plugin usn disable No Pass"
  CHECK_RESULT $? 0 0 "Check: plugin usn status No Pass"
  CHECK_RESULT $? 0 0 "Check: plugin usn global on No Pass"
  CHECK_RESULT $? 0 0 "Check: plugin usn global off No Pass"
  ... 共 62 条（其余见源脚本）
```

#### oe_test_dsconf_plugin_04

- 描述：Test "dsconf" command
- 函数：`pre_test, run_test, post_test`
- 断言（12 条）：

```
  CHECK_RESULT $? 0 0 "L$LINENO: plugin pam-pass-through-auth -h No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: plugin  pam-pass-through-auth show -h No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: plugin pam-pass-through-auth show No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: plugin pam-pass-through-auth enable -h No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: plugin pam-pass-through-auth enable No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: plugin pam-pass-through-auth disable -h No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: plugin pam-pass-through-auth disable No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: plugin pam-pass-through-auth status -h No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: plugin  pam-pass-through-auth status No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: plugin pam-pass-through-auth list -h No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: plugin pam-pass-through-auth config -h No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: plugin pam-pass-through-auth config No Pass"
```

- 涉及命令：dsconf×1

#### oe_test_dsconf_plugin_05

- 描述：Test "dsconf" command
- 函数：`pre_test, run_test, post_test`
- 断言（11 条）：

```
  CHECK_RESULT $? 0 0 "L$LINENO: plugin retro-changelog -h No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: plugin retro-changelog show -h No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: plugin retro-changelog show No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: plugin retro-changelog enable -h No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: plugin retro-changelog enable No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: plugin retro-changelog disable -h No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: plugin retro-changelog disable No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: plugin retro-changelog status -h No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: plugin retro-changelog status No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: plugin retro-changelog set -h No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: plugin retro-changelog set No Pass"
```

- 涉及命令：dsconf×1, dsidm×1

#### oe_test_dsconf_plugin_06

- 描述：Test "dsconf" command
- 函数：`pre_test, run_test, post_test`
- 断言（13 条）：

```
  CHECK_RESULT $? 0 0 "L$LINENO: plugin posix-winsync -h No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: plugin posix-winsync show -h No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: plugin posix-winsync show No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: plugin posix-winsync enable -h No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: plugin posix-winsync enable No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: plugin posix-winsync disable -h No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: plugin posix-winsync disable No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: plugin posix-winsync status -h No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: plugin posix-winsync status No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: plugin posix-winsync set -h No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: plugin posix-winsync set No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: plugin posix-winsync fixup -h No Pass"
  ... 共 13 条（其余见源脚本）
```

- 涉及命令：dsconf×1, dsidm×1

#### oe_test_dsconf_plugin_07

- 描述：Test "dsconf" command
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "L$LINENO: plugin list -h No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: plugin list No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: plugin set -h No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: plugin set No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: plugin show -h No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: plugin show No Pass"
```

- 涉及命令：dsconf×1, dsidm×1

#### oe_test_dsconf_pwpolicy

- 描述：Test "dsconf" command
- 函数：`pre_test, run_test, post_test`
- 断言（16 条）：

```
  CHECK_RESULT $? 0 0 "Check: pwpolicy -h No Pass"
  CHECK_RESULT $? 0 0 "Check: pwpolicy get -h No Pass"
  CHECK_RESULT $? 0 0 "Check: pwpolicy get No Pass"
  CHECK_RESULT $? 0 0 "Check: pwpolicy set -h No Pass"
  CHECK_RESULT $? 0 0 "Check: pwpolicy set all No Pass"
  CHECK_RESULT $? 0 0 "Check: localpwp -h No Pass"
  CHECK_RESULT $? 0 0 "Check: localpwp addsubtree -h No Pass"
  CHECK_RESULT $? 0 0 "Check: localpwp addsubtree  No Pass"
  CHECK_RESULT $? 0 0 "Check: localpwp adduser -h No Pass"
  CHECK_RESULT $? 0 0 "Check: localpwp adduser  No Pass"
  CHECK_RESULT $? 0 0 "Check: localpwp adduser -h No Pass"
  CHECK_RESULT $? 0 0 "Check: localpwp set --pwdmustchange No Pass"
  ... 共 16 条（其余见源脚本）
```

- 涉及命令：dsidm×1

#### oe_test_dsconf_repl-agmt

- 描述：Test "dsconf" command
- 函数：`pre_test, run_test, post_test`
- 断言（21 条）：

```
  CHECK_RESULT $? 0 0 "L$LINENO: repl-agmt -h No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: repl-agmt create -h No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: repl-agmt create No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: repl-agmt init -h No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: repl-agmt init No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: repl-agmt init-status -h No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: repl-agmt init-status No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: repl-agmt list -h No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: repl-agmt list No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: repl-agmt enable -h No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: repl-agmt enable No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: repl-agmt poke -h No Pass"
  ... 共 21 条（其余见源脚本）
```

- 涉及命令：dsconf×4

#### oe_test_dsconf_repl-conflict_01

- 描述：Test "dsconf" command
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Check:  repl-conflict list -h No Pass"
  CHECK_RESULT $? 0 0 "Check:  repl-conflict list  No Pass"
  CHECK_RESULT $? 0 0 "Check: repl-conflict compare -h No Pass"
  CHECK_RESULT $? 0 0 "Check: repl-conflict compare -h No Pass"
  CHECK_RESULT $? 0 0 "Check: repl-conflict delete -h No Pass"
  CHECK_RESULT $? 0 0 "Check: repl-conflict delete No Pass"
  CHECK_RESULT $? 0 0 "Check: repl-conflict swap -h No Pass"
  CHECK_RESULT $? 0 0 "Check: repl-conflict swap No Pass"
  CHECK_RESULT $? 0 0 "Check: repl-conflict convert -h No Pass"
  CHECK_RESULT $? 0 0 "Check: repl-conflict convert No Pass"
```

#### oe_test_dsconf_repl-conflict_02

- 描述：Test "dsconf" command
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "Check: repl-conflict list-glue -h No Pass"
  CHECK_RESULT $? 0 0 "Check: repl-conflict list-glue No Pass"
  CHECK_RESULT $? 0 0 "Check: repl-conflict delete-glue -h No Pass"
  CHECK_RESULT $? 0 0 "Check: repl-conflict delete-glue No Pass"
  CHECK_RESULT $? 0 0 "Check: repl-conflict convert-glue -h No Pass"
  CHECK_RESULT $? 0 0 "Check: repl-conflict convert-glue No Pass"
```

#### oe_test_dsconf_repl-tasks

- 描述：Test "dsconf" command
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 "L$LINENO: repl-tasks -h No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: repl-tasks list-cleanruv-tasks -h No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: repl-tasks list-cleanruv-tasks -h No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: repl-tasks list-abortruv-tasks -h No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: repl-tasks list-abortruv-tasks -h No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: repl-tasks cleanallruv -h No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: repl-tasks cleanallruv -h No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: repl-tasks abort-cleanallruv -h No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: repl-tasks abort-cleanallruv -h No Pass"
```

- 涉及命令：dsconf×1, dsidm×1

#### oe_test_dsconf_repl-winsync-agmt

- 描述：Test "dsconf" command
- 函数：`pre_test, run_test, post_test`
- 断言（23 条）：

```
  CHECK_RESULT $? 0 0 "L$LINENO: repl-winsync-agmt -h No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: repl-winsync-agmt create -h No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: repl-winsync-agmt create No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: repl-winsync-agmt enable -h No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: repl-winsync-agmt enable No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: repl-winsync-agmt init -h No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: repl-winsync-agmt init No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: repl-winsync-agmt init-status -h No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: repl-winsync-agmt init-status No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: repl-winsync-agmt list -h No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: repl-winsync-agmt list No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: repl-winsync-agmt poke -h No Pass"
  ... 共 23 条（其余见源脚本）
```

- 涉及命令：dsconf×1

#### oe_test_dsconf_replication

- 描述：Test "dsconf" command
- 函数：`pre_test, run_test, post_test`
- 断言（30 条）：

```
  CHECK_RESULT $? 0 0 "L$LINENO: replication -h No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: replication enable -h No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: replication enable No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: replication promote No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: replication get-ruv -h No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: replication get-ruv No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: replication list -h No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: replication list No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: replication status -h No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: replication status No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: replication winsync-status -h No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: replication winsync-status No Pass"
  ... 共 30 条（其余见源脚本）
```

#### oe_test_dsconf_sasl

- 描述：Test "dsconf" command
- 函数：`pre_test, run_test, post_test`
- 断言（12 条）：

```
  CHECK_RESULT $? 0 0 "L$LINENO: dsconf sasl -h No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: dsconf sasl list -h No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: dsconf sasl list No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: dsconf sasl list --details No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: dsconf sasl get-mechs -h No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: dsconf sasl get-mechs No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: dsconf sasl get -h No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: dsconf sasl get No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: dsconf sasl create -h No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: dsconf sasl create No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: dsconf sasl delete -h No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: dsconf sasl delete No Pass"
```

#### oe_test_dsconf_schema_01

- 描述：Test "dsconf" command
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Check: schema -h No Pass"
  CHECK_RESULT $? 0 0 "Check: list No Pass"
  CHECK_RESULT $? 0 0 "Check: list -h No Pass"
  CHECK_RESULT $? 0 0 "Check: attributetypes -h No Pass"
  CHECK_RESULT $? 0 0 "Check: get_syntaxes No Pass"
  CHECK_RESULT $? 0 0 "Check: get_syntaxes -h No Pass"
  CHECK_RESULT $? 0 0 "Check: schema -h No Pass"
  CHECK_RESULT $? 0 0 "Check: schema -h No Pass"
  CHECK_RESULT $? 0 0 "Check: attributetypes query -h No Pass"
  CHECK_RESULT $? 0 0 "Check: attributetypes query No Pass"
```

#### oe_test_dsconf_schema_02

- 描述：Test "dsconf" command
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Check:  attributetypes add No Pass"
  CHECK_RESULT $? 0 0 "Check:  attributetypes add -h No Pass"
  CHECK_RESULT $? 0 0 "Check:  attributetypes replace -h No Pass"
  CHECK_RESULT $? 0 0 "Check:  attributetypes replace -h No Pass"
  CHECK_RESULT $? 0 0 "Check:  attributetypes remove -h No Pass"
  CHECK_RESULT $? 0 0 "Check:  attributetypes remove No Pass"
  CHECK_RESULT $? 0 0 "Check:  objectclasses -h No Pass"
  CHECK_RESULT $? 0 0 "Check: objectclasses list -h No Pass"
  CHECK_RESULT $? 0 0 "Check: objectclasses list No Pass"
  CHECK_RESULT $? 0 0 "Check: objectclasses query No Pass"
```

#### oe_test_dsconf_schema_03

- 描述：Test "dsconf" command
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Check: objectclasses query -h No Pass"
  CHECK_RESULT $? 0 0 "Check: objectclasses add -h No Pass"
  CHECK_RESULT $? 0 0 "Check: objectclasses add No Pass"
  CHECK_RESULT $? 0 0 "Check: objectclasses replace -h No Pass"
  CHECK_RESULT $? 0 0 "Check: objectclasses replace No Pass"
  CHECK_RESULT $? 0 0 "Check: objectclasses remove -h No Pass"
  CHECK_RESULT $? 0 0 "Check: objectclasses remove No Pass"
  CHECK_RESULT $? 0 0 "Check: matchingrules -h No Pass"
  CHECK_RESULT $? 0 0 "Check: matchingrules list -h No Pass"
  CHECK_RESULT $? 0 0 "Check: matchingrules list No Pass"
```

#### oe_test_dsconf_schema_04

- 描述：Test "dsconf" command
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "Check: matchingrules query No Pass"
  CHECK_RESULT $? 0 0 "Check: matchingrules query -h No Pass"
  CHECK_RESULT $? 0 0 "Check: reload -h No Pass"
  CHECK_RESULT $? 0 0 "Check: reload --wait No Pass"
  CHECK_RESULT $? 0 0 "Check: validate-syntax -h No Pass"
  CHECK_RESULT $? 0 0 "Check: validate-syntax -f No Pass"
```

#### oe_test_dsconf_security_01

- 描述：Test "dsconf security" command
- 函数：`pre_test, run_test, post_test`
- 断言（16 条）：

```
  CHECK_RESULT $? 0 0 "L$LINENO: dsconf security -h No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: dsconf security set -h No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: dsconf security set --security No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: dsconf security set --listen-host No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: dsconf security set --secure-port No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: dsconf security set --tls-client-auth No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: dsconf security set --tls-client-renegotiation No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: dsconf security set --require-secure-authentication No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: dsconf security set --check-hostname No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: dsconf security set --verify-cert-chain-on-startup No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: dsconf security set --session-timeout No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: dsconf security set --tls-protocol-min No Pass"
  ... 共 16 条（其余见源脚本）
```

#### oe_test_dsconf_security_02

- 描述：Test "dsconf security" command
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 "L$LINENO: dsconf security get -h No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: dsconf security get No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: dsconf security disable -h No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: dsconf security disable No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: dsconf security enable -h No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: dsconf security enable No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: dsconf security enable --cert-name No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: dsconf security disable_plain_port -h No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: dsconf security disable_plain_port No Pass"
```

#### oe_test_dsconf_security_03

- 描述：Test "dsconf security" command
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 "L$LINENO: dsconf security certificate -h No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: dsconf security certificate add -h No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: dsconf security certificate set-trust-flags -h No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: dsconf security certificate set-trust-flags --flags No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: dsconf security certificate del -h No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: dsconf security certificate get -h No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: dsconf security certificate get No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: dsconf security certificate list -h No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: dsconf security certificate list No Pass"
```

#### oe_test_dsconf_security_04

- 描述：Test "dsconf security" command
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 "L$LINENO: dsconf security ca-certificate -h No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: dsconf security ca-certificate add -h No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: dsconf security ca-certificate set-trust-flags -h No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: dsconf security ca-certificate set-trust-flags --flags No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: dsconf security ca-certificate del -h No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: dsconf security ca-certificate get -h No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: dsconf security ca-certificate get No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: dsconf security ca-certificate list -h No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: dsconf security ca-certificate list No Pass"
```

#### oe_test_dsconf_security_05

- 描述：Test "dsconf security" command
- 函数：`pre_test, run_test, post_test`
- 断言（11 条）：

```
  CHECK_RESULT $? 0 0 "L$LINENO: dsconf security rsa -h No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: dsconf security rsa set -h No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: dsconf security rsa set --tls-allow-rsa-certificates No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: dsconf security rsa set --nss-cert-name No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: dsconf security rsa set --nss-token No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: dsconf security rsa get -h No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: dsconf security rsa get No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: dsconf security rsa enable -h No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: dsconf security rsa disable -h No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: dsconf security rsa disable No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: dsconf security rsa enable No Pass"
```

#### oe_test_dsconf_security_06

- 描述：Test "dsconf security" command
- 函数：`pre_test, run_test, post_test`
- 断言（14 条）：

```
  CHECK_RESULT $? 0 0 "L$LINENO: dsconf security ciphers -h No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: dsconf security ciphers enable -h No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: dsconf security ciphers disable -h No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: dsconf security ciphers get -h No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: dsconf security ciphers set -h No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: dsconf security ciphers list -h No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: dsconf security ciphers set No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: dsconf security ciphers get No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: dsconf security ciphers enable No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: dsconf security ciphers disable No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: dsconf security ciphers list No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: dsconf security ciphers list --enable No Pass"
  ... 共 14 条（其余见源脚本）
```

#### oe_test_dscreate

- 描述：Test "dscreate" command
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "L$LINENO: -h No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: create-template No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: from-file No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -j No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: from-file No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: interactive No Pass"
```

- 涉及命令：dscreate×3, test×1

#### oe_test_dsctl_01

- 描述：Test "dsctl" command
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "L$LINENO: -h No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -v No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -l No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -j No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: stop No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: start No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: restart No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: status No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: remove -h No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: remove No Pass"
```

- 涉及命令：dsctl×4, dsconf×1

#### oe_test_dsctl_02

- 描述：Test "dsctl" command
- 函数：`pre_test, run_test, post_test`
- 断言（11 条）：

```
  CHECK_RESULT $? 0 0 "L$LINENO: db2index -h No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: db2index No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: db2ldif -h No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: db2ldif No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: db2ldif --replication --encrypted No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: ldif2db -h No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: ldif2db No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: ldif2db --encrypted No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: ldifs -h No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: ldifs No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: ldifs --delete No Pass"
```

- 涉及命令：dsconf×1

#### oe_test_dsctl_03

- 描述：Test "dsctl" command
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 "L$LINENO: dbverify -h No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: dbverify No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: db2bak -h No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: db2bak No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: bak2db -h No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: bak2db No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: backups -h No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: backups No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: backups --delete No Pass"
```

- 涉及命令：dsconf×1

#### oe_test_dsctl_04

- 描述：Test "dsctl" command
- 函数：`pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $? 0 0 "L$LINENO: healthcheck -h No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: healthcheck --list-checks No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: healthcheck --list-errors No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: healthcheck --dry-run No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: healthcheck --check No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: get-nsstate -h No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: get-nsstate --suffix No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: get-nsstate --flip Np Pass"
```

- 涉及命令：dsconf×1

#### oe_test_dsctl_cockpit

- 描述：Test "dsctl" command
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "L$LINENO: cockpit -h No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: cockpit enable No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: cockpit open-firewall No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: cockpit close-firewall No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: cockpit disable No Pass"
```

- 涉及命令：dsctl×2, dsconf×1

#### oe_test_dsctl_dsrc

- 描述：Test "dsctl" command
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 "L$LINENO: dsrc -h No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: dsrc create -h No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: dsrc create No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: dsrc modify -h No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: dsrc modify No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: dsrc display -h No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: dsrc display No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: dsrc delete -h No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: dsrc delete No Pass"
```

- 涉及命令：dsconf×1

#### oe_test_dsctl_ldifgen

- 描述：Test "dsctl" command
- 函数：`pre_test, run_test, post_test`
- 断言（15 条）：

```
  CHECK_RESULT $? 0 0 "L$LINENO: ldifgen -h No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: ldifgen users -h No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: ldifgen users No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: ldifgen groups -h No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: ldifgen groups No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: ldifgen cos-def -h No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: ldifgen cos-def No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: ldifgen cos-template -h No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: ldifgen cos-template No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: ldifgen roles -h No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: ldifgen roles No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: ldifgen mod-load -h No Pass"
  ... 共 15 条（其余见源脚本）
```

- 涉及命令：dsconf×1

#### oe_test_dsctl_tls

- 描述：Test "dsctl" command
- 函数：`pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $? 0 0 "L$LINENO: tls -h No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: tls list-ca No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: tls list-client-ca No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: tls show-server-cert No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: tls generate-server-cert-csr -h No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: tls generate-server-cert-csr No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: tls generate-server-cert-csr --subject No Pass"
```

- 涉及命令：dsconf×1

#### oe_test_dsidm

- 描述：Test "dsidm" command
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 "L$LINENO: -h No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -b -D No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -w -W No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -v No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -y No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -Z No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -j No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: initialise -h No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: initialise No Pass"
```

- 涉及命令：dsidm×8

#### oe_test_dsidm_account

- 描述：Test "dsidm" command
- 函数：`pre_test, run_test, post_test`
- 断言（23 条）：

```
  CHECK_RESULT $? 0 0 "L$LINENO: account -h No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: account list -h No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: account list No Pass"=
  CHECK_RESULT $? 0 0 "L$LINENO: account get-by-dn -h No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: account get-by-dn No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: account modify-by-dn -h No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: account modify-by-dn No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: account rename-by-dn -h No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: account rename-by-dn No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: account unlock -h No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: account unlock No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: account lock -h No Pass"
  ... 共 23 条（其余见源脚本）
```

- 涉及命令：dsidm×10

#### oe_test_dsidm_client_config

- 描述：Test "dsidm" command
- 函数：`pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $? 0 0 "L$LINENO: client_config -h No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: client_config display -h No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: client_config display No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: client_config sssd.conf -h No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: client_config sssd.conf No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: client_config ldap.conf -h No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: client_config ldap.conf No Pass"
```

- 涉及命令：dsidm×3

#### oe_test_dsidm_group

- 描述：Test "dsctk" command
- 函数：`pre_test, run_test, post_test`
- 断言（21 条）：

```
  CHECK_RESULT $? 0 0 "L$LINENO: group -h No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: group list -h No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: group list No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: group get -h No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: group get No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: group get_dn -h No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: group get_dn No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: group create -h No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: group create No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: group modify -h No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: group modify No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: group rename -h No Pass"
  ... 共 21 条（其余见源脚本）
```

- 涉及命令：dsidm×9, grep×2

#### oe_test_dsidm_organizationalunit

- 描述：Test "dsidm" command
- 函数：`pre_test, run_test, post_test`
- 断言（15 条）：

```
  CHECK_RESULT $? 0 0 "L$LINENO: organizationalunit -h No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: organizationalunit list -h No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: organizationalunit list No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: organizationalunit get -h No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: organizationalunit get No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: organizationalunit get_dn -h No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: organizationalunit get_dn No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: organizationalunit create -h No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: organizationalunit create No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: organizationalunit modify -h No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: organizationalunit modify No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: organizationalunit rename -h No Pass"
  ... 共 15 条（其余见源脚本）
```

- 涉及命令：dsidm×6

#### oe_test_dsidm_posixgroup

- 描述：Test "dsidm" command
- 函数：`pre_test, run_test, post_test`
- 断言（15 条）：

```
  CHECK_RESULT $? 0 0 "L$LINENO: posixgroup -h No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: posixgroup list -h No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: posixgroup list No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: posixgroup get -h No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: posixgroup get No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: posixgroup get_dn -h No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: posixgroup get_dn No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: posixgroup create -h No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: posixgroup create No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: posixgroup modify -h No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: posixgroup modify No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: posixgroup rename -h No Pass"
  ... 共 15 条（其余见源脚本）
```

- 涉及命令：dsidm×7, grep×2

#### oe_test_dsidm_role

- 描述：Test "dsidm" command
- 函数：`pre_test, run_test, post_test`
- 断言（17 条）：

```
  CHECK_RESULT $? 0 0 "L$LINENO: role -h No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: role list -h No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: role list No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: role get-by-dn -h No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: role get-by-dn No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: role modify-by-dn -h No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: role modify-by-dn No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: role rename-by-dn -h No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: role rename-by-dn No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: role unlock -h No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: role unlock No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: role lock -h No Pass"
  ... 共 17 条（其余见源脚本）
```

- 涉及命令：dsidm×8

#### oe_test_dsidm_user

- 描述：Test "dsctk" command
- 函数：`pre_test, run_test, post_test`
- 断言（14 条）：

```
  CHECK_RESULT $? 0 0 "L$LINENO: user -h No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: user list -h No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: user list No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: user get -h No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: user get No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: user get_dn -h No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: user create -h No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: user create No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: user modify -h No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: user modify No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: user rename -h No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: user rename No Pass"
  ... 共 14 条（其余见源脚本）
```

- 涉及命令：dsidm×5

#### oe_test_service_dirsrv-snmp

- 描述：Test dirsrv-snmp.service restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_target_dirsrv

- 描述：Test dirsrv.target restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_dbscan

- 描述：Test "dbscan" command
- 函数：`pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $? 0 0 "L$LINENO: -f No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -R No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -t No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -K No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -l No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -G No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -r No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -s No Pass"
```

- 涉及命令：dbscan×8

#### oe_test_ds-logpipe

- 描述：Test "dbscan" command
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "L$LINENO: -h No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: ds-logpipe No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -m No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -d No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: --serverpid No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -i No Pass"
```

- 涉及命令：ds-logpipe.py×1

#### oe_test_ldclt

- 描述：Test "ldclt" command
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "L$LINENO: Generating LDIFs No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: Adding Entries No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: Modrdn Operations No Pass"
```

- 涉及命令：ldclt×3, dsconf×1, dsidm×1

#### oe_test_logconv

- 描述：Test "logconv" command
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "L$LINENO: -h No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -d No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -s No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -v No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -S No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -E No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -m No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -M No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -B No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -V No Pass"
```

- 涉及命令：logconv.pl×10

#### oe_test_ns-slapd

- 描述：Test "ns-slapd" command
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "L$LINENO: -D No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -d No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -v No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -V No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -i No Pass"
```

- 涉及命令：ns-slapd×5

#### oe_test_pwdhash

- 描述：Test "pwdhash" command
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "L$LINENO: pwdhash No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: pwdhash -H No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: pwdhash -c No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: pwdhash -s No Pass"
```

- 涉及命令：pwdhash×3

#### oe_test_ds-replcheck

- 描述：Test "oe_ds-replcheck" command
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "L$LINENO: ds-replcheck -h No Pass"
```

- 涉及命令：ds-replcheck×1
