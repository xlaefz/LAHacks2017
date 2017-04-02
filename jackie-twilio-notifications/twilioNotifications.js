var twilioClient = require('./twilioClient');
var fs = require('fs');

function formatMessage(userFirstName) {
  return 'Hi ' + userFirstName + '! ' +
      'A fellow Jackie is in need nearby! ' +
      'Open the app if you can help! ' +
      'If you want to mute notifications, click http://bit.ly/2nNrlZu ' +
      'Thanks and have a wonderful day!';
};

exports.sendAll = function(users) {
  console.log(users);
  var keys = Object.keys(users);
  for(var i=0; i<keys.length; i++) {
    var userPhoneNumber = keys[i];
    var userFirstName = users[keys[i]];
    var messageToSend = formatMessage(userFirstName);
    
    twilioClient.sendSms(userPhoneNumber, messageToSend);
  }
};