#!/usr/bin/perl

#  This script uses WMI to kill processes on remote machines.
#
#  Syntax:
#     WMI_Kill.pl \\machine Process1 [Process2 ...]
#
#     \\machine.....Computer name of remote machine (use . for local)
#     Process.......PID or name of process to kill
#                   eg: 1234 or IExplore.exe 
#                   You can use regex: IExplore.* 
#
#
#
print "Terminates running processes on local or remote machine using WMI\n\n";


use Win32::OLE qw( in );

$Machine = "." unless( $Machine = shift @ARGV );
$Machine =~ s#^[\\/]+## if( $ARGV[0] =~ m#^[\\/]{2}# );

# This is the WMI moniker that will connect to a machine's 
# CIM (Common Information Model) repository
$CLASS = "WinMgmts:{impersonationLevel=impersonate}!//$Machine";

# Get the WMI (Microsoft's implementation of WBEM) interface
$WMI = Win32::OLE->GetObject( $CLASS )
  || die "Unable to connect to \\$Machine:" . Win32::OLE->LastError();

# Get the collection of Win32_Process objects
$ProcList = $WMI->InstancesOf( "Win32_Process" );

# Try to kill each PID passed in
foreach $Pid ( @ARGV )
{
  my $KillList = GetProc( $Pid, $ProcList );
  if( scalar @$KillList )
  {
    foreach my $Proc ( @$KillList )
    {
      print "Killing $Proc->{Name} ($Proc->{ProcessID})...";
  
      # We found the correct Win32_Process object so 
      # call its Terminate method
      $Result = $Proc->Terminate( 0 );
      if( 0 == $Result )
      {
        print "Successfully terminated";
      }
      else
      {
        print "Failed to terminate";
      }
      print "\n";
    }
  }
  else
  {
    print "$Pid not found.";
  }
}

sub GetProc
{
  my( $Pid, $ProcList ) = @_;
  if( $Pid =~ /^\d+$/ )
  {
    $List = GetProcByPid( $Pid, $ProcList );
  }
  else
  {
    $List = GetProcByName( $Pid, $ProcList );
  }
  return( $List );
}

sub GetProcByPid
{
  my( $Pid, $ProcList ) = @_;
  
  # Cycle through each Win32_Process object 
  # until you find the right one
  foreach my $Proc ( in( $ProcList ) )
  {
    return( [ $Proc ] ) if( $Pid == $Proc->{ProcessID} );
  }
  return( [] );
}

sub GetProcByName
{
  my( $Name, $ProcList ) = @_;
  my( @Procs );
  my( $Regex ) = ( $Name =~ m#[$^\\/*?{}\[\]]+# );
  
  # Cycle through each Win32_Process object 
  # until you find the right one
  foreach my $Proc ( in( $ProcList ) )
  {
    if( $Regex )
    {
      push( @Procs, $Proc ) if( $Proc->{Name} =~ /$Name/i );
    }
    else
    {
      push( @Procs, $Proc ) if( lc $Name eq lc $Proc->{Name} );
    }
  }
  return( \@Procs );
}