#!/usr/bin/perl

use warnings;
use CGI;
use DBI;
use Number::Format 'format_number';
use List::Util qw/sum/;
use File::Copy;
use File::Path;
use DateTime;

#get variables from the html form
my $query = new CGI;
my $a = $query->param("a");


$html = qq{Content-Type: text/html

<html lang="en">
  <head>
    <!-- Required meta tags -->
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <link href="https://fonts.googleapis.com/css?family=Oswald:300,400|Roboto+Mono&display=swap" rel="stylesheet">

    <link rel="stylesheet" href="https://my.ergoport.dev/ergo/fonts/icomoon/style.css">


    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="https://my.ergoport.dev/ergo/css/bootstrap.min.css">
    
    <!-- Style -->
    <link rel="stylesheet" href="https://my.ergoport.dev/ergo/css/style.css">

    <title>sigmavote</title>
  </head>
  <body>
  

  <div class="content">
    
    <div class="container">
      <div class="row justify-content-center">
        <div class="col-md-8">
          <div class="row mb-5">
            <div class="col-md-4 mr-auto">
              <h3 class="thin-heading mb-4">Sigmanaut <br>-List Votes</h3>
              <p><a href="https://my.ergoport.dev/cgi-bin/ergo/new_user.pl">New User</a>
<a href="https://my.ergoport.dev/cgi-bin/ergo/edit_user.pl/">Edit User</a> <br>
<a href="https://my.ergoport.dev/cgi-bin/ergo/create_vote.pl?a=$a">Create Vote</a>
<a href="https://my.ergoport.dev/cgi-bin/ergo/list_votes.pl?a=$a">List Votes</a><br></p>
            </div>
            <div class="col-md-6 ml-auto">
              <h3 class="thin-heading mb-4">ERGO <br>Community Links</h3>
              <p>Discord <br> Telegram</p>
            </div>
          </div>

          <div class="row justify-content-center">
            <div class="col-md-12">
		<font size="+1"><b>ARCHIVED VOTES:</b></font size="+1">
              <p>Please click the link below a vote to open the full details of the archived vote.<br><br><br></p>
              <form class="mb-5" method="post"  ACTION="/cgi-bin/ergo/vote_dashboard.pl"  enctype="multipart/form-data">
		<form ACTION="/cgi-bin/ergo/vote_dashboard.pl" METHOD="post" enctype="multipart/form-data">
		
                <div class="row">

};

print $html;





#this gets the mysql password from a file so we don't have to store it in the script
open my $fh, '<', '/usr/lib/cgi-bin/sql.txt' or die "Can't open file $!";
$password2 = do { local $/; <$fh> };

#remove white spaces in the file just in case
$password2 =~ s/^\s+//;
$password2 =~ s/\s+$//;

#define mysql connection details
my $db="ergo_vote";
my $host="localhost";
my $user="root";

#connect to MySQL database
my $dbh   = DBI->connect ("DBI:mysql:database=$db:host=$host",
  $user,
  $password2)
  or die "Can't connect to database: $DBI::errstr\n";

##################


#getting all info from the employee that matches the company wallet
$sql = "select * from votedata where active_status='no';";

#prepare the query
my $sth = $dbh->prepare($sql);

#execute the query
$sth->execute();

my $dt = 'date error';
my $dte = 'date error';

#put it into an array and loop it with a while
$" = "<br>";
while (my @row = $sth->fetchrow_array( ) )  {
  push(@array, @row);


if (@array[9] ne ''){
$dt = DateTime->from_epoch(epoch => @array[9]);
$dt = $dt->ymd;

$dte = DateTime->from_epoch(epoch => @array[10]);
$dte = $dte->ymd;
};

$html2 = qq{
                  <div class="col-md-12 form-group">
                  <font size="+1"><b>Submitted by:</b></font size="+1"><br>@array[1] on $dt<br><br>
		  <font size="+1"><b>Subject:</b></font size="+1"><br>@array[2] <br><br>
		  <font size="+1"><b>Summary:</b></font size="+1"><br>@array[3] <br>
		  View <a href="https://my.ergoport.dev/cgi-bin/ergo/cast_vote.pl?a=@array[0].$a">full record</a><br><br><br>
                  </div>

};
print $html2;

@array = ();
};

$html3 = qq{
    
    

    <script src="https://my.ergoport.dev/ergo/js/jquery-3.3.1.min.js"></script>
    <script src="https://my.ergoport.dev/ergo/js/popper.min.js"></script>
    <script src="https://my.ergoport.dev/ergo/js/bootstrap.min.js"></script>
    <script src="https://my.ergoport.dev/ergo/js/jquery.validate.min.js"></script>
    <script src="https://my.ergoport.dev/ergo/js/main.js"></script>

  </body>
</html>
};
print $html3;
exit;
