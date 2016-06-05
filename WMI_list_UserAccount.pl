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
   my $colItems = $objWMIService->ExecQuery("SELECT * FROM Win32_UserAccount", "WQL",
                  wbemFlagReturnImmediately | wbemFlagForwardOnly);

   foreach my $objItem (in $colItems) {
      print "Account Type: $objItem->{AccountType}\n";
      print "Caption: $objItem->{Caption}\n";
      print "Description: $objItem->{Description}\n";
      print "Disabled: $objItem->{Disabled}\n";
	  print "Domain: $objItem->{Domain}\n";
	  print "FullName : $objItem->{FullName }\n";
	  print "LocalAccount : $objItem->{LocalAccount }\n";
	  print "Lockout: $objItem->{Lockout}\n";
	  print "Name: $objItem->{Name}\n";
	  print "PasswordChangeable : $objItem->{PasswordChangeable }\n";
	  print "PasswordExpires: $objItem->{PasswordExpires}\n";
	  print "PasswordRequired: $objItem->{PasswordRequired}\n";
	  print "SID: $objItem->{SID}\n";
	  print "SIDType : $objItem->{SIDType }\n";
	  print "Status  : $objItem->{Status  }\n";
      print "\n";
   }
}