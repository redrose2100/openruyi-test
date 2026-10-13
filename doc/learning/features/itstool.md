# itstool

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/itstool` |
| 注册用例数 | 3 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_itstool_base_01 | Test itstool | pre_test/run_test/post_test | 15 | ✔ |  |  |
| oe_test_itstool_base_02 | Test itstool | pre_test/run_test/post_test | 8 | ✔ |  |  |
| oe_test_itstool | Test itstool | pre_test/run_test/post_test | 8 | ✔ |  |  |

### 断言与命令明细

#### oe_test_itstool_base_01

- 描述：Test itstool
- 函数：`pre_test, run_test, post_test`
- 断言（15 条）：

```
  CHECK_RESULT $? 0 0 "itstool --help failed"
  CHECK_RESULT $? 0 0 "itstool -h failed"
  CHECK_RESULT $? 0 0 "itstool -i failed"
  CHECK_RESULT $? 0 0 "itstool --its failed"
  CHECK_RESULT $? 0 0 "itstool -m failed"
  CHECK_RESULT $? 0 0 "itstool --merge failed"
  CHECK_RESULT $? 0 0 "itstool -l failed"
  CHECK_RESULT $? 0 0 "itstool --lang failed"
  CHECK_RESULT $? 0 0 "itstool -n failed"
  CHECK_RESULT $? 0 0 "itstool --nobuitins failed"
  CHECK_RESULT $? 0 0 "itstool --path failed"
  CHECK_RESULT $? 1 0 "itstool -s failed"
  ... 共 15 条（其余见源脚本）
```

- 涉及命令：itstool×7

#### oe_test_itstool_base_02

- 描述：Test itstool
- 函数：`pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $? 0 0 "itstool -k failed"
  CHECK_RESULT $? 0 0 "itstool --keep-entities failed"
  CHECK_RESULT $? 0 0 "itstool -p failed"
  CHECK_RESULT $? 0 0 "itstool --param failed"
  CHECK_RESULT $? 0 0 "itstool -t failed"
  CHECK_RESULT $? 0 0 "itstool --test failed"
  CHECK_RESULT $? 0 0 "itstool --version failed"
  CHECK_RESULT $? 0 0 "itstool -v failed"
```

- 涉及命令：itstool×3

#### oe_test_itstool

- 描述：Test itstool
- 函数：`pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $? 0 0 "itstool -o failed"
  CHECK_RESULT $? 0 0 "Failed to generate out/out-o.pot"
  CHECK_RESULT $? 0 0 "itstool --output failed"
  CHECK_RESULT $? 0 0 "Failed to generate out/out--out.pot"
  CHECK_RESULT $? 0 0 "itstool -j failed"
  CHECK_RESULT $? 0 0 "Failed to generate out/out-j.xml"
  CHECK_RESULT $? 0 0 "itstool --join failed"
  CHECK_RESULT $? 0 0 "Failed to generate out/out-j.xml"
```

- 涉及命令：itstool×1
