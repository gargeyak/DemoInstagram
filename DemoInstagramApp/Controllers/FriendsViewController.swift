//
//  FriendsViewController.swift
//  DemoInstagramApp
//
//  Created by Ady on 8/8/18.
//  Copyright © 2018 RJTCompuquest. All rights reserved.
//

import UIKit
import Firebase
//import SDWebImage

class FriendsViewController: UIViewController {

    @IBOutlet weak var followingTblView: UITableView!
    
    var userArr = [PublicUser]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        followingTblView.tableFooterView = UIView(frame: .zero)
        title = "Friends"

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        FirebaseHandler.sharedInstance.getFollowingUsers(CurrentuserId: (Auth.auth().currentUser?.uid)!) { (publicUserArr) in
            
            self.userArr = publicUserArr
            print(self.userArr[0].firstName)
            self.followingTblView.reloadData()
        }
    }
    
    
   

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

  

}

extension FriendsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendsTableViewCell") as? FriendsTableViewCell
        let user = userArr[indexPath.row]
        cell?.friendNameLbl.text = user.firstName! + " " + user.lastName!
        cell?.friendImageView.sd_setImage(with: URL(string: user.profileImageUrl ?? "https://www.ohiolink.edu/sites/default/files/default_images/profile-placeholder.png"), completed: nil)
        return cell!
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.transform = CGAffineTransform(scaleX: 0.4, y: 0.8)
        UIView.animate(withDuration: 0.4) {
            cell.transform = CGAffineTransform.identity
        }
    }
    
    
    
}
