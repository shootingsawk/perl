#!/usr/bin/perl -w
 
use Socket; # For constants like AF_INET and SOCK_STREAM
 
$proto = getprotobyname('tcp');    #get the tcp protocol
 
# 1. create a socket handle (descriptor)
my($sock);
socket($sock, AF_INET, SOCK_STREAM, $proto) 
    or die "could not create socket : $!";
 
# 2. connect to remote server
$remote = 'www.google.fr';
$port = 80;
 
$iaddr = inet_aton($remote) 
    or die "Unable to resolve hostname : $remote";
$paddr = sockaddr_in($port, $iaddr);    #socket address structure
 
connect($sock , $paddr) 
    or die "connect failed : $!";
print "Connected to $remote on port $port\n";
 
# 3. Send some data to remote server - the HTTP get command
send($sock , "GET / HTTP/1.0\r\n\r\n" , 0) 
    or die "sendo failed : $!";
 
# 4. Receive reply from server - perl way of reading from stream
# can also do recv($sock, $msg, 2000 , 0);
while ($line = <$sock>) 
{
    print $line;
}
 
close($sock);
exit(0);