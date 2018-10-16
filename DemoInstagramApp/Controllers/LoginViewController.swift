//
//  LoginViewController.swift
//  DemoInstagramApp
//
//  Created by Ady on 8/2/18.
//  Copyright © 2018 RJTCompuquest. All rights reserved.
//

import UIKit
import Firebase
import TWMessageBarManager
import GoogleSignIn
import FacebookCore
import FacebookLogin
import FirebaseMessaging

class LoginViewController: UIViewController, GIDSignInDelegate, GIDSignInUIDelegate {
   
    
    @IBOutlet weak var emailLoginField: UITextField!
    @IBOutlet weak var passwordLoginField: UITextField!
    @IBOutlet weak var googleSignInBtn: GIDSignInButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.isNavigationBarHidden = true
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func signInLoginPageClicked(_ sender: UIButton) {
        FirebaseHandler.sharedInstance.userLogin(email: emailLoginField.text!, password: passwordLoginField.text!) { (error) in
            if let err = error {
                TWMessageBarManager().showMessage(withTitle: "SignIn Failed", description: err.localizedDescription, type: .error)
            }else{
//                DispatchQueue.main.async {
//                     Messaging.messaging().subscribe(toTopic: (Auth.auth().currentUser?.uid)!)
                    self.performSegue(withIdentifier: "InstagramTabBarController", sender: nil)
//                }
                TWMessageBarManager().showMessage(withTitle: "SignIn Successful", description: "You have successfully signedIn", type: .success)
            }
        }
        

    }
    
    //MARK:- Google SignIn
    @IBAction func googleSignIn(_ sender: UIButton) {
       

        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().signIn()
        
    }
    
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        if error == nil{
            guard let authentication = user.authentication else{
                return
            }
            let cred = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
//             Messaging.messaging().subscribe(toTopic: (Auth.auth().currentUser?.uid)!)
            Auth.auth().signInAndRetrieveData(with: cred) { (authResultData, error) in
            
                if error == nil {
                    
                    FirebaseHandler.sharedInstance.checkIfCurrentUserExists(userID: Auth.auth().currentUser?.uid, completion: { (resultBool) in
                        
                        if resultBool == false {
                            
                            FirebaseHandler.sharedInstance.createUser(firstName: (authResultData?.user.displayName)!, lastName: "", phoneNo: 80085, email: (authResultData?.user.email)!, password: "", completion: {
                                TWMessageBarManager().showMessage(withTitle: "Success", description: "Your Profile is created", type: .success)
                                
                                self.NavigateToHome()
                                
                            })
                        }else{
                            self.NavigateToHome()
                        }
                    })
                }
            }
            
        }
    }
    
    
    
    //MARK:- Facebook SignIn
    @IBAction func facebookSignIn(_ sender: UIButton) {
        let loginManager = LoginManager()
        loginManager.logIn(readPermissions: [.publicProfile, .email], viewController: self) { (loginResult) in
            
            switch loginResult {
            case .success(grantedPermissions: _, declinedPermissions: _, token: _):
                self.facebookSignInFirebase()
//                Messaging.messaging().subscribe(toTopic: (Auth.auth().currentUser?.uid)!)

            case .failed :
                TWMessageBarManager().showMessage(withTitle: "Error", description: "Facebook Login Failed", type: .error)
            case .cancelled:
                TWMessageBarManager().showMessage(withTitle: "Error", description: "Facebook Login Cancelled", type: .error)
            }
        }
    }
    
    
    func facebookSignInFirebase(){
        let credentials = FacebookAuthProvider.credential(withAccessToken: (AccessToken.current?.authenticationToken)!)
        Auth.auth().signInAndRetrieveData(with: credentials) { (authResultData, error) in
            
            if error == nil{
                
                FirebaseHandler.sharedInstance.checkIfCurrentUserExists(userID: Auth.auth().currentUser?.uid, completion: { (resultBool) in
                    if resultBool == false{
                  
                        FirebaseHandler.sharedInstance.createUser(firstName: (authResultData?.user.displayName)!, lastName: "", phoneNo: 12345678, email: (authResultData?.user.email)!, password: "", completion: {
                            TWMessageBarManager().showMessage(withTitle: "Success", description: "Your Profile is created", type: .success)

                            self.NavigateToHome()
                        })
                    }else{
                        print("Facebook successfully SignedIn")
                        self.NavigateToHome()
                    }
                })
                
                
            }else{
                TWMessageBarManager().showMessage(withTitle: "Facebook Login Failed", description: error.debugDescription, type: .error)
            }
        }
        
    }
    
        func NavigateToHome(){
            
            if let controller = self.storyboard?.instantiateViewController(withIdentifier: "InstagramTabBarController") as? InstagramTabBarController{
                self.navigationController?.pushViewController(controller, animated: true)
            }
        }
    
    
    
    @IBAction func forgotPasswordLoginPageClicked(_ sender: UIButton) {
        if let controller = storyboard?.instantiateViewController(withIdentifier: "ForgotPasswordViewController") as? ForgotPasswordViewController {
            navigationController?.pushViewController(controller, animated: true)

        }
    }
    
    @IBAction func signUpLoginPageClicked(_ sender: UIButton) {
        if let controller = storyboard?.instantiateViewController(withIdentifier: "RegistrationViewController") as? RegistrationViewController{
            navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

