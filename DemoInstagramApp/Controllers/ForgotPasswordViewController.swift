//
//  ForgotPasswordViewController.swift
//  DemoInstagramApp
//
//  Created by Ady on 8/3/18.
//  Copyright © 2018 RJTCompuquest. All rights reserved.
//

import UIKit
import Firebase
import TWMessageBarManager

class ForgotPasswordViewController: UIViewController {
    
    @IBOutlet weak var emailForgotPasswordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func sendPasswordReset(_ sender: UIButton) {

        FirebaseHandler.sharedInstance.forgotPassword(email: emailForgotPasswordField.text!) { (error) in
            if let err = error{
                TWMessageBarManager().showMessage(withTitle: "Error Occurred", description: "Sorry, we weren't able to send the password reset link ERROR: " + err.localizedDescription , type: .error)
            }else{
                TWMessageBarManager().showMessage(withTitle: "Email Sent", description: "Please check your email and follow the instructions to rest your password", type: .success)
                self.navigationController?.popViewController(animated: true)
            }
        }
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
