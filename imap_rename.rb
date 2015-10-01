#!/usr/bin/ruby 
# Copyright 2005, Geir Isene. Released under the GPL v. 2

require 'net/imap'
load    '~/.imap.conf'

if ARGV.length != 2 then 
  puts "Needs two arguments! (folder_name folder_new_name)"
  exit 
end

folder_name = ARGV[0]
folder_new_name = ARGV[1]

#imap = Net::IMAP.new(I_server, port="993", usessl="true")
imap = Net::IMAP.new(I_server, port="143")
imap.login(I_user, I_passwd)
imap.rename(folder_name, folder_new_name)
imap.logout
