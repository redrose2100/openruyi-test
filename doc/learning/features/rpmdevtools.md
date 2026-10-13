# rpmdevtools

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/rpmdevtools` |
| 注册用例数 | 5 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_rpmdevtools_rpmargs | test rpmargs rpmdev-checksig rpmdev-cksum rpmdev-diff rpmdev-extract rpmdev-md5 | pre_test/run_test/post_test | 20 | ✔ |  |  |
| oe_test_rpmdevtools_rpmdev-rmdevelrpms | test rpmdev-rmdevelrpms rpmdev-setuptree rpmdev-sha1 rpmdev-sha224 rpmdev-sha256 rpmdev-sha384 rpmdev-sha512 rpmdev-sort rpmdev-sum | pre_test/run_test/post_test | 14 | ✔ |  |  |
| oe_test_rpmdevtools_rpmdev-vercmp | test rpmdev-vercmp spectool | pre_test/run_test/post_test | 20 | ✔ |  |  |
| oe_test_rpmdevtools_rpmdev-wipetree | test rpmdev-wipetree rpmelfsym rpmfile rpminfo rpmls rpmpeek rpmsodiff rpmsoname | pre_test/run_test/post_test | 33 | ✔ |  | 120m |
| oe_test_rpmdevtools_rpmdev-bumpspec | test rpmdev-bumpspec rpmdev-newinit rpmdev-newspec | pre_test/run_test/post_test | 18 | ✔ |  |  |

### 断言与命令明细

#### oe_test_rpmdevtools_rpmargs

- 描述：test rpmargs rpmdev-checksig rpmdev-cksum rpmdev-diff rpmdev-extract rpmdev-md5
- 函数：`pre_test, run_test, post_test`
- 断言（20 条）：

```
  CHECK_RESULT $? 0 0 "Failed option: -h"
  CHECK_RESULT $? 0 0 "Failed option: -a"
  CHECK_RESULT $? 0 0 "Failed option: -p"
  CHECK_RESULT $? 0 0 "Failed command:rpmdev-checksig"
  CHECK_RESULT $? 0 0 "Failed command: rpmdev-cksum"
  CHECK_RESULT $? 0 0 "Failed option: -v"
  CHECK_RESULT $? 0 0 "Failed option: -h"
  CHECK_RESULT $? 0 0 "Failed option: -c"
  CHECK_RESULT $? 0 0 "Failed option: -l"
  CHECK_RESULT $? 0 0 "Failed option: -L"
  CHECK_RESULT $? 0 0 "Failed option: -m"
  CHECK_RESULT $? 0 0 "Failed option: -y"
  ... 共 20 条（其余见源脚本）
```

- 涉及命令：rpmdev-diff×7, rpmdev-extract×5, mkdir×3, rpmargs×3

#### oe_test_rpmdevtools_rpmdev-rmdevelrpms

- 描述：test rpmdev-rmdevelrpms rpmdev-setuptree rpmdev-sha1 rpmdev-sha224 rpmdev-sha256 rpmdev-sha384 rpmdev-sha512 rpmdev-sort rpmdev-sum
- 函数：`pre_test, run_test, post_test`
- 断言（14 条）：

```
  CHECK_RESULT $? 0 0 "Failed option: -h"
  CHECK_RESULT $? 0 0 "Failed option: -v"
  CHECK_RESULT $? 0 0 "Fail option: -l"
  CHECK_RESULT $? 0 0 "Fail option: --qf"
  CHECK_RESULT $? 0 0 "Fail option: -y"
  CHECK_RESULT $? 0 0 "Failed command: rpmdev-setuptree"
  CHECK_RESULT $? 0 0 "Failed command: rpmdev-sha1"
  CHECK_RESULT $? 0 0 "Failed command: rpmdev-sha224"
  CHECK_RESULT $? 0 0 "Failed command: rpmdev-sha256"
  CHECK_RESULT $? 0 0 "Failed command: rpmdev-sha384"
  CHECK_RESULT $? 0 0 "Failed command: rpmdev-sha512"
  CHECK_RESULT "$(find . -name '*rpm' | rpmdev-sort | wc -l)" 1 0 "Failed command: rpmdev-sort"
  ... 共 14 条（其余见源脚本）
