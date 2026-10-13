# postgresql

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/postgresql` |
| 注册用例数 | 42 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_postgresql_clusterdb | clusterdb | pre_test/run_test/post_test | 7 |  |  |  |
| oe_test_postgresql-contrib_oid2name01 | oid2name | pre_test/run_test/post_test | 9 |  |  |  |
| oe_test_postgresql-contrib_pg_archivecleanup | pg_archivecleanup oid2name | pre_test/run_test/post_test | 10 |  |  |  |
| oe_test_postgresql-contrib_pgbench01 | clusterdb | pre_test/run_test/post_test | 9 |  |  |  |
| oe_test_postgresql-contrib_pgbench02 | clusterdb | pre_test/run_test/post_test | 10 |  |  |  |
| oe_test_postgresql-contrib_pgbench03 | clusterdb | pre_test/run_test/post_test | 7 |  |  |  |
| oe_test_postgresql-contrib_pgbench04 | clusterdb | pre_test/run_test/post_test | 5 |  |  |  |
| oe_test_postgresql-contrib_pg_standby | pg_standby | pre_test/run_test/post_test | 18 |  |  |  |
| oe_test_postgresql-contrib_pg_test_fsync | pg_test_fsync pg_test_timing pg_upgrade | pre_test/run_test/post_test | 8 |  |  |  |
| oe_test_postgresql-contrib_pg_waldump | pg_waldump | pre_test/run_test/post_test | 8 |  |  |  |
| oe_test_postgresql-contrib_vacuumlo | vacuumlo | pre_test/run_test/post_test | 5 |  |  |  |
| oe_test_postgresql_createdb | createdb | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_postgresql_create_duplicate_db | Verify postgresql rejects duplicate database creation | pre_test/run_test/post_test | 6 | ✔ |  |  |
| oe_test_postgresql_createuser01 | createuser | pre_test/run_test/post_test | 19 |  |  |  |
| oe_test_postgresql_createuser02 | createuser | pre_test/run_test/post_test | 12 |  |  |  |
| oe_test_postgresql_create_duplicate_role | Verify postgresql rejects duplicate role creation | pre_test/run_test/post_test | 6 | ✔ |  |  |
| oe_test_postgresql-devel_ecpg | ecpg | pre_test/run_test/post_test | 22 |  |  |  |
| oe_test_postgresql-devel_pg_config01 | pg_config | pre_test/run_test/post_test | 10 |  |  |  |
| oe_test_postgresql-devel_pg_config02 | pg_config | pre_test/run_test/post_test | 14 |  |  |  |
| oe_test_postgresql_dropdb-dropuser | dropdb | pre_test/run_test/post_test | 12 |  |  |  |
| oe_test_postgresql_pg_dump01 | pg_dump | pre_test/run_test/post_test | 17 |  |  |  |
| oe_test_postgresql_pg_dump02 | pg_dump | pre_test/run_test/post_test | 16 |  |  |  |
| oe_test_postgresql_pg_dump03 | pg_dump | pre_test/run_test/post_test | 13 |  |  |  |
| oe_test_postgresql_pg_dumpall01 | pg_dumpall | pre_test/run_test/post_test | 16 |  |  |  |
| oe_test_postgresql_pg_isready | pg_isready pg_dumpall | pre_test/run_test/post_test | 13 |  |  |  |
| oe_test_postgresql_pg_restore01 | pg_restore | pre_test/run_test/post_test | 10 |  |  |  |
| oe_test_postgresql_pg_restore02 | pg_restore | pre_test/run_test/post_test | 10 |  |  |  |
| oe_test_postgresql_psql01 | psql | pre_test/run_test/post_test | 9 |  |  |  |
| oe_test_postgresql_psql02 | psql | pre_test/run_test/post_test | 8 |  |  |  |
| oe_test_postgresql_psql03 | psql | pre_test/run_test/post_test | 10 |  |  |  |
| oe_test_postgresql_reindexdb | reindexdb | pre_test/run_test/post_test | 15 |  |  |  |
| oe_test_postgresql-server_initdb | initdb | pre_test/run_test/post_test | 11 |  |  |  |
| oe_test_postgresql-server_pg_basebackup | pgsql_backup | pre_test/run_test/post_test | 10 |  |  |  |
| oe_test_postgresql-server_pg_ctl | pg_ctl | pre_test/run_test/post_test | 18 |  |  |  |
| oe_test_postgresql-server_pg_receivewal | pg_receivewal | pre_test/run_test/post_test | 19 |  |  |  |
| oe_test_postgresql-server_pg_recvlogical | pg_recvlogical | pre_test/run_test/post_test | 15 |  |  |  |
| oe_test_postgresql-server_pg_resetwal | pg_resetwal | pre_test/run_test/post_test | 14 |  |  |  |
| oe_test_postgresql-server_postgres01 | postgres | pre_test/run_test/post_test | 24 |  |  |  |
| oe_test_postgresql-server_postgres02 | postgres | pre_test/run_test/post_test | 20 |  |  |  |
| oe_test_postgresql-server_postgresql-setup | postgresql-setup pg_controldata pg_rewind | pre_test/run_test/post_test | 9 | ✔ |  |  |
| oe_test_postgresql_vacuumdb | vacuumdb | pre_test/run_test/post_test | 18 |  |  |  |
| oe_test_service_postgresql | Test postgresql.service restart | pre_test/run_test/post_test | 2 | ✔ |  |  |

### 断言与命令明细

#### oe_test_postgresql_clusterdb

- 描述：clusterdb
- 函数：`pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：clusterdb×1

