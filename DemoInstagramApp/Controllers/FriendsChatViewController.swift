//
//  FriendsChatViewController.swift
//  DemoInstagramApp
//
//  Created by Ady on 8/20/18.
//  Copyright © 2018 RJTCompuquest. All rights reserved.
//

import UIKit
import Firebase

class FriendsChatViewController: UIViewController {
    
    @IBOutlet weak var tblView: UITableView!
    
    var userArr = [PublicUser]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tblView.tableFooterView = UIView(frame: .zero)
        title = "Friends"

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        FirebaseHandler.sharedInstance.getFollowingUsers(CurrentuserId: (Auth.auth().currentUser?.uid)!) { (publicUserArr) in
            
            self.userArr = publicUserArr
            self.tblView.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

extension FriendsChatViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendsChatTableViewCell") as? FriendsChatTableViewCell
        let user = userArr[indexPath.row]
        cell?.friendNameLbl.text = user.firstName! + " " + user.lastName!
        cell?.friendImageView.sd_setImage(with: URL(string: user.profileImageUrl ?? "https://www.ohiolink.edu/sites/default/files/default_images/profile-placeholder.png"), completed: nil)
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let controller = storyboard?.instantiateViewController(withIdentifier: "ChatViewController") as? ChatViewController {
            let friendId = userArr[indexPath.row].userId
            controller.receiverId = friendId
            navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        UIView.animate(withDuration: 0.4) {
            cell.transform = CGAffineTransform.identity
        }
    }
    
    
}
