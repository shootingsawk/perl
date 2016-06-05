#!/usr/bin/perl

#  WMI_launch_processes_on_remotemachine.pl
#
#  This script uses WMI to create new processes on remote machines.
#
#  Syntax:
#     WMI_launch_processes_on_remotemachine.pl \\machine program param1 param2 param3....
#
#     \\machine.....Computer name of remote machine (use . for local)
#     Program.......Path to executable program you want to run
#     param.........Various parameters to pass into the new program
#
print "This script uses WMI to create new processes on remote machines\n\n";


use Win32::OLE qw( in );
use Win32::OLE::Variant;

$Machine = "." unless( $Machine = shift @ARGV );
$Machine =~ s#^[\\/]+## if( $ARGV[0] =~ m#^[\\/]{2}# );

# This is the WMI moniker that will connect to a machine's 
# CIM (Common Information Model) repository
$CLASS = "WinMgmts:{impersonationLevel=impersonate}!//$Machine";

# Get the WMI (Microsoft's implementation of WBEM) interface
$WMI = Win32::OLE->GetObject( $CLASS ) 
  || die "Unable to connect to \\$Machine:" . Win32::OLE->LastError();

# Now get a Win32_Process class object...
$Process = $WMI->Get( "Win32_Process" ) 
  || die "Unable to get the process list:" . Win32::OLE->LastError();

# Create a BYREF variant (so a COM object can modify its value and
# return it to us.
$vPid = Variant( VT_I4 | VT_BYREF, 0 );

# Now go ahead and create the new process using the Create() method
# off of the Win32_Process object
if( 0 == $Process->Create( join( " ", @ARGV ), undef, undef, $vPid ) )
{
    print "Process successfully created with PID $vPid\n";
}
else
{
    print "Failed to create process.\n";
}