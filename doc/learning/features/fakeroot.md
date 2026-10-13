# fakeroot

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/fakeroot` |
| 注册用例数 | 2 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_fakeroot_base | verify the uasge of fakeroot command | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_fakeroot_faked | verify the uasge of fakeroot command | pre_test/run_test/post_test | 5 | ✔ |  |  |

### 断言与命令明细

#### oe_test_fakeroot_base

- 描述：verify the uasge of fakeroot command
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Check fakeroot -l -s -u failed"
  CHECK_RESULT $? 0 0 "Check fakeroot --lib -s --unknown-is-real failed"
  CHECK_RESULT $? 0 0 "Check fakeroot --lib -f --port --save-file --foreground --debug --load --unknown-is-real failed"
  CHECK_RESULT $? 0 0 "Check fakeroot --lib -i --unknown-is-real failed"
  CHECK_RESULT $? 0 0 "Check fakeroot --lib --faked --port --save-file --foreground --debug --load --unknown-is-real failed"
  CHECK_RESULT $? 0 0 "Check fakeroot --lib -b --unknown-is-real failed"
  CHECK_RESULT $? 0 0 "Check fakeroot --lib --fd-base --unknown-is-real failed"
  CHECK_RESULT $? 0 0 "Check fakeroot -l -- failed"
  CHECK_RESULT $? 0 0 "Check fakeroot -h failed"
  CHECK_RESULT $? 0 0 "Check fakeroot --help failed"
```

- 涉及命令：fakeroot×3

#### oe_test_fakeroot_faked

- 描述：verify the uasge of fakeroot command
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "Check faked --port --debug --unknown-is-real --load failed"
  CHECK_RESULT $? 0 0 "Check faked --foreground failed"
  CHECK_RESULT $? 0 0 "Check faked --cleanup --key --save-file failed"
  CHECK_RESULT $? 0 0 "Check fakeroot -v failed"
  CHECK_RESULT $? 0 0 "Check fakeroot --version failed"
```

- 涉及命令：fakeroot×1
