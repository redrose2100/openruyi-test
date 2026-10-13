# bird

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/bird` |
| 注册用例数 | 9 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_birdcl_01 | verification birdcl command | pre_test/run_test/post_test | 7 | ✔ |  |  |
| oe_test_birdcl_02 | verification birdcl command | pre_test/run_test/post_test | 6 | ✔ |  |  |
| oe_test_birdcl_03 | verification birdcl command | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_birdc_01 | verification birdc command | pre_test/run_test/post_test | 7 | ✔ |  |  |
| oe_test_birdc_02 | verification birdc command | pre_test/run_test/post_test | 6 | ✔ |  |  |
| oe_test_birdc_03 | verification birdc command | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_bird_01 | verification bird command | pre_test/run_test/post_test | 9 | ✔ |  |  |
| oe_test_bird_02 | verification bird command | pre_test/run_test/post_test | 5 | ✔ |  |  |
| oe_test_service_bird | Test bird.service restart | pre_test/run_test/post_test | 2 | ✔ |  |  |

### 断言与命令明细

#### oe_test_birdcl_01

- 描述：verification birdcl command
- 函数：`pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $? 0 0 "check birdcl exit failed"
  CHECK_RESULT $? 0 0 "check birdcl exit failed"
  CHECK_RESULT $? 0 0 "check birdcl help failed"
  CHECK_RESULT $? 0 0 "check birdcl show failed"
  CHECK_RESULT $? 0 0 "check birdcl dump failed"
  CHECK_RESULT $? 0 0 "check birdcl eval failed"
  CHECK_RESULT $? 0 0 "check birdcl disable failed"
```

- 涉及命令：bird×1

#### oe_test_birdcl_02

- 描述：verification birdcl command
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "check birdcl enable failed"
  CHECK_RESULT $? 0 0 "check birdcl restart failed"
  CHECK_RESULT $? 0 0 "check birdcl reload failed"
  CHECK_RESULT $? 0 0 "check birdcl restrict failed"
  CHECK_RESULT $? 0 0 "check birdcl configure failed"
  CHECK_RESULT $? 0 0 "check birdcl down failed"
```

- 涉及命令：bird×1

#### oe_test_birdcl_03

- 描述：verification birdcl command
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "check birdcl graceful restart failed"
  CHECK_RESULT $? 0 0 "check birdcl echo failed"
  CHECK_RESULT $? 0 0 "check birdcl debug failed"
  CHECK_RESULT $? 0 0 "check birdcl mrtdump failed"
```

- 涉及命令：bird×2

#### oe_test_birdc_01

- 描述：verification birdc command
- 函数：`pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $? 0 0 "check birdc exit failed"
  CHECK_RESULT $? 0 0 "check birdc exit failed"
  CHECK_RESULT $? 0 0 "check birdc help failed"
  CHECK_RESULT $? 0 0 "check birdc show failed"
  CHECK_RESULT $? 0 0 "check birdc dump failed"
  CHECK_RESULT $? 0 0 "check birdc eval failed"
  CHECK_RESULT $? 0 0 "check birdc disable failed"
```

- 涉及命令：bird×1

#### oe_test_birdc_02

- 描述：verification birdc command
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "check birdc enable failed"
  CHECK_RESULT $? 0 0 "check birdc restart failed"
  CHECK_RESULT $? 0 0 "check birdc reload failed"
  CHECK_RESULT $? 0 0 "check birdc restrict failed"
  CHECK_RESULT $? 0 0 "check birdc configure failed"
  CHECK_RESULT $? 0 0 "check birdc down failed"
```

- 涉及命令：bird×1

#### oe_test_birdc_03

- 描述：verification birdc command
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "check birdc graceful restart failed"
  CHECK_RESULT $? 0 0 "check birdc echo failed"
  CHECK_RESULT $? 0 0 "check birdc debug failed"
  CHECK_RESULT $? 0 0 "check birdc mrtdump failed"
```

- 涉及命令：bird×2

#### oe_test_bird_01

- 描述：verification bird command
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 "check bird -h failed"
  CHECK_RESULT $? 0 0 "check bird --help failed"
  CHECK_RESULT $? 0 0 "check bird --version failed"
  CHECK_RESULT $? 0 0 "check bird -c failed"
  CHECK_RESULT $? 0 0 "check bird -d failed"
  CHECK_RESULT $? 0 0 "check bird -D failed"
  CHECK_RESULT $? 0 0 "check bird -f failed"
  CHECK_RESULT $? 0 0 "check bird -u failed"
  CHECK_RESULT $? 0 0 "check bird -g failed"
```

- 涉及命令：bird×7, pgrep×2, test×1, userdel×1

#### oe_test_bird_02

- 描述：verification bird command
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "check bird -l failed"
  CHECK_RESULT $? 0 0 "check bird -p failed"
  CHECK_RESULT $? 0 0 "check bird -P failed"
  CHECK_RESULT $? 0 0 "check bird -R failed"
  CHECK_RESULT $? 0 0 "check bird -s failed"
```

- 涉及命令：bird×5, grep×1

#### oe_test_service_bird

- 描述：Test bird.service restart
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "bird.service reload failed"
  CHECK_RESULT $? 0 0 "bird.service reload causes the service status to change"
```

- 涉及命令：sed×2
