#!/usr/bin/perl

use warnings;
use CGI;
use DBI;
use Number::Format 'format_number';
use List::Util qw/sum/;
use File::Copy;
use File::Path;
use WWW::Telegram::BotAPI;

my $api = WWW::Telegram::BotAPI->new (token => '5696623414:AAHnoJ7_ZLr6-Xh1UmUtNVnlByN36JDwdl4');

#get variables from the html form
my $query = new CGI;
my $subject = $query->param("subject");
my $summary = $query->param("summary");
my $body = $query->param("body");
my $username = $query->param("username");
my $password = $query->param("password");

$summary =~ s/\n/<br>\n/g;
$body =~ s/\n/<br>\n/g;

#clean up entries
$subject =~ s/\'/\'\'/g;
$summary =~ s/\'/\'\'/g;
$body =~ s/\'/\'\'/g;

#$subject =~ s/\,/\'\,/g;
#$summary =~ s/\,/\'\,/g;
#$body =~ s/\,/\'\,/g;

#$subject =~ s/\./\'\./g;
#$summary =~ s/\./\'\./g;
#$body =~ s/\./\'\./g;

#$subject =~ s/\@/\'\@/g;
#$summary =~ s/\@/\'\@/g;
#$body =~ s/\@/\'\@/g;

#$subject =~ s/\'/\'\'/;
#$summary =~ s/\'/\'\'/;
#$body =~ s/\'/\'\'/;

#this is for testing so I can see outputs in the browser
#$|=1;            # Flush immediately.
#print "Content-Type: text/plain\n\n";

my $epoc = time();
my $epoc_7_days = $epoc + '604800';

#this gets the mysql password from a file so we don't have to store it in the script
open my $fh, '<', '/usr/lib/cgi-bin/sql.txt' or die "Can't open file $!";
$password2 = do { local $/; <$fh> };

#remove white spaces in the file for some reason beyond me why it's doing that
$password2 =~ s/^\s+//;
$password2 =~ s/\s+$//;

#definition of variables
my $db="ergo_vote";
my $host="localhost";
my $user="root";


#connect to MySQL database
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
Wrong username or password! Please hit the back button and retry so that you don't lose your input!
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























#wite the form data back to the database
my $sql = "insert into votedata (subject, summary, body, username, start_date, end_date, active_status) VALUES ('$subject', '$summary', '$body', '$username', '$epoc', '$epoc_7_days', 'yes');";

#prepare the query
my $sth = $dbh->prepare($sql);

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

#let's display it
print $html;

#print "$subject \n$summary \n$body \n$username";
exit;
