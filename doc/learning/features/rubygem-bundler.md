# rubygem-bundler

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/rubygem-bundler` |
| 注册用例数 | 14 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_rubygem-bundler_bundle_01 | exrstdattr | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_rubygem-bundler_bundle_02 | exrstdattr | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_rubygem-bundler_bundle_03 | exrstdattr | pre_test/run_test/post_test | 9 | ✔ |  |  |
| oe_test_rubygem-bundler_bundle_04 | exrstdattr | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_rubygem-bundler_bundle_05 | exrstdattr | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_rubygem-bundler_bundle_06 | exrstdattr | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_rubygem-bundler_bundle_07 | exrstdattr | pre_test/run_test/post_test | 9 | ✔ |  |  |
| oe_test_rubygem-bundler_bundle_08 | exrstdattr | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_rubygem-bundler_bundle_09 | exrstdattr | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_rubygem-bundler_bundle_10 | exrstdattr | pre_test/run_test/post_test | 12 | ✔ |  |  |
| oe_test_rubygem-bundler_bundle_11 | exrstdattr | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_rubygem-bundler_bundle_12 | exrstdattr | pre_test/run_test/post_test | 9 | ✔ |  |  |
| oe_test_rubygem-bundler_bundle_13 | exrstdattr | pre_test/run_test/post_test | 9 | ✔ |  |  |
| oe_test_rubygem-bundler_bundle_14 | exrstdattr | pre_test/run_test/post_test | 10 | ✔ |  |  |

### 断言与命令明细

#### oe_test_rubygem-bundler_bundle_01

- 描述：exrstdattr
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Check bundle init failed."
  CHECK_RESULT $? 0 0 "Check bundle init -r 2 failed."
  CHECK_RESULT $? 0 0 "Check bundle init -V failed."
  CHECK_RESULT $? 0 0 "Check bundle gem failed."
  CHECK_RESULT $? 0 0 "Check bundle gem testgem -t failed."
  CHECK_RESULT $? 0 0 "Check gem testgem -e failed."
  CHECK_RESULT $? 0 0 "Check gem testgem -V failed."
  CHECK_RESULT $? 0 0 "Check gem testgem --exe failed."
  CHECK_RESULT $? 1 0 "Check gem testgem --no-exe failed."
  CHECK_RESULT $? 1 0 "Check gem testgem --no-coc failed."
```

#### oe_test_rubygem-bundler_bundle_02

- 描述：exrstdattr
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Check gem testgem --coc failed."
  CHECK_RESULT $? 0 0 "Check gem testgem --ext failed."
  CHECK_RESULT $? 1 0 "Check gem testgem --no-ext failed."
  CHECK_RESULT $? 0 0 "Check gem testgem --mit failed."
  CHECK_RESULT $? 1 0 "Check gem testgem --no-mit failed."
  CHECK_RESULT $? 0 0 "Check gem testgem --ci failed."
  CHECK_RESULT $? 0 0 "Check bundle update --all failed."
  CHECK_RESULT $? 0 0 "Check bundle update --group failed."
  CHECK_RESULT $? 0 0 "Check bundle update --source failed."
  CHECK_RESULT $? 0 0 "Check bundle update --ruby failed."
```

#### oe_test_rubygem-bundler_bundle_03

- 描述：exrstdattr
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 "Check bundle update --conservative failed."
  CHECK_RESULT $? 0 0 "Check bundle update --full-index failed."
  CHECK_RESULT $? 0 0 "Check bundle update -j failed."
  CHECK_RESULT $? 0 0 "Check bundle update --strict failed."
  CHECK_RESULT $? 1 0 "Check bundle update --quiet failed."
  CHECK_RESULT $? 0 0 "Check bundle update --redownload failed."
  CHECK_RESULT $? 0 0 "Check bundle update --patch failed."
  CHECK_RESULT $? 0 0 "Check bundle update --minor failed."
  CHECK_RESULT $? 0 0 "Check bundle update --major failed."
```

#### oe_test_rubygem-bundler_bundle_04

