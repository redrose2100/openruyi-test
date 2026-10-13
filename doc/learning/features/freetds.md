# freetds

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/freetds` |
| 注册用例数 | 4 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_freetds_datacopy | verify the uasge of freetds command | pre_test/run_test/post_test | 6 |  |  |  |
| oe_test_freetds_fisql | verify the uasge of freetds command | pre_test/run_test/post_test | 10 |  |  |  |
| oe_test_freetds_freebcp | verify the uasge of freetds command | pre_test/run_test/post_test | 8 |  |  |  |
| oe_test_freetds_tsql | verify the uasge of freetds command | pre_test/run_test/post_test | 5 |  |  |  |

### 断言与命令明细

#### oe_test_freetds_datacopy

- 描述：verify the uasge of freetds command
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "Check bsqldb -U -P -S -D -i -o -e failed"
  CHECK_RESULT $? 0 0 "Check bsqlodbc -U -P -S -D -i -o -e failed"
  CHECK_RESULT $? 0 0 "Check datacopy -t failed"
  CHECK_RESULT $? 0 0 "Check datacopy -a failed"
  CHECK_RESULT $? 0 0 "Check datacopy -S -c failed"
  CHECK_RESULT $? 0 0 "Check defncopy -i -o -e failed"
```

- 涉及命令：bsqldb×3, datacopy×3, bsqlodbc×1, defncopy×1

#### oe_test_freetds_fisql

- 描述：verify the uasge of freetds command
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Check fisql -v failed"
  CHECK_RESULT $? 0 0 "Check fisql -g failed"
  CHECK_RESULT $? 0 0 "Check fisql -e failed"
  CHECK_RESULT $? 0 0 "Check fisql -t -s -w failed"
  CHECK_RESULT $? 0 0 "Check fisql -E -I -y -c -H failed"
  CHECK_RESULT $? 0 0 "Check fisql -h failed"
  CHECK_RESULT $? 0 0 "Check fisql -F failed"
  CHECK_RESULT $? 0 0 "Check fisql -n failed"
  CHECK_RESULT $? 0 0 "Check fisql -X failed"
  CHECK_RESULT $? 0 0 "Check fisql -Y failed"
```

- 涉及命令：fisql×10

#### oe_test_freetds_freebcp

- 描述：verify the uasge of freetds command
- 函数：`pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $? 0 0 "Check freebcp out -c failed"
  CHECK_RESULT $? 0 0 "Check freebcp out -e -I -m -F -L -b -t -r failed"
  CHECK_RESULT $? 0 0 "Check freebcp out -d -c failed"
  CHECK_RESULT $? 0 0 "Check freebcp out -v failed"
  CHECK_RESULT $? 0 0 "Check freebcp out -h failed"
  CHECK_RESULT $? 0 0 "Check freebcp out -T -A -O failed"
  CHECK_RESULT $? 0 0 "Check freebcp in -n failed"
  CHECK_RESULT $? 0 0 "Check freebcp queryout -d -c failed"
```

- 涉及命令：bsqldb×1

#### oe_test_freetds_tsql

- 描述：verify the uasge of freetds command
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "Check tsql f failed"
  CHECK_RESULT $? 0 0 "Check tsql h failed"
  CHECK_RESULT $? 0 0 "Check tsql t failed"
  CHECK_RESULT $? 0 0 "Check tsql v failed"
  CHECK_RESULT $? 0 0 "Check tsql q failed"
```

- 涉及命令：bsqldb×1
