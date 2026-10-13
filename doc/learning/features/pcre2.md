# pcre2

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/pcre2` |
| 注册用例数 | 1 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_pcre2grep | the function of pcre2grep | pre_test/run_test/post_test | 3 | ✔ |  |  |

### 断言与命令明细

#### oe_test_pcre2grep

- 描述：the function of pcre2grep
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT "$(pcre2-config --version)" "$(rpm -qa pcre2-devel |awk -F "-" '{print $3}')" 0 "get dversion info"
  CHECK_RESULT "$(echo -e 'name:zhangsan,age:18\nname:lisi,age:20' | pcre2grep -O '$1 $2' 'name:(\w+),age:(\d+)')" "$(echo -e 'zhangsan 18\nlisi 20')" 0 "pcre2grep output text"
  CHECK_RESULT "$(echo -e 'name:zhangsan,age:18\nname:lisi,age:20' | pcre2grep -O '$1' 'name:(\w+),age:(\d+)')" "$(echo -e 'zhangsan\nlisi')" 0 "pcre2grep output text"
```
