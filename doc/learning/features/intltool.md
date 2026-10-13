# intltool

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/intltool` |
| 注册用例数 | 6 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_intltool_intltool-merge_01 | Test intltool-merge | pre_test/run_test/post_test | 22 | ✔ |  |  |
| oe_test_intltool_intltool-merge_02 | Test intltool-merge | pre_test/run_test/post_test | 20 | ✔ |  |  |
| oe_test_intltool_intltool-update | Test intltool-update options | pre_test/run_test/post_test | 20 | ✔ |  |  |
| oe_test_intltool_intltool-extract | Test intltool-extract | pre_test/run_test/post_test | 23 | ✔ |  |  |
| oe_test_intltool_intltool-prepare | Test intltool-prepare options | pre_test/run_test/post_test | 25 | ✔ |  |  |
| oe_test_intltool_intltoolize | TEST intltoolize options | pre_test/run_test/post_test | 10 | ✔ |  |  |

### 断言与命令明细

#### oe_test_intltool_intltool-merge_01

- 描述：Test intltool-merge
- 函数：`pre_test, run_test, post_test`
- 断言（22 条）：

```
  CHECK_RESULT $? 0 0 "option: --help error"
  CHECK_RESULT $? 0 0 "option: --version error"
  CHECK_RESULT $? 0 0 "option: -d generate error"
  CHECK_RESULT $? 0 0 "option: -d error"
  CHECK_RESULT $? 0 0 "option: --desktop-style generate error"
  CHECK_RESULT $? 0 0 "option: --desktop-style error"
  CHECK_RESULT $? 0 0 "option: -k generate error"
  CHECK_RESULT $? 0 0 "option: -k error"
  CHECK_RESULT $? 0 0 "option: --keys-style generate error"
  CHECK_RESULT $? 0 0 "option: --keys-style error"
  CHECK_RESULT $? 0 0 "option: -s generate error"
  CHECK_RESULT $? 0 0 "option: -s error"
  ... 共 22 条（其余见源脚本）
```

- 涉及命令：test×10, grep×10, intltool-merge×5

#### oe_test_intltool_intltool-merge_02

- 描述：Test intltool-merge
- 函数：`pre_test, run_test, post_test`
- 断言（20 条）：

```
  CHECK_RESULT $? 0 0 "option: --help error"
  CHECK_RESULT $? 0 0 "option: --version error"
  CHECK_RESULT $? 0 0 "option: -u -r generate error"
  CHECK_RESULT $? 0 0 "option: -u error"
  CHECK_RESULT $? 0 0 "option: --utf8 -r generate error"
  CHECK_RESULT $? 0 0 "option: --utf8 error"
  CHECK_RESULT $? 0 0 "option: -p error"
  CHECK_RESULT $? 0 0 "option: --pass-through error"
  CHECK_RESULT $? 0 0 "option: -m --quoted-style generate error"
  CHECK_RESULT $? 0 0 "option: -m --quoted-style error"
  CHECK_RESULT $? 0 0 "option: --multiple-output --quotedxml-style generate error"
  CHECK_RESULT $? 0 0 "option: --multiple-output --quotedxml-style error"
  ... 共 20 条（其余见源脚本）
```

- 涉及命令：test×7, grep×7, intltool-merge×4

#### oe_test_intltool_intltool-update

- 描述：Test intltool-update options
- 函数：`pre_test, run_test, post_test`
- 断言（20 条）：

```
  CHECK_RESULT $? 0 0 "option: --help error"
  CHECK_RESULT $? 0 0 "option: --version error"
  CHECK_RESULT $? 0 0 "option: -p error"
  CHECK_RESULT $? 0 0 "option: --pot error"
  CHECK_RESULT $? 0 0 "option: -g error"
  CHECK_RESULT $? 0 0 "option: --gettext-package=NAME error"
  CHECK_RESULT $? 0 0 "option: -s error"
  CHECK_RESULT $? 0 0 "option: --headers error"
  CHECK_RESULT $? 0 0 "option: -x error"
  CHECK_RESULT $? 0 0 "option: --verbose error"
  CHECK_RESULT $? 0 0 "option: -m error"
  CHECK_RESULT $? 0 0 "option: --maintain error"
  ... 共 20 条（其余见源脚本）
```

- 涉及命令：intltool-update×10, grep×10, test×1

#### oe_test_intltool_intltool-extract

- 描述：Test intltool-extract
- 函数：`pre_test, run_test, post_test`
- 断言（23 条）：

```
  CHECK_RESULT $? 0 0 "option: -h error"
  CHECK_RESULT $? 0 0 "option: --help error"
  CHECK_RESULT $? 0 0 "option: -v error"
  CHECK_RESULT $? 0 0 "option: --version error"
  CHECK_RESULT $? 0 0 "option: --type=\"gettext/${type}\" error"
  CHECK_RESULT $? 0 0 "option: --type=\"gettext/${type}\" error"
  CHECK_RESULT $? 0 0 "option: --type=\"gettext/${type}\" error"
  CHECK_RESULT $? 0 0 "option: -l error"
  CHECK_RESULT $? 0 0 "option: -l error"
  CHECK_RESULT $? 0 0 "option: -l error"
  CHECK_RESULT $? 0 0 "option: --local error"
  CHECK_RESULT $? 0 0 "option: -l error"
  ... 共 23 条（其余见源脚本）
```

- 涉及命令：test×8, grep×7, tar×1, intltool-extract×1, intltool-prepare×1

#### oe_test_intltool_intltool-prepare

- 描述：Test intltool-prepare options
- 函数：`pre_test, run_test, post_test`
- 断言（25 条）：

```
  CHECK_RESULT $? 0 0 "option: -h error"
  CHECK_RESULT $? 0 0 "option: --help error"
  CHECK_RESULT $? 0 0 "option: -v error"
  CHECK_RESULT $? 0 0 "option: --version error"
  CHECK_RESULT $? 0 0 "intltool-prepare output error"
  CHECK_RESULT $? 0 0 "intltool-prepare output error"
  CHECK_RESULT $? 0 0 "intltool-prepare output error"
  CHECK_RESULT $? 0 0 "intltool-prepare output error"
  CHECK_RESULT $? 0 0 "intltool-prepare output error"
  CHECK_RESULT $? 0 0 "intltool-prepare output error"
  CHECK_RESULT $? 0 0 "intltool-prepare output error"
  CHECK_RESULT $? 0 0 "intltool-prepare -x output error"
  ... 共 25 条（其余见源脚本）
```

- 涉及命令：grep×15, test×4, intltool-prepare×3, mkdir×1, tar×1

#### oe_test_intltool_intltoolize

- 描述：TEST intltoolize options
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "option: --help error"
  CHECK_RESULT $? 0 0 "option: --version error"
  CHECK_RESULT $? 0 0 "option: --automake error"
  CHECK_RESULT $? 0 0 "option: -c error"
  CHECK_RESULT $? 0 0 "option: --copy error"
  CHECK_RESULT $? 0 0 "option: --debug error"
  CHECK_RESULT $? 0 0 "option: --debug error"
  CHECK_RESULT $? 0 0 "option: -n error"
  CHECK_RESULT $? 0 0 "option: -f error"
  CHECK_RESULT $? 0 0 "option: --force error"
```

- 涉及命令：grep×4, mkdir×1, intltoolize×1
