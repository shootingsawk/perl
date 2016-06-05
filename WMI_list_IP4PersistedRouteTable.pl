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
   my $colItems = $objWMIService->ExecQuery("SELECT * FROM Win32_IP4PersistedRouteTable", "WQL",
                  wbemFlagReturnImmediately | wbemFlagForwardOnly);

   foreach my $objItem (in $colItems) {
      print "Caption: $objItem->{Caption}\n";
      print "Description: $objItem->{Description}\n";
      print "Destination: $objItem->{Destination}\n";
      print "InstallDate: $objItem->{InstallDate}\n";
      print "Mask: $objItem->{Mask}\n";
      print "Metric1: $objItem->{Metric1}\n";
      print "Name: $objItem->{Name}\n";
      print "NextHop: $objItem->{NextHop}\n";
      print "Status: $objItem->{Status}\n";
      print "\n";
   }
}sub WMIDateStringToDate(strDate)
{
   return "blah";
}