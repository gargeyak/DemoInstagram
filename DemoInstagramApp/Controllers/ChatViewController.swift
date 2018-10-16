//
//  ChatViewController.swift
//  DemoInstagramApp
//
//  Created by Ady on 8/14/18.
//  Copyright © 2018 RJTCompuquest. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var chatTblView: UITableView!
    @IBOutlet weak var msgField: UITextField!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    var receiverId: String?
    var messageArr = [Message]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Chat"
//        chatTblView.tableFooterView = UIView(frame: .zero)
        // Do any additional setup after loading the view.
        hideShowKeyboard()
//        showChat()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        chatTblView.separatorStyle = UITableViewCellSeparatorStyle.none
        
       showChat()
    }
    
    
    func showChat(){
        FirebaseHandler.sharedInstance.getChatHistory(receiverId: receiverId!, currentUserId: CurrentUser.sharedInstance.userId!) { (msgArr) in
            self.messageArr = msgArr.sorted(by: {
                return $0.timestamp! - $1.timestamp! > 0 ? false : true
            })
            print(self.messageArr)
            DispatchQueue.main.async {
                self.chatTblView.reloadData()
                
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
        return msgField.resignFirstResponder()
    }
    
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        
        msgField.resignFirstResponder()
    
        
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func sendClicked(_ sender: UIButton) {
        
        let timestamp = Date().timeIntervalSince1970
        let message = Message(incoming: true, text: msgField.text!, timestamp: Int(timestamp))

        sendMessgeTo(receiverId: receiverId!, msg: message)
        msgField.text = ""
    }
    
    func sendMessgeTo( receiverId: String,  msg: Message){
        
        let conv = ["senderId": CurrentUser.sharedInstance.userId, "message": msg.text]
        var conKey : String = ""
        let currentUser = CurrentUser.sharedInstance
        if receiverId < currentUser.userId!{
            conKey = receiverId + currentUser.userId!
        }else{
            conKey = currentUser.userId! + receiverId
        }
        
        let convUpdates = ["\(conKey)/\(msg.timestamp!)": conv]
        FirebaseHandler.sharedInstance.addConversation(dict: convUpdates)

        FirebaseHandler.sharedInstance.notification(msg: msgField.text!, receiverId: receiverId, currentUserId: currentUser.userId!)
       
        showChat()
    }

}


extension ChatViewController: UITableViewDataSource {

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageArr.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatViewController")
        let msgObj = messageArr[indexPath.row]
        if msgObj.incoming == true {
            
            cell?.textLabel?.text = msgObj.text
            cell?.textLabel?.textColor = UIColor.orange
        }else{
            cell?.detailTextLabel?.text = msgObj.text
            cell?.detailTextLabel?.textColor = UIColor.purple

        }
        return cell!
    }



}
