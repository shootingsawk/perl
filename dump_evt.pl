#!/usr/bin/perl

#----------------------------------------------------
# dump_evt.pl
# 
# Usage:    perl dump_evt.pl [Server] [> outputfile]
#----------------------------------------------------
use strict;
use Win32::EventLog;

my $server = shift || Win32::NodeName;

\&GetEvents($server,"System");
\&GetEvents($server,"Application");
\&GetEvents($server,"Security");

#----------------------------------------------------
# GetEvents()
# Input:  Server name, EventLog
# Output: Log entries, to STDOUT
#----------------------------------------------------
sub GetEvents {
	my($server,$log) = @_;
	my ($evt,$total,$oldest,$evtHashRef);
	my $start = 0;

	$evt = Win32::EventLog->new($log,$server) || 
		die "Could not open $log log on $server: $!\n";
	$evt->GetNumber($total) || die "Can't get number of EventLog records: $!\n";
	$evt->GetOldest($oldest) || die "Can't get number of oldest EventLog record: $!\n";
	
	while ($start < $total) {
  
$evt->Read(EVENTLOG_FORWARDS_READ|EVENTLOG_SEEK_READ,$oldest+$start,$evtHashRef)

  			or die "Can't read EventLog entry #$start\n";
  				
  	print "-" x 75; print "\n";
  	print "RecordNumber:  
".${$evtHashRef}{RecordNumber}."\n";
  	print "Source:        
".${$evtHashRef}{Source}."\n";
  	print "Computer:      
".${$evtHashRef}{Computer}."\n";
  	print "Category:      
".${$evtHashRef}{Category}."\n";
  	my $id = (${$evtHashRef}{EventID} & 0xffff);
  	print "Event ID:       ".$id."\n";
  	print "EventType:     
".${$evtHashRef}{EventType}."\n";
  	print "Time Generated:
".localtime(${$evtHashRef}{TimeGenerated})."\n";
  	print "Time Written:  
".localtime(${$evtHashRef}{Timewritten})."\n";
  	my $sid = unpack("H" . 2 *
length(${$evtHashRef}{User}), ${$evtHashRef}{User});
  	print "User:           ".$sid."\n";
  		
  	Win32::EventLog::GetMessageText($evtHashRef);
  	my $msg = $evtHashRef->{Message};
  	print "Message: $msg\n";
  	print "\n\n";
  	$start++;
	}
}