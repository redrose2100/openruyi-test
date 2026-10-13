# createrepo_c

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/createrepo_c` |
| 注册用例数 | 5 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_createrepo_c_local_repo | Test createrepo_c make repo | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_createrepo_c_algorithm | test createrepo_c algorithm | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_createrepo_c_pkg_path | test createrepo_c pkg path | pre_test/run_test/post_test | 14 | ✔ |  |  |
| oe_test_createrepo_c_BaseFun | test createrepo_c BaseFun | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_sqliterepo_c | test sqliterepo_c | pre_test/run_test/post_test | 32 | ✔ |  |  |

### 断言与命令明细

#### oe_test_createrepo_c_local_repo

- 描述：Test createrepo_c make repo
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "Generation failure"
  CHECK_RESULT $? 0 0 "Repo error"
  CHECK_RESULT $? 0 0 "Package install fail"
  CHECK_RESULT $? 0 0 "Package remove fail"
```

- 涉及命令：test×1

#### oe_test_createrepo_c_algorithm

- 描述：test createrepo_c algorithm
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "createrepo fail"
  CHECK_RESULT "$(grep -r -i "checksum type=" DIR-algorithm |awk -F '"' '{print $2}' |uniq)" "sha256" 0 "default algorithm fail"
  CHECK_RESULT $? 0 0 "createrepo fail"
  CHECK_RESULT "$(grep -r -i "checksum type=" DIR-algorithm |awk -F '"' '{print $2}' |uniq)" "sha512" 0 "chage algorithm fail"
```

- 涉及命令：test×2, createrepo_c×1

#### oe_test_createrepo_c_pkg_path

- 描述：test createrepo_c pkg path
- 函数：`pre_test, run_test, post_test`
- 断言（14 条）：

```
  CHECK_RESULT "$(yum --repo=local list --available |grep -E "$(arch)|noarch" |awk '{print $1}' |awk -F '.' '{print $1}' |sort |xargs)"  \
  CHECK_RESULT $? 0 0 "createrepo no rpm fail"
  CHECK_RESULT "$(yum --repo=local list --available |grep -E "$(arch)|noarch")x" "x" 0 "createrepo no rpm fail"
  CHECK_RESULT $? 0 0 "createrepo only tcpdump rpm fail"
  CHECK_RESULT "$(yum --repo=local list --available |grep -E "$(arch)|noarch" |awk '{print $1}' |awk -F '.' '{print $1}' |sort |xargs)"  \
  CHECK_RESULT $? 0 0 "createrepo only httpd-help rpm fail"
  CHECK_RESULT "$(yum --repo=local list --available |grep -E "$(arch)|noarch" |awk '{print $1}' |awk -F '.' '{print $1}' |sort |xargs)"  \
  CHECK_RESULT $? 0 0 "createrepo update fail"
  CHECK_RESULT "$(yum --repo=local list --available |grep -E "$(arch)|noarch" |awk '{print $1}' |awk -F '.' '{print $1}' |sort |xargs)"  \
  CHECK_RESULT $? 0 0 "createrepo pkglist fail"
  CHECK_RESULT "$(yum --repo=local list --available |grep -E "$(arch)|noarch" |awk '{print $1}' |awk -F '.' '{print $1}' |sort |xargs)"  \
  CHECK_RESULT $? 0 0 "Output the paths to the pkgs fail"
  ... 共 14 条（其余见源脚本）
```

- 涉及命令：test×5, createrepo_c×4, basename×1

#### oe_test_createrepo_c_BaseFun

- 描述：test createrepo_c BaseFun
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "createrepo_c usage fail"
  CHECK_RESULT $? 0 0 "createrepo_c version fail"
  CHECK_RESULT "$(createrepo_c -V |awk '{print $2}')" "$(rpm -qi createrepo_c  |grep Version |awk '{print $NF}')" 0 "createrepo_c version fail"
  CHECK_RESULT $? 0 0 "createrepo_c run verbosely fail"
  CHECK_RESULT $? 0 0 "createrepo_c run verbosely fail"
  CHECK_RESULT $? 0 0 "createrepo_c output missing 'All done'"
  CHECK_RESULT $? 0 0 "createrepo_c output missing timestamp"
  CHECK_RESULT $? 0 0 "fix Number of workers fail"
  CHECK_RESULT "$(createrepo_c --workers 4 "${test_path}"/pkg |grep "Pool started" |awk '{print $(NF-1)}')" "4" 0 "fix Number of workers fail"
  CHECK_RESULT "$(createrepo_c "${test_path}"/pkg |grep "Pool started" |awk '{print $(NF-1)}')" "5" 0 "default Number of workers error"
```

- 涉及命令：test×4, createrepo_c×2

#### oe_test_sqliterepo_c

- 描述：test sqliterepo_c
- 函数：`pre_test, run_test, post_test`
- 断言（32 条）：

```
  CHECK_RESULT $? 0 0 "sqliterepo_c usage fail"
  CHECK_RESULT $? 0 0 "sqliterepo_c version fail"
  CHECK_RESULT "$(sqliterepo_c -V |awk '{print $2}')" "$(rpm -qi createrepo_c  |grep Version |awk '{print $NF}')" 0 "sqliterepo_c version fail"
  CHECK_RESULT $? 0 0 "createrepo fail"
  CHECK_RESULT $? 0 1 "createrepo default no database fail"
  CHECK_RESULT $? 0 1 "createrepo default no database fail"
  CHECK_RESULT $? 0 0 "createrepo create database fail"
  CHECK_RESULT $? 0 0 "default sqlite format check fail"
  CHECK_RESULT $? 0 0 "default sqlite format check fail"
  CHECK_RESULT $? 0 0 "createrepo create database fail"
  CHECK_RESULT $? 0 0 "sqlite format xz check fail"
  CHECK_RESULT $? 0 0 "sqlite format xz check fail"
  ... 共 32 条（其余见源脚本）
```

- 涉及命令：test×4, sqliterepo_c×2, createrepo_c×2
