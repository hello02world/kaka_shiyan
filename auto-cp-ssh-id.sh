#!/usr/bin/expect

# Usage:
## $1: usr name
## $2: passwd
## $3: hostname or ip addr

set timeout 10
set username [lindex $argv 0]
set password [lindex $argv 1]
set hostname [lindex $argv 2]
set HOME /root
spawn ssh-copy-id -i ${HOME}/.ssh/id_rsa.pub $username@$hostname
expect {
            #first connect, no public key in ~/.ssh/known_hosts
            "Are you sure you want to continue connecting (yes/no)?" {
            send "yes\r"
            expect "password:"
                send "$password\r"
            }
            #already has public key in ~/.ssh/known_hosts
            "password:" {
                send "$password\r"
            }
            "Now try logging into the machine" {
                #it has authorized, do nothing!
            }
        }
expect eof