#### oe_test_postgresql-contrib_oid2name01

- 描述：oid2name
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

#### oe_test_postgresql-contrib_pg_archivecleanup

- 描述：pg_archivecleanup oid2name
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：oid2name×1, pg_archivecleanup×1

#### oe_test_postgresql-contrib_pgbench01

- 描述：clusterdb
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：psql×2

#### oe_test_postgresql-contrib_pgbench02

- 描述：clusterdb
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

#### oe_test_postgresql-contrib_pgbench03

- 描述：clusterdb
- 函数：`pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

#### oe_test_postgresql-contrib_pgbench04

- 描述：clusterdb
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：pgbench×1

#### oe_test_postgresql-contrib_pg_standby

- 描述：pg_standby
- 函数：`pre_test, run_test, post_test`
- 断言（18 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  ... 共 18 条（其余见源脚本）
```

- 涉及命令：kill×8, mkdir×1, pg_standby×1

#### oe_test_postgresql-contrib_pg_test_fsync

- 描述：pg_test_fsync pg_test_timing pg_upgrade
- 函数：`pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：pg_test_fsync×1, pg_test_timing×1, pg_upgrade×1

#### oe_test_postgresql-contrib_pg_waldump

- 描述：pg_waldump
- 函数：`pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：pg_waldump×1

#### oe_test_postgresql-contrib_vacuumlo

- 描述：vacuumlo
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：vacuumlo×1

#### oe_test_postgresql_createdb

- 描述：createdb
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：mkdir×1, chown×1, createdb×1

#### oe_test_postgresql_create_duplicate_db

- 描述：Verify postgresql rejects duplicate database creation
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "initdb should initialize the temporary PostgreSQL cluster"
  CHECK_RESULT $? 0 0 "pg_ctl should start the temporary PostgreSQL cluster"
  CHECK_RESULT $? 0 0 "first CREATE DATABASE for ${db_name} should succeed"
  CHECK_RESULT $? 0 1 "duplicate CREATE DATABASE for ${db_name} should fail"
  CHECK_RESULT $? 0 0 "duplicate database error should mention that ${db_name} already exists"
  CHECK_RESULT "$(su postgres -c "psql -d postgres -Atqc \"SELECT count(*) FROM pg_database WHERE datname='${db_name}';\"")" 1 0 "database ${db_name} should exist exactly once"
```

- 涉及命令：command×2, mkdir×1, chown×1, grep×1

#### oe_test_postgresql_createuser01

- 描述：createuser
- 函数：`pre_test, run_test, post_test`
- 断言（19 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  ... 共 19 条（其余见源脚本）
```

#### oe_test_postgresql_createuser02

- 描述：createuser
- 函数：`pre_test, run_test, post_test`
- 断言（12 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：createuser×1

#### oe_test_postgresql_create_duplicate_role

- 描述：Verify postgresql rejects duplicate role creation
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "initdb should initialize the temporary PostgreSQL cluster"
  CHECK_RESULT $? 0 0 "pg_ctl should start the temporary PostgreSQL cluster"
  CHECK_RESULT $? 0 0 "first CREATE ROLE for ${role_name} should succeed"
  CHECK_RESULT $? 0 1 "duplicate CREATE ROLE for ${role_name} should fail"
  CHECK_RESULT $? 0 0 "duplicate role error should mention that ${role_name} already exists"
  CHECK_RESULT "$(su postgres -c "psql -d postgres -Atqc \"SELECT count(*) FROM pg_roles WHERE rolname='${role_name}';\"")" 1 0 "role ${role_name} should exist exactly once"
```

- 涉及命令：command×2, mkdir×1, chown×1, grep×1

#### oe_test_postgresql-devel_ecpg

- 描述：ecpg
- 函数：`pre_test, run_test, post_test`
- 断言（22 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  ... 共 22 条（其余见源脚本）
```

- 涉及命令：ecpg×1

#### oe_test_postgresql-devel_pg_config01

- 描述：pg_config
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

#### oe_test_postgresql-devel_pg_config02

