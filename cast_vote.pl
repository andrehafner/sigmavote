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

#split incoming vars
my @a_array = split/\./,$a;


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
              <h3 class="thin-heading mb-4">Sigmanaut <br>-Cast Vote</h3>
              <p><a href="https://my.ergoport.dev/cgi-bin/ergo/new_user.pl">New User</a>
<a href="https://my.ergoport.dev/cgi-bin/ergo/edit_user.pl/">Edit User</a> <br>
<a href="https://my.ergoport.dev/cgi-bin/ergo/create_vote.pl?a=$a_array[1]/">Create Vote</a>
<a href="https://my.ergoport.dev/cgi-bin/ergo/list_votes.pl?a=$a_array[1]">List Votes</a><br></p>
            </div>
            <div class="col-md-6 ml-auto">
              <h3 class="thin-heading mb-4">ERGO <br>Community Links</h3>
              <p>Discord <br> Telegram</p>
            </div>
          </div>

          <div class="row justify-content-center">
            <div class="col-md-12">
              <p>Please click yes, no, or abstain to cast your vote. If there is an important detail that should be known about why you are voting the way you have chosen, please fill out below.<br><br><br></p>
              <form class="mb-5" method="post"  ACTION="/cgi-bin/ergo/process_cast_vote.pl"  enctype="multipart/form-data">
		<form ACTION="/cgi-bin/ergo/process_cast_vote.pl" METHOD="post" enctype="multipart/form-data">
		
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


my $clear_results = '';

#getting all info from the employee that matches the company wallet
$sql_anon = "select anon_id from userdata where username='$a_array[1]';";

#prepare the query
my $sth_anon = $dbh->prepare($sql_anon);

#execute the query
$sth_anon->execute();

#put it into an array and loop it with a while
$" = "<br>";
while (my @row_anon = $sth_anon->fetchrow_array( ) )  {
  push(@array_anon, @row_anon);}





#getting all info from the employee that matches the company wallet
$sql = "select * from votedata where id='$a_array[0]';";

#prepare the query
my $sth = $dbh->prepare($sql);

#execute the query
$sth->execute();

my $dt = 'date error';
my $dte = 'date error';
my $t_yes = ();
my $t_no = ();
my $t_abstain = ();
my $already_voted = "type\=\"submit\"";
my $already_voted_notify = ();
my $counted_results = ();
my $total_votes = ();
my $final_result = "";

#put it into an array and loop it with a while
$" = "<br>";
while (my @row = $sth->fetchrow_array( ) )  {
  push(@array, @row);}

$already_voted = "type\=\"submit\"";

if ($array[5] =~ m/$a_array[1]\,/s && $a_array[1] ne ''){
$already_voted = "type\=\"hidden\"";
$already_voted_notify = "You've already voted!";
}

if ($array[6] =~ m/$a_array[1]\,/s && $a_array[1] ne ''){
$already_voted = "type\=\"hidden\"";
$already_voted_notify = "You've already voted!";
}

if ($array[7] =~ m/$a_array[1]\,/s && $a_array[1] ne ''){
$already_voted = "type\=\"hidden\"";
$already_voted_notify = "You've already voted!";
}


if ($array[5] =~ m/$array_anon[0]\,/s && $array_anon[0] ne ''){
$already_voted = "type\=\"hidden\"";
$already_voted_notify = "You've already voted!";
}

if ($array[6] =~ m/$array_anon[0]\,/s && $array_anon[0] ne ''){
$already_voted = "type\=\"hidden\"";
$already_voted_notify = "You've already voted!";
}

if ($array[7] =~ m/$array_anon[0]\,/s && $array_anon[0] ne ''){
$already_voted = "type\=\"hidden\"";
$already_voted_notify = "You've already voted!";
}

if ($array[8] =~ m/no/s){
$already_voted = "type\=\"hidden\"";
$already_voted_notify = "You can't vote on archived votes!";
}


#lets tally because im just keeping track of userid's that vote not the actual count
$t_yes = $array[5] =~ tr/,//;
$t_no = $array[6] =~ tr/,//;
$t_abstain = $array[7] =~ tr/,//;

