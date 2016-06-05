#!/usr/bin/perl

#   This will display a process's parent processes. For example if you 
#   are running a Perl script with a Process ID (PID) of 1234 this script
#   will display the name of the Explorer.exe program, which is the parent
#   of the CMD.EXE process which is the parent of the Perl.EXE process.
#   In this example all three processes are displayed.
#   Syntax:
#       perl ProcTree.pl [Machine Name] PID
#
#   Examples:
#       perl ProcTree 1234
#       perl ProcTree.pl \\server 1234
#

use Win32::OLE qw( in );
use Win32::OLE::Variant;

$Machine = "\\\\.";
$Machine = shift @ARGV if( $ARGV[0] =~ /^\\\\/ );
$Pid = shift @ARGV || die "Syntax: $0 [\\\\machine] Pid";

# WMI Win32_Process class
$CLASS = "winmgmts:{impersonationLevel=impersonate}$Machine\\Root\\cimv2";
$WMI = Win32::OLE->GetObject( $CLASS ) || die;

if( my $Proc = $WMI->Get( "Win32_Process.Handle=\"$Pid\"" ) )
{
  print "\n";
  GetProcessInfo( $Proc );
}  
else
{
  print "Could not find PID $Pid\n";
}

sub GetProcessInfo
{
  my( $Proc ) = @_;
  my $Indent;
  
  return() if( 0 == $Proc->{ParentProcessId} );    
  if( my $ParentProc = $WMI->Get( "Win32_Process.Handle=\"$Proc->{ParentProcessId}\"" ) )
  {
    $Indent = GetProcessInfo( $ParentProc );
  }
  print $Indent . chr( 192 ) . chr( 196 ) if( $iTotal++ );
  print "\u$Proc->{Name} ($Proc->{ProcessID}): $Proc->{ExecutablePath}\n";
  return( $Indent . "  " );
}  