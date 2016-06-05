#!/usr/bin/perl

#   ProcList.pl
#   -----------
#   This script will display the list of current processes along with
#   the process's PID and binary path.
#   Syntax:
#       perl ProcList.pl [Machine Name]
#
#   Examples:
#       perl ProcTree.pl \\server 
#

use Win32::OLE qw( in );
use Win32::OLE::Variant;

$Machine = "\\\\.";
$Machine = shift @ARGV if( $ARGV[0] =~ /^\\\\/ );

# WMI Win32_Process class
$CLASS = "winmgmts:{impersonationLevel=impersonate}$Machine\\Root\\cimv2";
$WMI = Win32::OLE->GetObject( $CLASS ) || die;
foreach my $Proc ( sort {lc $a->{Name} cmp lc $b->{Name}} in( $WMI->InstancesOf( "Win32_Process" ) ) )
{
  printf( "% 5d) %s ", $Proc->{ProcessID}, "\u$Proc->{Name}" );
  print "( $Proc->{ExecutablePath} )" if( "" ne $Proc->{ExecutablePath} );
  print "\n";
}
