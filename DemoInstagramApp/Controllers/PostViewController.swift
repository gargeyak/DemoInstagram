//
//  PostViewController.swift
//  DemoInstagramApp
//
//  Created by Ady on 8/6/18.
//  Copyright © 2018 RJTCompuquest. All rights reserved.
//

import UIKit
import TWMessageBarManager
import SVProgressHUD

class PostViewController: UIViewController {

    @IBOutlet weak var postImgView: UIImageView!
    @IBOutlet weak var postDescView: UITextView!
    
     let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        navigationController?.navigationItem.hidesBackButton = true
        navigationController?.navigationBar.isHidden = true

        // Do any additional setup after loading the view.
    }
    
    @IBAction func postBtn(_ sender: Any) {
//        FirebaseHandler.sharedInstance.savePost(PostImage: postImgView.image!, description: postDescView.text)
//        dismiss(animated: true, completion: nil)

        FirebaseHandler.sharedInstance.savePost(PostImage: postImgView.image!, description: postDescView.text) { (error) in
            if error == nil{
                TWMessageBarManager().showMessage(withTitle: "Success", description: "Successfully Posted", type: .success)
                self.dismiss(animated: true, completion: nil)
            }else{
                TWMessageBarManager().showMessage(withTitle: "Failed", description: error.debugDescription, type: .error)
            }
        }
        
    }
    
    
    
    @IBAction func cancelBtn(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

  

}

extension PostViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBAction func pickImageBtn(_ sender: Any) {
        
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
            postImgView.image = selectedImage
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    

}
