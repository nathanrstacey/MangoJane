import getpass, poplib, time, datetime, os




M = poplib.POP3('mail.sambatop.com')
M.user('home@sambatop.com')
M.pass_('1qazZAQ!')
numMessages = len(M.list()[1])


for i in range(numMessages):
    now = datetime.datetime.now()
    timestamp = now.strftime("%Y%j%H%M%S%f")
    
    tempString = ('email/' + timestamp + '/')
    os.makedirs(tempString)
    
    tempString = ('email/' + timestamp + '/fullMessage.txt')
    fp = open(tempString , 'wb')
    for j in M.retr(i+1)[1]:
        fp.write(j)
    fp.close()
