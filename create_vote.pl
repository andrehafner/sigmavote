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
              <h3 class="thin-heading mb-4">Sigmanaut <br>-Create Vote</h3>
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
              <p>Please follow the suggested format. Remember, take your time and be clear with your intentions, the more clear the message, the more apt members will be to respond. <br><br></p>
	   <p>Once submitted, your vote will be pushed to all users via their requested method of notificaiton. Your vote will be closed after 7 days.
	   <p><br><br>Your vote can not be edited once submitted and can not be deleted. This is intentional!<br><br><br></p>
              <form class="mb-5" method="post"  ACTION="/cgi-bin/ergo/insert_vote.pl"  enctype="multipart/form-data">
		<form ACTION="/cgi-bin/ergo/insert_vote.pl" METHOD="post" enctype="multipart/form-data">
		
                <div class="row">

                  <div class="col-md-12 form-group">
                    <input type="text" class="form-control" name="subject" id="subject" maxlength="300" placeholder="subject">
                  </div>
                  <div class="col-md-12 form-group">
                    <textarea class="form-control" name="summary" wrap="hard" id="summary" cols="30" rows="2" maxlength="1000" placeholder="give a short one sentence summary"></textarea>
                  </div>
                  <div class="col-md-12 form-group">
                    <textarea class="form-control" name="body" id="body" cols="30" rows="5" maxlength="5000" placeholder="full description"></textarea>
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
