import poplib, mimetypes, time, datetime, os, re
from email import parser
from confVariables import *




if (global_email_uses_SSL):
    pop_conn = poplib.POP3_SSL(global_email_Server_Name)
else:
    pop_conn = poplib.POP3(global_email_Server_Name)
pop_conn.user(global_email_Main_User_Name)
pop_conn.pass_(global_email_Mail_User_Password)
#Get messages from server:
messages = [pop_conn.retr(i) for i in range(1, len(pop_conn.list()[1]) + 1)]
#for i in range(1, len(pop_conn.list()[1]) + 1):
#    pop_conn.dele(i) 
# Concat message pieces:
messages = ["\n".join(mssg[1]) for mssg in messages]
#Parse message intom an email object:
messages = [parser.Parser().parsestr(mssg) for mssg in messages]
for message in messages:
    print "email found\n"
    now = datetime.datetime.now()
    timestamp = now.strftime("%Y%j%H%M%S%f")
    
    tempString = ('email/' + timestamp + '/')
    os.makedirs(tempString)


    filename1 = 'info.info'
    fp = open(os.path.join(tempString, filename1), 'w')
    fp.write(message['From'])
    fp.write('\n')
    fp.write(message['To'])
    fp.write('\n')
    fp.close()
    theFrom = message['From']
    theTo = message['To']
    theBody = ""
    theAttachmentString = ""
    counter = 1
    for part in message.walk():
        # multipart/* are just containers
        if part.get_content_maintype() == 'multipart':
            continue
        # Applications should really sanitize the given filename so that an
        # email message can't be used to overwrite important files
        filename = part.get_filename()
        if not filename:
            ext = mimetypes.guess_extension(part.get_content_type())
            if not ext:
                # Use a generic bag-of-bits extension
                ext = '.bin'
            filename = 'part-%03d%s' % (counter, ext)
        counter += 1
        fp = open(os.path.join(tempString, filename), 'w')
        fp.write(part.get_payload(decode=True))
	match1 = re.search(r'part', filename )
	match2 = re.search(r'\.ksh', filename )
	if (match1 and match2):
		theBody = '%s%s' %(theBody,part.get_payload(decode=True))
	if ((not match1) and (not match2)):
		attachmentFileName = timestamp + filename
		fp1 = open(os.path.join('email/attachments', attachmentFileName), 'w')
		fp1.write(part.get_payload(decode=True))
		fp1.close()
		theAttachmentString = '%s %s' %(theAttachmentString,attachmentFileName)
        fp.close()

	#time to make the output
	outputFile = timestamp + 'rawemail.rawemail'
	fp = open(os.path.join('workToDo', outputFile), 'w')
	fp.write("iiiiiiiiBeginNewVariableiiiiiiiiiii\n")
	m_obj = re.search("<(.+)>", theFrom)
	fp.write(m_obj.group(1))
	fp.write("\niiiiiiiiBeginNewVariableiiiiiiiiiii\n")
	fp.write(theBody)
	fp.write("\niiiiiiiiBeginNewVariableiiiiiiiiiii\n")
	fp.write(theAttachmentString)
	fp.write("\niiiiiiiiBeginNewVariableiiiiiiiiiii\n")
	fp.write(theTo)
	fp.close()

pop_conn.quit()






