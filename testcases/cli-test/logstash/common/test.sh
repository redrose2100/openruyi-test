#!/bin/bash
expect <<-EOF
set timeout 30
log_file ./test.log
spawn ./logstash -e "input { stdin { } } output { stdout {} }"
expect "Successfully"
send "hello world\r"
expect "timestamp"
send "\03\r"
expect eof
EOF