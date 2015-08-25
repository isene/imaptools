#!/usr/bin/ruby 
# Copyright 2005, Geir Isene. Released under the GPL v. 2
# Version 0.3 (2005-09-25)

require 'net/imap'
load    '~/.imap.conf'

if ARGV.length != 2 then 
  puts "Needs two arguments! (folder_name folder_new_name)"
  exit 
end

folder_name = Regexp.new( ARGV[0] )
folder_new_name = ARGV[1]

imap = Net::IMAP.new(I_server)
imap.authenticate('LOGIN', I_user, I_passwd)

mail_list = imap.list( "", "INBOX.*" )

a_old = []
a_new = []

mail_list.each do |a1|
    a_old.push( a1[2] ) if a1[2] =~ folder_name
end

a_old.each do |ao|
    a_new.push( ao.sub( folder_name, folder_new_name ) )
end

a_old_new = a_old.zip( a_new )

a_old_new.each do |a|
    imap.rename( a[0], a[1] )
end

imap.logout
