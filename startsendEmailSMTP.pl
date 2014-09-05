#!/usr/bin/perl -w

use strict;
use Time::HiRes qw(gettimeofday);
#print "1\n";
my $timeStamp = int (gettimeofday * 1000000000);
my @variableArray; 
my $isFirstTimeInSendEmail = 1;
use Time::HiRes qw(gettimeofday);
use Cwd;
my $dir = getcwd;
#print "2\n";
#change the extension here
my $workToDoDir = $dir . '/workToDo/';
my $doneWorkToDoDir = $dir . '/doneWorkToDo/';
my @files = <workToDo/*medc>;
#print "first files $#files\n";
my @files1 = sort @files;
@files = @files1;
my $theFileName;
my $variableStringForExec = "";
my $tempNum = $#files +1;


my $portToAddToString;
if ($global_pop3_Port) {
	$portToAddToString = ":" . $global_pop3_Port;
}
else {
	$portToAddToString = "";
}
print "this many emails <$tempNum>\n";
if ($tempNum > 10) {
	system('sendEmail -f home@mangojane.com -t $nathanrstacey@gmail.com -m "Mango Jane just sent out ' . $tempNum . ' emails." -s ' . $global_email_url .$portToAddToString .' -xu home@mangojane.com -xp ' . $global_email_Mail_User_Password . ' -o tls=no -o message-content-type=html -o message-charset=utf-8');
}


if ($#files < 0) {
	#print "about to die\n";	
	die;
}
open (LOG, ">logs\/log_startsendEmail.txt");
print LOG "Starting to look at all files. There are $#files total files\n";
foreach $theFileName (@files) {
	print LOG "#######\n#######\n#######\n########About to start to evaluate a new .medc\n########\n########\n";
	my $timeStampFile = 99999999999;
	$variableStringForExec = "";
	my $fileNameWithoutFolderExtension;
	if ($theFileName =~ /workToDo\/(.*\.medc)$/) {
		$fileNameWithoutFolderExtension = $1;
		if ($theFileName =~ /workToDo\/(\d+).*\.medc$/) {
			$timeStampFile = $1;
		}
			
	}
	if ($timeStamp >= $timeStampFile) {
		my $doAgain;
		print LOG "   found $theFileName and its timestamp is less than this startTime\n";
		#print "\n" . $theFileName . "\n";
  		open (INPUT, "$theFileName");
		my @lines = <INPUT>;
		if ($#lines > 0) {
			chomp (@lines);
			my $theLinesName;
			my $lineScroll = 0;
			my $whichArrayWeAreOn = -1;
			foreach $theLinesName (@lines) {
				if ($theLinesName =~ /iiiiiiiiBeginNewVariableiiiiiiiiiii/) {
					$variableStringForExec = "$variableStringForExec \'";			
					$whichArrayWeAreOn++;
					$variableArray[$whichArrayWeAreOn] = "";
		
				}
				else {
					$variableStringForExec = $variableStringForExec . $theLinesName . "\n";
					#$variableArray[$whichArrayWeAreOn] = $variableArray[$whichArrayWeAreOn] . $theLinesName;
					if ($lineScroll < $#lines) {
						if ($lines[$lineScroll+1] =~ /iiiiiiiiBeginNewVariableiiiiiiiiiii/) {
							$variableStringForExec = $variableStringForExec . "\' ";
							#$variableArray[$whichArrayWeAreOn] = $variableArray[$whichArrayWeAreOn] . "\'\n";	
						}				
					}
				}
				$lineScroll++;
				#print "*" . $theLinesName . "\n";
			}
			print LOG "\n\n\n\n     " . $theFileName . "\n";
			my $variables;
			$variableStringForExec = $variableStringForExec . "\'\n";
					
			
			#put in the perl file in here
			print LOG "     going into sendEmailSMTP with variables:<$variableStringForExec>\n";	
			if ($isFirstTimeInSendEmail) {
				open (LOG1, ">log_sendEmailSMTP.txt");
				close LOG1;
				$isFirstTimeInSendEmail = 0;
			}
			$doAgain = doWeDoThisOrDelayItAgain($variableStringForExec);
			if ($doAgain) {
				print LOG "     about to send this email:\n##\n$variableStringForExec\n###\n";				
				system("perl converted_prepEmailToSend0.1.pl $variableStringForExec");
			}
		
		}
		close (INPUT);
		if ($doAgain)
		{
			system ("mv $theFileName $doneWorkToDoDir" . "$fileNameWithoutFolderExtension");
		}
		else
		{			
			system ("rm $theFileName");
		}
 	} 	
	else {
		print LOG "     the file was newer than the beginning of this script start  time\n";
	}
}	

sub doWeDoThisOrDelayItAgain {
	my $myString = $_[0];
	chomp ($myString);
	$myString = " \' " . $myString . "  \'";
	my @variableArray = split (/'  '/,$myString); #the first variable is worthless. So the first element in the array is worthless
	chomp (@variableArray);
	
	print LOG "     in doWeDoThisOrDelayItAgain with: <$myString>\n";
	print LOG "          Here is each variable\n#0\n$variableArray[0]\n#1\n$variableArray[1]\n#2\n$variableArray[2]\n#3\n$variableArray[3]\n#4\n$variableArray[4]\nthe repeat is <$variableArray[3]>\n";
	if ($variableArray[4] >= 1) {
		my $newRepeatsLeft = $variableArray[4] - 1;
		print LOG "          the repeat was <$variableArray[4]> but is now reduced to: <$newRepeatsLeft>\n";
		createOutputFileForNextScript("4", $variableArray[1],$variableArray[2],$variableArray[3],$newRepeatsLeft);
		print LOG "     leaving doWeDoThisOrDelayItAgain with 0\n";			
		return 0;
	}
	else {
		print LOG "     leaving doWeDoThisOrDelayItAgain with 1\n";
		return 1;
	}

}
	



sub createOutputFileForNextScript {
	use Time::HiRes qw(gettimeofday);
	print LOG "In createOutputFileForNextScript\n";
	my $folder = 'workToDo/';
	my $scriptName = 'masterEngine';
	my $extension = 'medc';

	my $numVariables = $_[0];
	print LOG "in createOutputFileForNextScript with this many variables <$numVariables> the first three are <$_[0]> <$_[1]> <$_[2]>\n";
	my $timestamp = int (gettimeofday * 1000000000);
	open(OUTVARIABLEFILE,"+>$folder$timestamp$scriptName.$extension");
	print LOG " this is the output data file <$folder$timestamp$scriptName.$extension>\n";
	my $temp = 1;
	for ($temp = 1; $temp <= $numVariables; $temp++) {
		print OUTVARIABLEFILE "iiiiiiiiBeginNewVariableiiiiiiiiiii\n";
		my $nextVariableToPrint = $_[$temp];
		if ($nextVariableToPrint =~ /^(.*)45454545454545\W*$/)	{
			$nextVariableToPrint = $1;
		}	
		print OUTVARIABLEFILE "$nextVariableToPrint\n";
	}
	close (OUTVARIABLEFILE);
}	

