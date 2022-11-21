#!/usr/bin/perl

use warnings;
use CGI;
use DBI;
use Number::Format 'format_number';
use List::Util qw/sum/;
use File::Copy;
use File::Path;

#get variables from the html form
my $query = new CGI;
my $reason = $query->param("reason");
my $submit = $query->param("submit");
my $username = $query->param("username");
my $password = $query->param("password");
my $id = $query->param("id");
my $anon = $query->param("anon");

#clean up entries
$reason =~ s/\'/\'\'/g;

#add line breaks instead of newline so html can work
$reason =~ s/\n/<br>\n/g;

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


#print "$reason - $submit - $username - $password - $id";
#exit;

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
$sql_check = "select username, anon_id from userdata where username='$username' and password=MD5('$password');";

#prepare the query
my $sth_check = $dbh->prepare($sql_check);

#execute the query
$sth_check->execute();

#put it into an array and loop it with a while
$" = "<br>";
while (my @row_check = $sth_check->fetchrow_array( ) )  {
  push(@array_check, @row_check);
};

if ($array_check[0] ne $username || $username eq '' || $array_check[0] eq ''){

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















my $html_2x_vote = "Content-Type: text/html

<HTML>

<HEAD>

<body>

<div style=\"text-align: center;\">
</br>
</br>
Hey, no voting twice please! I shall not even redirect you and that shall be your punishment!
</div>
</body>
<a/>
</HTML>";


#getting all info from the employee that matches the company wallet
$sql_anon = "select anon_id from userdata where username='$username';";

#prepare the query
my $sth_anon = $dbh->prepare($sql_anon);

#execute the query
$sth_anon->execute();

#put it into an array and loop it with a while
$" = "<br>";
while (my @row_anon = $sth_anon->fetchrow_array( ) )  {
  push(@array_anon, @row_anon);}



#getting all info from the employee that matches the company wallet
$sql_vd = "select * from votedata where id='$id';";

#prepare the query
my $sth_vd = $dbh->prepare($sql_vd);

#execute the query
$sth_vd->execute();

#put it into an array and loop it with a while
$" = "<br>";
while (my @row_vd = $sth_vd->fetchrow_array( ) )  {
  push(@array_vd, @row_vd);}



if ($array_vd[5] =~ m/$username\,/s && $username ne ''){
print $html_2x_vote;
exit;
}

if ($array_vd[6] =~ m/$username\,/s && $username ne ''){
print $html_2x_vote;
exit;
}

if ($array_vd[7] =~ m/$username\,/s && $username ne ''){
print $html_2x_vote;
exit;
}


if ($array_vd[5] =~ m/$array_anon[0]\,/s && $username ne ''){
print $html_2x_vote;
exit;
}

if ($array_vd[6] =~ m/$array_anon[0]\,/s && $username ne ''){
print $html_2x_vote;
exit;
}

if ($array_vd[7] =~ m/$array_anon[0]\,/s && $username ne ''){
print $html_2x_vote;
exit;
}













#wite the form data back to the database
#my $sql = "update votedata set $submit='$username, ', reason='$reason' where id='$id';";

#the ifnull command is giving me shite, this is a quick bypass (next 5 lines)
my $empty_reason = "reason=CONCAT(IFNULL(reason,''), '- $reason <br><br>'),";

if ($reason eq ''){
$empty_reason = ();
}


my $sql = "update votedata set $empty_reason $submit=CONCAT(IFNULL($submit,''), '$username,') where id='$id';";


if ($anon eq 'anon'){
$sql = "update votedata set $empty_reason $submit=CONCAT(IFNULL($submit,''), '$array_check[1],') where id='$id';";
}


#print $sql;

#prepare the query
my $sth = $dbh->prepare($sql);

#execute the query
$sth->execute();

my $html = "Content-Type: text/html

<HTML>
<meta http-equiv=\"refresh\" content=\"0; url=https://my.ergoport.dev/cgi-bin/ergo/cast_vote.pl?a=$id\.$username\">

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
