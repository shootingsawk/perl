#!/usr/bin/env perl
use IO::Select;
use IO::Socket;

$lsn_addr = shift(@ARGV);
$lsn_port = shift(@ARGV);
$cnx_addr = shift(@ARGV);
$cnx_port = shift(@ARGV);

print "$lsn_addr:$lsn_port -> $cnx_addr:$cnx_port\n";

$lsn = IO::Socket::INET->new(Listen =>   $lsn_addr, LocalPort => $lsn_port);
$cnx_c = IO::Socket::INET->new(PeerAddr => $cnx_addr, PeerPort =>  $cnx_port);
$sel = IO::Select->new();

$lsn_avail = "";
$cnx_avail = "";

$lsn_c = $lsn->accept;

$sel->add($lsn_c);
$sel->add($cnx_c);

while(1) {
		@ready = $sel->can_read(1) ;
		if ( length(@ready) > 0 ) {
				foreach $socket (@ready) {
						if ( $socket ==  $lsn_c ) {
								$socket->recv($tmp, 1024);
								$lsn_avail .= $tmp;
						} elsif ( $socket == $cnx_c ) {
								$socket->recv($tmp, 1024);
								$cnx_avail .= $tmp;
						}
				}
		}
		if ( length(@ready) > 0 ) {
				@ready = $sel->can_write(1) ;
				foreach $socket (@ready) {
						if ( $socket ==  $lsn_c && length($cnx_avail) > 0 ) {
								$socket->send($cnx_avail);
								$cnx_avail = '';
						} elsif ( $socket == $cnx_c && length($lsn_avail) > 0) {
								$socket->send($lsn_avail);
								$lsn_avail = '';
						}
				}
		}
}


$SIG{PIPE} =  sub
{
		if (defined $current_client) {
				$cnx_c->close;
				$lsn_c->close;
		}
};
