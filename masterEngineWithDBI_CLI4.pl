

#!/usr/bin/perl
#
#masterEngine.pl
#
#This is the central core of the gateway. Email content
#comes here to figure out what its content needs to do
#all parent scripts used to connect the sms message with the
#internet need to be in here somewhere or they cannot
#be used.
#
#
#Args = $ARGV[0]:emailaddress
#Args = $ARGV[1]:sms value
use strict;
use DBI;
use Cwd;

my $dir = getcwd;
open (LOGBLOG, "+>logs\/log_blog.txt");
my ($sec, $min, $hr, $day, $mon, $year) = localtime;	
printf LOGBLOG ("#####\n#####\n#####\n%02d/%02d/%04d %02d:%02d:%02d:", $day, $mon + 1, 1900 + $year, $hr, $min, $sec);
close (LOGBLOG);
open (LOG, "+>logs\/log_masterEngine.txt");
($sec, $min, $hr, $day, $mon, $year) = localtime;
printf LOG ("#####\n#####\n#####\n%02d/%02d/%04d %02d:%02d:%02d:In masterEngine.pl \n", $day, $mon + 1, 1900 + $year, $hr, $min, $sec);
#print "z";

my $theApp;
my $logBlogLines = 0;
my $logLines = 0;
my $theTextCompleted = "";
my $closeUpString = "";
my $host = $global_MYSQL_host;
my $database = $global_MYSQL_database;
my $username = $global_MYSQL_username ;
my $password = $global_MYSQL_password;

#all of the blog variables
my $connectionInfo = "dbi:mysql:$database;$host";
my $connection = DBI->connect($connectionInfo, $username, $password);
my $connection2 = DBI->connect($connectionInfo, $username, $password);

my $hostBlog = $global_MYSQL_host;
my $databaseBlog = $global_MYSQL_database;
my $usernameBlog = $global_MYSQL_username;
my $passwordBlog = $global_MYSQL_password;
my $theEmailBlog;
my $theAppBlog;
my $theSubAppBlog;
my $theTextBlog;
my $theTextBlogCompleted;
my $theTextBlogForNextScript;
my $closeUpBlogStringBlog;
my $passwordBlogSet;
my @spaceDelimitedtheTextBlog;
my $nextWordBlog;

my $connectionInfoBlog = "dbi:mysql:$databaseBlog;$hostBlog";

my $connectionBlog = DBI->connect($connectionInfoBlog, $usernameBlog, $passwordBlog);	

#my $str = $connection->prepare("DELETE FROM apps");
#$str->execute;
#my $str = $connection->prepare("DELETE FROM blogList");
#$str->execute;
#my $str = $connection->prepare("DELETE FROM blogPosts");
#$str->execute;
#my $str = $connection->prepare("DELETE FROM blogSubscriptions");
#$str->execute;



#arg1 is phone number of sender
#arg2 is text
my $theEmail = $ARGV[0];
chomp($theEmail);
my $theText = $ARGV[1];
chomp($theText);
#for some reason extra carriage returns are showing up at the end. 
#Also, if someone wants to put carriage returns into their post we fix it here 
PRINTLOG ("theText before changing the carraige returns:#\n$theText\n#\n");
$theText =~ s/\\n$//g;
$theText =~ s/\\\\n/\n/g;
$theText =~ s/\\\\\\n/\\\\n/g;
PRINTLOG ("theText after changing the carraige returns:#\n$theText\n#\n");
my $attachmentString = $ARGV[2];
chomp($attachmentString);
my $theOriginalFrom = $ARGV[3];
chomp ($theOriginalFrom);
$theOriginalFrom =~ /@(.*)$/; 
my $theOriginalFromURL = $1;
my $theFrom = $theOriginalFromURL;
chomp($theFrom);
my $fromEmail;
if ($theFrom =~ /<(.*)>/) {
	$theFrom = $1;
}
if ($theFrom =~ /\w/) {
	$fromEmail = $theOriginalFrom;
}
if ($theText =~ /qz/) {
	#this adds the last conversation onto this script
	my $str = $connection->prepare("SELECT * FROM lastEmailSent WHERE (theTo = \"$theEmail\" and theFrom = \"$fromEmail\")");
	$str->execute();
	my @resultsCheck=$str->fetchrow_array;	
	$theText =~ s/qz/$resultsCheck[3]/s;
		
}
elsif ($theText =~ /\\q\\z/) {
	#this lets us use the script qz on the script
	$theText =~ s/\\q\\z/qz/s;
		
}
PRINTLOG ("starting values\ntheEmail=$theEmail=\ntheText=$theText=\nattachmentString=$attachmentString\n\n\n");

my $nextWord;
my @theTextForNextScriptArray;
my $theTextForNextScript = $theText;
PRINTLOG( "about to go into getNextWord with theText=$theText=\n");
getNextWord("");
PRINTLOG( "getNextWord is done. nextWord=$nextWord=\n");

#lets see if there is a number to rank the most recent item seen
if ($nextWord =~ /\d/) {
	#
#
#	insert ranking code here
#
#
	getNextWord("");
}







while ($nextWord) {
	#print "y";
	PRINTLOG( "\n\n\n***********\ngoing through while loop to go into a new star sub with <$nextWord>\n");
	#as long as there are nextWords, we will continue this. 
	if ($nextWord =~ /^\*c/) {
	#starc creates a codeword and its script
		starc();
	}
	elsif ($nextWord =~ /^\*p/) {
	#starp adds a password to a subapp
		starp();
	}
	elsif ($nextWord =~ /^\*n/) {
	#starn adds a new app
	starn();
	}
	elsif ($nextWord =~ /^\*e/) {	
	#look into a subApp
		stare();
	}
	elsif ($nextWord =~ /^\*a/) {
	#stara changes the admins. either removing an admin or adding one
		stara();
	}
	elsif ($nextWord =~ /^\*x/) {
	#starx adds a subapp to an app
		starx();
	}
	elsif ($nextWord =~ /^\*z/) {
		starz();
	}
	elsif ($nextWord =~ /^\*s/) {
	#app status
		stars();
	}
	elsif ($nextWord =~ /^\*r/) {
	#app security
		starr();
	}
	elsif ($nextWord =~ /^\*m/) {
	#change From email
		starm();
	}
	elsif ($nextWord =~ /^\*h/) {
	#suggest some subapps for this app
		starh();
	}
	elsif ($nextWord =~ /^\*b/) {
	#search app
		starb();
	}
	elsif ($nextWord =~ /^\*d/) {
	#search all possible
		stard();
	}
	elsif ($nextWord =~ /^\*g/) {
	#admin accept app reader
		PRINTLOG( "going into starg\n");
		starg();
	}
	elsif ($nextWord =~ /^\*y/) {
	#change user nickname
		PRINTLOG( "going into stary\n");
		stary();
	}
	elsif ($nextWord =~ /^\*(\d*)/) {
	#perform a temp Code
		my $theNumber = $_[0];
		starNumber($theNumber);
	}

	#elsif ($nextWord =~ /^\*f/) {
	#user request to read app
	#	starf();
	#}
	elsif ($nextWord =~ /exit/) {
		PRINTLOG( "in exit\n");		
		$connection->do("update userUsage SET currentString=\'\' WHERE userName=\'$theEmail\'");	
		$theTextCompleted = "";
		getNextWord();
	}
	elsif ($nextWord =~ /^#/ ) {
		#this gets the recent usage string the recent usage string
		PRINTLOG( "no codeword so lets see what user did last\n");
		my $str = $connection->prepare("SELECT * FROM userUsage WHERE userName = \"$theEmail\"");
		$str->execute();
		my @resultsCheck=$str->fetchrow_array;	

		if ($resultsCheck[2] =~ /\w/) {
			PRINTLOG( "in if\n");		
			$theTextCompleted = "";	
			$theTextForNextScript =~ s/^\s+|\s+$//g;
			my @spaceDelimitedtheText = split(/ /,$theTextForNextScript);
			$nextWord = "";
		}
		getNextWord();
		PRINTLOG( "about to get first nextWord=<$nextWord> before while\n");
	}
	elsif ($nextWord =~ /^\w/) {
		my $variables = "";
		my $CLI;
		#this looks at codewords
		my $str = $connection->prepare("SELECT * FROM codeWord WHERE word = \"$nextWord\"");
		$str->execute;
		my @resultsCheck=$str->fetchrow_array;
		if ( @resultsCheck[1] ) {
			$CLI = $resultsCheck[1];
			$CLI =~ s/qq/$theEmail/g;
			while (isAnotherWordBeforeNextStar()) {
				PRINTLOG( "in while and CLI=<$CLI>\n");
				getNextWord();
				$CLI =~ s/jj/$nextWord/;
			}
			$theTextForNextScript = "$CLI $theTextForNextScript";
		}
		else {
			closeUp("");
		}
		getNextWord();
	}
	else {
		PRINTLOG( "completed while loop and nothing was found\n");
		closeUp("");
	}
}















###############################
#############Subs##############
###############################

sub sendOutText {
	PRINTLOG( "in sendOutText\n");
	my $sendOutEmail = $_[0];
	my $bodyOfEmail = $_[1];
	my $myRepeat = $_[2];
	my $execWorked;
	if ($bodyOfEmail =~ /\w/) {
		createOutputFileForNextScript("4", $sendOutEmail, $bodyOfEmail, $fromEmail,$myRepeat);
	}	
	PRINTLOG( "about to make to make an email with \"$sendOutEmail\" \"$bodyOfEmail\ \"$fromEmail\")\n");
	PRINTLOG( "leaving sendOutText\n");
}

sub closeUp {
	PRINTLOG( "in closeup\n");
	my $temp = $_[0];
	PRINTLOG( "in closeUp. theTextCompleted=$theTextCompleted=\n");
	$connection->do("update userUsage SET currentString=\'$theTextCompleted\' WHERE userName=\'$theEmail\'");
	$closeUpString = $closeUpString . $temp;
	sendOutText($theEmail,$closeUpString,0);
	PRINTLOG( "leaving closeup\n");	
	die;
}


sub createOutputFileForNextScript {
	use Time::HiRes qw(gettimeofday);

	my $folder = 'workToDo/';
	my $scriptName = 'masterEngine';
	my $extension = 'medc';

	my $numVariables = $_[0];
	PRINTLOG("in createOutputFileForNextScript with this many variables <$numVariables> the first three are <$_[0]> <$_[1]> <$_[2]>\n");
	my $timestamp = int (gettimeofday * 1000000000);
	open(OUTVARIABLEFILE,"+>$folder$timestamp$scriptName.$extension");
	PRINTLOG( " this is the output data file <$folder$timestamp$scriptName.$extension>\n");
	my $temp = 1;
	for ($temp = 1; $temp <= $numVariables; $temp++) {
		print OUTVARIABLEFILE "iiiiiiiiBeginNewVariableiiiiiiiiiii\n";
		my $nextVariableToPrint = $_[$temp];
		if ($nextVariableToPrint =~ /^(.*)45454545454545\W*$/)	{
			$nextVariableToPrint = $1;
		}	
		#This is where we save the last thing sent from this conversation. In case it will be used later
		if ($temp == 2) {
			saveThisEmail($_[1],$_[2],$_[3]);
		}
		print OUTVARIABLEFILE "$nextVariableToPrint\n";
	}
	close (OUTVARIABLEFILE);
}	




sub saveThisEmail {
	PRINTLOG("in saveThisEmail\n");
	my $myTo = $_[0];
	my $myPost = $_[1];	
	my $myFrom = $_[2];



	#make sure this conversation doesn't exist yet
	PRINTLOG("about to do the following MYSQL <SELECT * FROM lastEmailSent WHERE theTo = \'$myTo\' and theFrom = \'$myFrom\'>\n");
	my $str = $connection->prepare("SELECT * FROM lastEmailSent WHERE theTo = \'$myTo\' and theFrom = \'$myFrom\'");
	$str->execute;
	my @resultsCheck=$str->fetchrow_array; 
	PRINTLOG("about to evaluate if resultsCheck had anything <$resultsCheck[0]>\n");
	if (not $resultsCheck[0]) {
		PRINTLOG ("this conversation did not exist. About to add it <$myPost>\n");
		$connection->do("INSERT INTO lastEmailSent (theTo,theFrom,post) VALUES (\'$myTo\',\'$myFrom\',\'$myPost\')");
		PRINTLOG ("leaving saveThisEmail with everything set\n");
		return;
	}
	else {
		PRINTLOG ("This conversation did exist. We are adding it");
		$connection->do("update lastEmailSent SET post=\'$myPost\' WHERE (theTo = \'$myTo\' and theFrom =\'$myFrom\')");
		return;
		PRINTLOG ("Leaving saveThisEmail successfully\n");
	}
}	

sub getNextWord {
	PRINTLOG( "in getNextWord\n");
	my $temp = $_[0];
	if ($theTextForNextScript  =~ /\w/ or $theTextForNextScript  =~ /\#/ or $theTextForNextScript  =~ /\*/ ) {
		my @spaceDelimitedtheText = split(/ /,$theTextForNextScript);
		$nextWord = $spaceDelimitedtheText[0];
		chomp ($nextWord);
		@theTextForNextScriptArray = shift(@spaceDelimitedtheText);
		$theTextForNextScript = join(" ",@spaceDelimitedtheText);
		$theTextCompleted = $theTextCompleted . " " . $nextWord;
		chomp($theTextCompleted);
	}
	else {
		PRINTLOG( "leaving getNextWord. It appears no more words exist\n");		
		closeUp("");
	}
	PRINTLOG( "leaving getNextWord with nextWord <$nextWord>\n");
}

