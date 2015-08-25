#!/usr/bin/ruby 
# Copyright 2005, Geir Isene. Released under the GPL v. 2
# Version 0.1 (2005-09-25)

def help
puts <<HELPTEXT

NAME
        imap_search - search imap folders matching a regular expression

SYNOPSIS
        imap_search [ -asbftchv ] [long-options] [ searchstring ] [folder]

DESCRIPTION

        imap_search makes it possible to search through multiple imap mail
        folders. The resulting matches are presented (as copies of the
        mails) in a separate folder (INBOX.search).

OPTIONS

        -x, --text
                Make match against all fields (subject, body, from, to, cc)
  
        -s, --subject
                Make match in the subject of the e-mail
    
        -b, --body
                Make match in the body of the e-mail
    
        -f, --from
                Make match against the from: field
    
        -t, --to
                Make match against the to: field
    
        -c, --cc
                Make match against the cc: field
    
        -h, --help
                Show this help text
    
        -v, --version
                Show the version of imap_search

EXAMPLE
        imapsearch -sb test INBOX.mailbox1.*

        This would search in the subject and body of the e-mail for the
        search string "test" in any mailbox below "INBOX.mailbox1".
    
COPYRIGHT:
      
        Copyright 2005, Geir Isene (www.geir.isene.com)
        This program is released under the GNU General Public lisence v2
        For the full lisence text see: http://www.gnu.org/copyleft/gpl.html

HELPTEXT
end


require 'net/imap'
require 'getoptlong'
load    '~/.imap.conf'

opts = GetoptLong.new(
    [ "--text",             "-x",   GetoptLong::NO_ARGUMENT ],
    [ "--subject",          "-s",   GetoptLong::NO_ARGUMENT ],
    [ "--body",             "-b",   GetoptLong::NO_ARGUMENT ],
    [ "--from",             "-f",   GetoptLong::NO_ARGUMENT ],
    [ "--to",               "-t",   GetoptLong::NO_ARGUMENT ],
    [ "--cc",               "-c",   GetoptLong::NO_ARGUMENT ],
    [ "--help",             "-h",   GetoptLong::NO_ARGUMENT ],
    [ "--version",          "-v",   GetoptLong::NO_ARGUMENT ]
)

i_subject = false
i_body = false
i_from = false
i_to = false
i_cc = false
i_text = false
i_version = "0.2"

opts.each do |opt, arg|
  case opt
    when "--text"
      i_text = true
    when "--subject"
      i_subject = true
    when "--body"
      i_body = true
    when "--from"
      i_from = true
    when "--to"
      i_to = true
    when "--cc"
      i_cc = true
    when "--help"
      help
      exit
    when "--version"
      puts "\nimap_search version " + i_version + "\n\n"
      exit
    else
      i_subject = true
  end
end

if ARGV.empty? then 
  puts "No search string supplied!"
  exit 
end

searchkey = ARGV[0]
i_mailbox = 'INBOX.*'
if ARGV.length > 1 then i_mailbox = ARGV[1] end

imap = Net::IMAP.new(I_server)
imap.authenticate('LOGIN', I_user, I_passwd)

begin
  imap.delete("INBOX.search")
  imap.create("INBOX.search")
rescue
end

imap.list("", i_mailbox).each do |mailbox|
  mailbox = mailbox.to_s
  mailbox.sub!(/^.*name=\"/, "")
  mailbox.sub!(/\">/, "")
  mailbox.each do
    begin
      res = []
      imap.select(mailbox)
      if i_subject then res = res + imap.search(["SUBJECT", searchkey]) end
      if i_body then res = res + imap.search(["BODY", searchkey]) end
      if i_from then res = res + imap.search(["FROM", searchkey]) end
      if i_to then res = res + imap.search(["TO", searchkey]) end
      if i_cc then res = res + imap.search(["CC", searchkey]) end
      if i_text then res = res + imap.search(["TEXT", searchkey]) end
      res.uniq!
      imap.copy(res, "INBOX.search")
    rescue
    end
  end
end

imap.logout