$total_votes = $t_yes + $t_no + $t_abstain;

#$counted_votes = "Yes:$t_yes No:$t_no Abstain:$t_abstain - Total Voted: $total_votes";
$counted_votes = "Total Voted:$total_votes";

if ($total_votes > '9' && $t_yes > $t_no && $t_yes > $t_abstain && @array[8] eq "no"){
$clear_results = "Yes:$t_yes - No:$t_no - Abstain:$t_abstain - ";
$final_result = " ----- VOTE HAS PASSED!";
}

if (@array[8] eq "no"){
$final_result = " ----- VOTE HAS FAILED";
$clear_results = "Yes:$t_yes - No:$t_no - Abstain:$t_abstain - ";
}


if (@array[9] ne ''){
$dt = DateTime->from_epoch(epoch => @array[9]);
$dt = $dt->ymd;

$dte = DateTime->from_epoch(epoch => @array[10]);
$dte = $dte->ymd;
};

$html2 = qq{
                  <div class="col-md-12 form-group">
                  <font size="+1" style="color:#ff6a00"><b>Submitted by:</b></font size="+1"><br>@array[1]<br><br>
		  <font size="+1" style="color:#ff6a00"><b>Subject:</b></font size="+1"><br>@array[2] <br><br>
		  <font size="+1" style="color:#ff6a00"><b>Summary:</b></font size="+1"><br>@array[3] <br><br>
                  <font size="+1" style="color:#ff6a00"><b>Body:</b></font size="+1"><br>@array[4]<br><br><br><br><br>
                  <font size="+1" style="color:#ff6a00"><b>Reason:</b></font size="+1"><br>@array[12]<br><br>
                  <font size="+1" style="color:#ff6a00"><b>Created:</b></font size="+1"><br>@array[9] - $dt<br><br>
                  <font size="+1" style="color:#ff6a00"><b>Ends:</b></font size="+1"><br>@array[10] - $dte<br><br>
                  <font size="+1" style="color:#ff6a00"><b>Currently Active?:</b></font size="+1"><br>@array[8]<br><br>
                  <font size="+1" style="color:#ff6a00"><b>Result:</b></font size="+1"><br>$clear_results $counted_votes $final_result<br><br>
                  </div>


                  <div class="col-md-12 form-group">
                    <input type="text" class="form-control" name="reason" id="reason" maxlength="200" placeholder="please input reason if warranted">
                  </div>

                  <div class="col-md-6 form-group"><br>
                    <input type="text" class="form-control" name="username" id="username" placeholder="username">
                  </div>
                  <div class="col-md-6 form-group"><br>
                    <input type="password" class="form-control" name="password" id="password" placeholder="password">
                  </div>

                  <div class="col-md-12 form-group">
                    <input type="hidden" class="form-control" name="id" id="id" value="@array[0]">
                  </div>

                  <div class="col-md-12 form-group">
		    <input type="checkbox" id="anon" name="anon" value="anon">
		    <label for="anon">Make my vote anonymous</label>
                  </div>

                <div class="row">
                  <div class="col-12"> 
		    <input $already_voted value="yes" name="submit" id="yes" class="btn btn-primary rounded-0 py-2 px-4">
                    <input $already_voted value="no" name="submit" id="no" class="btn btn-primary rounded-0 py-2 px-4">
                    <input $already_voted value="abstain" name="submit" id="abstain" class="btn btn-primary rounded-0 py-2 px-4">
		    <span class="submitting"></span>
                  </div>


		  <div class="col-md-12 form-group">
   		  <font size="+2"><br>$already_voted_notify 
		  </div>

};
print $html2;

$already_voted_notify = ();
$already_voted = ();
@array = ();


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



#                  <font size="+1" style="color:#ff6a00"><b>Yes (total = $t_yes):</b></font size="+1"><br>@array[5]<br><br>
#                  <font size="+1" style="color:#ff6a00"><b>No (total = $t_no):</b></font size="+1"><br>@array[6]<br><br>
#                  <font size="+1" style="color:#ff6a00"><b>Abstain (total = $t_abstain):</b></font size="+1"><br>@array[7]<br><br>
