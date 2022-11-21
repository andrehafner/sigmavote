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
$email = $query->param("email");

#this is for testing so I can see outputs in the browser
#$|=1;            # Flush immediately.
#print "Content-Type: text/plain\n\n";

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

#prep mysql statment to write data as a new user entry into mysql table
$sql = "select id, twitter, discord, telegram, email from userdata where username='$username' and password=MD5('$password');";

#prepare the query
$sth = $dbh->prepare($sql);

#execute the query
$sth->execute();

#put it into an array and loop it with a while
$" = "<br>";
while (my @row = $sth->fetchrow_array( ) )  {
  push(@array, @row);

};


if ($array[0] eq ''){

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
              <h3 class="thin-heading mb-4">Sigmanaut <br>-Edit User</h3>
              <p><a href="https://my.ergoport.dev/cgi-bin/ergo/new_user.pl">New User</a>
            </div>
            <div class="col-md-6 ml-auto">
              <h3 class="thin-heading mb-4">ERGO <br>Community Links</h3>
              <p>Discord <br> Telegram</p>
            </div>
          </div>

          <div class="row justify-content-center">
            <div class="col-md-12">
              <p>Please log in to view and change your data!<br><br></p>

              <form class="mb-5" method="post"  ACTION="/cgi-bin/ergo/edit_user.pl"  enctype="multipart/form-data">
                <form ACTION="/cgi-bin/ergo/edit_user.pl" METHOD="post" enctype="multipart/form-data">

                <div class="row">


                  <div class="col-md-6 form-group"><br>
                    <input type="text" class="form-control" name="username" id="username" placeholder="username">
                  </div>
                  <div class="col-md-6 form-group"><br>
                    <input type="password" class="form-control" name="password" id="password" placeholder="password">
                  </div>



              </div>
                <div class="row">
                  <div class="col-12"> <br>
                    <input type="submit" value="Submit" class="btn btn-primary rounded-0 py-2 px-4">
                  <span class="submitting"></span>
                  </div>
                </div>
              </form>

              <div id="form-message-warning mt-4"></div>
              <div id="form-message-success">
                Your message was sent, thank you!
              </div>

            </div>
          </div>
        </div>
      </div>
    </div>

  </div>



    <script src="https://my.ergoport.dev/ergo/js/jquery-3.3.1.min.js"></script>
    <script src="https://my.ergoport.dev/ergo/js/popper.min.js"></script>
    <script src="https://my.ergoport.dev/ergo/js/bootstrap.min.js"></script>
    <script src="https://my.ergoport.dev/ergo/js/jquery.validate.min.js"></script>
    <script src="https://my.ergoport.dev/ergo/js/main.js"></script>

  </body>
</html>
};

print $html;
exit;

}

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
              <h3 class="thin-heading mb-4">Sigmanaut <br>-Edit User</h3>
              <p><a href="https://my.ergoport.dev/cgi-bin/ergo/new_user.pl">New User</a>
            </div>
            <div class="col-md-6 ml-auto">
              <h3 class="thin-heading mb-4">ERGO <br>Community Links $array[3]</h3>
              <p>Discord <br> Telegram</p>
            </div>
          </div>

          <div class="row justify-content-center">
            <div class="col-md-12">
              <p>Please fill in an id to be notified at that service! <br><br>You can look up your numeric ID's fairly quickly with tips from google.
<br>Leaving a field blank will clear the data on submit!<br>I will display these when a new password system is in place.<br><br>

To find your discord id message my bot \@my.ergoport (my.ergoport\#6220) with the words: <br>ep userid <br><br>

To find you telegram id message <a href="https://t.me/ergoportbot">my bot</a> with the words: <br>/ep userid <br><br>

</p>

              <form class="mb-5" method="post"  ACTION="/cgi-bin/ergo/process_edit_user.pl"  enctype="multipart/form-data">
		<form ACTION="/cgi-bin/ergo/process_edit_user.pl" METHOD="post" enctype="multipart/form-data">
		
                <div class="row">

                  <div class="col-md-6 form-group">
                    <input type="text" class="form-control" name="twitter" id="twitter" value="$array[1]" placeholder="twitter (NOT READY YET)">
                  </div>
                  <div class="col-md-6 form-group">
                    <input type="text" class="form-control" name="discord" id="discord" value="$array[2]" placeholder="discord NUMERIC id">
                  </div>
                  <div class="col-md-6 form-group">
                    <input type="text" class="form-control" name="telegram" id="telegram" value="$array[3]"  placeholder="telegram NUMERIC id">
                  </div>
                  <div class="col-md-6 form-group">
                    <input type="text" class="form-control" name="snail" id="snail" value="$array[4]" placeholder="email address (NOT READY YET)">
                  </div>

                  <div class="col-md-6 form-group"><br>
                    <input type="text" class="form-control" name="username" id="username" placeholder="username">
                  </div>
                  <div class="col-md-6 form-group"><br>
                    <input type="password" class="form-control" name="password" id="password" placeholder="password">
                  </div>


   
              </div>  
                <div class="row">
                  <div class="col-12"> <br>
                    <input type="submit" value="Submit" class="btn btn-primary rounded-0 py-2 px-4">
                  <span class="submitting"></span>
                  </div>
                </div>
              </form>

              <div id="form-message-warning mt-4"></div> 
              <div id="form-message-success">
                Your message was sent, thank you!
              </div>

            </div>
          </div>
        </div>
      </div>
    </div>

  </div>
    
    

    <script src="https://my.ergoport.dev/ergo/js/jquery-3.3.1.min.js"></script>
    <script src="https://my.ergoport.dev/ergo/js/popper.min.js"></script>
    <script src="https://my.ergoport.dev/ergo/js/bootstrap.min.js"></script>
    <script src="https://my.ergoport.dev/ergo/js/jquery.validate.min.js"></script>
    <script src="https://my.ergoport.dev/ergo/js/main.js"></script>

  </body>
</html>
};

print $html;
exit;
