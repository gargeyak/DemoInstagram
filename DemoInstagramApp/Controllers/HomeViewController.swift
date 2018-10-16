//
//  HomeViewController.swift
//  DemoInstagramApp
//
//  Created by Ady on 8/2/18.
//  Copyright © 2018 RJTCompuquest. All rights reserved.
//

import UIKit
import Firebase

class HomeViewController: UIViewController {

    @IBOutlet weak var homeTblView: UITableView!
    
    
    var currentUserId : String?
    var postsArray = [Posts]()
    var userLikedPostIdArr = [String]()
    var refreshController : UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentUserId = Auth.auth().currentUser?.uid
        refreshController = UIRefreshControl()
        refreshController.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshController.tintColor = UIColor.blue
        refreshController.addTarget(self, action: #selector(refreshAction), for: .valueChanged)
        homeTblView.addSubview(refreshController)
        
        // Do any additional setup after loading the view.
        setHomeTitle()
//        getAllPosts()
//        getcurrentUserLikes()
    }

    override func viewWillAppear(_ animated: Bool) {
        getAllPosts()
        getcurrentUserLikes()
    }
    
    func setHomeTitle() {
        let titleImage = UIImage(named: "HomeTitle")
        let imageView = UIImageView(image: titleImage)
        imageView.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        imageView.contentMode = .scaleAspectFit
        navigationItem.titleView = imageView
    }
    
    @objc func refreshAction() {
        postsArray.removeAll()
        getAllPosts()
    }
    
    
    func getAllPosts(){
        
        FirebaseHandler.sharedInstance.getAllPostData { (postsArr) in
//            self.postsArray = postsArr
         
            self.postsArray = postsArr.sorted(by: {
                return $0.timestamp! - $1.timestamp! > 0 ? true : false
            })
            print(postsArr)
//           print(postsArr[0].userObj?.profileImageUrl)
//            print(CurrentUser.sharedInstance.profileImageUrl)
            
            DispatchQueue.main.async {
                self.homeTblView.reloadData()
                self.refreshController.endRefreshing()
            }
            
        }
        
    }
    
    func getcurrentUserLikes(){
        FirebaseHandler.sharedInstance.getUserLikedPosts { (likedPostsArr) in
            print(likedPostsArr)
            self.userLikedPostIdArr = likedPostsArr
        }
    }
    
    
    @IBAction func CameraBtnAction(_ sender: UIBarButtonItem) {
        if let controller = storyboard?.instantiateViewController(withIdentifier: "PostViewController") as? PostViewController{
            present(controller, animated: true, completion: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}


extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell") as? HomeTableViewCell
        

        let postId = postsArray[indexPath.row].postId!
        
        if userLikedPostIdArr.contains(postId) {
            cell?.likeBtnOutlet.isSelected = true
        }
        
        let postImageUrl = postsArray[indexPath.row].postImageUrl
        
        if let imageurl = postsArray[indexPath.row].userObj?.profileImageUrl{
            
            cell?.userProfileImg.sd_setImage(with: URL(string: imageurl), completed: nil)
        }else{
            cell?.userProfileImg.image = UIImage(named: "userprofile")
        }
        let timestampInDays = postsArray[indexPath.row].timestamp
        let newTimestamp = Double(timestampInDays!)
        
        DispatchQueue.main.async {
            cell?.timeStamp.text = newTimestamp.timeElapsed
            cell?.userProfileLabel.text = self.postsArray[indexPath.row].userObj?.firstName
            cell?.userPostView.sd_setImage(with: URL(string: postImageUrl!), completed: nil)
            cell?.userPostDesc.text = self.postsArray[indexPath.row].description
            
        }
        cell?.commentBtnOutlet.addTarget(self, action: #selector(commentBtnAction), for: .touchUpInside)
        cell?.commentBtnOutlet.tag = indexPath.row
        cell?.numberOfLikes.addTarget(self, action: #selector(numberOfLikesBtnAction), for: .touchUpInside)
        cell?.numberOfLikes.tag = indexPath.row
        cell?.likeBtnOutlet.addTarget(self, action: #selector(likeBtnAction), for: .touchUpInside)
        cell?.likeBtnOutlet.tag = indexPath.row
        
        cell?.numberOfLikes.setTitle("\(postsArray[indexPath.row].numOfLikes!) Likes", for: .normal)
    
        return cell!
    }
    

    
    @objc func commentBtnAction(sender: UIButton){
        let controller = storyboard?.instantiateViewController(withIdentifier: "CommentViewController") as? CommentViewController
        controller?.postIdStr = postsArray[sender.tag].postId
        navigationController?.pushViewController(controller!, animated: true)
        
    }
    
    @objc func numberOfLikesBtnAction(sender: UIButton) {
        
        let conttroller = storyboard?.instantiateViewController(withIdentifier: "LikesViewController")
        navigationController?.pushViewController(conttroller!, animated: true)
    }
    
    
    
    @objc func likeBtnAction(sender: UIButton) {
        
        let postDetails = postsArray[sender.tag]
        
        sender.isSelected = !sender.isSelected
        
        if !sender.isSelected {
            
            if postDetails.numOfLikes! > 0 {
                FirebaseHandler.sharedInstance.userUnlikePost(postObj: postDetails, userId: currentUserId!) { (numOfLikes) in
                    postDetails.numOfLikes = numOfLikes
                    let indexPath = IndexPath(row: sender.tag, section: 0)
                    let cell = self.homeTblView.cellForRow(at: indexPath) as! HomeTableViewCell
                    DispatchQueue.main.async {
                        cell.numberOfLikes.setTitle("\(numOfLikes) Likes", for: .normal)
//                        cell.numberOfLikesLabel.text = "\(noofUpdatedLikes) Likes"
                    }
                }
            }
           
        }else{
            
            FirebaseHandler.sharedInstance.userLikePost(postObj: postDetails, userId: currentUserId!) { (numOfLikes) in
                postDetails.numOfLikes = numOfLikes
                let indexPath = IndexPath(row: sender.tag, section: 0)
                let cell = self.homeTblView.cellForRow(at: indexPath) as! HomeTableViewCell
                DispatchQueue.main.async {
                    cell.numberOfLikes.setTitle("\(numOfLikes) Likes", for: .normal)
                    //                        cell.numberOfLikesLabel.text = "\(noofUpdatedLikes) Likes"
                }
            }
        }
        
    }
    
    
}
