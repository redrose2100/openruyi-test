# rubygem-sdoc

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/rubygem-sdoc` |
| 注册用例数 | 7 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_rubygem-sdoc_sdoc-merge | Test sdoc-merge | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_rubygem-sdoc_sdoc_01 | Test sdoc | pre_test/run_test/post_test | 16 | ✔ |  |  |
| oe_test_rubygem-sdoc_sdoc_02 | Test sdoc | pre_test/run_test/post_test | 14 | ✔ |  |  |
| oe_test_rubygem-sdoc_sdoc_03 | Test sdoc | pre_test/run_test/post_test | 13 | ✔ |  |  |
| oe_test_rubygem-sdoc_sdoc_04 | Test sdoc | pre_test/run_test/post_test | 15 | ✔ |  |  |
| oe_test_rubygem-sdoc_sdoc_05 | Test sdoc | pre_test/run_test/post_test | 15 | ✔ |  |  |
| oe_test_rubygem-sdoc_sdoc_06 | Test sdoc | pre_test/run_test/post_test | 2 | ✔ |  |  |

### 断言与命令明细

#### oe_test_rubygem-sdoc_sdoc-merge

- 描述：Test sdoc-merge
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Check sdoc-merge -h failed"
  CHECK_RESULT $? 0 0 "Check sdoc-merge --title failed"
  CHECK_RESULT $? 0 0 "Check sdoc-merge -t failed"
  CHECK_RESULT $? 0 0 "Check sdoc-merge -u failed"
  CHECK_RESULT $? 0 0 "Check sdoc-merge --urls failed"
  CHECK_RESULT $? 0 0 "Check sdoc-merge -u failed"
  CHECK_RESULT $? 0 0 "Check sdoc-merge --op failed"
  CHECK_RESULT $? 0 0 "Check sdoc-merge -o failed"
  CHECK_RESULT $? 0 0 "Check sdoc-merge --names failed"
  CHECK_RESULT $? 0 0 "Check sdoc-merge -n failed"
```

- 涉及命令：sdoc-merge×10, grep×4, tar×1

#### oe_test_rubygem-sdoc_sdoc_01

- 描述：Test sdoc
- 函数：`pre_test, run_test, post_test`
- 断言（16 条）：

```
  CHECK_RESULT $? 0 0 "Check sdoc -h failed"
  CHECK_RESULT $? 0 0 "Check sdoc --help failed"
  CHECK_RESULT $? 0 0 "Check sdoc -v failed"
  CHECK_RESULT $? 0 0 "Check sdoc --version failed"
  CHECK_RESULT $? 0 0 "Check sdoc -V failed"
  CHECK_RESULT $? 0 0 "Check sdoc --verbose failed"
  CHECK_RESULT $? 0 0 "Check sdoc -q failed"
  CHECK_RESULT $? 0 0 "Check sdoc --quiet failed"
  CHECK_RESULT $? 0 0 "Check sdoc --ignore-invalid failed"
  CHECK_RESULT $? 1 0 "Check sdoc --ignore-invalid failed"
  CHECK_RESULT $? 0 0 "Check sdoc -D failed"
  CHECK_RESULT $? 0 0 "Check sdoc --debug failed"
  ... 共 16 条（其余见源脚本）
```

- 涉及命令：sdoc×5, tar×1

#### oe_test_rubygem-sdoc_sdoc_02

- 描述：Test sdoc
- 函数：`pre_test, run_test, post_test`
- 断言（14 条）：

```
  CHECK_RESULT $? 0 0 "Check sdoc -r failed"
  CHECK_RESULT $? 0 0 "Check sdoc --ri failed"
  CHECK_RESULT $? 0 0 "Check sdoc -R failed"
  CHECK_RESULT $? 0 0 "Check sdoc --ri-site failed"
  CHECK_RESULT $? 0 0 "Check sdoc --webcvs failed"
  CHECK_RESULT $? 0 0 "Check sdoc -W failed"
  CHECK_RESULT $? 0 0 "Check sdoc --copy-files failed"
  CHECK_RESULT $? 0 0 "Check sdoc -t failed"
  CHECK_RESULT $? 0 0 "Check sdoc --title failed"
  CHECK_RESULT $? 0 0 "Check sdoc --template-stylesheets failed"
  CHECK_RESULT $? 0 0 "Check sdoc -T failed"
  CHECK_RESULT $? 0 0 "Check sdoc --template failed"
  ... 共 14 条（其余见源脚本）
```

