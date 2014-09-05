my $global_email_Server_Name = 'localhost';
my $global_email_Main_User_Name = 'home';
my $global_email_Mail_User_Password = '1qazZAQ!';
my $global_email_url = 'localhost';
my $global_email_uses_SSL = '0';
my $global_pop3_Port = '0';
my $global_MYSQL_host = 'localhost';
my $global_MYSQL_database = 'txtCLI';
my $global_MYSQL_username = 'root';
my $global_MYSQL_password = 'mullet11';
my $global_admins = 'all';




#!/usr/bin/perl

use strict;
use warnings;
use Mail::POP3Client;
use MIME::Parser;
use Time::HiRes qw(gettimeofday);
use Cwd;
my $dir = getcwd;


my $from = $ARGV[0];
chomp($from);
my $code = $ARGV[1];
chomp($code);
my $attachmentLocationString = $ARGV[2];
chomp($attachmentLocationString);
my $to = $ARGV[3];
chomp($to);


my $nextWord = "";

print "0\n";
open (LOG, "+>logs\/log_parseEmail3_2.txt");
print "00\n";
my $prelimOutputDIR = $dir . '/workToDo/';
my $theTextForNextScript = "";
my $lastNextWord = "";








$code =~ s/\n+/ /g;
$code =~ s/\r+/ /g;
$code =~ s/\s+/ /g;
if ($code !~ s/^\#\#//) {

	codeWord();
}

###delete this in the real script
#$code =~ s/\n+/\\n/g;
####end delete
createOutputFileForNextScript("4", $from,$code,$attachmentLocationString,$to);








		



close(LOG);


