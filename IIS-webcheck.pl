#!/usr/bin/perl

use strict;
use LWP::UserAgent;
my $code;

my $server = shift || die "Must enter a server.\n";

my %urls = ("IDC" => "/*.idc",
      "ecp" => "/ecp/",
      "owa" => "/owa/",
      "powershell" => "/powershell",
      "rpc" => "/rpc/",
      "autodiscover" => "/autodiscover/autodiscover.xml",
      "Site Server 2.0 Repost" => "/scripts/repost.asp",
      "Site Server 3.0" => "/msadc/Samples/SELECTOR/showcode.asp",
      "FPCount" => "/_vti_bin/fpcount.exe?Page=default.htm|Image=3|Digits=15",
      "AdSamples" => "/adsamples/config/site.csc",
      "IISAdmin" => "/IISADMIN",
      "iisHelp" => "/iisHelp",
      "iisstart" => "/iisstart.htm",
      "Scripts1" => "/scripts/iisadmin/bdir.htr",
      "New DSN" => "/scripts/tools/newdsn.exe",
      "Query" => "/iissamples/issamples/query.asp",
      "HTR" => "/iisadmpwd/aexp2.htr",
      "RFP9907" => "/msadc/msadcs.dll",
      "vti_inf" => "/vti_inf.html",
      "advertising" => "/documentation/advertising.html",
      "documentation_default" => "/documentation/default.aspx",
      "parameter" => "/parameter.xml",
      "parame_83" => "/parame~1.xml",
      "aspnet_client" => "/aspnet_client",
      "documentation" => "/documentation",
      "javascript" => "/javascript",
      "vti_83" => "/_vti_s~1/",
      "aspnet_83" => "/aspnet~1/",
      "copy_83" => "/copyof~1/",
      "docume_83" => "/docume~1/",
      "javasc_83" => "/javasc~1/",
      "cgi-bin" => "/cgi-bin");

if (isIIS($server)) {
 print "$server: IIS web server.\n";
 foreach (keys %urls) {
  $code = testURL($server,$_,$urls{$_});
  print "$_ Code: $code\n";
 }
}
else {
 print "$server: NOT IIS.\n";
}

#-----------------------------------------------------------
# isIIS() - checks to see if web server is IIS
#-----------------------------------------------------------
sub isIIS {
 my($server) = @_;
 my $ua = new LWP::UserAgent;
 $ua->agent("IISBolom/0.1 ".$ua->agent);
 my $srv = "http://$server";
 my $req = new HTTP::Request Get => $srv;
 my $res = $ua->request($req);
 my $web = $res->server;
 (grep(/Microsoft-IIS/i,$web)) ? (return 1) : (return 0);
}

#-----------------------------------------------------------
# test CVE-2015-1635 (MS15-034)
# If the server responds with "Requested Header Range Not Satisfiable", 
# then you may be vulnerable.
# You should get a response saying "HTTP Error 400. The request has 
# an invalid header name.". Anything else as a response, and your 
# system may still be vulnerable.
#-----------------------------------------------------------
print "\ntest CVE-2015-1635 (MS15-034) :\n";
system("wget -O - --header=\"Range: 0-18446744073709551615\" http://$server/iisstart.htm");

#-----------------------------------------------------------
# test WebDAV
#-----------------------------------------------------------
#system("curl -X PROPFIND -H \"Content-Type: text/xml\" http://USER:PASSWORD@HOST/webdav/FOLDER | xmllint --format -");
print "\ntest WebDAV :\n";
print "\n-------------\n";
system("curl -X PROPFIND -H \"Content-Type: text/xml\" -H \"Depth: 1\" http://$server/webdav | xml_pp");

#-----------------------------------------------------------
# testURL() - fires URL at server, gets response code and
#             content (which can be saved for examination)
#-----------------------------------------------------------
sub testURL {
 my($server,$tag,$url) = @_;
 my $code;
 my $ua = new LWP::UserAgent;
 $ua->agent("IISBolom/0.1 ".$ua->agent);
 my $srv = "http://$server".$url;
 my $req = new HTTP::Request Get => $srv;
 my $res = $ua->request($req);
 $code = $res->code;
 my $content = $res->content;


# NOTE: This is the code for saving the content.  Uncomment
# the below 4 lines to save the returned web page to a file.
# my $file = $server."-".$tag.".html";
# open(FL,">$file") || die "Could not open $file: $!\n";
# print FL "$content\n";
# close(FL);

 return $code;
}
