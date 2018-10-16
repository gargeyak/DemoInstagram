//
//  LikesViewController.swift
//  DemoInstagramApp
//
//  Created by Ady on 8/10/18.
//  Copyright © 2018 RJTCompuquest. All rights reserved.
//

import UIKit

class LikesViewController: UIViewController {
    
    @IBOutlet weak var likesTblView: UITableView!
    
//    var likedUserIdArr = [String]()
    var likedUsersArr = [PublicUser]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Likes"
        
        // Do any additional setup after loading the view.
        getcurrentUserLikes()
    }
    
    func getcurrentUserLikes(){
        
        FirebaseHandler.sharedInstance.getLikedUsers { (likedUserIds) in
            self.likedUsersArr = likedUserIds
            print(self.likedUsersArr)
            self.likesTblView.reloadData()
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

   

}


extension LikesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return likedUsersArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "LikesTableViewCell") as? LikesTableViewCell
        let userObj = likedUsersArr[indexPath.row]
        cell?.userNameLbl.text = userObj.firstName
        cell?.userImgView.sd_setImage(with: URL(string: userObj.profileImageUrl ?? "https://www.ohiolink.edu/sites/default/files/default_images/profile-placeholder.png"), completed: nil)
        return cell!
    }
}
