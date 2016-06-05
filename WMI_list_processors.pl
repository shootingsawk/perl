#!/usr/bin/perl

use strict;
use warnings;

use Data::Dumper;

use Win32::OLE;
use Win32::OLE::Const;

use constant wbemFlagReturnImmediately => 0x10;
use constant wbemFlagForwardOnly => 0x20;

my $computer = "localhost";

my $WMI = Win32::OLE->GetObject("winmgmts:\\\\$computer\\root\\CIMV2") or die "WMI connection failed.\n";
my @items = $WMI->ExecQuery("SELECT * FROM Win32_Processor", "WQL", wbemFlagReturnImmediately | wbemFlagForwardOnly);

print Dumper($_) for (@items);