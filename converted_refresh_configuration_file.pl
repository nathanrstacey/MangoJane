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


open (CONFD, "configuration.d");
open (PERLVARIABLES, "+>confVariables.pl");
open (PYTHONVARIABLES, "+>confVariables.py");

 

my @lines = <CONFD>;
close (CONFD);


use strict;
use warnings;
my $nextVariableName = "";
my $theLine;
foreach $theLine (@lines) {
	if ($theLine =~ /^\#\#/) {
		next;
	}
	if ($theLine =~ /^\#(\w+)\:/) {
		$nextVariableName = $1;
	}
	elsif ($theLine =~ /^\w+/) {
		chomp($theLine);
		print PERLVARIABLES 'my $global_' . $nextVariableName . ' = \'' . $theLine . "\';\n";
		print PYTHONVARIABLES 'global_' . $nextVariableName . ' = \'' . $theLine . "\'\n";
	}

}

close (PERLVARIABLES);
close (PYTHONVARIABLES);
