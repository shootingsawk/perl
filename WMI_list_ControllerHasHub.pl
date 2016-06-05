#!/usr/bin/perl

use strict;
use Win32::OLE('in');

use constant wbemFlagReturnImmediately => 0x10;
use constant wbemFlagForwardOnly => 0x20;

my @computers = ("127.0.0.1");
foreach my $computer (@computers) {
   print "\n";
   print "==========================================\n";
   print "Computer: $computer\n";
   print "==========================================\n";

   my $objWMIService = Win32::OLE->GetObject("winmgmts:\\\\$computer\\root\\CIMV2") or die "WMI connection failed.\n";
   my $colItems = $objWMIService->ExecQuery("SELECT * FROM Win32_ControllerHasHub", "WQL",
                  wbemFlagReturnImmediately | wbemFlagForwardOnly);

   foreach my $objItem (in $colItems) {
      print "AccessState: $objItem->{AccessState}\n";
      print "Antecedent: $objItem->{Antecedent}\n";
      print "Dependent: $objItem->{Dependent}\n";
      print "NegotiatedDataWidth: $objItem->{NegotiatedDataWidth}\n";
      print "NegotiatedSpeed: $objItem->{NegotiatedSpeed}\n";
      print "NumberOfHardResets: $objItem->{NumberOfHardResets}\n";
      print "NumberOfSoftResets: $objItem->{NumberOfSoftResets}\n";
      print "\n";
   }
}