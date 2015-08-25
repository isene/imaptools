def matching (match,match_in,to_box)
    res = []
    to_box = "INBOX." + to_box
    if match_in =~ /s/ then res = res + Imap.search(["SUBJECT", match]) end
    if match_in =~ /b/ then res = res + Imap.search(["BODY", match]) end
    if match_in =~ /f/ then res = res + Imap.search(["FROM", match]) end
    if match_in =~ /t/ then res = res + Imap.search(["TO", match]) end
    if match_in =~ /c/ then res = res + Imap.search(["CC", match]) end
    if match_in =~ /x/ then res = res + Imap.search(["TEXT", match]) end
    res.uniq!
    res.each do |message_id|
      Imap.copy(message_id, to_box)
      Imap.store(message_id, "+FLAGS", [:Deleted])
      $count = $count + 1
    end
    Imap.expunge
end
