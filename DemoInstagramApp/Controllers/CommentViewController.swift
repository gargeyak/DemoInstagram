//
//  CommentViewController.swift
//  DemoInstagramApp
//
//  Created by Ady on 8/10/18.
//  Copyright © 2018 RJTCompuquest. All rights reserved.
//

import UIKit



class CommentViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var commentTblView: UITableView!
    @IBOutlet weak var commentField: UITextField!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    var postIdStr: String?
    var commentArray = [Comment]()
    var publicUserArray = [PublicUser]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Comments"
        commentTblView.tableFooterView = UIView(frame: .zero)
        // Do any additional setup after loading the view.
        hideShowKeyboard()
        getComments()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getComments()
    }
    
    func getComments(){
        FirebaseHandler.sharedInstance.getComments(postId: postIdStr!) { (publicUserArr, commentArr) in
            print(commentArr)
            print(publicUserArr)
            
            self.publicUserArray = publicUserArr
            self.commentArray = commentArr
            
            DispatchQueue.main.async {
                self.commentTblView.reloadData()
            }
        }
    }
    
    
    func hideShowKeyboard(){
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_ :)), name: Notification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_ :)), name: Notification.Name.UIKeyboardWillHide, object: nil)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let userInfo = notification.userInfo {
            
            if let keyboardSize = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                
                bottomConstraint.constant = 0
                bottomConstraint.constant -= keyboardSize.height - 50
            }
            UIView.animate(withDuration: 1.0) {
                self.view.layoutIfNeeded()
            }
        }
        
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        if let userInfo = notification.userInfo {
            
            if let keyboardSize = (userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
                
                bottomConstraint.constant += keyboardSize.height + 0
                bottomConstraint.constant = 0
            }
            UIView.animate(withDuration: 1.0) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        return commentField.resignFirstResponder()
    }
    
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        
        commentField.resignFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func sendCommentBtnActn(_ sender: UIButton) {
        let comment = commentField.text!
        
        FirebaseHandler.sharedInstance.postComments(commentDes: comment, postId: postIdStr!) { (error) in
            if error == nil{
                print("Successfully posted comment")
                self.getComments()
                self.commentField.text = ""
            }
        }
       
    }
   

}

extension CommentViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentTableViewCell") as? CommentTableViewCell
        cell?.userCommentLbl.text = commentArray[indexPath.row].commentDes
        
        let user = publicUserArray[indexPath.row]
        cell?.userNameLbl.text = user.firstName! + " " + user.lastName!
        
        let profileImageUrl = publicUserArray[indexPath.row].profileImageUrl
        cell?.userImgView.sd_setImage(with: URL(string: profileImageUrl ?? "https://www.ohiolink.edu/sites/default/files/default_images/profile-placeholder.png"))
        return cell!
        
    }



}