- 描述：exrstdattr
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Check bundle show failed."
  CHECK_RESULT $? 0 0 "Check bundle show -V failed."
  CHECK_RESULT $? 0 0 "Check bundle show --paths failed."
  CHECK_RESULT $? 0 0 "Check bundle update failed."
  CHECK_RESULT $? 0 0 "Check bundle update --bundler failed."
  CHECK_RESULT $? 0 0 "Check bundle update -r failed."
  CHECK_RESULT $? 0 0 "Check bundle update -V failed."
  CHECK_RESULT $? 0 0 "Check bundle update --local failed."
  CHECK_RESULT $? 0 0 "Check bundle update --force failed."
  CHECK_RESULT $? 0 0 "Check bundle check failed."
```

#### oe_test_rubygem-bundler_bundle_05

- 描述：exrstdattr
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Check bundle check --dry-run failed."
  CHECK_RESULT $? 0 0 "Check bundle check --gemfile failed."
  CHECK_RESULT $? 0 0 "Check bundle check --path failed."
  CHECK_RESULT $? 0 0 "Check bundle console failed."
  CHECK_RESULT $? 0 0 "Check bundle console -r failed."
  CHECK_RESULT $? 0 0 "Check bundle console -V failed."
  CHECK_RESULT $? 0 0 "Check bundle console -h failed."
  CHECK_RESULT $? 0 0 "Check bundle env failed."
  CHECK_RESULT $? 0 0 "Check bundle -r  failed."
  CHECK_RESULT $? 0 0 "Check bundle -V failed."
```

#### oe_test_rubygem-bundler_bundle_06

- 描述：exrstdattr
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Check bundle version failed."
  CHECK_RESULT $? 0 0 "Check bundle version -r failed."
  CHECK_RESULT $? 0 0 "Check bundle version -V failed."
  CHECK_RESULT $? 0 0 "Check bundle version -h failed."
  CHECK_RESULT $? 0 0 "Check bundle doctor failed."
  CHECK_RESULT $? 0 0 "Check bundle doctor --quiet failed."
  CHECK_RESULT $? 0 0 "Check bundle doctor --gemfile failed."
  CHECK_RESULT $? 0 0 "Check bundle help failed."
  CHECK_RESULT $? 0 0 "Check bundle help -r failed."
  CHECK_RESULT $? 0 0 "Check bundle help -V failed."
```

#### oe_test_rubygem-bundler_bundle_07

- 描述：exrstdattr
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 "Check bundle info failed."
  CHECK_RESULT $? 0 0 "Check bundle info bundler --path failed."
  CHECK_RESULT $? 0 0 "Check bundle binstubs failed."
  CHECK_RESULT $? 0 0 "Check bundle binstubs --force failed."
  CHECK_RESULT $? 0 0 "Check bundle binstubs --path failed."
  CHECK_RESULT $? 0 0 "Check bundle binstubs --shebang failed."
  CHECK_RESULT $? 0 0 "Check bundle binstubs --standalone failed."
  CHECK_RESULT $? 0 0 "Check bundle exec failed."
  CHECK_RESULT $? 0 0 "Check bundle open failed."
```

#### oe_test_rubygem-bundler_bundle_08

- 描述：exrstdattr
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Check bundle licenses failed."
  CHECK_RESULT $? 0 0 "Check bundle licenses --no-color failed."
  CHECK_RESULT $? 0 0 "Check bundle licenses -r failed."
  CHECK_RESULT $? 0 0 "Check bundle licenses -V failed."
  CHECK_RESULT $? 0 0 "Check bundle pristine failed."
  CHECK_RESULT $? 0 0 "Check bundle install failed."
  CHECK_RESULT $? 0 0 "Check bundle install--binstubs  failed."
  CHECK_RESULT $? 0 0 "Check bundle install --clean failed."
  CHECK_RESULT $? 0 0 "Check bundle install --deployment  failed."
  CHECK_RESULT $? 0 0 "Check bundle install --frozen failed."
```

#### oe_test_rubygem-bundler_bundle_09

- 描述：exrstdattr
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Check bundle install --no-full-index failed."
  CHECK_RESULT $? 0 0 "Check bundle install --gemfile failed."
  CHECK_RESULT $? 0 0 "Check bundle install -j failed."
  CHECK_RESULT $? 0 0 "Check bundle install --local failed."
  CHECK_RESULT $? 0 0 "Check bundle install --no-cache failed."
  CHECK_RESULT $? 0 0 "Check bundle install --force failed."
  CHECK_RESULT $? 0 0 "Check bundle install --no-prune failed."
  CHECK_RESULT $? 0 0 "Check bundle install --path failed."
  CHECK_RESULT $? 1 0 "Check bundle install --quiet failed."
  CHECK_RESULT $? 0 0 "Check bundle install --clean failed."
```

