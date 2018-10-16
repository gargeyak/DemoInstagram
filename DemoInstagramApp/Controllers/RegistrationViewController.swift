//
//  RegistrationViewController.swift
//  DemoInstagramApp
//
//  Created by Ady on 8/2/18.
//  Copyright © 2018 RJTCompuquest. All rights reserved.
//

import UIKit
import Firebase
import TWMessageBarManager
import FirebaseMessaging

class RegistrationViewController: UIViewController {
    
  
    //userRef = Database.database().reference().child("Users")

    
    @IBOutlet weak var firstNameRegistrationPageField: UITextField!
    @IBOutlet weak var lastNameRegistrationPageField: UITextField!
    @IBOutlet weak var emailRegistrationPageField: UITextField!
    @IBOutlet weak var phoneNumberRegistrationPageField: UITextField!
    @IBOutlet weak var passwordRegistrationPageField: UITextField!
    @IBOutlet weak var confirmPasswordRegistrationPageField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func registerRegistrationPageClicked(_ sender: UIButton) {
        
        FirebaseHandler.sharedInstance.userSignup(firstName: firstNameRegistrationPageField.text!, lastName: lastNameRegistrationPageField.text!, phoneNo: Int(phoneNumberRegistrationPageField.text!)!, email: emailRegistrationPageField.text!, password: passwordRegistrationPageField.text!) { (error) in
            if let err = error{
                TWMessageBarManager.sharedInstance().showMessage(withTitle: "SignUp Failed", description: err.localizedDescription, type: .error, duration: 4.0)
            } else{
//                DispatchQueue.main.async {
                Messaging.messaging().subscribe(toTopic: (Auth.auth().currentUser?.uid)!)
                    self.performSegue(withIdentifier: "InstagramTabBarController", sender: nil)
//                }
                TWMessageBarManager().showMessage(withTitle: "SignUp Succeeded", description: "You have successfully registered", type: .success)
            }
        }        
    }

    
  
    @IBAction func signInRegistrationPageClicked(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
