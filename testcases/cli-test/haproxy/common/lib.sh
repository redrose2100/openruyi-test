#!/usr/bin/bash
git clone https://gitee.com/kaixinlanzi/VTest /tmp/VTest
make -C /tmp/VTest FLAGS="-O2 -s -Wall"
export HAPROXY_PROGRAM=/usr/sbin/haproxy
export VTEST_PROGRAM=/tmp/VTest/vtest
git clone https://gitee.com/src-openeuler/haproxy
cd haproxy
tar -xf haproxy-2.4.8.tar.gz
cp -rf haproxy-2.4.8/scripts/run-regtests.sh ../
cp -rf haproxy-2.4.8/reg-tests/ ../
cd ../

