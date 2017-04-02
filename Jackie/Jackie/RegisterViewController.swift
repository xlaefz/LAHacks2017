//
//  RegisterViewController.swift
//  Jackie
//
//  Created by Yuna Lee on 4/1/17.
//  Copyright © 2017 Jackie. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {

  @IBOutlet weak var firstNameTF: UITextField!
  @IBOutlet weak var lastNameTF: UITextField!
  @IBOutlet weak var phoneNumberTF: UITextField!
  @IBOutlet weak var emailTF: UITextField!
  @IBOutlet weak var passwordTF: UITextField!
  @IBOutlet weak var confirmPasswordTF: UITextField!
  
    override func viewDidLoad() {
        super.viewDidLoad()
      
      
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
  @IBAction func signUpButtonPress(_ sender: Any) {
    if (passwordTF.text == confirmPasswordTF.text) {
      FirebaseManager.sharedInstance.registerUser(email: emailTF.text!, password: passwordTF.text!, firstName: firstNameTF.text!, lastName: lastNameTF.text!, phoneNumber: phoneNumberTF.text!) { (successful) in
        if (successful) {
          self.performSegue(withIdentifier: "signUpSegue", sender: self)
        } else {
          self.showAlert("Sign up invalid")
        }
      }
    } else {
        showAlert("Passwords are not the same")
    }
  }

  func showAlert(_ message: String) {
    let alertController = UIAlertController(title: "Sign Up", message: message, preferredStyle: UIAlertControllerStyle.alert)
    alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
    self.present(alertController, animated: true, completion: nil)
  }
  
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
