//
//  SettingsViewController.swift
//  DemoInstagramApp
//
//  Created by Ady on 8/3/18.
//  Copyright © 2018 RJTCompuquest. All rights reserved.
//

import UIKit
import Firebase
import TWMessageBarManager
import GoogleSignIn
import FBSDKLoginKit
import FacebookLogin

class SettingsViewController: UIViewController {
    
    
    let settingsHeader = ["Account", "Settings", "Support", "About"]
    let settingsCells = [["Photos of You", "Saved", "Story Settings", "Posts you've Liked", "Blocked Users", "Private Account"], ["Linked Accounts", "Contacts", "Language", "Push Notifications", "Email and SMS Notifications"], ["Help Center", "Report a Problem"], ["Ads", "Blog", "Privacy Policy", "Logout"]]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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

extension SettingsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return settingsHeader[section]
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return settingsCells.count
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingsCells[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "settingsIdentifier")
        cell?.textLabel?.text = settingsCells[indexPath.section] [indexPath.row]
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let arr = settingsCells[3]//[3]
        if indexPath.row == arr.index(of: "Logout") {
            
            // signout all the providers
            if let providerInfo = Auth.auth().currentUser?.providerData {
                for userInfo in providerInfo {
                    print(userInfo.providerID)
                    switch userInfo.providerID {
                    case FacebookAuthProviderID:
                        FBSDKLoginManager().logOut()
                        FBSDKAccessToken.setCurrent(nil)
                        FBSDKProfile.setCurrent(nil)
                    case GoogleAuthProviderID:
                        GIDSignIn.sharedInstance().signOut()
                    default:
                        break
                    }
                }
            }
            
            //signout firebase auth
            do{
                try Auth.auth().signOut()
                /*
                 //This is another way to go to Main Storyboard after we logout from another storyboard.
                 let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
                 let controller = mainStoryBoard.instantiateViewController(withIdentifier: "MainNavigationController")
                 UIApplication.shared.keyWindow?.rootViewController = controller
                 TWMessageBarManager().showMessage(withTitle: "SignOut Successful", description: "You have successfully signedOut", type: .success)
                 */
            }catch{
                print(error.localizedDescription)
            }
            destroyToLogin()
        }
    }
    
    
    
    private func destroyToLogin() {
        guard let window = UIApplication.shared.keyWindow else {
            return
        }
        
        guard let rootViewController = window.rootViewController else {
            return
        }
        
        //        // unsubscribe user from push notification
        //        Messaging.messaging().unsubscribe(fromTopic: CurrentUser.sharedInstance.userId)
        
        // Reset Current User
        CurrentUser.sharedInstance.dispose()
        
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let controller = mainStoryBoard.instantiateViewController(withIdentifier: "MainNavigationController") as! UINavigationController
        
        controller.view.frame = rootViewController.view.frame
        controller.view.layoutIfNeeded()
        
        UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: {
            window.rootViewController = controller
        }, completion: { completed in
            rootViewController.dismiss(animated: true, completion: nil)
        })
    }
    
}
