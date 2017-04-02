var twilioNotifications = require('../twilioNotifications');
var path = require('path');

// Map routes to controller functions
module.exports = function(router) {
  router.post('/request', function(req, resp) {

    twilioNotifications.sendAll(req.body);
    console.log("Got to page request");
    resp.status(200);
    resp.sendFile(path.join(__dirname, '../public', 'request.html'));
  });
};
