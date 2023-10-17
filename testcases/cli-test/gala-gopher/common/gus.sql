create database tpccdb;
create user tpcc with password 'tpcc_123456';
grant all privilege to tpcc;
create user opengauss_exporter with monadmin password 'opengauss_exporter123';
grant usage on schema dbe_perf to opengauss_exporter;
grant select on pg_stat_replication to opengauss_exporter;
