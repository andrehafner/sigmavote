#!/usr/bin/perl

use warnings;
use CGI;
use DBI;
use Number::Format 'format_number';
use List::Util qw/sum/;
use File::Copy;
use File::Path;

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
              <h3 class="thin-heading mb-4">Sigmanaut <br>-Voting</h3>
              <p>Welcome! <br> sigmavote</p>            </div>
            <div class="col-md-6 ml-auto">
              <h3 class="thin-heading mb-4">ERGO <br>Community Links</h3>
              <p>Discord <br> Telegram</p>
            </div>
          </div>

          <div class="row justify-content-center">
            <div class="col-md-12">
              

              <form class="mb-5" method="post"  ACTION="/cgi-bin/ergo/process_new_user.pl"  enctype="multipart/form-data">
		<form ACTION="/cgi-bin/ergo/process_new_user.pl" METHOD="post" enctype="multipart/form-data">
		
                <div class="row">
                  <div class="col-md-6 form-group">
                    <input type="text" class="form-control" name="username" id="username" placeholder="username">
                  </div>
                  <div class="col-md-6 form-group">
                    <input type="password" class="form-control" name="password" id="password" placeholder="password">
                  </div>
                  <div class="col-md-6 form-group">
                    <input type="password" class="form-control" hidden name="passwordh" id="passwordh" placeholder="password h">
                  </div>
                  <div class="col-md-6 form-group">
                    <input type="password" class="form-control" name="password3" id="password3" placeholder="password confirm">
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
