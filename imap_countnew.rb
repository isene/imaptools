#!/usr/bin/ruby 
# Copyright 2005, Geir Isene. Released under the GPL v. 2

require 'net/imap'
load    '~/.imap.conf'

Imap = Net::IMAP.new(I_server, port="993", usessl="true")
Imap.authenticate('LOGIN', I_user, I_passwd)
Imap.status("INBOX.FreeCode", "UNSEEN")

open('/home/isene/.mail', 'w') do |f|
    f.write( "FC:" + Imap.status("INBOX.FreeCode", "UNSEEN")["UNSEEN"].to_s + "\n" )
    f.write( "Geir:" + Imap.status("INBOX.Geir", "UNSEEN")["UNSEEN"].to_s  + "\n")
    f.write( "EFN:" + Imap.status("INBOX.Lists.EFN", "UNSEEN")["UNSEEN"].to_s  + "\n")
    f.write( "EFN-S:" + Imap.status("INBOX.Lists.EFN-styret", "UNSEEN")["UNSEEN"].to_s  + "\n")
    f.write( "ISOC:" + Imap.status("INBOX.Lists.ISOC", "UNSEEN")["UNSEEN"].to_s )
end