```

- 涉及命令：rpmdev-rmdevelrpms×4, test×3, rpmdev-sort×1

#### oe_test_rpmdevtools_rpmdev-vercmp

- 描述：test rpmdev-vercmp spectool
- 函数：`pre_test, run_test, post_test`
- 断言（20 条）：

```
  CHECK_RESULT $? 12 0 "Failed option: n:n-n < n:n-n"
  CHECK_RESULT $? 11 0 "Failed option: n:n-n > n:n-n"
  CHECK_RESULT $? 11 0 "Failed option: n > n"
  CHECK_RESULT $? 12 0 "Failed option: n < n"
  CHECK_RESULT $? 0 0 "Failed option: n == n"
  CHECK_RESULT $? 0 0 "Failed option: n:n-n == n:n-n"
  CHECK_RESULT $? 0 0 "Failed option: -h"
  CHECK_RESULT $? 0 0 "Failed option: -l"
  CHECK_RESULT $? 0 0 "Failed option: -g"
  CHECK_RESULT $? 0 0 "Failed option: -h"
  CHECK_RESULT $? 0 0 "Failed option: -S"
  CHECK_RESULT $? 0 0 "Failed option: -P"
  ... 共 20 条（其余见源脚本）
```

- 涉及命令：spectool×12, test×3, rpmdev-vercmp×1

#### oe_test_rpmdevtools_rpmdev-wipetree

- 描述：test rpmdev-wipetree rpmelfsym rpmfile rpminfo rpmls rpmpeek rpmsodiff rpmsoname
- 函数：`pre_test, run_test, post_test`
- 断言（33 条）：

```
  CHECK_RESULT $? 0 0 "Failed pre_test"
  CHECK_RESULT $? 0 0 "Failed pre_test"
  CHECK_RESULT $? 2 0 "Failed command: rpmdev-wipetree"
  CHECK_RESULT $? 0 0 "Failed option: -p"
  CHECK_RESULT $? 0 0 "Failed option: -h"
  CHECK_RESULT $? 0 0 "Failed option: -a"
  CHECK_RESULT $? 0 0 "Failed option: -p"
  CHECK_RESULT $? 0 0 "Failed option: -h"
  CHECK_RESULT $? 0 0 "Failed option: -a"
  CHECK_RESULT $? 0 0 "Failed option: -h"
  CHECK_RESULT $? 0 0 "Failed option: -v"
  CHECK_RESULT $? 0 0 "Failed option: -q"
  ... 共 33 条（其余见源脚本）
```

- 涉及命令：rpminfo×16, mkdir×3, rpmelfsym×3, rpmfile×3, rpmpeek×2, rpmsoname×2, test×1, rpmls×1, rpmsodiff×1, userdel×1

#### oe_test_rpmdevtools_rpmdev-bumpspec

- 描述：test rpmdev-bumpspec rpmdev-newinit rpmdev-newspec
- 函数：`pre_test, run_test, post_test`
- 断言（18 条）：

```
  CHECK_RESULT $? 0 0 "Failed option: -h"
  CHECK_RESULT $? 0 0 "Failed option: -c"
  CHECK_RESULT $? 0 0 "Failed option: -V"
  CHECK_RESULT $? 0 0 "Failed option: -v"
  CHECK_RESULT $? 0 0 "Failed option: -u"
  CHECK_RESULT $? 0 0 "Failed option: -f"
  CHECK_RESULT $? 0 0 "Failed option: -r"
  CHECK_RESULT $? 0 0 "Failed option: -s"
  CHECK_RESULT $? 0 0 "Failed option: -n"
  CHECK_RESULT $? 0 0 "Failed options: -v"
  CHECK_RESULT $? 0 0 "Failed options: -h"
  CHECK_RESULT $? 0 0 "Failted options: -o"
  ... 共 18 条（其余见源脚本）
```

- 涉及命令：rpmdev-bumpspec×9, rpmdev-newspec×7, grep×6, rpmdev-newinit×3, test×2
