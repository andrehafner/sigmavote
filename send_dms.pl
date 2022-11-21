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




my $epoc = time();
my $epoc_3_5_days = $epoc + '302400';
my $epoc_7_days = $epoc + '604800';
my $epoc_difference = ();

#print $epoc;
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


my $pyfile = ();
my $send = ();
my $result = ();
my $twitter_path = "/usr/lib/cgi-bin/ergo/twitter.py";
my $discord_path = "/usr/lib/cgi-bin/ergo/dbot.py";
my $discord_path_ergo = "/usr/lib/cgi-bin/ergo/webhook_ergo_vote.py";
my $reminder_number = 'VOTE';
my $sig_or_erg = "sig";
my $already_voted = ();


#wite the form data back to the database
my $sql = "select id, subject, start_date, initial_dm, halfway_dm, final_dm, sig, erg, reason, yes, no, abstain, summary from votedata where active_status='yes';";


#prepare the query
my $sth = $dbh->prepare($sql);

#execute the query
$sth->execute();

#put it into an array
$" = "<br>";
while (my @row = $sth->fetchrow_array( ) )  {
  push(@array, @row);


$epoc_difference = $epoc - $array[2];
print "########$epoc_difference#########";

#labeling the vote type
if ($array[3] ne 'yes' && $array[4] ne 'yes' && $array[5] ne 'yes' && $epoc_difference<302400){ 
$reminder_number = "NEW VOTE";
}

if ($array[3] eq 'yes' && $array[4] ne 'yes' && $array[5] ne 'yes' && $epoc_difference>302400 && $epoc_difference<604800){
$reminder_number = "REMINDER VOTE";
}

if ($array[3] eq 'yes' && $array[4] eq 'yes' && $array[5] ne 'yes' && $epoc_difference>604800){
$reminder_number = "LAST REMINDER";
}

if ($array[3] eq 'yes' && $array[4] eq 'yes' && $array[5] eq 'yes' && $epoc_difference>691200){
$reminder_number = "VOTE CLOSED";
}
print  "########$reminder_number#########";

#figuring out if its a erg only vote
if ($array[7] eq 'yes' && $array[6] ne 'yes'){
$sig_or_erg = 'erg';
}



#lets build a query to get the users based on the data we gathered above
$sql_user = "select username, twitter, discord, telegram from userdata";

#prepare the query
my $sth_user = $dbh->prepare($sql_user);

#execute the query
$sth_user->execute();

#put it into an array
$" = "<br>";
while (my @row_user = $sth_user->fetchrow_array( ) )  {
  push(@array_user, @row_user);


if ($array[9] =~ m/$array_user[0]\,/){
$already_voted = 'yes';
}

if ($array[10] =~ m/$array_user[0]\,/){
$already_voted = 'yes';
}

if ($array[11] =~ m/$array_user[0]\,/){
$already_voted = 'yes';
}


#let's notify people


#TWITTER DM
#if (@array_user[1] ne '' && $already_voted ne 'yes'){
#set command, dir, filename for system call
#$pyfile = "python3 $twitter_path $array_user[1] \'$reminder_number $array[1] - https://my.ergoport.dev/cgi-bin/ergo/cast_vote.pl?a=$array[0]\'";

#system call to run python script
#$send = qx($pyfile);
#};



#DISCORD DM
if (@array_user[2] ne '' && $already_voted ne 'yes' && $reminder_number ne 'VOTE'){
#set command, dir, filename for system call
$pyfile = "python3 $discord_path $array_user[2] \'$reminder_number $array[1] - https://my.ergoport.dev/cgi-bin/ergo/cast_vote.pl?a=$array[0].$array_user[0]\'";

#system call to run python script
$send = qx($pyfile);
};


#TELEGRAM DM
if (@array_user[3] ne '' && $already_voted ne 'yes' && $reminder_number ne 'VOTE'){
$result = eval { $api->getMe }
    or die 'Got error message: ', $api->parse_error->{msg};
$api->sendMessage ({
    chat_id => "$array_user[3]",
    text    => "$reminder_number $array[1] - https://my.ergoport.dev/cgi-bin/ergo/cast_vote.pl?a=$array[0].$array_user[0]"
}, sub {
    my ($ua, $tx) = @_;
    die 'Something bad happened!' if $tx->error;
    say $tx->res->json->{ok} ? 'YAY!' : ':('; # Not production ready!
});
}



$already_voted = ();
@array_user = ();
#end of user loop
}



if ($array[3] ne 'yes' && $array[4] ne 'yes' && $array[5] ne 'yes' && $epoc_difference<302400 && $reminder_number ne 'VOTE'){
$sql_update_status = "update votedata set initial_dm='yes' where id='$array[0]';";
$pyfile2 = "python3 $discord_path_ergo \'NEW VOTE\' \'https://my.ergoport.dev/cgi-bin/ergo/cast_vote.pl?a=$array[0]\' \'$array[1]\'";
$send = qx($pyfile2);
}

#marking the vote as done
if ($array[3] eq 'yes' && $array[4] ne 'yes' && $array[5] ne 'yes' && $epoc_difference>302400 && $epoc_difference<604800 && $reminder_number ne 'VOTE'){
$sql_update_status = "update votedata set halfway_dm='yes' where id='$array[0]';";
$pyfile2 = "python3 $discord_path_ergo \'REMINDER VOTE\' \'https://my.ergoport.dev/cgi-bin/ergo/cast_vote.pl?a=$array[0]\' \'$array[1]\'";
$send = qx($pyfile2);
}

#marking the vote as done
if ($array[3] eq 'yes' && $array[4] eq 'yes' && $array[5] ne 'yes' && $epoc_difference>604800 && $reminder_number ne 'VOTE'){
$sql_update_status = "update votedata set final_dm='yes' where id='$array[0]';";
$pyfile2 = "python3 $discord_path_ergo \'LAST REMINDER\' \'https://my.ergoport.dev/cgi-bin/ergo/cast_vote.pl?a=$array[0]\' \'$array[1]\'";
$send = qx($pyfile2);
}

#marking the vote as done
if ($array[3] eq 'yes' && $array[4] eq 'yes' && $array[5] eq 'yes' && $epoc_difference>691200 && $reminder_number ne 'VOTE'){
$sql_update_status = "update votedata set active_status='no' where id='$array[0]';";
$pyfile2 = "python3 $discord_path_ergo \'VOTE CLOSED\' \'https://my.ergoport.dev/cgi-bin/ergo/cast_vote.pl?a=$array[0]\' \'$array[1]\'";
$send = qx($pyfile2);
}


#prepare the query
my $sth_update_status = $dbh->prepare($sql_update_status);

#execute the query
$sth_update_status->execute();

@array = ();
$reminder_number = 'VOTE';
#final end of main loop
} 






exit;

