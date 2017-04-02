# Jackie Notifications Twilio, Node.js, and Express

Use Twilio to send SMS alerts to potential donators 

You will also need to [sign up for a Twilio account](https://www.twilio.com/try-twilio) if you don't have one already.

### Install Dependencies

Navigate to the project directory in your terminal and run:

```bash
npm install
```

This should install all of our project dependencies from npm into a local 
`node_modules` folder.

### Configuration

Next, open `.env.example` at the root of the project and update it with
values from your
[Twilio account](https://www.twilio.com/user/account/voice-messaging)
and local configuration. Save the file as `.env`.  You'll need to set
`TWILIO_AUTH_TOKEN`, `TWILIO_ACCOUNT_SID`, and `TWILIO_NUMBER`.

For the `TWILIO_NUMBER` variable you'll need to provision a new number
in the
[Manage Numbers page](https://www.twilio.com/user/account/phone-numbers/incoming)
under your account. The phone number should be in
[E.164 format](https://www.twilio.com/help/faq/phone-numbers/how-do-i-format-phone-numbers-to-work-internationally).

### Running the Project

To launch the application, you can use `node .` in the project's root directory. 

To send notifications, connect to the endpoint at http://SERVER_IP:3000/request, make a x-www-form-urlencoded POST request, with parameters specified as PHONE_NUMBER = NAME_OF_USER. The telephone format must be a 11-digit number starting with +1, followed by 1 digit country code, 3 digit area code, and 7 digit phone number. As an example, ```+12345678910```

Modified from the [Twilio example repo](https://github.com/TwilioDevEd/server-notifications-node) 