sub isAnotherWordBeforeNextStar {
	PRINTLOG( "in isAnotherWordBeforeNextStar and theTextForNextScript:<$theTextForNextScript> and nextWord:<$nextWord>\n");
	if ($theTextForNextScript !~ /^$/) {
		my @spaceDelimitedtheText = split(/ /,$theTextForNextScript);
		my $nextWordTemp = $spaceDelimitedtheText[0];
		my $tempInt = 1;
		while (($nextWordTemp =~ /^\s*$/) and ($#spaceDelimitedtheText > $tempInt)) {
			$nextWordTemp = $spaceDelimitedtheText[$tempInt];
			$tempInt++;
		}	

	
		if ($nextWordTemp =~ /^$/ or $nextWordTemp =~ /^\*\w$/ or $nextWordTemp =~ /^\#\#/) {
			PRINTLOG( "leaving isAnotherWordBeforeNextStar with <0>\n");
			return 0;
		}
		else {
			PRINTLOG( "leaving isAnotherWordBeforeNextStar with <1>\n");
			return 1;
		} 
	}
}


sub isAnotherWordOfCodeWord {
	PRINTLOG( "in isAnotherWordOfCodeWord and theTextForNextScript:<$theTextForNextScript> and nextWord:<$nextWord>\n");
	if ($theTextForNextScript  =~ /\w/ ) {
		my @spaceDelimitedtheText = split(/ /,$theTextForNextScript);
		my $nextWordTemp = $spaceDelimitedtheText[0];	
		if ($nextWordTemp =~ /^$/ or $nextWordTemp =~ /^\#\#/) {
			PRINTLOG( "leaving isAnotherWordBeforeNextStar with <0>\n");
			return 0;
		}
		else {
			PRINTLOG( "leaving isAnotherWordBeforeNextStar with <1>\n");
			return 1;
		} 
	}
}

sub isAnotherWord {
	PRINTLOG( "in isAnotherWord with <$theTextForNextScript>\n");	
	if ($theTextForNextScript =~ /^$/) {
		PRINTLOG( "leaving isAnotherWord with <0> as there was no more words\n");		
		return 0;
	}
	if ($theTextForNextScript =~ /^\#\#/) {
		PRINTLOG( "leaving isAnotherWord with <0> as there was a pound#\n");
		getNextWord();		
		return 0;
	}
	else {
		PRINTLOG( "leaving isAnotherWord with <1>\n");
		return 1;
	} 
}

sub PRINTLOG {
	$logLines++;
	if ($logLines < 5000) {
		print LOG $_[0];
	}	
	else {
		die;
	}
}

sub starIsDone {
	PRINTLOG( "in starIsDone\n");
	my $temp = $_[0];
	$connection->do("update userUsage SET currentString=\'\' WHERE userName=\'$theEmail\'");
	$theTextCompleted = "";
	$closeUpString = $closeUpString . " " . $temp;
	getNextWord("$closeUpString");
	PRINTLOG( "leaving starIsDone\n");
}


sub findAllOptionsOrFormat {
	PRINTLOG( "in findAllOptions\n");	
	my $temp = "";
	if (isAnotherWordBeforeHash()) {
		getNextWord();
		$temp = $nextWord;
	}
	while (isAnotherWordBeforeHash()) {
		getNextWord();
		$temp = $temp . " " . $nextWord;
	}
	PRINTLOG( "leaving findAllOptions with return <$temp> and nextWord <$nextWord> and theTextForNextScript:<$theTextForNextScript>\n");
	return $temp;	

}





sub isAnotherWordBeforeHash {
	PRINTLOG( "in isAnotherWordBeforeHash and theTextForNextScript:<$theTextForNextScript> and nextWord:<$nextWord>\n");
	my @nextWordTemp = split(/ /,$theTextForNextScript);	
	if ($nextWordTemp[0] =~ /^$/) {
		PRINTLOG( "leaving isAnotherWordBeforeHash with <0>\n");
		return 0;
	}
	if ($nextWordTemp[0] =~ /^\#$/) {
		PRINTLOG( "leaving isAnotherWordBeforeHash with, it was a # so I am moving the getNextWord cursor to the next word <0>\n");
		return 0;
	}
	if ($nextWordTemp[0] =~ /^\#\#$/) {
		PRINTLOG( "leaving isAnotherWordBeforeHash with, it was a ## so I am moving the getNextWord cursor to the next word <0>\n");
		return 0;
	}
	else {
		PRINTLOG( "leaving isAnotherWordBeforeHash with <1>\n");
		return 1;
	} 
}




sub addEmailUser {
	PRINTLOG ("in addEmailUser with <" . $_[0] . ">\n");
	my $theWord = $_[0];

	open (EMAILS, ">>\/etc\/postfix\/vmailbox");
	my $fullNewWord	= $theWord . '@' . $theOriginalFromURL;
	PRINTLOG( "about to add vmailbox user $fullNewWord\n");
	print EMAILS "\n" . $fullNewWord . "\thome";
	close EMAILS;
	system "postmap /etc/postfix/vmailbox";
	system "postfix reload";
	PRINTLOG ("leaving addEmailUser after adding the following to vmailbox <$fullNewWord . \thome>\n");

}



sub getAllSubAppCode {
	PRINTLOG( "in getAllSubAppCode\n");	
	my $temp = "";
	if (isAnotherWordBeforeNextStar()) {
		getNextWord();
		$temp = $nextWord;
	}
	while (isAnotherWordBeforeNextStar()) {
		getNextWord();
		$temp = $temp . " " . $nextWord;
	}
	PRINTLOG( "leaving getAllSubAppCode with return <$temp>\n");
	return $temp;
}


sub getAllCodeWord {
	PRINTLOG( "in getAllCodeWord\n");	
	my $temp = "";
	while (isAnotherWordOfCodeWord()) {
		getNextWord();
		$temp = $temp . " " . $nextWord;
	}
	PRINTLOG( "leaving getAllCodeWord with return <$temp>\n");
	return $temp;
}


sub setNickname {
	my $theRealName = $_[0];
	PRINTLOG("In setNickname\nabout to do <select * FROM userUsage WHERE (userName = \'$theRealName\')>\n");	
	my $str2 = $connection2->prepare("select * FROM userUsage WHERE (userName = \'$theRealName\')");
    	$str2->execute;   
    	my @resultsCheck2=$str2->fetchrow_array;
	if ($resultsCheck2[4]) {
		return $resultsCheck2[4];
	}
	else {
		return $theRealName;
	}
	PRINTLOG("Leaving set nickname\n");

}


sub isAdminOrAll {
	PRINTLOG( "in isAdminOrAll\n");
	my $str = $connection->prepare("SELECT * FROM apps WHERE (appName = \'$theApp\' AND (admin1 = \'$theEmail\' OR admin2 = \'$theEmail\' OR admin3 = \'$theEmail\'))");
	$str->execute;
	my @resultsCheck=$str->fetchrow_array;
	if ($resultsCheck[0] =~ /^$/) {
		my $str1 = $connection->prepare("SELECT * FROM apps WHERE (appName = \'$theApp\' AND security = \'all\')");		
		$str1->execute;
		my @resultsCheck1=$str1->fetchrow_array;
		if ($resultsCheck1[0] =~ /^$/) {	
			closeUp("");
		}
		else {
			return 1;
		}
	}
	else {
		return 1;
	}
}

sub isAllNotAdmin {
	PRINTLOG( "in isAllNotAdmin\n");
	my $str1 = $connection->prepare("SELECT * FROM apps WHERE (appName = \'$theApp\' AND security = \'all\')");		
	$str1->execute;
	my @resultsCheck1=$str1->fetchrow_array;
	if ($resultsCheck1[0] =~ /^$/) {	
		return 0;
		}
	else {
		return 1;
	}
}


sub isAdminOrCreator {
	my $mySubAppName = $_[0];	
	PRINTLOG( "in isAdminOrCreator\n");
	PRINTLOG ("about to do <SELECT * FROM apps WHERE (appName = \'$theApp\' AND (admin1 = \'$theEmail\' OR admin2 = \'$theEmail\' OR admin3 = \'$theEmail\'))>\n");
	my $str = $connection->prepare("SELECT * FROM apps WHERE (appName = \'$theApp\' AND (admin1 = \'$theEmail\' OR admin2 = \'$theEmail\' OR admin3 = \'$theEmail\'))");
	$str->execute;
	my @resultsCheck=$str->fetchrow_array;
	if ($resultsCheck[0] =~ /^$/) {
		if (isAdminOrAll()) {
			PRINTLOG("about to do <SELECT * FROM blogList WHERE (appName = \'$theApp\' AND subAppName = \'$mySubAppName\' AND creator  = \'$theEmail\')>\n");
			my $str1 = $connection->prepare("SELECT * FROM blogList WHERE (appName = \'$theApp\' AND subAppName = \'$mySubAppName\' AND creator  = \'$theEmail\')");		
			$str1->execute;
			my @resultsCheck1=$str1->fetchrow_array;
			if ($resultsCheck1[0] =~ /^$/) {	
				
	PRINTLOG ("leaving isAdminOrCreator with <0>, not an admin or creator\n");								
				return 0;
			}
			else {
				PRINTLOG ("leaving isAdminOrCreator with <1>. Email is a creator\n");
				return 1;
			}
		}
		else {
				PRINTLOG ("leaving isAdminOrCreator with <0>, isAdminOrAdd did not work\n");
			return 0;
		}
	}
	else {
		PRINTLOG("leaving isAdminOrCreator with <1>. Email is an admin\n");
		return 1;
	}
}

sub takeOffHashes {
	PRINTLOG("In takeOffHashes with <$_[0]>\n");
	my $theCLI = $_[0];	
	$theCLI =~ s/\\\#\\\#/\#\#/g;
	$theCLI =~ s/\\\\\#\\\\\#/\\\#\\\#/g;
	$theCLI =~ s/\\\\\\\#\\\\\\\#/\\\\\#\\\\\#/g;
	$theCLI =~ s/\\\\\\\\\#\\\\\\\\\#/\\\\\\\#\\\\\\\#/g;
	$theCLI =~ s/\\q\\j/qj/g;
	$theCLI =~ s/\\q\\b/qb/g;	
	$theCLI =~ s/\\j\\j/jj/g;
	$theCLI =~ s/\\q\\q/qq/g;
	$theCLI =~ s/\\j\\q/jq/g;
	$theCLI =~ s/\\q\\j/qj/g;
	$theCLI =~ s/\\q\\z/qz/g;
	$theCLI =~ s/\\\\q\\\\j/\\q\\j/g;
	$theCLI =~ s/\\\\q\\\\b/\\q\\b/g;	
	$theCLI =~ s/\\\\j\\\\j/\\j\\j/g;
	$theCLI =~ s/\\\\q\\\\q/\\q\\q/g;
	$theCLI =~ s/\\\\j\\\\q/\\j\\q/g;
	$theCLI =~ s/\\\\q\\\\j/\\q\\j/g;
	$theCLI =~ s/\\\\q\\\\z/\\q\\z/g;
	$theCLI =~ s/\\\\\\q\\\\\\j/\\\\q\\\\j/g;
	$theCLI =~ s/\\\\\\q\\\\\\b/\\\\q\\\\b/g;	
	$theCLI =~ s/\\\\\\j\\\\\\j/\\\\j\\\\j/g;
	$theCLI =~ s/\\\\\\q\\\\\\q/\\\\q\\\\q/g;
	$theCLI =~ s/\\\\\\j\\\\\\q/\\\\j\\\\q/g;
	$theCLI =~ s/\\\\\\q\\\\\\j/\\\\q\\\\j/g;
	$theCLI =~ s/\\\\\\q\\\\\\z/\\\\q\\\\z/g;
	$theCLI =~ s/\\\\\\\\q\\\\\\\\j/\\\\\\q\\\\\\j/g;
	$theCLI =~ s/\\\\\\\\q\\\\\\\\b/\\\\\\q\\\\\\b/g;	
	$theCLI =~ s/\\\\\\\\j\\\\\\\\j/\\\\\\j\\\\\\j/g;
	$theCLI =~ s/\\\\\\\\q\\\\\\\\q/\\\\\\q\\\\\\q/g;
	$theCLI =~ s/\\\\\\\\j\\\\\\\\q/\\\\\\j\\\\\\q/g;
	$theCLI =~ s/\\\\\\\\q\\\\\\\\j/\\\\\\q\\\\\\j/g;
	$theCLI =~ s/\\\\\\\\q\\\\\\\\z/\\\\\\q\\\\\\z/g;
	PRINTLOG("Leaving takeOffHashes with <$theCLI>\n");
	return $theCLI;

}

sub isAdmin {
    	#see if this guy is an admin
	PRINTLOG(" in isAdmin about to do <SELECT * FROM apps WHERE (appName = \'$theApp\' AND (admin1 = \'$theEmail\' OR admin2 = \'$theEmail\' OR admin3 = \'$theEmail\'))>\n");
    	my $str = $connection->prepare("SELECT * FROM apps WHERE (appName = \'$theApp\' AND (admin1 = \'$theEmail\' OR admin2 = \'$theEmail\' OR admin3 = \'$theEmail\'))");
    	$str->execute; 
    	my $theAdmin = $theEmail;    
    	my @resultsCheck=$str->fetchrow_array;
    	if (@resultsCheck) {
		PRINTLOG( "leaving isAdmin with return <1>\n");
		return 1;
    	}
	else {
		PRINTLOG( "leaving isAdmin with return <0>\n");
		return 0;
	}
}
sub finalPostFormat {
	my $mySearchTerm = $_[0];
	my $myPost = $_[1];
	my $toEmail = $_[2];
	my $theFromEmail = $_[3];
	my $myFormat = $_[4];
	$myFormat =~ s/^ //; #we seem to have a leading space. get rid of it
	my $finalPost = $_[5];
	my $searchResultsString = $_[6];
	if ($myFormat =~ /^(?<!\\)\{/){
		$finalPost = $finalPost . $myPost;
		do {
			$myFormat =~ s/.//;
		} while ($myFormat !~ /^(?<!\\)\}/) ;
		$myFormat =~ s/.//;
		PRINTLOG ("It was a { myformat was <$myFormat> and finalPost is now <$finalPost>\n");
		return finalPostFormat($mySearchTerm,$myPost,$toEmail,$theFromEmail,$myFormat,$finalPost);
	}
	elsif ($myFormat =~ /^\\\\/) {
		$myFormat =~ s/..//;
		$finalPost = $finalPost . "\\";
		PRINTLOG ("It was a \\ myformat was <$myFormat> and finalPost is now <$finalPost>\n");
		return finalPostFormat($mySearchTerm,$myPost,$toEmail,$theFromEmail,$myFormat,$finalPost);
	}	
	elsif ($myFormat =~ /^\\/) {
		$myFormat =~ s/.(.)//;
		$finalPost = $finalPost . $1;
		PRINTLOG ("It was a \ myformat was <$myFormat> and finalPost is now <$finalPost>\n");
		return finalPostFormat($mySearchTerm,$myPost,$toEmail,$theFromEmail,$myFormat,$finalPost);
	}
	elsif ($myFormat =~ /^-st/) {
		$finalPost = $finalPost . $mySearchTerm;
		$myFormat =~ s/...//;
		PRINTLOG ("It was a -st myformat was <$myFormat> and finalPost is now <$finalPost>\n");
		return finalPostFormat($mySearchTerm,$myPost,$toEmail,$theFromEmail,$myFormat,$finalPost);
	}
	elsif ($myFormat =~ /^-e/) { #carrage return for the format
		$finalPost = $finalPost . "45454545454545";
		$myFormat =~ s/..//;
		PRINTLOG ("It was a -e myformat was <$myFormat> and finalPost is now <$finalPost>\n");
		return finalPostFormat($mySearchTerm,$myPost,$toEmail,$theFromEmail,$myFormat,$finalPost);
	}
	elsif ($myFormat =~ /^-t/) {
		$finalPost = $finalPost . $toEmail;
		$myFormat =~ s/..//;
		PRINTLOG ("It was a -t myformat was <$myFormat> and finalPost is now <$finalPost>\n");
		return finalPostFormat($mySearchTerm,$myPost,$toEmail,$theFromEmail,$myFormat,$finalPost);
	}
	elsif ($myFormat =~ /^-fe/) {
		$finalPost = $finalPost . $theFromEmail;
		$myFormat =~ s/...//;
		PRINTLOG ("It was a -fe myformat was <$myFormat> and finalPost is now <$finalPost>\n");
		return finalPostFormat($mySearchTerm,$myPost,$toEmail,$theFromEmail,$myFormat,$finalPost);
	}
	elsif ($myFormat =~ /^$/) {
		PRINTLOG ("It is done. myformat was <$myFormat> and finalPost is now <$finalPost>\n");
		return $finalPost;
	}
	else {
		$myFormat =~ s/(.)//;
		$finalPost = $finalPost . $1;
		PRINTLOG ("myformat was <$myFormat> and finalPost is now <$finalPost>\n");
		return finalPostFormat($mySearchTerm,$myPost,$toEmail,$theFromEmail,$myFormat,$finalPost);
	}


	PRINTLOG ("Leaving finalPostFormat with <$finalPost>\n");
	return $finalPost;
}


sub addToPostFormat {
	my $myAuthor = $_[0];
	my $myDate = $_[1];
	my $mySubApp = $_[2];
	my $myApp = $_[3];
	my $numbers = $_[4];
	my $results = $_[5];
	my $myFormat = $_[6];
	my $finalPost = $_[7];
	if ($myFormat =~ /(?<!\\)\{(.*)(?<!\\)\}/) {
		$myFormat = $1;
		PRINTLOG ("We found a { in myformat: <$myFormat> and addToPost is now <$finalPost>\n");
		return addToPostFormat($myAuthor,$myDate,$mySubApp,$myApp,$numbers,$results,$myFormat,$finalPost);
	}
	elsif ($myFormat =~ /^\\\\/) {
		$myFormat =~ s/..//;
		$finalPost = $finalPost . "\\";
		PRINTLOG ("It was a \\ myformat was <$myFormat> and addToPost is now <$finalPost>\n");
		return addToPostFormat($myAuthor,$myDate,$mySubApp,$myApp,$numbers,$results,$myFormat,$finalPost);
	}	
	elsif ($myFormat =~ /^\\/) {
		$myFormat =~ s/.(.)//;
		$finalPost = $finalPost . $1;
		PRINTLOG ("It was a \ myformat was <$myFormat> and addToPost is now <$finalPost>\n");
		return addToPostFormat($myAuthor,$myDate,$mySubApp,$myApp,$numbers,$results,$myFormat,$finalPost);
	}
	elsif ($myFormat =~ /^-ap/) {
		$finalPost = $finalPost . $myApp;
		$myFormat =~ s/...//;
		PRINTLOG ("It was a -ap myformat was <$myFormat> and addToPost is now <$finalPost>\n");
		return addToPostFormat($myAuthor,$myDate,$mySubApp,$myApp,$numbers,$results,$myFormat,$finalPost);
	}
	elsif ($myFormat =~ /^-sa/) {
		$finalPost = $finalPost . $mySubApp;
		$myFormat =~ s/...//;
		PRINTLOG ("It was a -sa myformat was <$myFormat> and addToPost is now <$finalPost>\n");
		return addToPostFormat($myAuthor,$myDate,$mySubApp,$myApp,$numbers,$results,$myFormat,$finalPost);
	}
	elsif ($myFormat =~ /^-d/) {
		$finalPost = $finalPost . $myDate;
		$myFormat =~ s/..//;
		PRINTLOG ("It was a -d myformat was <$myFormat> and addToPost is now <$finalPost>\n");
		return addToPostFormat($myAuthor,$myDate,$mySubApp,$myApp,$numbers,$results,$myFormat,$finalPost);
	}
	elsif ($myFormat =~ /^-a/) {
		$finalPost = $finalPost . $myAuthor;
		$myFormat =~ s/..//;
		PRINTLOG ("It was a -a myformat was <$myFormat> and addToPost is now <$finalPost>\n");
		return addToPostFormat($myAuthor,$myDate,$mySubApp,$myApp,$numbers,$results,$myFormat,$finalPost);
	}
	elsif ($myFormat =~ /^-b/) {
		$finalPost = $finalPost . '*';
		$myFormat =~ s/..//;
		PRINTLOG ("It was a -b myformat was <$myFormat> and addToPost is now <$finalPost>\n");
		return addToPostFormat($myAuthor,$myDate,$mySubApp,$myApp,$numbers,$results,$myFormat,$finalPost);
	}
	elsif ($myFormat =~ /^-p/) {
		$finalPost = $finalPost . $results;
		$myFormat =~ s/..//;
		PRINTLOG ("It was a -p myformat was <$myFormat> and addToPost is now <$finalPost>\n");
		return addToPostFormat($myAuthor,$myDate,$mySubApp,$myApp,$numbers,$results,$myFormat,$finalPost);
	}
	elsif ($myFormat =~ /^-n/) {
		$finalPost = $finalPost . $numbers;
		$myFormat =~ s/..//;
		PRINTLOG ("It was a -n myformat was <$myFormat> and addToPost is now <$finalPost>\n");
		return addToPostFormat($myAuthor,$myDate,$mySubApp,$myApp,$numbers,$results,$myFormat,$finalPost);
	}
	elsif ($myFormat =~ /^$/) {
		PRINTLOG ("It is done. myformat was <$myFormat> and addToPost is now <$finalPost>\n");
		return $finalPost;
	}
	else {
		$myFormat =~ s/(.)//;
		$finalPost = $finalPost . $1;
		PRINTLOG ("myformat was <$myFormat> and addToPost is now <$finalPost>\n");
		return addToPostFormat($myAuthor,$myDate,$mySubApp,$myApp,$numbers,$results,$myFormat,$finalPost);
	}
	PRINTLOG("Leaving addToPost with <$finalPost>\n");
	return $finalPost;
}


sub createEmailToRequestAdminSecurityApproval {
	use Time::HiRes qw(gettimeofday);
	my $timestamp = int (gettimeofday * 1000000000);
	PRINTLOG ("In createEmailToRequestAdminSecurityApproval with <$_[0]> <$_[1]> <$_[2]> <$_[3]> <$_[4]>\n");
	my $myApp = $_[0];
	my $mySubApp = $_[1];
	my $myTheEmail = $_[2];
	my $mySubscribeOrRead = $_[3];
	my $myCLI = $_[4];
	my $myCodeName = "a" . $timestamp; #This is the myCodeName after demo version is complete. It cannot work with our email service as it makes 
	addEmailUser($myCodeName);	

	#emails with crazy numbers in them. This only works if our email service sends from any email address
	#my $myCodeName = "a13284928193829";
	#this is used for both subapp approvals and app approvals. So we first need to see if 
	#we need app admins or subapp admins
	if ($mySubApp =~ /^$/) {
		#this is an app admin request
		PRINTLOG(" this is an app request with <INSERT INTO codeWord (word,cli,username) VALUES (\'$myCodeName\',\'$myCLI\',\'admin\')>\n");
		my $myCLI = "*g $myApp -a -a $myTheEmail";
		#$connection->do("INSERT INTO codeWord (word,cli,username) VALUES (\'$myCodeName\',\'$myCLI\',\'admin\')");#This is the myCodeName after demo version is complete. It cannot work with our email service as it makes 
		#emails with crazy num bers in them. This only works if our email service sends from any email address
#mysql uses \ as a wildcard and deletes one. So the CLI needs an additional at each locations
		$myCLI =~ s/\\/\\\\/g;
		$connection->do("update codeWord SET cli = \'$myCLI\' WHERE (word = \'a13284928193829\')");
		my $theFromEmail = $myCodeName . '@' . $theOriginalFromURL;
		my $nickname = setNickname($theEmail);
		my $bodyEmail = "$nickname wishes to subscribe to $myApp. Text YES back to approve";
    		my $str = $connection->prepare("SELECT * FROM apps WHERE (appName = \'$myApp\')");
    		$str->execute; 
    		my @resultsCheck=$str->fetchrow_array;
    		if ($resultsCheck[3]) {
			createOutputFileForNextScript("3", $resultsCheck[3],$bodyEmail , $theFromEmail);
		}
    		if ($resultsCheck[4]) {
			createOutputFileForNextScript("3", $resultsCheck[4],$bodyEmail , $theFromEmail);
		}    		
		if ($resultsCheck[5]) {
			createOutputFileForNextScript("3", $resultsCheck[5],$bodyEmail , $theFromEmail);
		}
			PRINTLOG (" Leaving createEmailToRequestAdminSecurityApproval\n");
			return;		
	}
	else {
		#this is a subapp admin request
		PRINTLOG(" this is a subapp request with <INSERT INTO codeWord (word,cli,username) VALUES (\'$myCodeName\',\'myCodeName\',\'admin\')>\n");
		my $myCLI = "*e $myApp $mySubApp **a -a -a $mySubscribeOrRead $myTheEmail $fromEmail";
		$connection->do("INSERT INTO codeWord (word,cli,username) VALUES (\'$myCodeName\',\'$myCLI\',\'admin\')");#This is the myCodeName after demo version is complete. It cannot work with our email service as it makes 
	#emails with crazy numbers in them. This only works if our email service sends from any email address
		#mysql uses \ as a wildcard and deletes one. So the CLI needs an additional at each locations
		$myCLI =~ s/\\/\\\\/g;	
		PRINTLOG(" about to do <update codeWord SET cli=\'$myCLI\' where (word=\'a13284928193829\')>");
		$connection->do("update codeWord SET cli=\'$myCLI\' where (word=\'a13284928193829\')");
		my $theFromEmail = $myCodeName . '@' . $theOriginalFromURL;
		my $subscribeOrReadSpelledOut = "subscribe to";
		if ($mySubscribeOrRead =~ /r/) {
			$subscribeOrReadSpelledOut = "read";
		}
		my $nickname = setNickname($theEmail);
		my $bodyEmail = "$nickname wishes to $subscribeOrReadSpelledOut your group $mySubApp. Text me back YES to approve";
		my $str = $connection->prepare("SELECT * FROM blogList WHERE (appName = \'$myApp\' and subAppName = \'$mySubApp\')");
    		$str->execute; 
    		my @resultsCheck=$str->fetchrow_array;
    		if ($resultsCheck[4]) {
			createOutputFileForNextScript("3", $resultsCheck[4],$bodyEmail , $theFromEmail);
		}
    		if ($resultsCheck[5]) {
			createOutputFileForNextScript("3", $resultsCheck[5],$bodyEmail , $theFromEmail);
		}
    		if ($resultsCheck[6]) {
			createOutputFileForNextScript("3", $resultsCheck[6],$bodyEmail , $theFromEmail);
		}
    		if ($resultsCheck[7]) {
			createOutputFileForNextScript("3", $resultsCheck[7],$bodyEmail , $theFromEmail);
		}
		PRINTLOG (" Leaving createEmailToRequestAdminSecurityApproval\n");
		return;		
	}
	PRINTLOG (" Leaving createEmailToRequestAdminSecurityApproval\n");
	return;		
}#($theAppName,"",$theEmail);








####################
######stars#########
####################

sub starNumber {
	PRINTLOG( "In starNumber\n");
	my $theNumber = $_[0];
	my $str = $connection->prepare("SELECT * FROM tempCode WHERE userName = \'$theEmail\' AND codeNumber = \'$theNumber\'");
	$str->execute;
	my @resultsCheck=$str->fetchrow_array; 
	$theTextForNextScript = "$resultsCheck[3] $theTextForNextScript)"; 	
	$connection->do("delete FROM tempCode WHERE (userName = \'$theEmail\')");
	starIsDone();
}


sub stary {
	PRINTLOG( "In stary\n");
	getNextWord();	
	my $word = $nextWord;
	while (isAnotherWord() ) {
		getNextWord();
		$word = $word . " " . $nextWord;
	}
	my $str = $connection->prepare("SELECT * FROM userUsage WHERE userName = \'$theEmail\'");
	$str->execute;
	my @resultsCheck=$str->fetchrow_array; 
	if ($resultsCheck[0]) {
		PRINTLOG("about to do the following<update userUsage SET nickname=\'$word\' WHERE (userName = \'$theEmail\')>\n"); 
		$connection->do("update userUsage SET nickname=\'$word\' WHERE (userName = \'$theEmail\')");
		
	}
	else {
		$connection->do("INSERT INTO userUsage (userName,nickname) VALUES (\'$theEmail\',\'$word\')");
	}
	PRINTLOG("Leaving stary\n");
}



sub starh {
#select subAppName, count(*) as c from blogPosts where (appName = 'wikipedia') group by appName,subAppName order by c desc limit 3
#select subAppName, count(*) as c from blogSubscriptions where (appName = 'wikipedia') group by appName,subAppName order by c desc limit 3
	PRINTLOG ("In starh\n");
	use Time::HiRes qw(gettimeofday);
	getNextWord();
	my $myApp = $nextWord;
	getNextWord();
	my $myCLI = $nextWord;	
	while (isAnotherWord() ) {
		getNextWord();
		$myCLI = $myCLI . " " . $nextWord;
	}
	PRINTLOG ("myCLI for codeWord is <$myCLI>\n");
	PRINTLOG ("about to do <select subAppName, count(*) as c from blogSubscriptions where (appName = \'$myApp\') group by appName,subAppName order by c desc limit 5>\n");
	my $str = $connection->prepare("select subAppName, count(*) as c from blogSubscriptions where (appName = \'$myApp\') group by appName,subAppName order by c desc limit 5");
	$str->execute;
	my @resultsCheck=$str->fetchrow_array; 	
	while ($resultsCheck[0]) {
		my $timestamp = int (gettimeofday * 1000000000);
		$myCLI =~ s/js/$resultsCheck[0]/g;
		$myCLI =~ s/jz/$myApp/g;
		my $myCodeName = "s" . $timestamp;#This is the myCodeName after demo version is complete. It cannot work with our email service as it makes 
	#emails with crazy numbers in them. This only works if our email service sends from any email address
		#my $myCodeName = "s483942948523";
		addEmailUser($myCodeName);
		PRINTLOG(" the new CLI is <$myCLI>\n");
		#$connection->do("INSERT INTO codeWord (word,cli,username) VALUES (\'$myCodeName\',\'$myCLI\',\'admin\')");#This is the myCodeName after demo version is complete. It cannot work with our email service as it makes 
	#emails with crazy numbers in them. This only works if our email service sends from any email address
		$connection->do("update codeWord SET cli = \'$myCLI\' WHERE (word = \'s483942948523\')");
		my $theFromEmail = $myCodeName . '@' . $theOriginalFromURL;
		my $bodyEmail = "$resultsCheck[0] is very popular. Text anything back to subscribe\n";
		createOutputFileForNextScript("3", $theEmail,$bodyEmail , $theFromEmail);
		PRINTLOG (" created invite for $resultsCheck[0]\n");
		@resultsCheck=$str->fetchrow_array; 
	}
	PRINTLOG ("leaving starh\n");
}



sub starz {
	PRINTLOG( "In starz\n");
	if ($theEmail =~ /^${global_email_Main_User_Name}$/) {
	}
	else {
		closeUp("");
	}
	my $mysqlText = "";
	if (isAnotherWordOfCodeWord()) {
		getNextWord();
		$mysqlText = $nextWord;
	}
	while (isAnotherWordOfCodeWord()) {
		getNextWord();
		$mysqlText = "$mysqlText $nextWord";
	}
	PRINTLOG("going to mysql with <$mysqlText>\n");
	my $str = $connection->prepare($mysqlText);
	$str->execute;
	my @resultsCheck=$str->fetchrow_array;
	my $results = "";
	while ($resultsCheck[0]) {
		#PRINTLOG ("there is another line of output from starz. Currently we have $results\n");
		my $tempInt = 1;
		my $resultsCheckString = "$resultsCheck[0]";
		for ($tempInt = 1; $tempInt <= $#resultsCheck; $tempInt++) {
			#PRINTLOG ("next resultsCheck is <$resultsCheck[$tempInt]>\n");
			$resultsCheckString = "$resultsCheckString $resultsCheck[$tempInt]";
		}
		$results = "$results$resultsCheckString\n";
		@resultsCheck=$str->fetchrow_array;
	}
	PRINTLOG ("Leaving starz with <$results>\n");
	closeUp($results);
}



sub starc {
	#starc creates a codeword and its script
	PRINTLOG ("In starc\n");	
	getNextWord();	
	my $word = $nextWord;
	getNextWord();
	my $CLI = $nextWord;	
	while (isAnotherWord() ) {
		getNextWord();
		$CLI = $CLI . " " . $nextWord;
	}	
	#make sure this codeword doesn't exist
	PRINTLOG("about to do the following MYSQL <SELECT * FROM codeWord WHERE word = \'$word\'>\n");
	my $str = $connection->prepare("SELECT * FROM codeWord WHERE word = \'$word\'");
	$str->execute;
	my @resultsCheck=$str->fetchrow_array; 
	PRINTLOG("about to evaluate if resultsCheck had anything <$resultsCheck[0]>\n");
	#I need to take off a hash at each point of the CLI
	my $theNewCLI = takeOffHashes($CLI);
	#mysql uses \ as a wildcard and deletes one. So the CLI needs an additional at each location
	$theNewCLI =~ s/\\/\\\\/g;
	if (not $resultsCheck[0]) {
		PRINTLOG ("this codeword did not exist. About to add it <$theNewCLI>\n");		
		$theEmail =~ /@(.*)$/; 
		my $theURL = $1;
		my $fullNewWord	= $word . '@' . $theURL;
		addEmailUser($word);	
		$connection->do("INSERT INTO codeWord (word,cli,username) VALUES (\'$word\',\'$theNewCLI\',\'$theEmail\')");
		PRINTLOG ("leaving starc with codeWord set\n");		
		starIsDone("");
		return;
	}
	else {
		PRINTLOG ("This codeword did exist. If the previous owner is editing it. They can do so\n");
		if ($theEmail eq $resultsCheck[2]) {
			PRINTLOG ("This is the previous owner. About to change CLI to <$theNewCLI>\n");
			$connection->do("update codeWord SET cli=\'$theNewCLI\' WHERE (word = \'$word\')");
		}	
		else {
			PRINTLOG ("leaving starc without finishing codeWord\n");
			my $emailMessage = "Sorry, [$word] is already in use. Please try another!";
			sendOutText($theEmail,$emailMessage,0);				
			closeUp("");
		}
		starIsDone("");
		return;
	}
}






sub starg {
	PRINTLOG( "In starg\n");
	my $subscribeOrRead;
	my $userName;
	my $adminGenerated = 0;
	getNextWord();
	my $theAppName = $nextWord;
	$theApp = $theAppName;
	getNextWord();
	my $addOrRemove = $nextWord;
	getNextWord();
	my $adminOrSubscriber = $nextWord;
	if ($adminOrSubscriber =~ /-a/) {
		getNextWord();
		$userName = $nextWord;
	}	
	PRINTLOG( "appName:<$theAppName>|||addRemove:<$addOrRemove>|||adminOrUser:<$adminOrSubscriber>|||userName(if applicable):<$userName>\n");

	my $str;
	if ($adminOrSubscriber =~ /-a/) {
		$str = $connection->prepare("SELECT * FROM appSubscriptions WHERE (app = \'$theAppName\' AND userName = \'$userName\')");
	}
	else {
		$str = $connection->prepare("SELECT * FROM appSubscriptions WHERE (app = \'$theAppName\' AND userName = \'$theEmail\')");
	}
        $str->execute;
        my @resultsCheck=$str->fetchrow_array;
	if ($resultsCheck[0]) {
		PRINTLOG( "the user existed so we will update it and the results were: <$resultsCheck[0]>\n");
		if ($addOrRemove =~ /\-a/) {
			PRINTLOG( "in starg adding a user\n");			
			if (($adminOrSubscriber =~ /-a/) and (isAdmin())) {
				PRINTLOG( "adding the user with admin approval\n");
				PRINTLOG( "in starg and the admin or poster will approve the user:<$userName>\n");				
				$connection->do("update appSubscriptions SET adminApproved=\'1\' WHERE (app = \'$theAppName\' AND userName = \'$userName\')");
        			starIsDone("");
			}
			elsif (($adminOrSubscriber =~ /-u/) and isAdminOrAll()) {
				PRINTLOG( "adding user with both admin and user approval as this is an all system\n");
				PRINTLOG( "in starg and it is a public subApp so user is fully approved\n");        			
				$connection->do("update appSubscriptions SET adminApproved=\'1\' AND userApproved=\'1\'WHERE (app = \'$theAppName\' AND userName = \'$theEmail\')");
        			startstarIsDone("");
			}
			elsif ($adminOrSubscriber =~ /-u/) {
				PRINTLOG( "adding the user with user approval\n");
				PRINTLOG( "in starg and user is approving themself\n");				
				$connection->do("update appSubscriptions SET userApproved=\'1\' WHERE (app = \'$theAppName\' AND userName = \'$theEmail\')");
				PRINTLOG("now creating codeword and sending email to admins to approve this user\n");
				createEmailToRequestAdminSecurityApproval($theAppName,"",$theEmail,"","*g -a -a $theEmail");
        			starIsDone("");
			}
			else {
				closeUp("");
			}
		}
		if ($addOrRemove =~ /\-r/) {
			PRINTLOG( "in starg and about to remove a user\n");
			if (($adminOrSubscriber =~ /-a/) and (isAdmin())) {
				PRINTLOG( "in starg and admin will remove this user\n");				
				$connection->do("delete FROM appSubscriptions WHERE (app = \'$theAppName\' AND userName = \'$userName\')");
        			starIsDone("");
			}
			elsif ($adminOrSubscriber =~ /-u/) {
				PRINTLOG( "in starg and user will remove himself\n");				
				$connection->do("delete FROM appSubscriptions WHERE (app = \'$theAppName\' AND userName = \'$theEmail\')");
        			starIsDone("");	
			}
			else {
				PRINTLOG( "in starg and the person who entered this subAPp subscription removals does not have sufficent rights.\n");				
				closeUp("");
			}	
		}	
	
	}
#	$connection->do("INSERT INTO apps (app,pwd,pwd_rights,admin1) VALUES(\'$nextWord\',\'\',\'\',\'$theEmail\')");
	else {
		PRINTLOG( "user does not exist. We will create it\n");		
		if ($addOrRemove =~ /\-a/) {
			PRINTLOG( "we will add the user\n");
			if (($adminOrSubscriber =~ /-a/) and (isAdmin())) {
				PRINTLOG( "we will insert the user with admin rights\n");
				$connection->do("INSERT INTO appSubscriptions (app,userName,adminApproved) VALUES (\'$theAppName\',\'$userName\',\'1\')");
        			starIsDone("");
			}
			elsif (($adminOrSubscriber =~ /-u/) and isAdminOrAll()) {
				PRINTLOG( "this is public to the user will get full rights entered\n");
				$connection->do("INSERT INTO appSubscriptions (app,userName,adminApproved,userApproved) VALUES (\'$theAppName\',\'$theEmail\',\'1\',\'1\')");
        			starIsDone("");
			}
			elsif ($adminOrSubscriber =~ /-u/) {
				PRINTLOG( "we will insert user with user rights\n");
				PRINTLOG( "in starg and user is approving themselve\n");				
				$connection->do("INSERT INTO appSubscriptions (app,userName,adminApproved,userApproved) VALUES (\'$theAppName\',\'$theEmail\',\'0\',\'1\')");
				PRINTLOG("now creating codeword and sending email to admins to approve this user\n");
				createEmailToRequestAdminSecurityApproval($theAppName,"",$theEmail,"","*g -a -a $theEmail");
        			starIsDone("");
			}
			else {
				closeUp("");	
			}
		}
		if ($addOrRemove =~ /\-r/) {
			closeUp("");	
		}
	}	
}






sub starb {
	PRINTLOG( "in starb\n");
	#search a specific app
	getNextWord();	
	my $starBApp = $nextWord;
	my $searchTerms = findAllOptionsOrFormat();
	getNextWord();
	PRINTLOG("We are going to search through the app <$starBApp> with search terms <$searchTerms>\n");
	###
	my $blogOptions = findAllOptionsOrFormat();
	getNextWord();
	my $blogFormat = findAllOptionsOrFormat();
	PRINTLOG("blogOptions <$blogOptions> and blogFormat <$blogFormat>\n");
	my $howManyToSearch = 5;
	if ($blogOptions =~ /-c(#+)/) {
		$howManyToSearch = $1;
	}	
	my $searchSubAppName = 0; 
	if ($blogOptions =~ /-fw/) {
		$searchSubAppName = 1;
	}
	my $firstWord = "";
	if ($blogOptions =~ /-fw/ and $searchTerms !~ /\w \w/) { #if they search for two words with a "first word" request, default to a non-first word search
		my @tempArray = split(/ /,$searchTerms);
		$firstWord = $tempArray[0];
		PRINTLOG ("this is a first word search\n");
		$searchSubAppName = 1;
	}
	###
	chomp ($searchTerms);
	my @appSubscriptions;
	my $appString;
	#first figure out all app subscriptions this user has into an array
	PRINTLOG ("SELECT * FROM appSubscriptions WHERE (userName = \'$theEmail\' AND app=\'$starBApp\' AND userApproved = \'1\' and adminApproved = \'1\')\n");
    	my $str = $connection->prepare("SELECT * FROM appSubscriptions WHERE (userName = \'$theEmail\' AND app=\'$starBApp\' AND userApproved = \'1\' and adminApproved = \'1\')");
    	$str->execute;   
    	my @resultsCheck=$str->fetchrow_array;
	my $appStringPartIfUserDoesNotHaveAppSubscription = "";
	if (not @resultsCheck) {
		$appStringPartIfUserDoesNotHaveAppSubscription = " and public = \'public\'";
	}
	#then search blog posts with a lot of 'or' statements and PUBLIC
	$appString = "(appName = \'$starBApp\'$appStringPartIfUserDoesNotHaveAppSubscription)";	
	###
	if ($searchSubAppName) { #we are just searching for subApp not the post. This is for wikipedia type searches
		PRINTLOG( "a first word search <SELECT appName,subAppName,post,userName,cur_timestamp FROM blogPosts WHERE ($appString and subAppName = \'$firstWord\') limit 1>\n");
		$str = $connection->prepare("SELECT  appName,subAppName,post,userName,cur_timestamp FROM blogPosts WHERE ($appString and subAppName = \'$firstWord\') limit 1");
	}
	else {
		PRINTLOG( "prepare(\"select appName,subAppName,post,userName,cur_timestamp from blogPosts where $appString and match post against (\'$searchTerms\') limit 0,5\");");
    		$str = $connection->prepare("select appName,subAppName,post,userName,cur_timestamp from blogPosts where $appString and match post against (\'$searchTerms\') limit 0,$howManyToSearch");
	}
	###
    	$str->execute;   
    	my @resultsCheck=$str->fetchrow_array;
	my $tempInt = 1;
	my $searchResults = "";
	if (not $resultsCheck[0]) {
		$searchResults = $searchResults . "Sorry, nothing matched\n";
	}
	while (@resultsCheck) {
		my $nickname = "";
		if ($resultsCheck[3]) {
			#We need to use this posters nickname and not their real name
			$nickname = $resultsCheck[3];
			PRINTLOG("about to do <select * FROM userUsage WHERE (userName = \'$resultsCheck[3]\')>\n");
			my $str2 = $connection2->prepare("select * FROM userUsage WHERE (userName = \'$resultsCheck[3]\')");
    			$str2->execute;   
    			my @resultsCheck2=$str2->fetchrow_array;
			if ($resultsCheck2[4]) {
				$nickname = $resultsCheck2[4];
			}
		}
		###
		PRINTLOG("Going into addToPostFormat with <$nickname,$resultsCheck[4],$resultsCheck[1],$resultsCheck[0],$tempInt,$resultsCheck[2],$blogFormat,><>\n");
		$searchResults = "$searchResults" . addToPostFormat($nickname,$resultsCheck[4],$resultsCheck[1],$resultsCheck[0],$tempInt,$resultsCheck[2],$blogFormat,"") ."45454545454545";
		PRINTLOG("searchResults now equals <$searchResults>");
#		return addToPostFormat($myAuthor,$myDate,$mySubApp,$myApp,$numbers,$results,$myFormat,$finalPost);
	#my $myAuthor = $_[0];
	#my $myDate = $_[1];
	#my $mySubApp = $_[2];
	#my $myApp = $_[3];
	#my $myScore = $_[4];
	#my $prePostFormat = $_[5];
	#my $results = $_[6];
	#my $numbers = $_[7];
	#my $mySearchTerm = $_[8];
		###
		@resultsCheck=$str->fetchrow_array;
		$tempInt++;		
	}	
	###
	PRINTLOG("going into finalPostFormat with <$searchTerms,$searchResults,$theEmail,$fromEmail,$blogFormat,<>>\n");
	$searchResults = finalPostFormat($searchTerms,$searchResults,$theEmail,$fromEmail,$blogFormat,"");	
	#my $mySearchTerm = $_[0];
	#my $myPost = $_[1];
	#my $toEmail = $_[2];
	#my $fromEmail = $_[3];
	#my $myFormat = $_[4];
	#my $finalPost = $myFormat;
	###
	PRINTLOG ("Leaving starb and found <$searchResults>\n");
	starIsDone($searchResults);	
	
}





sub stard {
	PRINTLOG( "in stard\n");
	#search everything the user can see
	my $searchTerms = findAllOptionsOrFormat();
	chomp ($searchTerms);
##
	getNextWord();
	my $blogOptions = findAllOptionsOrFormat();
	getNextWord();
	my $blogFormat = findAllOptionsOrFormat();
	my $searchSubAppName;
	if ($blogOptions =~ /-fw/) {
		$searchSubAppName = 1;
	}
	my $howManyToSearch = 5;
	if ($blogOptions =~ /-c(#+)/) {
		$howManyToSearch = $1;
	}
##

	my @appSubscriptions;
	my $appString;
	my $subAppString;
	#first figure out all app subscriptions this user has into an array
    	my $str = $connection->prepare("SELECT * FROM appSubscriptions WHERE (userName = \'$theEmail\' AND userApproved = \'1\' and adminApproved = \'1\')");
    	$str->execute;   
    	my @resultsCheck=$str->fetchrow_array;
	my $tempInt = 0;
	while ($resultsCheck[0]) {
		PRINTLOG("in while for appSubscriptions with <$resultsCheck[0]>\n");
		$appSubscriptions[$tempInt] = $resultsCheck[0];
    		@resultsCheck=$str->fetchrow_array;		
	}
	#then figure out all subapp subscriptions this user has. Into an array
	my @subAppSubscriptionsApps;
	my @subAppSubscriptionsSubApps;
    	$str = $connection->prepare("SELECT * FROM blogSubscriptions WHERE (userName = \'$theEmail\' AND userApproved = \'1\' and adminApproved = \'1\')");
    	$str->execute;   
    	@resultsCheck=$str->fetchrow_array;
	my $tempInt = 0;
	while (@resultsCheck[0]) {
		PRINTLOG( "in while for blogSubscriptions with <$resultsCheck[1]:$resultsCheck[2]>\n");
		$subAppSubscriptionsApps[$tempInt] = $resultsCheck[1];
		$subAppSubscriptionsSubApps[$tempInt] = $resultsCheck[2];
    		@resultsCheck=$str->fetchrow_array;
		$tempInt++;		
	}	
	#then search blog posts with a lot of 'or' statements and PUBLIC
	$tempInt = 0;
	$appString = "((public = \'public\')";
	for ($tempInt = 0; $tempInt <= $#appSubscriptions; $tempInt++) {
		$appString = "$appString or (appName = \'$appSubscriptions[$tempInt]\')";
	}
	$tempInt =0;
	for ($tempInt = 0; $tempInt <= $#subAppSubscriptionsApps; $tempInt++) {
		$appString = "$appString or (appName = \'$subAppSubscriptionsApps[$tempInt]\' AND subAppName = \'$subAppSubscriptionsSubApps[$tempInt]\')";
	}
	$appString = $appString . ")";
	PRINTLOG( "prepare(\"select appName,subAppName,post,userName from blogPosts where $appString and  MATCH post AGAINST (\'$searchTerms\') limit 0,$howManyToSearch\");");
    	$str = $connection->prepare("select appName,subAppName,post,userName,cur_timestamp from blogPosts where $appString and MATCH post AGAINST (\'$searchTerms\') limit 0,5");
    	$str->execute;   
    	@resultsCheck=$str->fetchrow_array;
	$tempInt = 0;
	my $searchResults = "";
	while (@resultsCheck) {
		my $nickname = "";
		if ($resultsCheck[3]) {
			#We need to use this posters nickname and not their real name
			$nickname = $resultsCheck[3];
			PRINTLOG("about to do <select * FROM userUsage WHERE (userName = \'$resultsCheck[3]\')>\n");
			my $str2 = $connection2->prepare("select * FROM userUsage WHERE (userName = \'$resultsCheck[3]\')");
    			$str2->execute;   
    			my @resultsCheck2=$str2->fetchrow_array;
			if ($resultsCheck2[4]) {
				$nickname = $resultsCheck2[4];
			}
		}
		PRINTLOG("Going into addToPostFormat with <$nickname,$resultsCheck[4],$resultsCheck[1],$resultsCheck[0],$tempInt,$resultsCheck[2],$blogFormat,><>\n");
		$searchResults = "$searchResults" . addToPostFormat($nickname,$resultsCheck[4],$resultsCheck[1],$resultsCheck[0],$tempInt,$resultsCheck[2],$blogFormat,"") ."45454545454545";
#		$searchResults = "$searchResults" . addToPostFormat($nickname,$resultsCheck[4],$resultsCheck[1],$resultsCheck[0],$tempInt,$resultsCheck[2],$blogFormat,"") ."45454545454545";
		@resultsCheck=$str->fetchrow_array;		
	}
	PRINTLOG("going into finalPostFormat with $searchTerms,$searchResults,$theEmail,$fromEmail,$blogFormat,<>\n");
#	$searchResults = finalPostFormat($searchTerms,$searchResults,$theEmail,$fromEmail,$blogFormat,"");
	$searchResults = finalPostFormat($searchTerms,$searchResults,$theEmail,$fromEmail,$blogFormat,"");	
	PRINTLOG( "Leaving Stard with <$searchResults>\n");
	starIsDone($searchResults);	
	
}


sub starm {
	#change the fromEmail
	PRINTLOG( "in starm\n");
	getNextWord();
	if ($nextWord =~ /^\w+@\w+\.\w+$/) {	
		$fromEmail = $nextWord
	}
	else {
		$nextWord =~ s/@//g;	
		$fromEmail = $nextWord . '@' . $theOriginalFromURL;
	}
	PRINTLOG( "leaving starm with fromEmail:<$fromEmail>\n");
	starIsDone("");
}

sub stare {
	#look into a subApp
	PRINTLOG( "in stare\n");
	getNextWord();
	$theApp = $nextWord;
	getNextWord();	
	my $subAppName = $nextWord;
	my $subAppType;
	my $foundSubApp = "didn\'t work";
	my $str = $connection->prepare("SELECT * FROM blogList WHERE appName = \'$theApp\' and subAppName = \'$subAppName\'");
	$str->execute;
	my @resultsCheck=$str->fetchrow_array;
	if (not @resultsCheck) {
		closeUp("");
	}
	if (@resultsCheck) {
		$foundSubApp = "worked";
	}
	my $subAppCode = getAllSubAppCode();
	chomp($subAppCode);
	$subAppCode =~ s/^ //g;
	#print "subAppCode is <$subAppCode>\n";
	if ($foundSubApp =~ /^worked$/) {
		PRINTLOG( "going into goThroughBlog with email:<$theEmail> app:<$theApp> subApp:<$subAppName> code:<$subAppCode>\n");		
		goThroughBlog("$theEmail", "$theApp", "$subAppName", "$subAppCode");	
		PRINTLOG( "leaving stare and entered app correctly\n");
		starIsDone("");
	}
	else {
		PRINTLOG( "leaving stare without entering app\n");
		closeUp("");
	}	
}








sub stara {
	#stara changes the admins. either removing an admin or adding one
	PRINTLOG( "in stara\n");
	if (not isAdmin()) {
		closeUp("");
	}
	getNextWord();
	$theApp = $nextWord;
	getNextWord();
	my $addOrDelete;
	if ($nextWord =~ /-r|-a/) {
		$addOrDelete = $nextWord;
	}
	else {
		closeUp("");
	}
	getNextWord();
	my $adminToChange = $nextWord;
	my $str = $connection->prepare("SELECT * FROM apps WHERE (appName = \'$theApp\' AND (admin1=\'$theEmail\' OR admin2=\'$theEmail\' OR admin3=\'$theEmail\'))");
	$str->execute;
	my @resultsCheck=$str->fetchrow_array;
	if (not @resultsCheck) {
		closeUp("");
	}
	if ($addOrDelete =~ /^-a$/) {
		if ($resultsCheck[4] =~ // or (not $resultsCheck[4])) {
			$connection->do("update apps SET admin1=\'$adminToChange\' WHERE appName = \'$theApp\'");
		}
		elsif ($resultsCheck[5] =~ // or (not $resultsCheck[5])) {
			$connection->do("update apps SET admin2=\'$adminToChange\' WHERE appName = \'$theApp\'");
		}
		elsif ($resultsCheck[6] =~ // or (not $resultsCheck[6])) {
			$connection->do("update apps SET admin3=\'$adminToChange\' WHERE appName = \'$theApp\'");
		}
		else {
			PRINTLOG( "leaving stara but all admin slots used up\n");
			closeUp("");
		}
	}
	elsif ($addOrDelete =~ /^-r$/) {
		PRINTLOG( "in remove for change admin\n");
		if ($resultsCheck[4] =~ /$adminToChange/) {
			$connection->do("update apps SET admin1=\'\' WHERE appName = \'$theApp\'");
		}
		elsif ($resultsCheck[5] =~ /$adminToChange/) {
			$connection->do("update apps SET admin2=\'\' WHERE appName = \'$theApp\'");
		}
		elsif ($resultsCheck[6] =~ /$adminToChange/) {
			$connection->do("update apps SET admin3=\'\' WHERE appName = \'$theApp\'");
		}
		else {
			PRINTLOG( "leaving stara but admin doesn not exist\n");
			closeUp("");
		}
	}
	else {
		PRINTLOG( "leaving stara without doing anything\n");
		closeUp("");
	}
	PRINTLOG( "leaving stara all went well\n");
}





sub starr {
#change security of the app
	PRINTLOG( "entering starr\n");
	getNextWord();
	$theApp = $nextWord;
	getNextWord();
    	if (isAdmin() and ($nextWord =~ /all|admin/)) {
		PRINTLOG( "in starr\nupdate apps SET security=\'$nextWord\' WHERE (appName = \'$theApp\')");
		$connection->do("update apps SET security=\'$nextWord\' WHERE appName = \'$theApp\'");
        	PRINTLOG( "leaving starr and security was set\n");
		starIsDone("");
    	}
    	else {
   		PRINTLOG( "leaving starr without doing anything\n");     	
		closeUp("");
    	}
}



sub stars {
	#app status
	PRINTLOG( "in stars\n");
	startEdit();
	PRINTLOG( "leaving stars successfully\n");
	starIsDone("");
}







sub starx {
	#starx adds a subapp to an app
	PRINTLOG( "entering starx\n");
	my $subAppType;
	my $addOrDelete;
	my $newString;

	PRINTLOG ("\n\n\nIn starx with nextWord=$nextWord=\ntheTextCompleted=$theTextCompleted=\ntheTextForNextScript=$theTextForNextScript=\n");
	getNextWord();
	if ($nextWord =~ /-a|-r/ ) {
		$addOrDelete = $nextWord;
	}
	else {
		closeUp("");
	}
	getNextWord();
	$theApp = $nextWord;
	getNextWord();
	my $subAppName = $nextWord;	
	if ($addOrDelete =~ /-a/) {
		getNextWord();
		$subAppType = $nextWord;	
	}
	
	#all variables now exist. Lets do some database work
	if ($addOrDelete =~ /-a/ and isAdminOrAll()  ) {
		$newString =~ s/^\s+//; #delete leading space
   		my $str = $connection->prepare("SELECT * FROM blogList WHERE (appName = \'$theApp\' AND subAppName = \'$subAppName\')");#lets see if that app/subapp already exist
    		$str->execute;    
    		my @resultsCheck=$str->fetchrow_array;
		if (not $resultsCheck[0]) {
			#first lets bring in the parent security rules
			my $str = $connection->prepare("SELECT * FROM apps WHERE (appName = \'$theApp\')");
    			$str->execute;    
    			my @resultsCheck1=$str->fetchrow_array;
			my $securityValue = "private";
			if ($resultsCheck1[6] =~ /all/) {
				 $securityValue = "public";
			}
        		$connection->do("INSERT INTO blogList(appName, subAppName, security, creator) VALUES(\'$theApp\', \'$subAppName'\, \'$securityValue\',\'$theEmail\')");
			PRINTLOG( "leaving starx with new App\n");
			starIsDone("");
		}
		else {
			PRINTLOG( "leaving starx. That was a duplicate subApp\n");
			starIsDone("");
		}
	}
	elsif (($addOrDelete =~ /-r/) and ( isAdminOrCreator($subAppName) or isAdminOrAll() )) {
		PRINTLOG( "In subApp\n");
		PRINTLOG(" about to perform <DELETE FROM blogList WHERE (appName = \'$theApp\' AND subAppName = \'$subAppName\')>\n");
		$connection->do("DELETE FROM blogList WHERE (appName = \'$theApp\' AND subAppName = \'$subAppName\')");
		PRINTLOG(" about to perform<DELETE FROM blogPosts WHERE (appName = \'$theApp\' AND subAppName = \'$subAppName\')>\n");
		$connection->do("DELETE FROM blogPosts WHERE (appName = \'$theApp\' AND subAppName = \'$subAppName\')"); 
		PRINTLOG( "leaving starx successfully\n");
		starIsDone(""); 
	}
	else {
		closeUp ("");
	}
	
	
}






sub starp {	
	#starp adds a password to a subapp
	PRINTLOG( "in starp\n");
	if (isAdmin()) {
		getNextWord();
		my $theApp = $nextWord;
		getNextWord();
		my $thePassword = $nextWord;
		$connection->do("update apps SET pwd=\'$thePassword\' WHERE appName = \'$theApp\'");
		PRINTLOG( "leaving starp successfully\n");
		starIsDone("");
	}
	else {
		PRINTLOG( "leaving starp without doing anything\n");		
		closeUp("");
	}
}





sub starn {	
	#starn adds a new app
	getNextWord();
	PRINTLOG( "in starn\n");
	$connection->do("INSERT INTO apps (appName,pwd,pwd_rights,admin1) VALUES(\'$nextWord\',\'\',\'\',\'$theEmail\')");
	starIsDone("");
}








































#########################
######################
##########################
#blog subs
######################
#####################
##################


sub goThroughBlog {
	#this cleans up the old blog and starts the file new
	open (LOGBLOG, ">>logs\/log_blog.txt");
	PRINTLOGBLOG( "\n\n\n\n\n##################\n###############\n#################\nin goThroughBlog with <$_[0]> <$_[1]> <$_[2]> <$_[3]>\n");
	#arg1 is phone number of sender
	#arg2 is text 
	$theEmailBlog = $_[0];
	chomp($theEmailBlog);
	$theAppBlog = $_[1];
	chomp($theAppBlog);
	$theSubAppBlog = $_[2];
	chomp($theSubAppBlog);
	$theTextBlog = $_[3];
	chomp($theTextBlog);
	$theTextBlogCompleted = "$theAppBlog *e ";
	$theTextBlogForNextScript = $theTextBlog;
	$closeUpBlogStringBlog = "";
	$passwordBlogSet = 0;
	@spaceDelimitedtheTextBlog = split(/ /,$theTextBlog);
	$nextWordBlog = $spaceDelimitedtheTextBlog[0];
	#my @theTextForNextScriptArray = shift(@spaceDelimitedtheTextBlog);

	#join(/ /,@theTextForNextScriptArray);



	#lets see which app it is for
	getNextWordBlog();
	while ($nextWordBlog =~ /\*\*/) {
		PRINTLOGBLOG( "in while loop to look at next sub to go into with nextWordBlog:<$nextWordBlog>\n");
	    #as long as there are stars, we will continue this. 	
	    if ($nextWordBlog =~ /\*\*i/) {
		#add or remove poster
	        starstarBlogi();
	    }
	    if ($nextWordBlog =~ /\*\*l/) {
		#look at __ last posts
	        starstarBlogl();	
	    }
	    elsif ($nextWordBlog =~ /\*\*r/) {
		#set security parameters
	        starstarBlogr();
	    }
	    elsif ($nextWordBlog =~ /\*\*n/) {
		#add blog post
	        starstarBlogn();
	    }
	    elsif ($nextWordBlog =~ /\*\*s/) {
		#blogList status
	        starstarBlogs();
	    }
	    elsif ($nextWordBlog =~ /\*\*p/) {
		#give password
	        starstarBlogp();
	    }
	    elsif ($nextWordBlog =~ /\*\*e/) {
		#email all posts	
	        starstarBloge();
	    }
	    elsif ($nextWordBlog =~ /\*\*o/) {
		#open or close posting from non-posters	
	        starstarBlogo();
	    }
	    elsif ($nextWordBlog =~ /\*\*a/) {
		#add/remove reader	
	        starstarBloga();
	    }
	elsif ($nextWordBlog =~ /\*\*b/) {
		#search Blog	
	        starstarBlogb();
	    }
	    else {
	        closeUpBlog("");
	    }
	}
	close(LOGBLOG);
} #end the method called "goThroughBlog"







###################
####subroutines####
###################


sub sendOutTextBlog {
	PRINTLOGBLOG( "In sendOutTextBlog with $_[0] and $_[1]\n");
	my $sendOutEmail1 = $_[0];
	my $bodyOfEmail = $_[1];
	my $myRepeat = $_[2];
	my $execWorked;
	PRINTLOGBLOG( "about to create the following email \"$sendOutEmail1\" \"$bodyOfEmail\" \"$fromEmail\" \"$myRepeat\"");
	if ($bodyOfEmail =~ /\w/) {
		createOutputFileForNextScript("4", $sendOutEmail1, $bodyOfEmail, $fromEmail, $myRepeat);
	}
	PRINTLOGBLOG( "Leaving sendOutTextBlog\n");
}


sub closeUpBlog {
	my $temp = $_[0];
	PRINTLOGBLOG( "in closeUpBlog. theTextCompleted<$theTextBlogCompleted>\n and closeUpBlogStringBlog<$closeUpBlogStringBlog>\n**********\n\n");
	$connectionBlog->do("update userUsage SET currentString=\'$theTextBlogCompleted\' WHERE userName=\'$theEmailBlog\'");	
	$closeUpBlogStringBlog = $closeUpBlogStringBlog . " " .$temp;
	sendOutTextBlog($theEmail,$closeUpBlogStringBlog,0);
	if ($nextWordBlog =~ /\*\*/) {
		getNextWordBlog();
	}
	
}


sub PRINTLOGBLOG {
	$logBlogLines++;
	if ($logBlogLines < 5000) {
		print LOGBLOG $_[0];
	}	
	else {
		die;
	}
}


sub getNextWordBlog {
	PRINTLOGBLOG( "in getNextWordBlog with theTextBlogForNextScript:<$theTextBlogForNextScript>\n");
	my $temp = $_[0];
	if ($theTextBlogForNextScript  =~ /\w/ or $theTextBlogForNextScript  =~ /\#/ or $theTextBlogForNextScript  =~ /\*/ ) {
		my @spaceDelimitedtheTextBlog = split(/ /,$theTextBlogForNextScript);
		$nextWordBlog = $spaceDelimitedtheTextBlog[0];
		my @theTextForNextScriptArray = shift(@spaceDelimitedtheTextBlog);
		$theTextBlogForNextScript = join(" ",@spaceDelimitedtheTextBlog);
		$theTextBlogCompleted = $theTextBlogCompleted . " " . $nextWordBlog;
		chomp($theTextBlogCompleted);
	}
	else {
		PRINTLOGBLOG( "no more words says getNextWordBlog\n");
		$theTextBlogForNextScript = "";
		$nextWordBlog = "";		
		closeUpBlog("");
	}
	PRINTLOGBLOG( "leaving getNextWordBlog\n");
}

sub isAnotherWordBlog {
	if ($theTextBlogForNextScript =~ //) {
		return 0;
	}
	elsif ($theTextBlogForNextScript =~ /^\#\#/) {
		getNextWordBlog();		
		return 0;
	}
	elsif ($theTextBlogForNextScript =~ s/^\\\#\\\#/^\#\#/) {
	 	return 0;
	}
	elsif (length($theTextBlogForNextScript) == 0) {
		return 0;
	}
	else {
		return 1;
	} 
}


sub startstarIsDoneBlog {
	PRINTLOGBLOG( "in startstarIsDoneBlog\n");
	my $temp = $_[0];
	$connectionBlog->do("update userUsage SET currentString=\'\' WHERE userName=\'$theEmailBlog\'");
	$theTextBlogCompleted = "";
	$closeUpBlogStringBlog = $closeUpBlogStringBlog . " " . $temp;
	getNextWordBlog("");
	PRINTLOGBLOG( "leaving startstarIsDoneBlog\n**************\n\n");
}

sub changeMMSAddressToSMS {
	print LOGBLOG "In changeMMSAddressToSMS\n";
	my $preEmail = $_[0];
	my $preEmailDomain;
	my $preEmailName;
	$preEmail =~ /^(.*)(@.*\..*)$/;
	$preEmailName = $1;	
	$preEmailDomain = $2;
	print LOGBLOG "the email Name is <$preEmailName> and domain <$preEmailDomain>\n";
	my $str = $connection->prepare("SELECT * FROM sms2mmsEmails WHERE (mmsDomain = \'$preEmailDomain\')");
	$str->execute;
	my @resultsCheck=$str->fetchrow_array;
	if ($resultsCheck[0]) {
		print LOGBLOG "leaving makeSureThisSMSandNotMMSEmail with a new email address <$resultsCheck[0]>\n";
		return $preEmailName . $resultsCheck[0];
	}
	else {
		print LOGBLOG "leaving makeSureThisSMSandNotMMSEmail with the original email address\n";
		return $preEmail;
	}

}
sub isAdminOrAllBlog {
	PRINTLOGBLOG( "in isAdminOrAll\nabout to do <SELECT * FROM apps WHERE (appName = \'$theAppBlog\' AND (admin1 = \'$theEmailBlog\' OR admin2 = \'$theEmailBlog\' OR admin3 = \'$theEmailBlog\'))\n");
	
	my $myEmail = changeMMSAddressToSMS($theEmailBlog);
	

	my $str = $connection->prepare("SELECT * FROM apps WHERE (appName = \'$theAppBlog\' AND (admin1 = \'$myEmail\' OR admin2 = \'$theEmailBlog\' OR admin3 = \'$theEmailBlog\'))");
	$str->execute;
	my @resultsCheck=$str->fetchrow_array;
	if ($resultsCheck[0] =~ /^$/) {
		my $str1 = $connection->prepare("SELECT * FROM apps WHERE (appName = \'$theAppBlog\' AND security = \'all\')");		
		$str1->execute;
		my @resultsCheck1=$str1->fetchrow_array;
		if ($resultsCheck1[0] =~ /^$/) {
			PRINTLOGBLOG( "leaving isAdminOrAllBlog with return <0>\n");	
			return 0;
		}
		else {
			PRINTLOGBLOG( "leaving isAdminOrAllBlog with return <1>\n");
			return 1;
		}
	}
	else {
		PRINTLOGBLOG( "leaving isAdminOrAllBlog with return <1>\n");
		return 1;
	}
}

sub isAdminOrCreatorBlog {
	my $mySubAppName = $_[0];	
	PRINTLOGBLOG( "in isAdminOrCreatorBlog\n");
	my $myEmail = changeMMSAddressToSMS($theEmailBlog);
	PRINTLOGBLOG ("about to do <SELECT * FROM apps WHERE (appName = \'$theAppBlog\' AND (admin1 = \'$myEmail\' OR admin2 = \'$myEmail\' OR admin3 = \'$myEmail'))>\n");
	my $str = $connection->prepare("SELECT * FROM apps WHERE (appName = \'$theAppBlog\' AND (admin1 = \'$myEmail\' OR admin2 = \'$myEmail\' OR admin3 = \'$myEmail\'))");
	$str->execute;
	my @resultsCheck=$str->fetchrow_array;
	if ($resultsCheck[0] =~ /^$/) {
		if (isAdminOrAllBlog()) {
			PRINTLOGBLOG("about to do <SELECT * FROM blogList WHERE (appName = \'$theAppBlog\' AND subAppName = \'$mySubAppName\' AND creator  = \'$myEmail\')>\n");
			my $str1 = $connection->prepare("SELECT * FROM blogList WHERE (appName = \'$theAppBlog\' AND subAppName = \'$mySubAppName\' AND creator  = \'$myEmail\')");		
			$str1->execute;
			my @resultsCheck1=$str1->fetchrow_array;
			if ($resultsCheck1[0] =~ /^$/) {	
				
				PRINTLOGBLOG ("leaving isAdminOrCreatorBlog with <0>, not an admin or creator\n");								
				return 0;
			}
			else {
				PRINTLOGBLOG ("leaving isAdminOrCreator with <1>. Email is a creator\n");
				return 1;
			}
		}
		else {
			PRINTLOGBLOG ("leaving isAdminOrCreatorBlog with <0>, isAdminOrAddBlog did not work\n");
			return 0;
		}
	}
	else {
		PRINTLOGBLOG("leaving isAdminOrCreatorBlog with <1>. Email is an admin\n");
		return 1;
	}
}


sub isAdminBlog {
    	#see if this guy is an admin
	PRINTLOGBLOG( "in isAdminBlog\nabout to do : SELECT * FROM apps WHERE (appName = \'$theAppBlog\' AND (admin1 = \'$theEmailBlog\' OR admin2 = \'$theEmailBlog\' OR admin3 = \'$theEmailBlog\'))");
    	my $str = $connection->prepare("SELECT * FROM apps WHERE (appName = \'$theAppBlog\' AND (admin1 = \'$theEmailBlog\' OR admin2 = \'$theEmailBlog\' OR admin3 = \'$theEmailBlog\'))");
    	$str->execute; 
    	my $theAdmin = $theEmail;    
    	my @resultsCheck=$str->fetchrow_array;
    	if (@resultsCheck) {
		PRINTLOGBLOG( "leaving isAdminBlog with return <1>\n");
		return 1;
    	}
	else {
		PRINTLOGBLOG( "leaving isAdminBlog with return <0>\n");
		return 0;
	}
}

sub isPosterBlog {
	PRINTLOGBLOG( "in isPosterBlog\n");
	if ($passwordBlogSet) {
		return 1;
	}   
    	my $str = $connectionBlog->prepare("SELECT * FROM blogList WHERE (appName = \'$theAppBlog\' AND subAppName = \'$theSubAppBlog\')");
    	$str->execute;
    	my @resultsCheck=$str->fetchrow_array;
    	my $security = $resultsCheck[3];
    	my $poster1 = $resultsCheck[4];
    	my $poster2 = $resultsCheck[5];
    	my $poster3 = $resultsCheck[6];
	my $resultValue = (($theEmailBlog =~ /$poster1/) and (length($theEmailBlog) == length($poster1))) or (($theEmailBlog =~ /$poster2/) and (length($theEmailBlog) == length($poster2))) or (($theEmailBlog =~ /$poster3/) and (length($theEmailBlog) == length($poster1)));
	PRINTLOGBLOG( "return values for canEditBlog ($theEmailBlog =~ /$poster1|$poster2|$poster3/).this equals<$resultValue>\n");
    	return $resultValue; 
}

sub isReaderOrSubscriber {
	if (isAReaderBlog() or isASubscriberBlog()) {
		PRINTLOGBLOG("leaving isReaderOrSubscriber with <1>\n");
		return 1;
	}
	else {
		PRINTLOGBLOG("leaving isReaderOrSubscriber with <0>\n");
		return 0;
	}
}


sub canEditBlog {
	PRINTLOGBLOG( "in canEditBlog\n");
	if ($passwordBlogSet) {
		return 1;
	}   
    	my $str = $connectionBlog->prepare("SELECT * FROM blogList WHERE (appName = \'$theAppBlog\' AND subAppName = \'$theSubAppBlog\')");
    	$str->execute;
    	my @resultsCheck=$str->fetchrow_array;
    	my $security = $resultsCheck[3];
    	my $poster1 = $resultsCheck[5];
    	my $poster2 = $resultsCheck[6];
    	my $poster3 = $resultsCheck[7];
    

    	#see if this guy is an admin
    	my $str = $connectionBlog->prepare("SELECT * FROM apps WHERE (appName = \'$theAppBlog\' AND (admin1 = \'$theEmailBlog\' OR admin2 = \'$theEmailBlog\' OR admin3 = \'$theEmailBlog\'))");
    	$str->execute; 
    	my $theAdmin = $theEmailBlog;    
    	my @resultsCheck=$str->fetchrow_array;
    	if (not @resultsCheck) {
		$theAdmin = "";
    	}
	my $resultValue = (($theEmailBlog =~ /$poster1|$poster2|$poster3|$theAdmin/) or ($security =~ /public/));
    	#alright, lets see if this guy can edit subscribers
	my $returnValue = (($theEmailBlog =~ /$poster1|$poster2|$poster3|$theAdmin/) or ($security =~ /public/));
	PRINTLOGBLOG( "return values for canEditBlog (($theEmailBlog =~ /$poster1|$poster2|$poster3|$theAdmin/) or ($security =~ /public/))|||this equals<$returnValue>\n");
    	return $returnValue;
}




sub findAllOfTheBlogPostBlog {
	PRINTLOGBLOG( "In findAllOfTheBlogPostBlog\n");
	my $temp;
	if (isAnotherWordBeforeHashBlog()) {
		PRINTLOGBLOG( "looking at another word for the post in findAllOfTheBlogPostBlog\n");
		getNextWordBlog();
		$temp = $nextWordBlog;
	}
	while (isAnotherWordBeforeHashBlog()) {
		PRINTLOGBLOG( "looking at another word for the post in findAllOfTheBlogPostBlog\n");
		getNextWordBlog();
		$temp = $temp . " " . $nextWordBlog;
	}
	PRINTLOGBLOG("Leaving findAllOfTheBlogPostBlog with <$temp>");
	return $temp;	
}





sub findAllOptionsOrFormatBlog {
	PRINTLOGBLOG( "in findAllOptionsBLog\n");	
	my $temp = "";
	if (isAnotherWordBeforeHashBlog()) {
		getNextWordBlog();
		$temp = $nextWordBlog;
	}
	while (isAnotherWordBeforeHashBlog()) {
		getNextWordBlog();
		$temp = $temp . " " . $nextWordBlog;
	}
	PRINTLOGBLOG( "leaving findAllOptionsBlog with return <$temp>\n");
	return $temp;	

}


sub isAnotherWordBeforeHashBlog {
	PRINTLOGBLOG("in isAnotherWordBeforeHashBlog and theTextBlogForNextScript:<$theTextBlogForNextScript> and nextWord:<$nextWordBlog>\n");
	my @nextWordTemp = split(/ /,$theTextBlogForNextScript);
	my $tempInt = 0;
	while (($#nextWordTemp > $tempInt) and ($nextWordTemp[$tempInt] =~ /^\s*$/)) {	
		$tempInt++;
	}
	if ($nextWordTemp[$tempInt] =~ /^$/) {
		PRINTLOGBLOG( "leaving isAnotherWordBeforeHashBlog with <0>\n");
		return 0;
	}
	if ($nextWordTemp[$tempInt] =~ /^\#$/) {
		PRINTLOGBLOG( "leaving isAnotherWordBeforeHashBlog with <0>, it was a # \n");
		return 0;
	}
	else {
		PRINTLOGBLOG( "leaving isAnotherWordBeforeHashBlog with <1>\n");
		return 1;
	} 
}







sub isASubscriberBlog {
	if ($passwordBlogSet) {
		return 1;
	}   
    my $str = $connectionBlog->prepare("SELECT * FROM blogSubscriptions WHERE (appName = \'$theAppBlog\' AND subAppName = \'$theSubAppBlog'\ AND userName=\'$theEmailBlog\' AND (subscribe_or_read=\'subscribe\' or subscribe_or_read=\'-s\' or subscribe_or_read=\'s\'))");
    $str->execute;
    my $theAdmin = $theEmailBlog;    
    my @resultsCheck=$str->fetchrow_array;
    if (not @resultsCheck) {
	PRINTLOGBLOG("leaving isASubscriberBlog with a 0\n");
        return 0;
    }
	PRINTLOGBLOG("leaving isASubscriberBlog with a 1\n");
    return 1;
}


sub isAReaderBlog {
	if ($passwordBlogSet) {
		return 1;
	}     
	   my $str = $connectionBlog->prepare("SELECT * FROM blogSubscriptions WHERE (appName = \'$theAppBlog\' AND subAppName = \'$theSubAppBlog'\ AND userName=\'$theEmailBlog\' AND (subscribe_or_read=\'read\' or subscribe_or_read=\'-r\' or subscribe_or_read=\'r\'))");
    $str->execute;
    my $theAdmin = $theEmailBlog;    
    my @resultsCheck=$str->fetchrow_array;
    if (not @resultsCheck) {
	PRINTLOGBLOG("leaving isAReaderBlog with a 0\n");
        return 0;
    }
	PRINTLOGBLOG("leaving isAReaderBlog with a 1\n");
    return 1;
}


sub isPublicBlog {
	my $str = $connectionBlog->prepare("SELECT * FROM blogList WHERE (appName = \'$theAppBlog\' AND subAppName = \'$theSubAppBlog'\ AND security=\'public\')");
 	$str->execute;  
    	my @resultsCheck=$str->fetchrow_array;
    	if (not @resultsCheck) {
		PRINTLOGBLOG("leaving isPublicBlog with a 0\n");
        	return 0;
    	}
	PRINTLOGBLOG("leaving isPublicBlog with a 1\n");
    	return 1;
	$connectionBlog->do("update blogList SET security=\'$nextWordBlog\' WHERE (appName = \'$theAppBlog\' AND subAppName  = \'$theSubAppBlog\')");

}


sub isPrivateBlog {
	my $str = $connectionBlog->prepare("SELECT * FROM blogList WHERE (appName = \'$theAppBlog\' AND subAppName = \'$theSubAppBlog'\ AND security=\'private\')");
 	$str->execute;  
    	my @resultsCheck=$str->fetchrow_array;
    	if (not @resultsCheck) {
		PRINTLOGBLOG("leaving isPrivateBlog with a 0\n");
        	return 0;
    	}
	PRINTLOGBLOG("leaving isPrivateBlog with a 1\n");
    	return 1;
}

sub isOpenBlog {
	PRINTLOGBLOG("in isOpenBlog\n");
	my $str = $connectionBlog->prepare("SELECT * FROM blogList WHERE (appName = \'$theAppBlog\' AND subAppName = \'$theSubAppBlog'\ AND (open = \'-o\' or open=\'open\' or open=\'o\'))");
 	$str->execute;  
    	my @resultsCheck=$str->fetchrow_array;
    	if (not @resultsCheck) {
		PRINTLOGBLOG("leaving isOpenBlog with a 0\n");
        	return 0;
    	}
	else {
		PRINTLOGBLOG("leaving isOpenBlog with a 1\n");
    		return 1;
	}
	PRINTLOGBLOG("leaving isOpenBlog with a 1\n");
}


sub isPrivileged {
	my $str = $connectionBlog->prepare("SELECT * FROM blogList WHERE (appName = \'$theAppBlog\' AND subAppName = \'$theSubAppBlog'\ AND (open=\'p\' or open=\'privileged\' or open=\'-p\')");
 	$str->execute;  
    	my @resultsCheck=$str->fetchrow_array;
    	if (not @resultsCheck) {
        	return 0;
    	}
    	return 1;
}





####################
####the starstarBlogs######
####################
sub starstarBlogi {
	#
   	#posters can add people to the subscription
    	#check if removing or adding
    	#then check if reader or subscriber. 
	PRINTLOGBLOG( "in starstarBlogi with nextWordBlog=<$nextWordBlog>\n");
    	my $isRemoveOrAdd;
    	my $subOrRead;
	getNextWordBlog();
    	if ($nextWordBlog =~ /-r|-a/) {
       		$isRemoveOrAdd = $nextWordBlog;    
    	}
    	else {
        	closeUpBlog("");
    	}


    
    	getNextWordBlog();
    	my $posterName = $nextWordBlog;
    	if (isAdminBlog()) {
		#look to see if this user is a poster yet
		my $posterLocation = 0; 
			#1=poster1 is the posterName; 
			#2=poster2 is the posterName 
			#3=poster3 is the posterName. 
			#4=poster1 is empty
			#5=poster2 is empty
			#6=poster3 is empty
		my $str = $connectionBlog->prepare("SELECT * FROM blogList WHERE (appName = \'$theAppBlog\' AND subAppName = \'$theSubAppBlog\')");
 		$str->execute;  
    		my @resultsCheck=$str->fetchrow_array;
    		if (@resultsCheck) {
			if ($resultsCheck[4] =~ /^$posterName$/) {
				$posterLocation = 1;
			}
			elsif ($resultsCheck[5] =~ /^$posterName$/) {
				$posterLocation = 2;
			}
			elsif ($resultsCheck[6] =~ /^$posterName$/) {
				$posterLocation = 3;
			}
			elsif ($resultsCheck[4] =~ /^$/) {
				$posterLocation = 4;
			}
			elsif ($resultsCheck[5] =~ /^$/) {
				$posterLocation = 5;
			}
			elsif ($resultsCheck[6] =~ /^$/) {
				$posterLocation = 6;
			}
			PRINTLOGBLOG( "the posterlocation value is:<$posterLocation>. If this is less than 3 the poster was found. Greater than 3 the poster was not found and that is a slot to add this new poster. If it is 0 then all locations are filled and the poster was not found.");
		}
		else {
			startstarIsDoneBlog("");
		}



        	if (($isRemoveOrAdd =~ /-r/) and (0 < $posterLocation) and ($posterLocation <=3)) {
			#$connectionBlog->do("update blogList SET security=\'$nextWordBlog\' WHERE (appName = \'$theAppBlog\' AND subAppName  = \'$theSubAppBlog\')");
            		$connectionBlog->do("UPDATE blogList SET poster$posterLocation=\'\' WHERE (appName = \'$theAppBlog\' AND subAppName = \'$theSubAppBlog\')"); 
            		startstarIsDoneBlog("");
        	} 
		else {
			PRINTLOGBLOG( "sorry that poster was not found\n");
			startstarIsDoneBlog("");	
		}
        	if ($isRemoveOrAdd =~ /-a/ and ($posterLocation >3)) {
			my $tempPosterLocation = $posterLocation - 3;
        		$connectionBlog->do("UPDATE blogList SET poster$tempPosterLocation=\'$posterName\' WHERE (appName = \'$theAppBlog\' AND subAppName = \'$theSubAppBlog\')");
            		startstarIsDoneBlog("");
        	}
		else {
			PRINTLOGBLOG( "sorry that poster already exists\n");
			startstarIsDoneBlog("");
		}
		if ($posterLocation = 0) {
			startstarIsDoneBlog("");
		}
	}
    	else {
        	closeUpBlog("");
    	}
}






sub starstarBlogb {
	#search a specific subapp
	PRINTLOGBLOG('in starstarBlogb\n');
	my $str;
	my $searchTerms = findAllOfTheBlogPostBlog();
	###
	getNextWordBlog();
	my $blogOptions = findAllOptionsOrFormatBlog();
	getNextWordBlog();
	my $blogFormat = findAllOptionsOrFormatBlog();
	PRINTLOGBLOG("blogOptions <$blogOptions> and blogFormat <$blogFormat>\n");
	my $searchSubAppName = 0; 
	if ($blogOptions =~ /-fw/) {
		$searchSubAppName = 1;
	}
	my $howManyToSearch = 5;
	if ($blogOptions =~ /-c(#+)/) {
		$howManyToSearch = $1;
	}
	###
	chomp ($searchTerms);
	my @appSubscriptions;
	my $appString;
	my $subAppString;
	my $tempInt;
	#then figure out all subapp subscriptions this user has. Into an array
	#then search blog posts with a lot of 'or' statements and PUBLIC
	$tempInt =0;
	$subAppString = "((public = \'public\') or ((appName=\'$theAppBlog\') and (subAppName=\'$theSubAppBlog\'))";
	$subAppString = $subAppString . ")";
#select appName,subAppName,post from txtCLI.blogPosts where  ((0=1) or (appName = 'one' and subAppName = 'oneSub') or (appName = 'jimbo' and subAppName = 'two')) and match post against ('apples') limit 0,5
	###
	if ($searchSubAppName) { #we are just searching for subApp not the post. This is for wikipedia type searches
		PRINTLOGBLOG( "a first word search <SELECT appName,subAppName,post,userName,cur_timestamp FROM blogPosts WHERE (appName = \'$theAppBlog\' AND subAppName = \'$theSubAppBlog\') limit 1\n");
		$str = $connectionBlog->prepare("SELECT appName,subAppName,post,userName,cur_timestamp FROM blogPosts WHERE (appName = \'$theAppBlog\' AND subAppName = \'$theSubAppBlog\') limit 1");
	}
	else {
		PRINTLOGBLOG( "not a first word search. prepare(\"select appName,subAppName,post,attachmentString,userName,cur_timestamp from blogPosts where ($subAppString) and match post against (\'$searchTerms\') limit 0,5\");");
    	$str = $connection->prepare("select appName,subAppName,post,userName,cur_timestamp from blogPosts where ($subAppString) and match post against (\'$searchTerms\') limit 0,$howManyToSearch");
	}
	###
    	$str->execute;   
    	my @resultsCheck=$str->fetchrow_array;
	my $tempInt = 1;
	my $searchResults = "";
	if ($blogFormat !~ /\w/) {
		$blogFormat = '-b-n.-r\-in-ap:-sa\n	By-a\n	Date:-d';
	}
	while (@resultsCheck) {
		###Lets get the writers nickname
		my $nickname = "";
		if ($resultsCheck[3]) {
			#We need to use this posters nickname and not their real name
			$nickname = $resultsCheck[3];
			PRINTLOG("about to do <select * FROM userUsage WHERE (userName = \'$resultsCheck[3]\')>\n");
			my $str2 = $connection2->prepare("select * FROM userUsage WHERE (userName = \'$resultsCheck[3]\')");
    			$str2->execute;   
    			my @resultsCheck2=$str2->fetchrow_array;
			if ($resultsCheck2[4]) {
				$nickname = $resultsCheck2[4];
			}
		}
		###
		PRINTLOG ("going into addToPostFormat with $nickname,$resultsCheck[4],$theSubAppBlog,$theAppBlog,$tempInt,$resultsCheck[2],$blogFormat,<>\n");
		$searchResults = "$searchResults" . addToPostFormat($nickname,$resultsCheck[4],$theSubAppBlog,$theAppBlog,$tempInt,$resultsCheck[2],$blogFormat,"") ."45454545454545";
		#return addToPostFormat($myAuthor,$myDate,$mySubApp,$myApp,$numbers,$results,$myFormat,$finalPost);
		###
		@resultsCheck=$str->fetchrow_array;
		$tempInt++;		
	}
	
	PRINTLOGBLOG('leaving starstarBlogb\n');
	###
	PRINTLOG("going into finalPostFormat with $searchTerms,$searchResults,$theEmailBlog,$fromEmail,$blogFormat,<>\n");
	finalPostFormat($searchTerms,$searchResults,$theEmailBlog,$fromEmail,$blogFormat,"");	
	###	
	closeUpBlog($searchResults);	
}





sub starstarBlogl {
	PRINTLOGBLOG( "in starstarBlogl\n");
	my $repeat = 0;
    	getNextWordBlog();
	my $numOfPostsToSendBack = $nextWordBlog;
	getNextWordBlog();
	if ($nextWordBlog =~ /^\d+$/) {
		$repeat = $nextWordBlog;
		getNextWordBlog();
	}
	my $blogOptions = findAllOptionsOrFormatBlog();
	getNextWordBlog();
	my $blogFormat = findAllOptionsOrFormatBlog();
	PRINTLOGBLOG("blogOptions <$blogOptions> and blogFormat <$blogFormat>\n");
    	if (isPublicBlog() or isAdminBlog() or isAReaderBlog() or isAdminOrAllBlog()) {
		PRINTLOGBLOG( "about to perform <SELECT * FROM blogPosts WHERE (appName = \'$theAppBlog\' AND subAppName = \'$theSubAppBlog\') ORDER BY cur_timestamp DESC>\n");
        	my $str = $connectionBlog->prepare("SELECT * FROM blogPosts WHERE (appName = \'$theAppBlog\' AND subAppName = \'$theSubAppBlog\') ORDER BY cur_timestamp DESC");
        	$str->execute;
		my @resultsCheck=$str->fetchrow_array;
        	my $tempInt = 0;
        	my $finalString = "";

		

#	my $myAuthor = $_[0];
#	my $myDate = $_[1];
#	my $mySubApp = $_[2];
#	my $myApp = $_[3];
#	my $numbers = $_[4];
#	my $results = $_[5];
#	my $myFormat = $_[6];
#	my $finalPost = $_[7];
#



		my $tempBool = $tempInt<$numOfPostsToSendBack and $#resultsCheck > 0;
		PRINTLOGBLOG( "while ($tempInt<$numOfPostsToSendBack and $#resultsCheck > 0) equals <$tempBool>\n");
		my $countNum = 1;
        	while ($tempInt<$numOfPostsToSendBack and $#resultsCheck > 0) {
			#nathanrstacey@gmail.com,,search,blogger,1,,{-p},""
			###lets get this guys nickname
			my $nickname = "";
			$nickname = $theEmailBlog;
			PRINTLOG("about to do <select * FROM userUsage WHERE (userName = \'$theEmailBlog\')>\n");
			my $str2 = $connection2->prepare("select * FROM userUsage WHERE (userName = \'$theEmailBlog\')");
    			$str2->execute;   
    			my @resultsCheck2=$str2->fetchrow_array;
			if ($resultsCheck2[4]) {
				$nickname = $resultsCheck2[4];
			}
			PRINTLOGBLOG("going into addToPostFormat($nickname,$resultsCheck[7],$theSubAppBlog,$theAppBlog,$countNum,$resultsCheck[3],$blogFormat,\"\")\n");
			$finalString = "$finalString" . addToPostFormat($nickname,$resultsCheck[7],$theSubAppBlog,$theAppBlog,$countNum,$resultsCheck[3],$blogFormat,"") ."45454545454545";
			$tempInt++;
			$countNum++;
			@resultsCheck=$str->fetchrow_array;
        	}    
		
	#my $mySearchTerm = $_[0];
	#my $myPost = $_[1];
	#my $toEmail = $_[2];
	#my $fromEmail = $_[3];
	#my $myFormat = $_[4];
	#my $finalPost = $_[5];

		PRINTLOG("going into finalPostFormat with <>,<$finalString>,<$theEmailBlog>,<$fromEmail>,<$blogFormat>,<>\n");
		my $finalString = finalPostFormat("",$finalString,$theEmailBlog,$fromEmail,$blogFormat,"");	
		sendOutTextBlog($theEmail,$finalString,$repeat);
		PRINTLOGBLOG( "ending starstarBlogl\nfinalString <$finalString>\n****************\n\n");
        	startstarIsDoneBlog("");
    	}
    	else {
        	closeUpBlog("");
    	}
}









sub starstarBlogr {
	PRINTLOGBLOG( "in starstarBlogr\n");
    getNextWordBlog();
    if (isAdminOrCreatorBlog($theSubAppBlog) and ($nextWordBlog =~ /public|private|subscription/)) {
	PRINTLOGBLOG( "We have approval to update security with <update bloglist SET security=\'$nextWordBlog\' WHERE (appName = \'$theAppBlog\' AND subAppName  = \'$theSubAppBlog\')>");
        $connectionBlog->do("update blogList SET security=\'$nextWordBlog\' WHERE (appName = \'$theAppBlog\' AND subAppName  = \'$theSubAppBlog\')");
        startstarIsDoneBlog("");
    }
    else {
        closeUpBlog("");
    }
	PRINTLOGBLOG("leaving starstarblogr\n");
}








sub starstarBlogn {
	PRINTLOGBLOG( "in starstarBlogn\n");
	#this is always the last post allowed to allow starstarBlogs to be part of the text. So, 
	#we must clean up the rest of the CLI string once this subroutine is over
	my $isDelivered = "";
	my $blogPostValue = findAllOfTheBlogPostBlog();
	PRINTLOGBLOG ("blogPostValue is <$blogPostValue>\n");
	###
	getNextWordBlog();
	my $blogOptions = findAllOptionsOrFormatBlog();
	getNextWordBlog();
	my $blogFormat = findAllOptionsOrFormatBlog();
	PRINTLOGBLOG("blogOptions <$blogOptions> and blogFormat <$blogFormat>\n");
	my $sendAsAttachment = 0;
	###
	PRINTLOGBLOG("blogPostValue before chomp <$blogPostValue>\n");
	if ($blogPostValue =~ /^(.*)\W+$/) {
		$blogPostValue = $1;
	}
	PRINTLOGBLOG("blogPostValue after chomp <$blogPostValue>\n");
	my $nickname = "";
	$nickname = $theEmailBlog;
	PRINTLOG("about to do <select * FROM userUsage WHERE (userName = \'$theEmailBlog\')>\n");
	my $str2 = $connection2->prepare("select * FROM userUsage WHERE (userName = \'$theEmailBlog\')");
	$str2->execute;   
	my @resultsCheck2=$str2->fetchrow_array;
	if ($resultsCheck2[4]) {
		$nickname = $resultsCheck2[4];
	}
    	if (isPublicBlog() or isPosterBlog() or isAdminOrCreatorBlog($theSubAppBlog) or (isOpenBlog())) {
	#we need to figure out the security of this blog
		my $str = $connectionBlog->prepare("SELECT * FROM blogList WHERE (appName = \'$theAppBlog\' AND subAppName = \'$theSubAppBlog\')");
        	$str->execute;
        	my @resultsCheck=$str->fetchrow_array;
        	my $security = $resultsCheck[3];
		if ($blogPostValue =~ /^$/) {
			closeUpBlog("");
		}
        	#now update the database
		my @attachmentArray = split(/ /,$attachmentString);
		PRINTLOGBLOG( "starting to add attachments to blogPost. The attachmentString is <$attachmentString> which created <$#attachmentArray> total attachments\n");
		while (<@attachmentArray>) {
			if ($_ =~ /\w/) {
				$blogPostValue = $blogPostValue . " 789502735 $_ 789502735 ";
				PRINTLOGBLOG( "adding another attachment to the blogPost. The full blog post is now <$blogPostValue>\n");
			}
		}
		#mysql uses \ as a wildcard and deletes one. So the CLI needs an additional at each locations
		$blogPostValue =~ s/\\/\\\\/g;
		PRINTLOGBLOG( "about to perform <INSERT INTO blogPosts(appName, subAppName, post, public, pointsMade, pointsPossible,userName) VALUES(\'$theAppBlog\', \'$theSubAppBlog\', \'$blogPostValue\', \'$security\', \'0\', \'0\',\'$theEmailBlog\')");
        
        	$connectionBlog->do("INSERT INTO blogPosts(appName, subAppName, post, public, pointsMade, pointsPossible,userName) VALUES(\'$theAppBlog\', \'$theSubAppBlog\', \'$blogPostValue\', \'$security\', \'0\', \'0\',\'$theEmailBlog\')");
        
        	#now send out the texts to the subscribers
        	my $str = $connectionBlog->prepare("SELECT * FROM blogSubscriptions WHERE (appName = \'$theAppBlog\' AND subAppName = \'$theSubAppBlog\' AND (subscribe_or_read = \'subscribe\' or subscribe_or_read = \'-s\' or subscribe_or_read = \'s\') AND adminApproved='1' AND userApproved='1')");
        	$str->execute;
		my $tempInt1 = 1;
        	while (@resultsCheck=$str->fetchrow_array) {
			PRINTLOGBLOG( "found another subscriber for this post:<$resultsCheck[3]>\n");			
			PRINTLOGBLOG( "about to do the following command:<sendOutTextBlog($resultsCheck[3],$blogPostValue);\n");	
			###
			if ($blogFormat !~ /\w/) {
				$blogFormat = '-p\-By:-a';
				
			}
			PRINTLOG ("going into addToPostFormat with <$nickname>,<>,<$theSubAppBlog>,<$theAppBlog>,<$tempInt1>,<$blogPostValue>,<$blogFormat>,<>\n");
			my $addDoneBlogFormat = addToPostFormat($nickname,"",$theSubAppBlog,$theAppBlog,$tempInt1,$blogPostValue,$blogFormat,"") . "45454545454545";
#		return addToPostFormat($myAuthor,$myDate,$mySubApp,$myApp,$numbers,$results,$myFormat,$finalPost);
			PRINTLOG("going into finalPostFormat with <>,<$addDoneBlogFormat>,<$resultsCheck[3]>,<$fromEmail>,<$blogFormat>,<>\n");
			my $finalEmailMessage = finalPostFormat("",$addDoneBlogFormat,$resultsCheck[3],$fromEmail,$blogFormat,"");
			###
			sendOutTextBlog($resultsCheck[3],"$finalEmailMessage",0);
			$isDelivered = "and is delivered";
			$tempInt1++;
        	}
    	}
    	else {
        	closeUpBlog("");
    	}
	$theTextBlogCompleted = "";
	$blogPostValue = "";
	PRINTLOGBLOG( "Leaving starstarblogn\n");
	startstarIsDoneBlog("");
}





sub starstarBlogs {
    if (isAdmin()) {
        my $str = $connectionBlog->prepare("SELECT * FROM blogList WHERE (appName = \'$theAppBlog\' AND subAppName = \'$theSubAppBlog\')");
        $str->execute;
        my @resultsCheck=$str->fetchrow_array;
        my $tempStr = join("\n",@resultsCheck);
        startstarIsDoneBlog($tempStr);
    }
    else {
        closeUpBlog("");
    }
}










sub starstarBloge {
	my $theToForStarE;
	my @allAttachments;
    getNextWordBlog();
    if (isAdminBlog() or isAReaderBlog() or isASubscriberBlog() or isPosterBlog()) {
        my $str = $connectionBlog->prepare("SELECT post FROM blogPosts WHERE (appName = \'$theAppBlog\' AND subAppName = \'$theSubAppBlog\') ORDER BY cur_timestamp");
        $str->execute;
        my @resultsCheck;
	my @allAttachments;
        open (ATTACHMENT, ">>output_$theAppBlog$theSubAppBlog$theEmailBlog.txt");
        while (@resultsCheck=$str->fetchrow_array) {
		$_ = $resultsCheck[0];
		my @tempAttachments = / 789502735 ([\w\/]*) 789502735 /g;
		@allAttachments = @allAttachments . @tempAttachments;
		my $tempBlog = s/ 789502735 ([\w\/]*) 789502735 //g;
           	print ATTACHMENT "$tempBlog\n";
        }
        close(ATTACHMENT);	
	$theToForStarE = $nextWordBlog;							

	my $attachmentString = "-a \"output_$theAppBlog$theSubAppBlog$theEmailBlog.txt\"";
	my $tempVal = 0;
	while (<@allAttachments>) {
		if ($_ =~ /\w/) {
			$attachmentString = $attachmentString . " $allAttachments[$tempVal]";
		}
	}

	my $int = 0;
	my $portToAddToString;
	if ($global_pop3_Port) {
		$portToAddToString = ":" . $global_pop3_Port;
	}
	else {
		$portToAddToString = "";
	}
	PRINTLOGBLOG( "about to send out to system:<sendEmail -f $fromEmail -t $theToForStarE -u \"Database Dump\" -m \"$theText\" -s $global_email_url$portToAddToString -xu $fromEmail -xp $global_email_Mail_User_Password -o tls=no $attachmentString>");
	system("sendEmail -f $fromEmail -t $theToForStarE -u \"Database Dump\" -m \"$theText\" -s $global_email_url$portToAddToString -xu $fromEmail -xp $global_email_Mail_User_Password -o tls=no -o message-content-type=html $attachmentString");
        startstarIsDoneBlog("");
    }
    else {
        closeUpBlog("");
    }
}



sub starstarBlogo {
	PRINTLOGBLOG( "in starstarBlogo\n");
#open or privileged
	getNextWordBlog();
	if (isAdminOrCreatorBlog($theSubAppBlog) and (($nextWordBlog =~ /-o|p/) or ($nextWordBlog =~ /p|o/) or($nextWordBlog =~ /open/) or($nextWordBlog =~ /privileged/) or($nextWordBlog =~ /-open/) or($nextWordBlog =~ /-privileged/))) {
		my $oOrC;		
		if (($nextWordBlog =~ /-o/) or ($nextWordBlog =~ /open/) or ($nextWordBlog =~ /o/) or ($nextWordBlog =~ /-open/)){
			$oOrC = "o";
		}
		else {
			$oOrC = "p";
		}
		PRINTLOGBLOG( "in starstarBlogo\nupdate blogList SET security=\'$nextWordBlog\' WHERE (appName = \'$theAppBlog\' AND subAppName  = \'$oOrC\')");
        	$connectionBlog->do("update blogList SET open=\'$oOrC\' WHERE (appName = \'$theAppBlog\' AND subAppName  = \'$theSubAppBlog\')");
        	startstarIsDoneBlog("");
    	}
    	else {
        	closeUpBlog("");
    	}
	
}


sub starstarBloga {
	PRINTLOGBLOG( "In starstaraBloga\n");
	my $subscribeOrRead;
	my $userName;
	my $emailToAnnounceApproval;
	my $adminGenerated = 0;
	getNextWordBlog();
	my $addOrRemove = $nextWordBlog;
	getNextWordBlog();
	my $adminOrSubscriber = $nextWordBlog;
	if ($addOrRemove =~ /-a/) {
		getNextWordBlog();
		$subscribeOrRead = $nextWordBlog;
	}
	if ($adminOrSubscriber =~ /-a/) {
		getNextWordBlog();
		$userName = $nextWordBlog;
		getNextWordBlog();
		$emailToAnnounceApproval = $nextWordBlog;
	}	


	my $str;
	if ($adminOrSubscriber =~ /-a/) {
		$str = $connectionBlog->prepare("SELECT * FROM blogSubscriptions WHERE (appName = \'$theAppBlog\' AND subAppName = \'$theSubAppBlog\' AND userName = \'$userName\')");
	}
	else {
		$str = $connectionBlog->prepare("SELECT * FROM blogSubscriptions WHERE (appName = \'$theAppBlog\' AND subAppName = \'$theSubAppBlog\' AND userName = \'$theEmail\')");
	}
        $str->execute;
        my @resultsCheck=$str->fetchrow_array;
	if ($resultsCheck[0]) {
		PRINTLOGBLOG( "this user already exists. We will update them\n");
		if ($addOrRemove =~ /\-a/) {
			PRINTLOGBLOG( "in starstarBloga adding a user\n");			
			if (($adminOrSubscriber =~ /-a/) and (isPosterBlog() or isAdminOrCreatorBlog($theSubAppBlog))) {
				PRINTLOGBLOG( "in starstarBloga and the admin or poster will approve the user:<$userName>\n");				
				$connectionBlog->do("update blogSubscriptions SET adminApproved=\'1\' WHERE (appName = \'$theAppBlog\' AND subAppName  = \'$theSubAppBlog\' AND userName = \'$userName\')");
				########## to:userName from: $emailToAnnounceApproval Message: Approved! The admin approved you for group $theSubAppBlog	
				my $theEmailBody = "Approved!" . '\\n' .  "The admin approved you for group $theSubAppBlog";				
				createOutputFileForNextScript("4", $userName, $theEmailBody, $emailToAnnounceApproval, 1);		
        			startstarIsDoneBlog("");
			}
			elsif (($adminOrSubscriber =~ /-u/) and isPublicBlog()) {
				PRINTLOGBLOG( "in starstarBloga and it is a public subApp so user is fully approved\n");        			
				$connectionBlog->do("update blogSubscriptions SET adminApproved=\'1\' WHERE (appName = \'$theAppBlog\' AND subAppName  = \'$theSubAppBlog\' AND userName = \'$theEmail\')");
				$connectionBlog->do("update blogSubscriptions SET userApproved=\'1\' WHERE (appName = \'$theAppBlog\' AND subAppName  = \'$theSubAppBlog\' AND userName = \'$theEmail\')");
				$connectionBlog->do("update blogSubscriptions SET subscribe_or_read =\'$subscribeOrRead\' WHERE (appName = \'$theAppBlog\' AND subAppName  = \'$theSubAppBlog\' AND userName = \'$theEmail\')");
        			startstarIsDoneBlog("");
			}
			elsif ($adminOrSubscriber =~ /-u/) {
				PRINTLOGBLOG( "in starstarBloga and user is approving themselve with\nupdate blogSubscriptions SET userApproved=\'1\' AND subscribe_or_read = \'$subscribeOrRead\' WHERE (appName = \'$theAppBlog\' AND subAppName  = \'$theSubAppBlog\' AND userName = \'$theEmail\')\n");				
				$connectionBlog->do("update blogSubscriptions SET userApproved=\'1\' WHERE (appName = \'$theAppBlog\' AND subAppName  = \'$theSubAppBlog\' AND userName = \'$theEmail\')");
				$connectionBlog->do("update blogSubscriptions SET subscribe_or_read = \'$subscribeOrRead\' WHERE (appName = \'$theAppBlog\' AND subAppName  = \'$theSubAppBlog\' AND userName = \'$theEmail\')");
				createEmailToRequestAdminSecurityApproval($theAppBlog,"$theSubAppBlog",$theEmail,"$subscribeOrRead","*e $theAppBlog $theSubAppBlog **a -a -a $subscribeOrRead $theEmail");
        			startstarIsDoneBlog("");
			}
			else {
				closeUpBlog("");
			}
		}
		if ($addOrRemove =~ /\-r/) {
			PRINTLOGBLOG( "in starstarBloga and about to remove a user\n");
			if (($adminOrSubscriber =~ /-a/) and (isPosterBlog() or isAdminOrCreatorBlog($theSubAppBlog))) {
				PRINTLOGBLOG( "in starstarBloga and admin will remove this user\n");				
				$connectionBlog->do("delete FROM blogSubscriptions WHERE (appName = \'$theAppBlog\' AND subAppName  = \'$theSubAppBlog\' AND userName = \'$userName\')");
        			startstarIsDoneBlog("");
			}
			elsif ($adminOrSubscriber =~ /-u/) {
				PRINTLOGBLOG( "in starstarBloga and user will remove himself\n");				
				$connectionBlog->do("delete FROM blogSubscriptions WHERE (appName = \'$theAppBlog\' AND subAppName  = \'$theSubAppBlog\' AND userName = \'$theEmail\')");
        			startstarIsDoneBlog("");	
			}
			else {
				PRINTLOGBLOG( "in starstarBloga and the person who entered this subAPp subscription removals does not have sufficent rights.\n");				
				closeUpBlog("");
			}	
		}	
	
	}
#	$connection->do("INSERT INTO apps (appName,pwd,pwd_rights,admin1) VALUES(\'$nextWord\',\'\',\'\',\'$theEmail\')");
	else {
		PRINTLOGBLOG( "this user is not setup yet. We will create them\n");
		if ($addOrRemove =~ /\-a/) {
			if (($adminOrSubscriber =~ /-a/) and (isPosterBlog() or isAdminOrCreatorBlog($theSubAppBlog))) {
				$connectionBlog->do("INSERT INTO blogSubscriptions (appName,subAppName,userName,adminApproved,subscribe_or_read) VALUES (\'$theAppBlog\',\'$theSubAppBlog\',\'$userName\',\'1\',\'$subscribeOrRead\')");
        			startstarIsDoneBlog("");
			}
			elsif (($adminOrSubscriber =~ /-u/) and isPublicBlog()) {
				$connectionBlog->do("INSERT INTO blogSubscriptions (appName,subAppName,userName,adminApproved,subscribe_or_read,userApproved) VALUES (\'$theAppBlog\',\'$theSubAppBlog\',\'$theEmail\',\'1\',\'$subscribeOrRead\',\'1\')");
        			startstarIsDoneBlog("");
			}
			elsif ($adminOrSubscriber =~ /-u/) {
				PRINTLOGBLOG( "in starstarBloga and user is approving themselve\n");				
				$connectionBlog->do("INSERT INTO blogSubscriptions (appName,subAppName,userName,adminApproved,subscribe_or_read,userApproved) VALUES (\'$theAppBlog\',\'$theSubAppBlog\',\'$theEmail\',\'0\',\'$subscribeOrRead\',\'1\')");
				createEmailToRequestAdminSecurityApproval($theAppBlog,"$theSubAppBlog",$theEmail,"$subscribeOrRead","*e $theAppBlog $theSubAppBlog **a -a -a $subscribeOrRead $theEmail");
        			startstarIsDoneBlog("");
			}
			else {
				closeUpBlog("");	
			}
		}
		if ($addOrRemove =~ /\-r/) {
			closeUpBlog("");	
		}
	}
}

































