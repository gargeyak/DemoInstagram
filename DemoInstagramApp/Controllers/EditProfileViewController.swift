//
//  EditProfileViewController.swift
//  DemoInstagramApp
//
//  Created by Ady on 8/3/18.
//  Copyright © 2018 RJTCompuquest. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage
import TWMessageBarManager

class EditProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var website: UITextField!
    @IBOutlet weak var bio: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var gender: UITextField!
    
    @IBOutlet weak var profilePickerView: UIImageView!
    @IBOutlet weak var doneBtn: UIBarButtonItem!
    
    let imagePicker = UIImagePickerController()

    var doneBtnFlag = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isHidden = true
        profilePickerView.layer.cornerRadius = profilePickerView.frame.size.height/2
        profilePickerView.layer.borderWidth = 1.0
        profilePickerView.layer.borderColor = UIColor.lightGray.cgColor
        imagePicker.delegate = self
        // Do any additional setup after loading the view.
        getProfileImage()
//        getProfileData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getProfileData()
//        getProfileImage()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        if !doneBtnFlag {
            print("Something")
            TWMessageBarManager.sharedInstance().showMessage(withTitle: "click Done to update your profile", description: "Profile is not updated with latest changes", type: .error, duration: 4.0)
        }
        
    }
    
    func getProfileImage() {
        if let url = URL(string: FirebaseHandler.sharedInstance.currentUser.profileImageUrl ?? "https://www.ohiolink.edu/sites/default/files/default_images/profile-placeholder.png") {
            profilePickerView.sd_setImage(with: url)
        }
    }
    
    func getProfileData() {
        let curUserData = FirebaseHandler.sharedInstance.currentUser
        firstName.text = curUserData.firstName
        lastName.text = curUserData.lastName
        website.text = curUserData.website
        bio.text = curUserData.bio
        email.text = curUserData.email
        phone.text = "\(String(describing: curUserData.phoneNo!))"
        gender.text = curUserData.gender
        
    }
    
    @IBAction func changeBtn(_ sender: Any) {
        imagePicker.allowsEditing = true
        
        if imagePicker.sourceType == .camera{
            imagePicker.sourceType = .camera
        }
        else{
            imagePicker.sourceType = .photoLibrary
        }
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let selectedImage = info[UIImagePickerControllerEditedImage] as? UIImage{
            profilePickerView.image = selectedImage
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        dismiss(animated: true, completion: nil)
        
    }
    @IBAction func backBtn(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func doneBtn(_ sender: Any?) {
        
        doneBtnFlag = true
        
        FirebaseHandler.sharedInstance.updateUserProfile(firstName: firstName.text!, lastName: lastName.text!, website: website.text!, bio: bio.text!, email: email.text!, phoneNo: Int(phone.text!)!, gender: gender.text!) {
            print("Update Success")
        }
        
        FirebaseHandler.sharedInstance.uploadUserProfileImage(profileImage: profilePickerView.image!) { (url) in
            print(url)
            print(self.profilePickerView.image!)
            
            let imageDict: [String: URL] = ["profileImage": url]
            
            self.profilePickerView.sd_setImage(with: url, placeholderImage: UIImage(named: "userprofile"))
            
            NotificationCenter.default.post(name: NSNotification.Name(notificationName), object: nil, userInfo: imageDict)
            
            FirebaseHandler.sharedInstance.initCurrentUser {
                print("updating currentUser data")
            }
        }
       
    self.navigationController?.popViewController(animated: true)
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}


