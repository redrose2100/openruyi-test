# ansible

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/ansible` |
| 注册用例数 | 4 |
| 环境约束 | machine num = 2 |

> ⚠️ 本套件声明环境约束，执行前由 `check_environment.py` 预检；不满足的用例自动 skipped(255)。

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_ansible_01 | verification ansible's commnd | pre_test/run_test/post_test | 16 |  |  | 60m |
| oe_test_ansible_02 | verification ansible's commnd | pre_test/run_test/post_test | 8 |  |  |  |
| oe_test_ansible_03 | verification ansible's commnd | pre_test/run_test/post_test | 10 |  |  |  |
| oe_test_ansible_04 | verification ansible's commnd | pre_test/run_test/post_test | 11 |  |  |  |

### 断言与命令明细

#### oe_test_ansible_01

- 描述：verification ansible's commnd
- 函数：`pre_test, run_test, post_test`
- 断言（16 条）：

```
  CHECK_RESULT $? 0 0 "Check ansible --version failed."
  CHECK_RESULT $? 0 0 "Check ansible --help failed."
  CHECK_RESULT $? 0 0 "Check ansible -mfailed."
  CHECK_RESULT $? 0 0 "Check ansible -m ping failed."
  CHECK_RESULT $? 0 0 "Check ansible -e failed."
  CHECK_RESULT $? 0 0 "Check ansible -a failed."
  CHECK_RESULT $? 0 0 "Check ansible -m update failed."
  CHECK_RESULT $? 0 0 "Check ansible -m date -R failed."
  CHECK_RESULT $? 0 0 "Check ansible -m shell failed."
  CHECK_RESULT $? 0 0 "Check ansible -m group failed."
  CHECK_RESULT $? 0 0 "Check ansible -m user failed."
  CHECK_RESULT $? 0 0 "Check ansible -m -a remove failed."
  ... 共 16 条（其余见源脚本）
```

#### oe_test_ansible_02

- 描述：verification ansible's commnd
- 函数：`pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $? 0 0 "Check ansible-config --version failed."
  CHECK_RESULT $? 0 0 "Check ansible-config --help failed."
  CHECK_RESULT $? 0 0 "Check ansible-config view failed."
  CHECK_RESULT $? 0 0 "Check ansible-config dump failed."
  CHECK_RESULT $? 0 0 "Check ansible-config list -v failed."
  CHECK_RESULT $? 0 0 "Check ansible-console --help failed."
  CHECK_RESULT $? 0 0 "Check ansible-console --version failed."
  CHECK_RESULT $? 0 0 "Check ansible-console failed."
```

#### oe_test_ansible_03

- 描述：verification ansible's commnd
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Check ansible-doc --help failed."
  CHECK_RESULT $? 0 0 "Check ansible-doc --version failed."
  CHECK_RESULT $? 0 0 "Check ansible-doc -l failed."
  CHECK_RESULT $? 0 0 "Check ansible-doc -s failed."
  CHECK_RESULT $? 0 0 "Check ansible-doc -a failed."
  CHECK_RESULT $? 0 0 "Check ansible-galaxy --help failed."
  CHECK_RESULT $? 0 0 "Check ansible-galaxy --version failed."
  CHECK_RESULT $? 0 0 "Check ansible-galaxy list failed."
  CHECK_RESULT $? 0 0 "Check ansible-galaxy search failed."
  CHECK_RESULT $? 0 0 "Check ansible-galaxy info failed."
```

#### oe_test_ansible_04

- 描述：verification ansible's commnd
- 函数：`pre_test, run_test, post_test`
- 断言（11 条）：

```
  CHECK_RESULT $? 0 0 "Check ansible-inventory --help failed."
  CHECK_RESULT $? 0 0 "Check ansible-inventory --version failed."
  CHECK_RESULT $? 0 0 "Check ansible-console failed."
  CHECK_RESULT $? 0 0 "Check ansible-console --ask-vault-pass failed."
  CHECK_RESULT $? 0 0 "Check ansible-console --vault-password failed."
  CHECK_RESULT $? 0 0 "Check ansible-playbook --help failed."
  CHECK_RESULT $? 0 0 "Check ansible-playbook --version failed."
  CHECK_RESULT $? 0 0 "Check ansible-pull --help failed."
  CHECK_RESULT $? 0 0 "Check ansible-pull --version failed."
  CHECK_RESULT $? 0 0 "Check ansible-vault --help failed."
  CHECK_RESULT $? 0 0 "Check ansible-vault --version failed."
```
