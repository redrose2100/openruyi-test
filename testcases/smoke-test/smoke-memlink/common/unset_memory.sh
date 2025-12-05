#!/bin/bash

VM_NAME=$1

export VM_NAME

/usr/bin/expect << 'EOF'
    set timeout 20
    spawn virsh console $env(VM_NAME)
    expect {
        "Ctrl + ]" {
            send "\r"
            exp_continue
        }
        "Connected to domain" {
            send "\r"
            exp_continue
        }
        "*login*" {
            send "root\r"
            exp_continue
        }
        "Password" {
            send "openEuler12#$\r"
            exp_continue
        }
        "*#" {
            send "rm -rf /mnt/tmpfs/largefile\r"
            expect {
                "*#" { }
                timeout { puts "delete timeout"; exit 1 }
            }
            exit 0
        }
        timeout {
            exit 1
        }
        eof {
            exit 1
        }
    }
EOF