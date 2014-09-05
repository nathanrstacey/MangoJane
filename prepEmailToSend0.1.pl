#!/usr/bin/perl
#
#sendEmailSMTPStandard.pl
#
#This looks sends out an email 
#
#
#Args = ARGV[0]:emailaddress
#Args = ARGV[1]:sms value
#Args = ARGV[2]:from email
#
#
#
#important variables in this script
my $from= $global_email_Main_User_Name;
my $subject='';
my $title='Perl Mail demo';
#
#
use strict;

my $portToAddToString;
if ($global_pop3_Port) {
	$portToAddToString = $global_pop3_Port;
}
else {
	$portToAddToString = "25";
}

open (LOG, ">>logs\/log_sendEmailSMTP.txt");
print LOG "#######\n#######\n####Next Email\n######\n#####\n#####\n";
#arg1 is phone number of sender
#arg2 is text
my $toEmail = $ARGV[0];
chomp($toEmail);
print LOG "the toEmail is <$toEmail>\n";
my $theText = $ARGV[1];
chomp($theText);
$theText =~ s/</&lt;/g;
$theText =~ s/>/&gt;/g;
$theText =~ s/\\n/\n/g;
$theText =~ s/45454545454545/\n/g;  #some posts use this number to make carriage returns
$theText =~ s/\n /\n&nbsp;/g;
$theText =~ s/  /&nbsp;&nbsp;/g;
print LOG "theText is <$theText>\n";
$from = $ARGV[2];
chomp($from);
$from =~ ~ s/\\n/\n/g;
if ($theText =~ /^$/) {
	print LOG "there was no text to send out so we will die now\n";
	close LOG;
	die;	
}
my ($sec, $min, $hr, $day, $mon, $year) = localtime;
printf LOG ("#\n#\n#\n%02d/%02d/%04d %02d:%02d:%02d:In sendEmailSMTP with:$toEmail\n#and theText:\n$theText\n#\n", $day, $mon + 1, 1900 + $year, $hr, $min, $sec);


my @attachmentArray;
lookforAttachments();



my $tempScalar = scalar(@attachmentArray);
if ($tempScalar) {
	print LOG "This is the first attachment $attachmentArray[0]\n";
}
print LOG "there are this many attachments <$tempScalar>\n";
$_ = $theText;
print LOG "the email before switching out attachments <\n\n$theText\n\n>\n";
$theText =~ s/ 789502735 .* 789502735 //g;
chomp($theText);
$theText =~ s/\n+$//g;
$theText =~ s/\r+$//g;
$theText =~ s/\s+$//g;
print LOG "the email now states after attachments and lagging white space are gone \n\n<\n$theText\n>\n\n";
makeToEmailBeMMSIfAttachmentsOr140Char();
my $to=$toEmail;


my $tempVal = 0;
my $attachmentString = "";
my $isAttachment = 0;
while (<@attachmentArray>) {
	if ($_ =~ /\w/) {
		if ($tempVal == 0) {
			$isAttachment = 1;
			$attachmentString = "-a \""
		}
		$attachmentString = $attachmentString . "email\/attachments\/$attachmentArray[$tempVal] ";
	}
	$tempVal++;
}
if ($isAttachment) {
	$attachmentString =~ /^(.+) $/;
	$attachmentString = $1 . '"';
}
my $toSystem;
$theText = $theText . "\n";
#$theText =~ s/\n/\n<br><p>\p/g;
#$theText = "\"" . $theText . "\"";
open (TXT, ">\/var\/mangojane\/message.txt");
print TXT $theText;
close TXT;
my $htmlString = "";
my $needsToBeHTML = 0;
if (length($theText>160) and $attachmentString =~ /^$/) {
	$needsToBeHTML = 1;
}


#while (length($theText) > 0 ) {

	#$toSystem = "python sendEmailOnly0.2.py -f $from -t $to -of /var/mangojane/message.txt -server $global_email_url -p $portToAddToString -xu $from -xp $global_email_Mail_User_Password -ot tls=no -omch message-charset=utf-8 -html $needsToBeHTML $attachmentString";
		#python sendEmailOnly0.2.py -f home@acnejane.com -t nathanrstacey@gmail.com -of /var/mangojane/message.txt -server localhost
	$toSystem = "python sendEmailOnly0.2.py -f $from -t $to -of /var/mangojane/message.txt -server $global_email_url -xu $global_email_Main_User_Name -xp $global_email_Mail_User_Password $attachmentString";
	#if (length($theText>160) and $attachmentString =~ /^$/) {
	#	$theText = substr $theText, 160, (length($theText)-160);
	#	$attachmentString = 0;
	#}
	#else {
	#	$theText = "";
	#}
#}
       #system("sendEmail -f $from -t $to -u \"Database Dump\" -m \"$theText\" -s sambatop.com:2525 -xu $fromEmail -xp 1qazZAQ! -o tls=no -o message-content-type=html $attachmentString");
        
chomp($toSystem);
$toSystem =~ s/\n+$//g;
$toSystem =~ s/\r+$//g;
$toSystem =~ s/\s+$//g;
print LOG "about to send out to system:<$toSystem>";
system("$toSystem");

	
 


 
close(MAIL);
close(LOG);

sub lookforAttachments {
	print LOG "\tIn lookforAttachments\n";
	my $myText = $theText;
	my $myInt = 0;
	while ($myText =~ /789502735/) {
		print LOG "\twhile loop turn $myInt with myText: \n\t#\n\t<$myText>\n\t#\n";
		my $first;
		my $rest;
		my $theAttachment;
		($first, $theAttachment, $rest) = split(/789502735/, $myText, 3);
		$theAttachment =~ /^\s*(\S+)\s*$/;
		my $filtered = $1;
		print LOG "\t\tthe attachmentment found was <$filtered>\n";
		$attachmentArray[$myInt] = $filtered;
		$myText = $rest;
		$myInt += 1;
	}
}


sub makeToEmailBeMMSIfAttachmentsOr140Char {
	use DBI;

	my $host = $global_MYSQL_host;
	my $database = $global_MYSQL_database;
	my $username = $global_MYSQL_username;
	my $password = $global_MYSQL_password;

	#all of the blog variables
	my $connectionInfo = "dbi:mysql:$database;$host";
	my $connection = DBI->connect($connectionInfo, $username, $password);

	print LOG "in makeToEmailBeMMSIfAttachmentsOr140Char with toEmail \n\n<\n$toEmail\n>\n\n";
	my $mytempScalar = scalar(@attachmentArray);
	print LOG "there are this many attachments <$mytempScalar>\n";	
	if (($mytempScalar > 0) or (length($theText) > 140)) {
		print LOG "we believe there is an attachment so we will try to change the email address\n";
		$toEmail =~ m/^(.*)(@.*)$/i;
		my $sid = $1;
		my $domain = $2;
		print LOG "looking at this attachment and we have sid=<$sid> and domain=<$domain>\n";
    		my $str = $connection->prepare("SELECT mmsDomain FROM sms2mmsEmails WHERE (smsDomain = \'$domain\')");
    		$str->execute;  
    		my @resultsCheck=$str->fetchrow_array;
    		if (@resultsCheck) {
			$toEmail = $sid . $resultsCheck[0];
		}
	}
	print LOG "leaving makeToEmailBeMMSIfAttachmentsOr140Char with toEmail=<$toEmail>\n";
}