#### oe_test_rubygem-bundler_bundle_10

- 描述：exrstdattr
- 函数：`pre_test, run_test, post_test`
- 断言（12 条）：

```
  CHECK_RESULT $? 0 0 "Check bundle install --system failed."
  CHECK_RESULT $? 0 0 "Check bundle install --shebang failed."
  CHECK_RESULT $? 0 0 "Check bundle install --trust-policy failed."
  CHECK_RESULT $? 0 0 "Check bundle config list failed."
  CHECK_RESULT $? 0 0 "Check bundle config get path failed."
  CHECK_RESULT $? 0 0 "Check bundle config set failed."
  CHECK_RESULT $? 1 0 "Check bundle config unset failed."
  CHECK_RESULT $? 0 0 "Check bundle config set --global failed."
  CHECK_RESULT $? 1 0 "Check bundle config unset --global failed."
  CHECK_RESULT $? 0 0 "Check bundle config set --local failed."
  CHECK_RESULT $?
  CHECK_RESULT $? 1 0 "Check bundle config unset --local failed."
```

#### oe_test_rubygem-bundler_bundle_11

- 描述：exrstdattr
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $? 1 0 "Check bundle config unset --local failed."
  CHECK_RESULT $? 0 0 "Check bundle lock failed."
  CHECK_RESULT $? 0 0 "Check bundle lock --update failed."
  CHECK_RESULT $? 0 0 "Check bundle lock --local failed."
  CHECK_RESULT $? 0 0 "Check bundle lock --print failed."
  CHECK_RESULT $? 0 0 "Check bundle lock --lockfile failed."
  CHECK_RESULT $? 0 0 "Check bundle lock --no-full-index failed."
  CHECK_RESULT $? 0 0 "Check bundle lock --patch failed."
  CHECK_RESULT $? 0 0 "Check bundle lock --minor failed."
```

#### oe_test_rubygem-bundler_bundle_12

- 描述：exrstdattr
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 "Check bundle lock --minor failed."
  CHECK_RESULT $? 0 0 "Check bundle lock --minor failed."
  CHECK_RESULT $? 0 0 "Check bundle lock --minor failed."
  CHECK_RESULT $? 0 0 "Check bundle lock --minor failed."
  CHECK_RESULT $? 0 0 "Check bundle lock --minor failed."
  CHECK_RESULT $? 0 0 "Check bundle lock --minor failed."
  CHECK_RESULT $? 0 0 "Check bundle platform failed."
  CHECK_RESULT $? 0 0 "Check bundle platform --ruby failed."
  CHECK_RESULT $? 0 0 "Check bundle cache failed."
```

#### oe_test_rubygem-bundler_bundle_13

- 描述：exrstdattr
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 "Check bundle list failed."
  CHECK_RESULT $? 0 0 "Check list --name-only failed."
  CHECK_RESULT $? 0 0 "Check list --paths failed."
  CHECK_RESULT $? 0 0 "Check bundle plugin failed."
  CHECK_RESULT $? 0 0 "Check bundle plugin list failed."
  CHECK_RESULT $? 0 0 "Check bundle plugin help failed."
  CHECK_RESULT $? 1 0 "Check bundle clean failed."
  CHECK_RESULT $? 0 0 "Check bundle clean --dry-run failed."
  CHECK_RESULT $? 0 0 "Check bundle  clean --force failed."
```

#### oe_test_rubygem-bundler_bundle_14

- 描述：exrstdattr
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Check bundle outdated failed."
  CHECK_RESULT $? 0 0 "Check bundle outdated --local failed."
  CHECK_RESULT $? 0 0 "Check bundle outdated --pre failed."
  CHECK_RESULT $? 0 0 "Check bundle outdated --source failed."
  CHECK_RESULT $? 0 0 "Check bundle outdated --strict failed."
  CHECK_RESULT $? 0 0 "Check bundle outdated --only-explicit failed."
  CHECK_RESULT $? 0 0 "Check bundle outdated --group failed."
  CHECK_RESULT $? 0 0 "Check bundle outdated --groups failed."
  CHECK_RESULT $? 0 0 "Check bundle outdated --update-strict failed."
  CHECK_RESULT $? 0 0 "Check bundle outdated --minor failed."
```
