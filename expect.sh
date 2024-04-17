#!/usr/bin/expect

set passphrase [lindex $argv 0]
set ssh_key_path [lindex $argv 1]
set selected_host [lindex $argv 2]

spawn ssh -o "StrictHostKeyChecking=no" -i "$ssh_key_path" "$selected_host"
expect "Enter passphrase for key '$ssh_key_path':"
send "$passphrase\r"
interact