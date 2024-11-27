#!/bin/bash
expect <<-END
spawn telnet 127.0.0.1 25
set timeout 5
log_file /tmp/test/test.txt 
expect "ESMTP Sendmail" { send "help\r";}
expect "End of HELP info" { send "quit\r";}
expect eof
END
