use WWW::Telegram::BotAPI;

my $api = WWW::Telegram::BotAPI->new (token => 'telegramtokenhere');

# The API methods die when an error occurs.
#say $api->getMe->{result}{username};
# ... but error handling is available as well.

my $result = eval { $api->getMe }
    or die 'Got error message: ', $api->parse_error->{msg};



$api->sendMessage ({
    chat_id => chatidhere,
    text    => 'Hello world!'
}, sub {
    my ($ua, $tx) = @_;
    die 'Something bad happened!' if $tx->error;
    say $tx->res->json->{ok} ? 'YAY!' : ':('; # Not production ready!
});





# Uploading files is easier than ever.
#$api->sendPhoto ({
#    chat_id => -1001633274824,
#     chat_id => dadreboi,
#    photo   => {
#        file => '/var/www/51.81.84.167/Vote_Middle.png'
#    },
#    caption => 'Look at my cool photo!'
#});
# Complex objects are as easy as writing a Perl object.
#$api->sendMessage ({
#    chat_id      => -1001633274824,
#    # Object: ReplyKeyboardMarkup
#    reply_markup => {
#        resize_keyboard => \1, # \1 = true when JSONified, \0 = false
#        keyboard => [
#            # Keyboard: row 1
#            [
#                # Keyboard: button 1
#                'Hello world!',
#                # Keyboard: button 2
#                {
#                    text => 'Give me your phone number!',
#                    request_contact => \1
#                }
#            ]
#        ]
#    }
#});
