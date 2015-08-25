#!/usr/bin/ruby 
# Copyright 2005, Geir Isene. Released under the GPL v. 2
# Version 0.1 (2005-09-25)

require 'net/imap'
load    '~/.imap.conf'
load    '~/bin/core_imap_filter.rb'

Imap = Net::IMAP.new(I_server)
Imap.authenticate('LOGIN', I_user, I_passwd)
Imap.select("INBOX")

$count = 0

# The syntax for matching is: 
# matching("string-to match", "match-against", "send-to-mailbox")
# The following options are available to match against:
# "s" for SUBJECT, "b" for BODY, "t" for TO, "f" for FROM, "c" for CC
# to match any part of the mail (header or body): "x" for TEXT

# Lists
matching("somelist.org", "tc", "Lists.somelist")

# Other matching rules
matching("bullshit", "s", "Spam")
matching("VIRUS", "s", "Spam")
matching("ImportantWord", "x", "ImportantFolder")

# Catch-the-rest
matching("", "s", "DefaultFolder")

Imap.logout
puts "#{$count} mails filtered"
