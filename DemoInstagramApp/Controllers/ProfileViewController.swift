//
//  ProfileViewController.swift
//  DemoInstagramApp
//
//  Created by Ady on 8/3/18.
//  Copyright © 2018 RJTCompuquest. All rights reserved.
//

import UIKit
import Firebase

let notificationName = "notificationName"

class ProfileViewController: UIViewController {
    
    var postsArray = [Posts]()
    
    @IBOutlet weak var profileCollectionView: UICollectionView!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var profilePic: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isHidden = false
        profilePic.layer.cornerRadius = profilePic.frame.size.height/2
        profilePic.layer.borderWidth = 1.0
        profilePic.layer.borderColor = UIColor.lightGray.cgColor
        tabBarController?.delegate = self
    
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateProfilePic(_:)), name: NSNotification.Name(notificationName), object: profilePic.image)
        
        // Do any additional setup after loading the view.
        
//        getProfileData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getProfileData()
    }
    
    @objc func updateProfilePic(_ notification: Notification) {
    
        print(notification.userInfo!["profileImage"]!)
        let userInfo = notification.userInfo!["profileImage"] as! URL
            print(userInfo)
            profilePic.sd_setImage(with: userInfo)
//           userNameLbl.text = "\(String(describing: FirebaseHandler.sharedInstance.currentUser.firstName!)) \(String(describing: FirebaseHandler.sharedInstance.currentUser.lastName!))"
        
        
    }
    
    func getProfileData() {
        if let url = URL(string: FirebaseHandler.sharedInstance.currentUser.profileImageUrl  ?? "https://www.ohiolink.edu/sites/default/files/default_images/profile-placeholder.png"){
            profilePic.sd_setImage(with: url)
//            userNameLbl.text = FirebaseHandler.sharedInstance.currentUser.firstName ?? "Name"
            userNameLbl.text =  "\(FirebaseHandler.sharedInstance.currentUser.firstName ?? "fName") \(FirebaseHandler.sharedInstance.currentUser.lastName ?? "lName")"
        }
        
        FirebaseHandler.sharedInstance.getAllPostData { (postsArr) in
            self.postsArray = postsArr
            self.profileCollectionView.reloadData()
        }
        
    }
    
    
    
    
    @IBAction func editProfileBtn(_ sender: Any) {
        if let controller = storyboard?.instantiateViewController(withIdentifier: "EditProfileViewController") as? EditProfileViewController{
            navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    @IBAction func settingsBtn(_ sender: Any) {
        if let controller = storyboard?.instantiateViewController(withIdentifier: "SettingsViewController") as? SettingsViewController{
            navigationController?.pushViewController(controller, animated: true)
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

extension ProfileViewController: UICollectionViewDataSource {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return postsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileCollectionViewCell", for: indexPath) as? ProfileCollectionViewCell
        let postImageUrl = postsArray[indexPath.row].postImageUrl
        cell?.imgView.sd_setImage(with: URL(string: postImageUrl ?? "https://www.ohiolink.edu/sites/default/files/default_images/profile-placeholder.png"))
        return cell!
    }
    
    
    
}

extension ProfileViewController: UITabBarControllerDelegate {
    
    //Function asks the delegate whether the specified view controller should be made active.
    
//    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
//
//        return viewController == tabBarController.selectedViewController
//    }
}
