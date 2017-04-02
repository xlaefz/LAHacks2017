import Firebase
import FirebaseAuth
import GeoFire
//import CoreLocation

struct Jackie {
  var firstName = ""
  var lastName = ""
  var phoneNumber = ""
  var coordinate = CLLocationCoordinate2D()
}

class FirebaseManager {
  static let sharedInstance = FirebaseManager();
  
  let ref = FIRDatabase.database().reference()
  var circleQuery: GFCircleQuery? = nil;
  
  private init() {}
  
  func registerUser(email: String, password: String, firstName: String, lastName: String, phoneNumber: String, completion: @escaping (_ successful : Bool) -> Void) {
    FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
      if error != nil {
        print(error!)
        completion(false);
        return
      }
      
      guard let uid = user?.uid else {
        completion(false);
        return
      }
      
      let values = ["email" : email, "firstName" : firstName, "lastName" : lastName, "phoneNumber": phoneNumber]
      self.registerUserIntoDatabaseWithUID(uid, values: values as [String : AnyObject], completion: completion)
      
      completion(true);
    })
  }
  
  fileprivate func registerUserIntoDatabaseWithUID(_ uid: String, values: [String: AnyObject], completion: @escaping (_ successful : Bool) -> Void) {
    let ref = FIRDatabase.database().reference()
    let usersReference = ref.child("users").child(uid)
    
    usersReference.updateChildValues(values, withCompletionBlock: { (error, ref) in
      if error != nil {
        print(error!)
        completion(false);
        return
      }
    })
  }
  
  func signInUser(email: String, password: String, completion: @escaping (_ successful : Bool) -> Void) {
    FIRAuth.auth()?.signIn(withEmail: email, password: password) { (user, error) in
      if ((error) != nil) {
        completion(false)
      } else {
        completion(true)
      }
    }
  }
  
  func signOutUser(completion: (_ successful : Bool) -> Void) {
    let firebaseAuth = FIRAuth.auth()
    do {
      try firebaseAuth?.signOut()
    } catch let signOutError as NSError {
      print ("Error signing out: %@", signOutError)
      completion(false)
      return
    }
    completion(true)
  }
  
      func updateUserLocation(location: CLLocation, completion: (_ successful : Bool) -> Void) {
        let geoFire = GeoFire(firebaseRef: ref.child("users_location"))
  
        let userID = FIRAuth.auth()?.currentUser!.uid
        geoFire!.setLocation(location, forKey: userID) { (error) in
            if (error != nil) {
                debugPrint("An error occured in updateUserLocation in SetLocation: \(error)")
            } else {
                print("Saved location successfully!")

                //Update circleQuery
//                if circleQuery != nil {
//                    circleQuery.center = location
//                }
            }
        }
      }
  //
  //
  //    //Needs better closure, how would the app run
  //    //Create 2 closures for key enter and key exit handling
  //    //One for initial nearby users
  //    //Only find those requesting
      func findNearbyUsers(location: CLLocation, completion: @escaping (_ completionUsers : [Jackie]) -> Void) {
            let geoFire = GeoFire(firebaseRef: ref.child("users_location"))
        
            circleQuery = geoFire!.query(at: location, withRadius: 0.2)
        
            var nearbyUsers = [String]();
        
            _ = circleQuery!.observe(.keyEntered, with: { (key, location) in
                if !nearbyUsers.contains(key!) && key! != FIRAuth.auth()!.currentUser!.uid {
                    nearbyUsers.append(key!)
                    if (nearbyUsers.count >= 10) {
                      self.usersToJackies(users: nearbyUsers, completion: completion)
                      return;
                    }
                }
            })
  
            circleQuery?.observeReady({
                for user in nearbyUsers {
                    self.ref.child("users/\(user)").observe(.value, with: { snapshot in
                        let value = snapshot as? NSDictionary
                        print(value)
                    })
                }
                self.usersToJackies(users: nearbyUsers, completion: completion)
                return
            })

            //Handle key enter and key exit events with closures
            var keyEnteredQueryHandle = circleQuery!.observe(.keyEntered, with: { (key: String!, location: CLLocation!) in
              print("Key '\(key)' entered the search area and is at location '\(location)'")
            })
  
            var keyExitedQueryHandle = circleQuery!.observe(.keyExited, with: { (key: String!, location: CLLocation!) in
              print("Key '\(key)' exited the search area and is at location '\(location)'")
            })
    }
  
  func usersToJackies(users: [String], completion: @escaping (_ completionUsers: [Jackie]) -> Void) -> Void {
    
    let geoFire = GeoFire(firebaseRef: ref.child("users_location"))
    var jackies = [Jackie]();
    let myGroup = DispatchGroup();
    
    for user in users {
      myGroup.enter()
      geoFire?.getLocationForKey(user, withCallback: { (location, error) in
        if (error == nil) {
          self.ref.child("users").child(user).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            var jackie = Jackie()
            jackie.coordinate = location!.coordinate
            let value = snapshot.value as? NSDictionary
            jackie.firstName = value?["firstName"] as? String ?? ""
            jackie.lastName = value?["lastName"] as? String ?? ""
            jackie.phoneNumber = value?["phoneNumber"] as? String ?? ""
            jackies.append(jackie)
            myGroup.leave()
          }) { (error) in
            print(error.localizedDescription)
            myGroup.leave()
          }
        }
      })
    }
    
    myGroup.notify(queue: .main){
      completion(jackies);
    }
  }
  
  
  //    func request(requesting, productType) {
  //      //Change current user state to requesting
  //      //Change productType to correct type
  //    }
  //
  //    func respond(userRequesting) {
  //      //Change currentUser to Delivery
  //      //Change userRequesting to WaitingForDelivery
  //    }
  
}