sub codeWord {
#lets look at the to address. If it is to "home" then ignore. Anywhere else, it needs code words
	print LOG "in codeWord() with the following code $code\n";
	if ( ($to !~ /${global_email_Main_User_Name}/ )  ){
		print LOG "In theToEmail if\n";
		use DBI;
	
	
		my $host = $global_MYSQL_host;
		my $database = $global_MYSQL_database;
		my $username = $global_MYSQL_username;
		my $password = $global_MYSQL_password;
		my $connectionInfo = "dbi:mysql:$database;$host";
	
		my $connection = DBI->connect($connectionInfo, $username, $password);
	
		my $codeWord = "";
		my $CLI;
		
		$_ = $to;
		if ( m/(\A.*)\@/) {	
			$codeWord = $1;
			print LOG "in emailName if with codeWord=<$codeWord> and theToEmail=<$to>\n";	
		}
		my $str = $connection->prepare("SELECT * FROM codeWord WHERE word = \"$codeWord\"");
		$str->execute;
		my @resultsCheck=$str->fetchrow_array;
		if ( $resultsCheck[1] ) {
			print LOG "we found that codeWord\n";
			$CLI = $resultsCheck[1];
			$CLI =~ s/qq/$from/g;
			my $fromWithoutAtSymbol = $from;
			$fromWithoutAtSymbol =~ s/\@/_/g;
			$CLI =~ s/qb/$fromWithoutAtSymbol/g;
			$theTextForNextScript = $code;
			while (($CLI =~ /jq/) or ($CLI =~ /qj/) or ($CLI =~ /jj/)){
				print LOG "in while and CLI=<$CLI>\n";
				if (($CLI =~ /qj/) and ($CLI !~ /jq/) and ($CLI !~ /jj/)) {
					getNextWord();	
					my $tempCLI2 = $nextWord;				
					while (isAnotherWordBeforeNextStar()) {
						getNextWord();
						$tempCLI2 = $tempCLI2 . " " . $nextWord;
					}
					print LOG "CLI is <$CLI> and tempCLI2 is <$tempCLI2>\n";
					$CLI =~ s/qj/$tempCLI2/;	
				}
				my $preJQ = $CLI;
				if ($CLI =~ /jq/) {
								#that out myself by getting all of the matches and finding the shortest one
					$preJQ = findSmallestjq($CLI); #I do not know of a way to get the smallest match, so I have to figure
					print LOG "just found a jq, the preJQ is <$preJQ>\n";
				}
				if ($preJQ =~ /jj/) {
					print LOG "still in while, there is a jj prior to the jq. We will take care of the jj first\n";
					getNextWord();
					$CLI =~ s/jj/$nextWord/;
				}
				elsif ($preJQ =~ /jq/) {
					print LOG "there is a jq before the next jj. So we are taking care of it\n";
					$CLI =~ s/jq/$nextWord/;
				}
				elsif (isAnotherWordBeforeNextStar()) {
					print LOG "still in while. A jj with the next word\n";
					getNextWord();
					$CLI =~ s/jj/$nextWord/;
				}
				else {
					print LOG "still in while. It appears there are no jq or qj and the last nextWord is done. So we are doing another jj if there is one\n";
					$CLI =~ s/jj/$nextWord/;
				}
				print LOG "completing a while iteration with CLI=<$CLI>\n";
			}
			$CLI =~ s/\\q\\j/qj/g;
			$CLI =~ s/\\q\\b/qb/g;			
			$CLI =~ s/\\j\\j/jj/g;
			$CLI =~ s/\\q\\q/qq/g;
			$CLI =~ s/\\j\\q/jq/g;
			$CLI =~ s/\\q\\j/qj/g;
			$CLI =~ s/\\q\\z/qz/g;
			$CLI =~ s/\\\\q\\\\j/\\q\\j/g;
			$CLI =~ s/\\\\q\\\\b/\\q\\b/g;			
			$CLI =~ s/\\\\j\\\\j/\\j\\j/g;
			$CLI =~ s/\\\\q\\\\q/\\q\\q/g;
			$CLI =~ s/\\\\j\\\\q/\\j\\q/g;
			$CLI =~ s/\\\\q\\\\j/\\q\\j/g;
			$CLI =~ s/\\\\q\\\\z/\\q\\z/g;
			$CLI =~ s/\\\\\\q\\\\\\j/\\\\q\\\\j/g;
			$CLI =~ s/\\\\\\q\\\\\\b/\\\\q\\\\b/g;			
			$CLI =~ s/\\\\\\j\\\\\\j/\\\\j\\\\j/g;
			$CLI =~ s/\\\\\\q\\\\\\q/\\\\q\\\\q/g;
			$CLI =~ s/\\\\\\j\\\\\\q/\\\\j\\\\q/g;
			$CLI =~ s/\\\\\\q\\\\\\j/\\\\q\\\\j/g;
			$CLI =~ s/\\\\\\q\\\\\\z/\\\\q\\\\z/g;
			$CLI =~ s/\\\\\\\\q\\\\\\\\j/\\\\\\q\\\\\\j/g;
			$CLI =~ s/\\\\\\\\q\\\\\\\\b/\\\\\\q\\\\\\b/g;			
			$CLI =~ s/\\\\\\\\j\\\\\\\\j/\\\\\\j\\\\\\j/g;
			$CLI =~ s/\\\\\\\\q\\\\\\\\q/\\\\\\q\\\\\\q/g;
			$CLI =~ s/\\\\\\\\j\\\\\\\\q/\\\\\\j\\\\\\q/g;
			$CLI =~ s/\\\\\\\\q\\\\\\\\j/\\\\\\q\\\\\\j/g;
			$CLI =~ s/\\\\\\\\q\\\\\\\\z/\\\\\\q\\\\\\z/g;

			#$CLI =~ s/\\\#\\\#/\#\#/g;

			$code = "$CLI $theTextForNextScript";
			print LOG "code =<$code>\n";
		}
		else {
			$to = $global_email_Main_User_Name;
		}
		print LOG "leaving codeWord()\n";
	
	}
}	




