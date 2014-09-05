#! /usr/local/bin/python

#"python sendEmailOnly0.1.py -f $from -t $to -of message-file=/var/mangojane/message.txt -s $global_email_url$portToAddToString -xu $from -xp $global_email_Mail_User_Password -ot tls=no -om message-content-type=html -omch message-charset=utf-8 $attachmentString"; note an -a before attachments
import argparse

parser = argparse.ArgumentParser(description='gets input much like Perls sendEmail program. And uses that input to send out a file')
parser.add_argument('-f', help='The from email', type=str, required=True)
parser.add_argument('-t', help='The to email', type=str, required=True)
parser.add_argument('-of', help='The file of the message being sent', type=str, required=True)
parser.add_argument('-ot', help='1 means there is tls 0 mean no tls', type=bool, required=False, default=0)
parser.add_argument('-server', help='Email server', type=str, required=True)
parser.add_argument('-port', help='port used for SMTP', type=str, required=False, default=25)
parser.add_argument('-xu', help='username to log into email server', type=str, required=False, default='home')
parser.add_argument('-xp', help='password to log into email server', type=str, required=False, default='1qazZAQ!')
parser.add_argument('-html', help='is 0 if html NOT required for email. 1 if required. Note: this is NOT part of sendEmail, added for convenience', type=str, required=False, default=1 )
parser.add_argument('-a', help='attachment file and filename seperated by a space (again, following the same structure as sendEmail)', type=str, required=False, default = '')
args = vars(parser.parse_args())



isTLS = args['ot']
SMTPserver = args['server']
SMPTport = args['port']

sender =  args['f']
destination = args['t']
messageFile = args['of']
USERNAME = args['xu']
PASSWORD = args['xp']
attachmentString = args['a']

# typical values for text_subtype are plain, html, xml
if args['html'] == '0':
	text_subtype = 'plain'
else:
	text_subtype = 'html'


with open (messageFile, "r") as myfile:
    content=myfile.read().replace('\n', '')



subject="Sent from Mango Jane"

import sys
import os
import re
# Import smtplib for the actual sending function
import smtplib






# Open a plain text file for reading.  For this example, assume that
# the text file contains only ASCII characters.
fp = open(messageFile, 'rb')

if attachmentString == "":
	# Import the email modules we'll need
	from email.mime.text import MIMEText
	
	# Create a text/plain message
	msg = MIMEText(fp.read())
	fp.close()
	
	# me == the sender's email address
	# you == the recipient's email address
	msg['From'] = sender
	msg['To'] = destination
	
	# Send the message via our own SMTP server, but don't include the
	# envelope header.
	if isTLS:
		s = smtplib.SMTPTLS(SMTPserver)
		s.sendmail(sender, destination, msg.as_string())
		s.quit()
		print ("Message Sent")
	else:
		s = smtplib.SMTP(SMTPserver)
		s.sendmail(sender, destination, msg.as_string())
		s.quit()
		print ("Message Sent")


else:
	from email.message import Message
	from email.mime.audio import MIMEAudio
	from email.mime.base import MIMEBase
	from email.mime.image import MIMEImage
	from email.mime.multipart import MIMEMultipart
	from email.mime.text import MIMEText
	import mimetypes
	from email import encoders
	
	# Create the container (outer) email message.
	outer = MIMEMultipart()
	# me == the sender's email address
	# family = the list of all recipients' email addresses
	outer['From'] = sender
	outer['To'] = destination
       	fp = open(messageFile)
 	# Note: we should handle calculating the charset
        msg = MIMEText(fp.read())
        fp.close()
	outer.attach(msg)
	# Assume we know that the image files are all in PNG format
	files = attachmentString.split(' ')	
	for path in files:
		ctype, encoding = mimetypes.guess_type(path)
        	if ctype is None or encoding is not None:
        	    # No guess could be made, or the file is encoded (compressed), so
        	    # use a generic bag-of-bits type.
        	    ctype = 'application/octet-stream'
        	maintype, subtype = ctype.split('/', 1)
        	if maintype == 'image':
        	    fp = open(path, 'rb')
        	    msg = MIMEImage(fp.read(), _subtype=subtype)
        	    fp.close()
        	elif maintype == 'audio':
        	    fp = open(path, 'rb')
        	    msg = MIMEAudio(fp.read(), _subtype=subtype)
        	    fp.close()
        	else:
        	    fp = open(path, 'rb')
        	    msg = MIMEBase(maintype, subtype)
        	    msg.set_payload(fp.read())
        	    fp.close()
        	    # Encode the payload using Base64
        	    encoders.encode_base64(msg)
        	outer.attach(msg)
	
	# Send the email via our own SMTP server.
	if isTLS:
    		composed = outer.as_string()
		s = smtplib.SMTP(SMTPserver)
		s.sendmail(sender, destination, composed)
		s.quit()
		print ("Message Sent")
	else:
    		composed = outer.as_string()
		s = smtplib.SMTP(SMTPserver)
		s.sendmail(sender, destination, composed)
		s.quit()
		print ("Message Sent")
