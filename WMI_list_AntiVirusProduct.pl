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

   my $objWMIService = Win32::OLE->GetObject("winmgmts:\\\\$computer\\root\\SecurityCenter2") or die "WMI connection failed.\n";
   my $colItems = $objWMIService->ExecQuery("select * from AntiVirusProduct", "WQL",
                  wbemFlagReturnImmediately | wbemFlagForwardOnly);

   foreach my $objItem (in $colItems) {
      print "companyName: $objItem->{companyName}\n";
      print "displayName: $objItem->{displayName}\n";
      print "instanceGuid: $objItem->{instanceGuid}\n";
      print "onAccessScanningEnabled: $objItem->{onAccessScanningEnabled}\n";
      print "pathToSignedProductExe: $objItem->{pathToSignedProductExe}\n";
      print "productHasNotifiedUser: $objItem->{productHasNotifiedUser}\n";
      print "productState: $objItem->{productState}\n";
      print "productUptoDate: $objItem->{productUptoDate}\n";
      print "productWantsWscNotifications: $objItem->{productWantsWscNotifications}\n";
      print "versionNumber: $objItem->{versionNumber}\n";	  
      print "\n";
   }
}