sub findSmallestjq {
	my $tempCLI = $_[0];
	if ($tempCLI =~ /^(.*jq).*jq/) {
		return findSmallestjq($1);
	}
	else {
		return $tempCLI;
	}
}


sub getNextWord {
	print LOG "in getNextWord and rest of code is <$theTextForNextScript>\n";
	my $temp = $_[0];
	if ($theTextForNextScript  =~ /\w/ ) {
		my @spaceDelimitedtheText = split(/ /,$theTextForNextScript);
		$nextWord = $spaceDelimitedtheText[0];
		$lastNextWord = $nextWord;
		chomp ($nextWord);
		my $spaceDelimitedSize = $#spaceDelimitedtheText - 1;
		splice(@spaceDelimitedtheText,0,1);
		$theTextForNextScript = join(" ",@spaceDelimitedtheText);
	}
	else {
		print LOG "no more codeWords exist in getNextWord so we are redoing the last one\n";		
		$nextWord = $lastNextWord;
	}
	print LOG "leaving getNextWord with nextWord <$nextWord>\n";
}





sub isAnotherWordBeforeNextStar {
	print LOG "in isAnotherWordBeforeNextStar and rest of code is <$theTextForNextScript>\n";
	if ($theTextForNextScript =~ /^$/ or $theTextForNextScript =~ /^\*\w$/ or $theTextForNextScript !~ /\w/) {
		print LOG "leaving isAnotherWordBeforeNextStar with 0\n";
		return 0;
	}
	else {
		print LOG "leaving isAnotehrWordBeforeNextStar with 1\n";		
		return 1;
	} 
}




sub createOutputFileForNextScript {
	use Time::HiRes qw(gettimeofday);

	print LOG "entering createOutputFileForNextScript\n";
	my $folder = 'workToDo/';
	my $scriptName = 'parser';
	my $extension = 'parse';

	my $numVariables = $_[0];
	#print $numVariables;
	my $timestamp = int (gettimeofday * 1000000000);
	open(OUTVARIABLEFILE,"+>$folder$timestamp$scriptName.$extension");
	print "$folder$timestamp$scriptName.$extension\n";
	my $temp = 1;
	for ($temp = 1; $temp <= $numVariables; $temp++) {
		print OUTVARIABLEFILE "iiiiiiiiBeginNewVariableiiiiiiiiiii\n";
		print OUTVARIABLEFILE "$_[$temp]\n";
	}
	close (OUTVARIABLEFILE);
	print LOG "leaving createOutputFileForNextScript\n";
}	







sub makeSureThisSMSandNotMMSEmail {
	use DBI;
	my $host = $global_MYSQL_host;
	my $database = $global_MYSQL_database;
	my $username = $global_MYSQL_username;
	my $password = $global_MYSQL_password;

	#all of the blog variables
	my $connectionInfo = "dbi:mysql:$database;$host";
	my $connection = DBI->connect($connectionInfo, $username, $password);
	
	print LOG "in makeSureThisSMSandNotMMSEmail with email address <$_[0]>\n";





	my $preFrom = $_[0];
	my $preFromDomain;
	my $preFromName;
	$preFrom =~ /^(.*)(@.*\..*)$/;
	$preFromName = $1;	
	$preFromDomain = $2;
	print LOG "the email Name is <$preFromName> and domain <$preFromDomain>\n";
	my $str = $connection->prepare("SELECT * FROM sms2mmsEmails WHERE (mmsDomain = \'$preFromDomain\')");
	$str->execute;
	my @resultsCheck=$str->fetchrow_array;
	if ($resultsCheck[0]) {
		print LOG "leaving makeSureThisSMSandNotMMSEmail with a new email address <$resultsCheck[0]>\n";
		return $preFromName . $resultsCheck[0];
	}
	else {
		print LOG "leaving makeSureThisSMSandNotMMSEmail with the original email address\n";
		return $preFrom;
	}
}
