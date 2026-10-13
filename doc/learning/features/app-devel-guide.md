# app-devel-guide

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 文档域（doc-test） |
| 套件路径 | `$OET_PATH/testcases/doc-test/app-devel-guide` |
| 注册用例数 | 8 |
| 环境约束 | machine type = Kvm |

> ⚠️ 本套件声明环境约束，执行前由 `check_environment.py` 预检；不满足的用例自动 skipped(255)。

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_use_gcc_create_dynamic_link_library | Using gcc to create and use dynamic link libraries | pre_test/run_test/post_test | 6 | ✔ |  |  |
| oe_test_use_gcc_create_static_link_library | Using gcc to create and use dynamic link libraries | pre_test/run_test/post_test | 7 | ✔ |  |  |
| oe_test_use_gcc_compile_c_program | Using gcc compile C program | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_use_make_compile | Using Makefile for Compilation | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_jdk_compile_without_pkg | Compiling Java programs without packages using JDK | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_jdk_compile_with_pkg | Compiling Java programs with packages using JDK | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_local_build_rpm | Building RPM software packages locally | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_prepare_dev_env | Prepare the development environment | pre_test/run_test/post_test | 16 | ✔ |  |  |

### 断言与命令明细

#### oe_test_use_gcc_create_dynamic_link_library

- 描述：Using gcc to create and use dynamic link libraries
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "Failed to create dynamic library libmath.so!"
  CHECK_RESULT $? 0 0 "The dynamic library does not exist in the lib directory!"
  CHECK_RESULT $? 0 0 "Compiling math.out failed!"
  CHECK_RESULT $? 0 0 "The math.out does not exist in the lib directory!"
  CHECK_RESULT $? 0 0 "Adding dynamic library to environment variable failed!"
  CHECK_RESULT $? 0 0 "Failed to execute math.out!"
```

- 涉及命令：test×2, mkdir×1, gcc×1, expect×1

#### oe_test_use_gcc_create_static_link_library

- 描述：Using gcc to create and use dynamic link libraries
- 函数：`pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $? 0 0 "Compiling add.c, sub.c failed!"
  CHECK_RESULT $? 0 0 "The add.o and sub.o does not exist!"
  CHECK_RESULT $? 0 0 "Failed to generate static library /home/code/lib/libmath.a!"
  CHECK_RESULT $? 0 0 "The libmath.a does not exist!"
  CHECK_RESULT $? 0 0 "Compiling math.out failed!"
  CHECK_RESULT $? 0 0 "The math.out does not exist in the lib directory!"
  CHECK_RESULT $? 0 0 "Failed to execute math.out!"
```

- 涉及命令：test×3, mkdir×1, gcc×1, expect×1

#### oe_test_use_gcc_compile_c_program

- 描述：Using gcc compile C program
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Compilation failed!"
  CHECK_RESULT $? 0 0 "Failed to run helloworld file!"
```

#### oe_test_use_make_compile

- 描述：Using Makefile for Compilation
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Failed to execute the make command!"
  CHECK_RESULT $? 0 0 "Failed to execute make file!"
```

#### oe_test_jdk_compile_without_pkg

- 描述：Compiling Java programs without packages using JDK
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Failed to execute 'javac HelloWorld.java'!"
  CHECK_RESULT $? 0 0 "Class file does not exist!"
  CHECK_RESULT $? 0 0 "Failed to execute 'java HelloWorld'!"
```

- 涉及命令：test×1

#### oe_test_jdk_compile_with_pkg

- 描述：Compiling Java programs with packages using JDK
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Javac compilation source file failed!"
  CHECK_RESULT $? 0 0 "Class file does not exist!"
  CHECK_RESULT $? 0 0 "Java failed to execute Test program!"
```

- 涉及命令：mkdir×1, javac×1, test×1, java×1

#### oe_test_local_build_rpm

- 描述：Building RPM software packages locally
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Failed to build RPM package"
  CHECK_RESULT $? 0 0 "Failed to check SRPMS file"
```

- 涉及命令：test×2, rpmbuild×1

#### oe_test_prepare_dev_env

- 描述：Prepare the development environment
- 函数：`pre_test, run_test, post_test`
- 断言（16 条）：

```
  CHECK_RESULT $? 0 0 "Failed to set repo!"
  CHECK_RESULT $? 0 0 "Clearing cache failed"
  CHECK_RESULT $? 0 0 "Failed to create cache"
  CHECK_RESULT $? 0 0 "Failed to install jdk"
  CHECK_RESULT $? 0 0 "JDK version error"
  CHECK_RESULT $? 0 0 "Clearing cache failed"
  CHECK_RESULT $? 0 0 "Failed to create cache"
  CHECK_RESULT $? 0 0 "Failed to install rpm!"
  CHECK_RESULT $? 0 0 "rpm-build version error!"
  CHECK_RESULT $? 0 0 "Java path error!"
  CHECK_RESULT $? 0 0 "Set java_home path error!"
  CHECK_RESULT $? 0 0 "Set PATH error!"
  ... 共 16 条（其余见源脚本）
```

- 涉及命令：java×1, test×1
