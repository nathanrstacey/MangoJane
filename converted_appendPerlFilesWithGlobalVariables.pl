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
use Cwd;
my $dir = getcwd;

open (VARS, "confVariables.pl");
my @vars = <VARS>;
close (VARS);

my @perlScripts = <*.pl>;
my $theFileName;
foreach $theFileName (@perlScripts) {
	if ($theFileName !~ /converted/) {
		open (OUTPUT, "+>converted_$theFileName");
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