- 描述：pg_config
- 函数：`pre_test, run_test, post_test`
- 断言（14 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  ... 共 14 条（其余见源脚本）
```

#### oe_test_postgresql_dropdb-dropuser

- 描述：dropdb
- 函数：`pre_test, run_test, post_test`
- 断言（12 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $? 1
  CHECK_RESULT $? 1
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：dropdb×1, dropuser×1

#### oe_test_postgresql_pg_dump01

- 描述：pg_dump
- 函数：`pre_test, run_test, post_test`
- 断言（17 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $? 1
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  ... 共 17 条（其余见源脚本）
```

- 涉及命令：test×3

#### oe_test_postgresql_pg_dump02

- 描述：pg_dump
- 函数：`pre_test, run_test, post_test`
- 断言（16 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $? 1
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $? 1
  CHECK_RESULT $?
  CHECK_RESULT $?
  ... 共 16 条（其余见源脚本）
```

- 涉及命令：pg_dump×1

#### oe_test_postgresql_pg_dump03

- 描述：pg_dump
- 函数：`pre_test, run_test, post_test`
- 断言（13 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $? 1
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  ... 共 13 条（其余见源脚本）
```

#### oe_test_postgresql_pg_dumpall01

- 描述：pg_dumpall
- 函数：`pre_test, run_test, post_test`
- 断言（16 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $? 1
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $? 1
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $? 1
  CHECK_RESULT $?
  ... 共 16 条（其余见源脚本）
```

#### oe_test_postgresql_pg_isready

- 描述：pg_isready pg_dumpall
- 函数：`pre_test, run_test, post_test`
- 断言（13 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $? 1
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  ... 共 13 条（其余见源脚本）
```

- 涉及命令：test×2, pg_dumpall×1, pg_isready×1

#### oe_test_postgresql_pg_restore01

- 描述：pg_restore
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：sed×1

#### oe_test_postgresql_pg_restore02

- 描述：pg_restore
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：psql×1, pg_restore×1

#### oe_test_postgresql_psql01

- 描述：psql
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：psql×1

#### oe_test_postgresql_psql02

- 描述：psql
- 函数：`pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：test×2

#### oe_test_postgresql_psql03

- 描述：psql
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

#### oe_test_postgresql_reindexdb

- 描述：reindexdb
- 函数：`pre_test, run_test, post_test`
- 断言（15 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  ... 共 15 条（其余见源脚本）
```

- 涉及命令：reindexdb×1

#### oe_test_postgresql-server_initdb

- 描述：initdb
- 函数：`pre_test, run_test, post_test`
- 断言（11 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：test×8, initdb×1

#### oe_test_postgresql-server_pg_basebackup

- 描述：pgsql_backup
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：test×3, pg_basebackup×1

#### oe_test_postgresql-server_pg_ctl

- 描述：pg_ctl
- 函数：`pre_test, run_test, post_test`
- 断言（18 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  ... 共 18 条（其余见源脚本）
```

- 涉及命令：pg_ctl×1

#### oe_test_postgresql-server_pg_receivewal

- 描述：pg_receivewal
- 函数：`pre_test, run_test, post_test`
- 断言（19 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  ... 共 19 条（其余见源脚本）
```

- 涉及命令：kill×7, psql×1, pg_receivewal×1

#### oe_test_postgresql-server_pg_recvlogical

- 描述：pg_recvlogical
- 函数：`pre_test, run_test, post_test`
- 断言（15 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  ... 共 15 条（其余见源脚本）
```

- 涉及命令：kill×5

#### oe_test_postgresql-server_pg_resetwal

- 描述：pg_resetwal
- 函数：`pre_test, run_test, post_test`
- 断言（14 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  ... 共 14 条（其余见源脚本）
```

#### oe_test_postgresql-server_postgres01

- 描述：postgres
- 函数：`pre_test, run_test, post_test`
- 断言（24 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  ... 共 24 条（其余见源脚本）
```

#### oe_test_postgresql-server_postgres02

- 描述：postgres
- 函数：`pre_test, run_test, post_test`
- 断言（20 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  ... 共 20 条（其余见源脚本）
```

- 涉及命令：postgres×1

#### oe_test_postgresql-server_postgresql-setup

- 描述：postgresql-setup pg_controldata pg_rewind
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：pg_rewind×1, pg_controldata×1

#### oe_test_postgresql_vacuumdb

- 描述：vacuumdb
- 函数：`pre_test, run_test, post_test`
- 断言（18 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  ... 共 18 条（其余见源脚本）
```

- 涉及命令：vacuumdb×1

#### oe_test_service_postgresql

- 描述：Test postgresql.service restart
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "postgresql.service reload failed"
  CHECK_RESULT $? 0 0 "postgresql.service reload causes the service status to change"
```

- 涉及命令：sed×2
