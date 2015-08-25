#!/usr/bin/ruby 
# Copyright 2005, Geir Isene. Released under the GPL v. 2

require 'net/imap'
load    '~/.imap.conf'

i_mailbox = []
if ARGV.length == 0 then i_mailbox = [ "INBOX.FreeCode", "INBOX.Geir" ] end
if ARGV.length > 0 then ARGV.each { |b| i_mailbox.push(b) } end

imap = Net::IMAP.new(I_server, port="993", usessl="true")
imap.authenticate('LOGIN', I_user, I_passwd)

res = []
i_mailbox.each do |b|
    imap.examine(b)
    res = imap.search(["NOT", "NEW"])
    if res.length >0 then 
	sub = imap.fetch(res, "BODY[HEADER.FIELDS (SUBJECT)]")
	sub.each do |s| 
	    subject = s.attr["BODY[HEADER.FIELDS (SUBJECT)]"]
	    subject.gsub!(/Subject: /, '* ')
	    subject.gsub!(/\n/, '')
	    puts subject
	end
    end
end

imap.logout