- 涉及命令：sdoc×6, tar×1

#### oe_test_rubygem-sdoc_sdoc_03

- 描述：Test sdoc
- 函数：`pre_test, run_test, post_test`
- 断言（13 条）：

```
  CHECK_RESULT $? 0 0 "Check sdoc -N failed"
  CHECK_RESULT $? 0 0 "Check sdoc --line-numbers failed"
  CHECK_RESULT $? 0 0 "Check sdoc --no-line-numbers failed"
  CHECK_RESULT $? 0 0 "Check sdoc --main failed"
  CHECK_RESULT $? 0 0 "Check sdoc -m failed"
  CHECK_RESULT $? 0 0 "Check sdoc --hyperlink-all failed"
  CHECK_RESULT $? 0 0 "Check sdoc -A failed"
  CHECK_RESULT $? 0 0 "Check sdoc --charset failed"
  CHECK_RESULT $? 0 0 "Check sdoc -c failed"
  CHECK_RESULT $? 0 0 "Check sdoc -d failed"
  CHECK_RESULT $? 0 0 "Check sdoc -o failed"
  CHECK_RESULT $? 0 0 "Check sdoc --output failed"
  ... 共 13 条（其余见源脚本）
```

- 涉及命令：sdoc×6, tar×1

#### oe_test_rubygem-sdoc_sdoc_04

- 描述：Test sdoc
- 函数：`pre_test, run_test, post_test`
- 断言（15 条）：

```
  CHECK_RESULT $? 0 0 "Check sdoc -C failed"
  CHECK_RESULT $? 0 0 "Check sdoc --coverage-report failed"
  CHECK_RESULT $? 0 0 "Check sdoc --no-coverage-report failed"
  CHECK_RESULT $? 0 0 "Check sdoc --dcov failed"
  CHECK_RESULT $? 0 0 "Check sdoc --no-dcov failed"
  CHECK_RESULT $? 0 0 "Check sdoc -i failed"
  CHECK_RESULT $? 0 0 "Check sdoc --include failed"
  CHECK_RESULT $? 0 0 "Check sdoc -f failed"
  CHECK_RESULT $? 0 0 "Check sdoc --fmt failed"
  CHECK_RESULT $? 0 0 "Check sdoc --format failed"
  CHECK_RESULT $? 0 0 "Check sdoc -O failed"
  CHECK_RESULT $? 0 0 "Check sdoc --force-output failed"
  ... 共 15 条（其余见源脚本）
```

- 涉及命令：sdoc×4, tar×1

#### oe_test_rubygem-sdoc_sdoc_05

- 描述：Test sdoc
- 函数：`pre_test, run_test, post_test`
- 断言（15 条）：

```
  CHECK_RESULT $? 0 0 "Check sdoc --visibility failed"
  CHECK_RESULT $? 0 0 "Check sdoc -w failed"
  CHECK_RESULT $? 0 0 "Check sdoc --tab-width failed"
  CHECK_RESULT $? 0 0 "Check sdoc -U failed"
  CHECK_RESULT $? 0 0 "Check sdoc --no-force-update failed"
  CHECK_RESULT $? 0 0 "Check sdoc -E failed"
  CHECK_RESULT $? 0 0 "Check sdoc --extension failed"
  CHECK_RESULT $? 0 0 "Check sdoc -x failed"
  CHECK_RESULT $? 0 0 "Check sdoc --exclude failed"
  CHECK_RESULT $? 0 0 "Check sdoc -a failed"
  CHECK_RESULT $? 0 0 "Check sdoc --all failed"
  CHECK_RESULT $? 0 0 "Check sdoc --locale-data-dir failed"
  ... 共 15 条（其余见源脚本）
```

- 涉及命令：sdoc×6, tar×1

#### oe_test_rubygem-sdoc_sdoc_06

- 描述：Test sdoc
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Check sdoc -g failed"
  CHECK_RESULT $? 0 0 "Check sdoc --github failed"
```

- 涉及命令：tar×1, sdoc×1
