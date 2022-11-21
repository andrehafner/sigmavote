#!/usr/bin/perl

use warnings;
use CGI;
use DBI;
use Number::Format 'format_number';
use List::Util qw/sum/;
use File::Copy;
use File::Path;

#get vars from tp_company_setup.html
$query = new CGI;
$username = $query->param("username");
$password = $query->param("password");
$twitter = $query->param("twitter");
$discord = $query->param("discord");
$telegram = $query->param("telegram");
$email = $query->param("snail");

#this gets the mysql password from a file so we don't have to store it in the script
open my $fh, '<', '/usr/lib/cgi-bin/sql.txt' or die "Can't open file $!";
$password2 = do { local $/; <$fh> };

#remove white spaces in the file for some reason beyond me why it's doing that
$password2 =~ s/^\s+//;
$password2 =~ s/\s+$//;

#let's get UNIX time
my $timecode = gettimeofday;

#definition of variables
my $db="ergo_vote";
my $host="localhost";
my $user="root";

#prep connect to MySQL database
my $dbh   = DBI->connect ("DBI:mysql:database=$db:host=$host",
  $user,
  $password2)
  or die "Can't connect to database: $DBI::errstr\n";









#getting all info from the employee that matches the company wallet
$sql_check = "select username from userdata where username='$username' and password=MD5('$password');";

#prepare the query
my $sth_check = $dbh->prepare($sql_check);

#execute the query
$sth_check->execute();

#put it into an array and loop it with a while
$" = "<br>";
while (my @row_check = $sth_check->fetchrow_array( ) )  {
  push(@array_check, @row_check);
};

if ($array_check[0] ne $username){

$html = "Content-Type: text/html

<HTML>

<HEAD>

<body>

<div style=\"text-align: center;\">
</br>
</br>
Wrong password! Please hit the back button and retry so that you don't lose your input! 
</div>
</body>
<a/>
</HTML>";

#this is for testing so I can see outputs in the browser
#$|=1;            # Flush immediately.
#print "Content-Type: text/plain\n\n";

print $html;
exit;

}














#prep mysql statment to write data as a new user entry into mysql table
$sql = "update userdata set twitter='$twitter', discord='$discord', telegram='$telegram', email='$email' where username='$username';";

#prepare the query
$sth = $dbh->prepare($sql);

#execute the query
$sth->execute();

my $html = "Content-Type: text/html

<HTML>
<meta http-equiv=\"refresh\" content=\"0; url=https://my.ergoport.dev/cgi-bin/ergo/list_votes.pl?a=$username\">

<HEAD>

<body>

<div style=\"text-align: center;\">
</br>
</br>
</div>
</body>
<a/>
</HTML>";


print $html;

exit;
