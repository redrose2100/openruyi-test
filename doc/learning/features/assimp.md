# assimp

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/assimp` |
| 注册用例数 | 2 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_assimp_01 | Test assimp | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_assimp_02 | Test assimp | pre_test/run_test/post_test | 8 | ✔ |  |  |

### 断言与命令明细

#### oe_test_assimp_01

- 描述：Test assimp
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "test assimp help failed"
  CHECK_RESULT $? 0 0 "test assimp version failed"
  CHECK_RESULT $? 0 0 "test assimp listext failed"
  CHECK_RESULT $? 0 0 "test assimp info failed"
  CHECK_RESULT $? 0 0 "test assimp knowext failed"
  CHECK_RESULT $? 0 0 "test assimp listexport failed"
  CHECK_RESULT $? 0 0 "test assimp export --help failed"
  CHECK_RESULT $? 0 0 "test assimp export failed"
  CHECK_RESULT $? 0 0 "test assimp extract --help failed"
  CHECK_RESULT $? 0 0 "test assimp extract -ba failed"
```

- 涉及命令：tar×1

#### oe_test_assimp_02

- 描述：Test assimp
- 函数：`pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $? 0 0 "test assimp extract -t failed"
  CHECK_RESULT $? 0 0 "test assimp extract -f failed"
  CHECK_RESULT $? 0 0 "test assimp extract -cfast failed"
  CHECK_RESULT $? 0 0 "test assimp extract -cdefault failed"
  CHECK_RESULT $? 0 0 "test assimp extract -cfull failed"
  CHECK_RESULT $? 0 0 "test assimp exportinfo failed"
  CHECK_RESULT $? 0 0 "test assimp dump failed"
  CHECK_RESULT $? 0 0 "test assimp cmpdump failed"
```

- 涉及命令：tar×1
