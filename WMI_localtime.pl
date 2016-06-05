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
   my $colItems = $objWMIService->ExecQuery("SELECT * FROM Win32_LocalTime", "WQL",
                  wbemFlagReturnImmediately | wbemFlagForwardOnly);

   foreach my $objItem (in $colItems) {
      print "Day: $objItem->{Day}\n";
      print "DayOfWeek: $objItem->{DayOfWeek}\n";
      print "Hour: $objItem->{Hour}\n";
      print "Milliseconds: $objItem->{Milliseconds}\n";
      print "Minute: $objItem->{Minute}\n";
      print "Month: $objItem->{Month}\n";
      print "Quarter: $objItem->{Quarter}\n";
      print "Second: $objItem->{Second}\n";
      print "WeekInMonth: $objItem->{WeekInMonth}\n";
      print "Year: $objItem->{Year}\n";
      print "\n";
   }
}