# libsmi

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/libsmi` |
| 注册用例数 | 13 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_libsmi_smicache | Test "libsmi" command | pre_test/run_test/post_test | 5 | ✔ |  |  |
| oe_test_libsmi_smidiff | Test "libsmi" command | pre_test/run_test/post_test | 8 | ✔ |  |  |
| oe_test_libsmi_smidump_01 | Test "libsmi" command | pre_test/run_test/post_test | 11 | ✔ |  |  |
| oe_test_libsmi_smidump_02 | Test "libsmi" command | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_libsmi_smidump_03 | Test "libsmi" command | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_libsmi_smidump_04 | Test "libsmi" command | pre_test/run_test/post_test | 9 | ✔ |  |  |
| oe_test_libsmi_smidump_05 | Test "libsmi" command | pre_test/run_test/post_test | 11 | ✔ |  |  |
| oe_test_libsmi_smidump_06 | Test "libsmi" command | pre_test/run_test/post_test | 9 | ✔ |  |  |
| oe_test_libsmi_smidump_07 | Test "libsmi" command | pre_test/run_test/post_test | 9 | ✔ |  |  |
| oe_test_libsmi_smilint | Test "libsmi" command | pre_test/run_test/post_test | 11 | ✔ |  |  |
| oe_test_libsmi_smiquery | Test "libsmi" command | pre_test/run_test/post_test | 11 | ✔ |  |  |
| oe_test_libsmi_smistrip | Test "libsmi" command | pre_test/run_test/post_test | 7 | ✔ |  |  |
| oe_test_libsmi_smixlate | Test "libsmi" command | pre_test/run_test/post_test | 10 | ✔ |  |  |

### 断言与命令明细

#### oe_test_libsmi_smicache

- 描述：Test "libsmi" command
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "L$LINENO: -V No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -h No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -d dir No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -p prefix No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: mib No Pass"
```

- 涉及命令：smicache×4, mkdir×1

#### oe_test_libsmi_smidiff

- 描述：Test "libsmi" command
- 函数：`pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $? 0 0 "L$LINENO: -V No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -c, --config=file No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -h, --help No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -i, --ignore=prefix No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -l, --level=level No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -m, --error-names  No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -p, --preload=module  No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -s, --severity No Pass"
```

- 涉及命令：smidiff×8

#### oe_test_libsmi_smidump_01

- 描述：Test "libsmi" command
- 函数：`pre_test, run_test, post_test`
- 断言（11 条）：

```
  CHECK_RESULT $? 0 0 "L$LINENO: -V, --version No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -h, --help No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -q, --quiet No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -c, --config=file No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -p, --preload=module No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -l, --level=level No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -m, --error-names No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -s, --severity No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -o, --output=name No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -u, --unified No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -k, --keep-going No Pass"
```

- 涉及命令：smidump×11

#### oe_test_libsmi_smidump_02

- 描述：Test "libsmi" command
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "L$LINENO: -f cm No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -f cm --cm-explain No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -f corba No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -f identifiers No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -f identifiers --identifiers-lines No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -f identifiers --identifiers-path No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -f identifiers --identifiers-ctag No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -f imports No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -f jax imports No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -f jax --jax-package imports No Pass"
```

- 涉及命令：smidump×10

#### oe_test_libsmi_smidump_03

- 描述：Test "libsmi" command
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "L$LINENO: -f metrics No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -f metrics --metrics-raw No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -f mosy No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -f netsnmp No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -f netsnmp --netsnmp-no-mgr-stubs No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -f netsnmp --netsnmp-no-agt-stubs No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -f perl No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -f python No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -f sming No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -f smiv1 No Pass"
```

- 涉及命令：smidump×10

#### oe_test_libsmi_smidump_04

- 描述：Test "libsmi" command
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 "L$LINENO: -f smiv2 No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -f sppi No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -f scli No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -f scli --scli-prefix=string No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -f scli --scli-include=string No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -f scli --scli-exclude=string No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -f scli --scli-set No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -f scli --scli-create No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -f scli --scli-delete No Pass"
```

- 涉及命令：smidump×9

#### oe_test_libsmi_smidump_05

- 描述：Test "libsmi" command
- 函数：`pre_test, run_test, post_test`
- 断言（11 条）：

```
  CHECK_RESULT $? 0 0 "L$LINENO: -f svg No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -f svg --svg-width=number No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -f svg --svg-height=number No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -f svg --svg-show-deprecated No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -f svg --svg-show-depr-obsolete No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -f svg --svg-static-output No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -f tree No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -f  tree --tree-no-conformance No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -f  tree --tree-no-leafs No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -f  tree --tree-full-root No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -f  tree --tree-compact No Pass"
```

- 涉及命令：smidump×11

#### oe_test_libsmi_smidump_06

- 描述：Test "libsmi" command
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 "L$LINENO: -f types No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -f types --types-no-implicit No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -f sizes No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -f sizes --sizes-variables No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -f xml No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -f xml --xml-no-schema No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -f xml --xml-no-doctype No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -f compliances No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -f boilerplate No Pass"
```

- 涉及命令：smidump×9

#### oe_test_libsmi_smidump_07

- 描述：Test "libsmi" command
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 "L$LINENO: -f xsd No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -f xsd --xsd-schema-url=string No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -f xsd --xsd-container No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -f xsd --xsd-nest-augments No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -f xsd --xsd-nest-subtables No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -f yang No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -f yang --yang-smi-extensions No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -f yang --yang-no-notifications No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -f yang --yang-indent=number No Pass"
```

- 涉及命令：smidump×9

#### oe_test_libsmi_smilint

- 描述：Test "libsmi" command
- 函数：`pre_test, run_test, post_test`
- 断言（11 条）：

```
  CHECK_RESULT $? 0 0 "L$LINENO: -V, --version No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -h, --help No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -c, --config=file No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -p, --preload=module No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -e, --error-list No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -m, --error-names No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -s, --severity No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -r, --recursive No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -l, --level=level No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -i, --ignore=prefix No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: --noignore=prefix No Pass"
```

- 涉及命令：smilint×11

#### oe_test_libsmi_smiquery

- 描述：Test "libsmi" command
- 函数：`pre_test, run_test, post_test`
- 断言（11 条）：

```
  CHECK_RESULT $? 0 0 "L$LINENO: -V, --version No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -h, --help No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -c, --config=file No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -p, --preload=module No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: module <module> No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: imports <module> No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: node <module::name> No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: compliance <module::name> No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: children <module::name> No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: type <module::name> No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: macro <module::name>  No Pass"
```

- 涉及命令：smiquery×4

#### oe_test_libsmi_smistrip

- 描述：Test "libsmi" command
- 函数：`pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $? 0 0 "L$LINENO: -V No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -h No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -n No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -i dir No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -d dir No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -m module No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: file1 ... No Pass"
```

- 涉及命令：smistrip×6

#### oe_test_libsmi_smixlate

- 描述：Test "libsmi" command
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "L$LINENO: -V, --version No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -h, --help No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -c, --config=file No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -p, --preload=module No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -r, --recursive No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -l, --level=level No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -i, --ignore=prefix No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -I, --noignore=prefix No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -a, --all  No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -f, --format No Pass"
```

- 涉及命令：smixlate×2
