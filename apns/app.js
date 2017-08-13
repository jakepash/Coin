var apn = require('apn');

// Set up apn with the APNs Auth Key
var apnProvider = new apn.Provider({  
     token: {
        key: 'apns.p8', // Path to the key p8 file
        keyId: 'C37X7ACM85', // The Key ID of the p8 file (available at https://developer.apple.com/account/ios/certificate/key)
        teamId: 'Z28CSUK723', // The Team ID of your Apple Developer Account (available at https://developer.apple.com/account/#/membership/)
    },
    production: false // Set to true if sending a notification to a production iOS app
});


// // grab the packages we need
var express = require('express');
var app = express();
var port = process.env.PORT || 8000;
var bodyParser = require('body-parser');
app.use(bodyParser.json()); // support json encoded bodies
app.use(bodyParser.urlencoded({ extended: true })); // support encoded bodies

// routes will go here

app.post('/', function(req, res) {
    var coinamount = req.body.coinamount;
    var token = req.body.token;


// Prepare a new notification
var notification = new apn.Notification();

// Specify your iOS app's Bundle ID (accessible within the project editor)
notification.topic = 'com.labbylabs.coin';

// Set expiration to 1 hour from now (in case device is offline)
notification.expiry = Math.floor(Date.now() / 1000) + 3600;

// Set app badge indicator
// notification.badge = ;

// Play ping.aiff sound when the notification is received
notification.sound = 'coinSound.aiff';

// Display the following message (the actual notification text, supports emoji)
notification.alert = 'Someone sent you ' + coinamount + ' Coins';

  	// Actually send the notification
	apnProvider.send(notification, token).then(function(result) {  
    	// Check the result for any failed devices
    	console.log(result);
	});

});
// start the server

app.listen(port);
console.log('Server started! At http://localhost:' + port);

[ 
users :[
	"adam",
	"jacob",
	"hanan"
]	
codes: [
	"2342",
	"432423",
	"4324"
]
]