#!/usr/bin/perl -w
use strict;
use Time::HiRes qw(gettimeofday);
use Cwd;

my $timeStamp = int (gettimeofday * 1000000000);
my @variableArray; 
open (LOG, "+>logs\/log_startMasterEngine.txt");

#change the extension here
my $dir = getcwd;
my $workToDoDir = $dir . '/workToDo/';
my $doneWorkToDoDir = $dir . '/doneWorkToDo/';
my @files = <workToDo/*parse>;
my @files1 = sort @files;
@files = @files1;
my $theFileName;
my $variableStringForExec = "";
print LOG "Starting to look at all files. There are $#files total files\n";
foreach $theFileName (@files) {
	my $timeStampFile = 99999999999;
	$variableStringForExec = "";
	print LOG "found $theFileName\n";
	my $fileNameWithoutFolderExtension;
	if ($theFileName =~ /workToDo\/(.*\.parse)$/) {
		$fileNameWithoutFolderExtension = $1;
		if ($theFileName =~ /workToDo\/(\d+).*\.parse$/) {
			$timeStampFile = $1;
		}
	}
	if ($timeStamp >= $timeStampFile) {
		print LOG "found $theFileName and its timestamp is less than this startTime\n";
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
			print LOG "\n\n\n\n" . $theFileName . "\n";
			my $variables;
			$variableStringForExec = $variableStringForExec . "\'\n";
			
		
			#put in the perl file in here
			print LOG "going into converted_masterEngine variables:<$variableStringForExec>\n";		
			system("perl converted_masterEngineWithDBI_CLI4.pl $variableStringForExec");
		
		}
		close (INPUT);
		system ("mv $theFileName $doneWorkToDoDir" . "$fileNameWithoutFolderExtension");
	} 
	else {
		print LOG "the file was newer than the beginning of this script start  time\n";
	}	
}
	close (LOG);
