//
//  UsersViewController.swift
//  DemoInstagramApp
//
//  Created by Ady on 8/7/18.
//  Copyright © 2018 RJTCompuquest. All rights reserved.
//

import UIKit
import Firebase

class UsersViewController: UIViewController {
    
    @IBOutlet weak var usersTblView: UITableView!
    
    var allUserArr = [PublicUser]()
    var followingUsersArr = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        usersTblView.tableFooterView = UIView(frame: .zero)
        title = "Users"
        // Do any additional setup after loading the view.
        
//        allUsers()
//        getFollowing()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        allUsers()
        getFollowing()
    }
    
    func allUsers(){
        FirebaseHandler.sharedInstance.getAllUsersExceptCurrentUser { (resultArr) in
            print(resultArr)
            self.allUserArr = resultArr
//            self.allUserArr = resultArr[0].userId
//            self.allUserArr = allUserArr.filter(){$0 != CurrentUser.sharedInstance.userId}
            DispatchQueue.main.async {
                self.usersTblView.reloadData()
            }
        }
    }
    
    
    
    func getFollowing() {
        FirebaseHandler.sharedInstance.getCurrentUserFollowing(CurrentuserId: (Auth.auth().currentUser?.uid)!) { (followingArr) in
            self.followingUsersArr = followingArr
            print(self.followingUsersArr)
        }
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}

extension UsersViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allUserArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UsersTableViewCell") as? UsersTableViewCell
        let user = allUserArr[indexPath.row]
        cell?.nameLabel.text = user.firstName! + " " + user.lastName!
        let profileImageUrl = allUserArr[indexPath.row].profileImageUrl
        cell?.profileImage.sd_setImage(with: URL(string: profileImageUrl ?? "https://www.ohiolink.edu/sites/default/files/default_images/profile-placeholder.png"))
        
        if followingUsersArr.contains(user.userId!) {
            cell?.followFollowing.isSelected = true
        }
        
        cell?.followFollowing.addTarget(self, action: #selector(followFollowingAction), for: .touchUpInside)
        cell?.followFollowing.tag = indexPath.row
        
        return cell!
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.transform = CGAffineTransform(scaleX: 0.4, y: 0.8)
        UIView.animate(withDuration: 0.4) {
            cell.transform = CGAffineTransform.identity
        }
    }
    
    @objc func followFollowingAction(sender: UIButton){
        let user = allUserArr[sender.tag]
        let currentUserID = Auth.auth().currentUser?.uid
        sender.isSelected = !sender.isSelected
        
        if !sender.isSelected{
            FirebaseHandler.sharedInstance.addFollowing(userId: user.userId!, currentUserId: currentUserID!)
        }else {
            FirebaseHandler.sharedInstance.removeFollowing(userId: user.userId!, currentUserId: currentUserID!)
        }
    }
    
}
