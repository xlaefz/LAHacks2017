import Firebase

class FirebaseManager {
    static let sharedInstance = FirebaseManager();
	
	static let ref = FIRDatabase.database().reference()
    static let circleQuery = nil;

    private init() {}

    func registerUser(email: String, password: String, firstName: String, lastName: String, phoneNumber: String, completion: (_ successful : Bool) -> Void) {
   		FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user: FIRUser?, error: AnyObject) in
   			if error != nil {
   				print(error)
   				completion(successful: false);
   				return
   			}

   			guard let uid = user?.uid else {
   				completion(successful: false);
   				return
   			}

   			let values = ["email" : email, "firstName" : firstName, "lastName" : lastName, "phoneNumber": phoneNumber]
   			self.registerUserIntoDatabaseWithUID(uid, values: values as [String : AnyObject], completion)

   			completion(successful, true);
   		})
    }

    fileprivate func registerUserIntoDatabaseWithUID(_ uid: String, values: [String: AnyObject], completion: (_ successful : Bool) -> Void) {
    	let usersReference = ref.child("users").child(uid)

    	usersReference.updateChildValues(values, withHCompletionBlock: { (err, ref) in 
    		if err != nil {
    			print(error)
   				completion(successful: false);
    			return
    		}

    		let user = User()

            //this setter potentially crashes if keys don't match
    		user.setValuesForKeys(values)
		})
    }

    func signInUser(email: String, password: String, completion: (_ successful : Bool) -> Void) {
    	FIRAuth.auth()?.signIn(withEmail: email, password: password) { (user, error) in
    		if (error) {
    			completion(successful: false)
			} else {
    			completion(successful: true)
			}
    	}
    }

    func signOutUser(completion: (_ successful : Bool) -> Void) {
	    let firebaseAuth = FIRAuth.auth()
		do {
		    try firebaseAuth?.signOut()
		} catch let signOutError as NSError {
		    print ("Error signing out: %@", signOutError)
	        completion(successful: false)
		    return
		}
		completion(successful: true)
    }

    func updateUserLocation(location: CLLocation, completion: (_ successful : Bool) -> Void) {
    	let geoFire = GeoFire(firebaseRef: ref.child("users_location"))

    	if let myLocation = location {

    		let userID = FIRAuth.auth()!.createUser!.uid
    		geoFire!.setLocation(myLocation, forKey: userID) { (error) in
    			if (error != nil) {
    				debugPrint("An error occured in updateUserLocation in SetLocation: \(error)")
    			} else {
    				print("Saved location successfully!")
			    	
			    	//Update circleQuery
			    	if circleQuery != nil {
			    		circleQuery.center = myLocation
			    	}
    			}
    		}
    	}

    }


    //Needs better closure, how would the app run
    //Create 2 closures for key enter and key exit handling
    //One for initial nearby users
    //Only find those requesting
    func findNearbyUsers(location: CLLocation, completion: (_ successful : Bool) -> Void) {
    	if let myLocation = location {
	    	let geoFire = GeoFire(firebaseRef: ref.child("users_location"))
	    	let circleQuery = geoFire!.query(at: location, withRadius: 0.2)

	    	_ = circleQuery!.observe(.keyEntered, with: { (key, location) in
	    		if !self.nearbyUsers.contains(key!) && key! != FIRAuth.auth()!.currentUser!.uid {
	    			self.nearbyUsers.append(key!)
	    		}
    		})

	    	circleQuery?.observeReady({
	    		for user in self.nearbyUsers {
		    		self.ref.child("users/\(user)").observe(.value, with: { snapshot in 
		    			let value = snapshot as? NSDictionary
		    			print(value)
		    		})	
	    		}
    		})

	    	//Handle key enter and key exit events with closures
    		var keyEnteredQueryHandle = circleQuery.observeEventType(.KeyEntered, withBlock: { (key: String!, location: CLLocation!) in
			  println("Key '\(key)' entered the search area and is at location '\(location)'")
			})

    		var keyExitedQueryHandle = circleQuery.observeEventType(.KeyExited, withBlock: { (key: String!, location: CLLocation!) in
			  println("Key '\(key)' exited the search area and is at location '\(location)'")
			})
    	}
    }

//    func request(requesting, productType) {
//    	//Change current user state to requesting
//    	//Change productType to correct type
//    }
//
//    func respond(userRequesting) {
//    	//Change currentUser to Delivery
//    	//Change userRequesting to WaitingForDelivery
//    }

}
