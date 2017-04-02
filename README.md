# Jackie- Emergency Feminine Hygiene Product Delivery 

Jackie provides a community-based delivery service for emergency feminine hygiene products. 
This mobile app aims to create a community of women (colloquially named "Jackies") that help each other out when they need it the most.

## Inspiration

The app serves to match people who direly need a disposable feminine hygiene product to nearby users who happen to carry extra. Jackie
creates an interface for women to request for a product, and ask other app users if they can deliver it to a nearby location. At the 
click of a button, a user can send a request to nearby users to see if they have extras pads to offer. Other Jackies can then see the 
request in the app, and, if they have the resources and time, offer to deliver it.


## What it does

The app serves to match people who direly need a disposable feminine hygiene product to nearby users who happen to carry extra. Jackie 
creates an interface for women to request for a product, and ask other app users if they can deliver it to a nearby location.
At the click of a button, a user can send a request to nearby users to see if they have extras pads to offer. Other Jackies can then see the request 
in the app, and, if they have the resources and time, offer to deliver it. 

## How we built it

We wrote our iOS application in Swift 3. Using [Firebase](https://firebase.google.com) as our backend service, we also used [Geofire](https://firebase.google.com/?utm_source=geofire-objc) as a lightweight
framework to find other nearby users. We use the [Google Maps API](https://developers.google.com/maps/) to get the users location, and stores it in the realtime
Firebase database. Lastly, we host a [Twilio](https://www.twilio.com) server using Node and Express for sending text messages, as a temporary alternative and potential 
supplement to push notifications.

## Challenges we ran into

We had a difficult time getting all the external libraries integrated into our project, since it was our first time using many of them. Debugging linker issues and handling storyboard conflicts with the application probably took more time than we would have hoped. Lastly, handling app to app communication was difficult at first, since we did not have access to the regular Apple Push Notification service and did not want to host a general server due to scalability reasons.

## What's next?

Additional features such as privacy, push notifications, rating systems, and potentially tipping for Jackie deliverers. 

##Team

[Alex Hong](mailto:hongalex@usc.edu)
[Yuna Lee](mailto:yunalee@usc.edu)
[Kevin Wu](mailto:kwu135@usc.edu)
[Jason Zheng](mailto:jasonzhe@usc.edu)