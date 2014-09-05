#!/usr/bin/perl

use strict;
use warnings;
use Cwd;
my $dir = getcwd;

open (VARS, "confVariables.pl");
my @vars = <VARS>;
close (VARS);

my @allScripts = <pre_all.sh>;
my $theFileName;
foreach $theFileName (@allScripts) {
	if ($theFileName !~ /converted/) {
		open (OUTPUT, "+>all\.sh");
		my $confLine;
		foreach $confLine (@vars) {
			print OUTPUT $confLine;
		}
		print OUTPUT "\n\n\n";
		open (SCRIPT, "$theFileName");
		my $scriptLine;
		my @script = <SCRIPT>;
		close (SCRIPT);
		foreach $scriptLine (@script) {
			print OUTPUT $scriptLine;
		}	
		close (OUTPUT);
	}
} 
