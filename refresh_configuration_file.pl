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
