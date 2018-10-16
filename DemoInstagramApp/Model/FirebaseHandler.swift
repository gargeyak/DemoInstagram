//
//  FirebaseHandler.swift
//  DemoInstagramApp
//
//  Created by Ady on 8/2/18.
//  Copyright © 2018 RJTCompuquest. All rights reserved.
//

import Foundation
import Firebase

class FirebaseHandler: NSObject {
    
    static var sharedInstance = FirebaseHandler()
    private override init(){}
    
    private lazy var databaseRef = Database.database().reference()
    private lazy var userDatabaseRef = Database.database().reference().child("User")
    private lazy var userProfileImageStorageRef = Storage.storage().reference().child("userProfileImages")
    private lazy var postDatabaseRef = Database.database().reference()
    private lazy var postStorageRef = Storage.storage().reference()
    
    var currentUser = CurrentUser.sharedInstance
    

    
    
    func userSignup(firstName: String, lastName: String, phoneNo: Int, email: String, password: String, completion: @escaping (Error?) -> ()){
        
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if let err = error {
                completion(err)
            }else{
                self.currentUser.userId = result?.user.uid
                let userDict = ["firstName": firstName, "lastName": lastName, "email": email, "phoneNo": phoneNo] as [String : Any]
                self.userDatabaseRef.child("/\(String(describing: self.currentUser.userId!))").setValue(userDict, withCompletionBlock: { (error, dbRef) in
                    if let err = error{
                        completion(err)
                    }else{
                        completion(nil)
                    }
                })
                completion(nil)
            }
        }
    }
    
    
  
    
//    func saveUser(user: CurrentUser, completion: @escaping (CurrentUser?, String?) -> ()) {
//        let userDict = ["firstName": user.firstName!, "lastName": user.lastName!, "email": user.email!, "phoneNo": user.phoneNo!, "password": user.password!, "confirmPassword": user.confirmPassword!, "userId": user.userId!, /*"profileImageUrl": user.profileImageUrl!,*/ "website": user.website!, "bio": user.bio!, "gender": user.gender!, "posts": user.posts, "following": user.following, "followers": user.followers] as [String : Any]
//
//        self.userDatabaseRef.child("/\(String(describing: user.userId!))").setValue(userDict) { (error, dbRef) in
//            if let err = error{
//                completion(nil, err.localizedDescription)
//            }else{
//                completion(user, nil)
//            }
//        }
//    }
    
    
    
    
    func userLogin(email: String, password: String, completion: @escaping (Error?) -> ()) {
        
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if let err = error{
                completion(err)
            }else{
                self.currentUser.userId = Auth.auth().currentUser?.uid
                
                self.userDatabaseRef.child(self.currentUser.userId!).observeSingleEvent(of: .value, with: { (snapshot) in
                    guard let values = snapshot.value as? [String: Any] else{
                        return
                    }
                    self.currentUser.firstName = values["firstName"] as? String
//                    print(self.currentUser.firstName)
                    self.currentUser.lastName = values["lastName"] as? String
//                    print(self.currentUser.lastName)
                    self.currentUser.phoneNo = values["phoneNo"] as? Int
//                    print(self.currentUser.phoneNo)
                    self.currentUser.email = values["email"] as? String
//                    print(self.currentUser.email)
                    self.currentUser.profileImageUrl = values["profileImageUrl"] as? String
//                    print(self.currentUser.profileImageUrl)
                    self.currentUser.website = values["website"] as? String
                    self.currentUser.bio = values["bio"] as? String
                    self.currentUser.gender = values["gender"] as? String

                })
                
                completion(nil)
            }
        }
    }
    
    
    //MARK:- GoogleSignIn & populateDatabase Methods
    func checkIfCurrentUserExists(userID: String?, completion: @escaping (Bool) -> ()) {
        var result = false
        
        userDatabaseRef.child(userID!).observeSingleEvent(of: .value) { (snapshot) in
            if (snapshot.value as? Dictionary<String, Any>) != nil {
            result = true
        }
            completion(result)
        }
    }
    
    func createUser(firstName: String, lastName: String, phoneNo: Int, email: String, password: String, completion: @escaping () -> () ) {
        
        currentUser.userId = Auth.auth().currentUser?.uid
        
        let dict = ["firstName": firstName, "lastName": lastName, "email": email, "phoneNo": phoneNo] as [String : Any]
        userDatabaseRef.child(currentUser.userId!).updateChildValues(dict) { (error, dbRef) in
            
            print("Finished Creating User")
            completion()
        }
    }
    
    func updateUserProfile(firstName: String, lastName: String, website: String, bio: String, email: String, phoneNo: Int, gender: String, completion: @escaping () -> ()) {
        
        let dict = ["firstName": firstName, "lastName": lastName, "website": website, "bio": bio, "email": email, "phoneNo": phoneNo, "gender": gender] as [String : Any]
        userDatabaseRef.child(currentUser.userId!).updateChildValues(dict) { (error, dbRef) in
            
            print("Finished updating User profile")
            completion()
        }
    }
    
    
    //MARK:- Initializing Current User
//    func initCurrentUser(completion: @escaping ()->()){
//        currentUser.userId = Auth.auth().currentUser?.uid
//        userDatabaseRef.child(currentUser.userId!).observeSingleEvent(of: .value) { (snapshot) in
//            guard let values = snapshot.value as? [String: Any] else{
//                return
//            }
//            self.currentUser.firstName = values["firstName"] as? String
//            self.currentUser.lastName = values["lastName"] as? String
//            self.currentUser.phoneNo = values["phoneNo"] as? Int
//            self.currentUser.email = values["email"] as? String
//            self.currentUser.profileImageUrl = values["profileImageUrl"] as? String
//            completion()
//        }
//    }
    
    func initCurrentUser(completion: @escaping ()->()){
        currentUser.userId = Auth.auth().currentUser?.uid
        userDatabaseRef.child(currentUser.userId!).observeSingleEvent(of: .value) { (snapshot) in
            guard let values = snapshot.value as? [String: Any] else{
                return
            }
            self.currentUser.firstName = values["firstName"] as? String
            self.currentUser.lastName = values["lastName"] as? String
            self.currentUser.phoneNo = values["phoneNo"] as? Int
            self.currentUser.email = values["email"] as? String
            self.currentUser.profileImageUrl = values["profileImageUrl"] as? String
            self.currentUser.website = values["website"] as? String
            self.currentUser.bio = values["bio"] as? String
            self.currentUser.gender = values["gender"] as? String
            completion()
        }
    }


    
    func forgotPassword(email: String, completion: @escaping (Error?) -> ()) {
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            if let err = error{
                completion(err)
            }else{
                completion(error)
            }
        }
    }
    
    func uploadUserProfileImage(profileImage: UIImage, completion: @escaping (URL) -> ()){
        
        let userId = Auth.auth().currentUser?.uid
        print(userId!)

        let image = profileImage
        let data = UIImageJPEGRepresentation(image, 0.5)
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        userProfileImageStorageRef.child("/\(String(describing: userId!)).jpeg").putData(data!, metadata: metadata) { (meta, error) in
            if error == nil {
                print(meta!)
                self.userProfileImageStorageRef.child("/\(String(describing: userId!)).jpeg").downloadURL(completion: { (url, error) in
                    print(url)
                    let profileImageDict = ["profileImageUrl": url?.absoluteString] as? [String: String]
                    self.userDatabaseRef.child(userId!).updateChildValues(profileImageDict!)//(url?.absoluteString)
                    completion(url!)
                })
            }
        }
        
    }
    
    //MARK:- Saving Posts Methods
    func savePost(PostImage: UIImage, description: String, completion: @escaping(Error?)->()) {
        
        let postId = postDatabaseRef.child("Posts").childByAutoId().key
        let userId = Auth.auth().currentUser?.uid
        let timestamp = Int(Date().timeIntervalSince1970)
        let postDict = ["userId": userId!, "timestamp": timestamp, "description": description, "numOfLikes": 0, "likedBy": ""] as [String : Any]
        
        postDatabaseRef.child("Posts").child(postId).updateChildValues(postDict) { (error, dbRef) in
            
            let dict = [postId: "postId"]
            self.userDatabaseRef.child(userId!).child("posts").updateChildValues(dict)
            
            self.savePostImage(postImage: PostImage, imgName: postId, completion: { (error) in
                if error == nil{
                     completion(nil)
                }else{
                    completion(error)
                }
               
            })
            
        }
        
    }
    
    
    
    
    
    func savePostImage(postImage: UIImage, imgName: String, completion: @escaping (Error?)->()) {
        
        let data = UIImageJPEGRepresentation(postImage, 0.5)
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        postStorageRef.child("postImages").child("\(imgName).jpeg").putData(data!, metadata: metadata) { (meta, error) in
            
            if error == nil{
                self.postStorageRef.child("postImages").child("\(imgName).jpeg").downloadURL(completion: { (url, error) in
                    let dict = ["postImageUrl": url?.absoluteString] as? [String: String]
//                    self.databaseRef.child("Posts").child(imgName).updateChildValues(dict!)
                    self.databaseRef.child("Posts").child(imgName).updateChildValues(dict!, withCompletionBlock: { (error, dbRef) in
                        if error == nil{
                            completion(nil)
                        }else{
                            completion(error)
                        }
                    })
                })
            }
        }

    }
    
    //MARK:- Get Posts Methods
    func getAllPostData(completion: @escaping ([Posts]) -> ()){
        
        var postsArr = [Posts]()
        
        databaseRef.child("Posts").observeSingleEvent(of: .value) { (snapshot) in
            guard let values = snapshot.value as? Dictionary<String, Any> else{
                return
            }
            
            
            for i in values{
                
                let post = i.value as? Dictionary<String, Any>
                print(post)
                self.getUser(userId: post!["userId"] as! String, completion: { (user) in
                    let postObj = Posts(postId: i.key, userId: post!["userId"] as! String, description: post!["description"] as! String, timestamp: post!["timestamp"] as! Int, postImageUrl: post!["postImageUrl"] as! String, userObj: user, numOfLikes: post?["numOfLikes"] as? Int, likedBy: post?["likedBy"] as? [String])
                    
                    postsArr.append(postObj)
                    completion(postsArr)
                })
                
                
            }
        }
    }
    
    func getUser(userId: String, completion: @escaping (PublicUser)->()) {
        
        userDatabaseRef.child(userId).observeSingleEvent(of: .value) { (snapshot) in
            let userSnapshot = snapshot.value as? Dictionary<String, Any>
         
            let publicUser = PublicUser(firstName: userSnapshot!["firstName"] as? String, lastName: userSnapshot!["lastName"] as? String, password: userSnapshot!["password"] as? String, userId: userId, email: userSnapshot!["email"] as? String, profileImageUrl: userSnapshot!["profileImageUrl"] as? String, postId: nil, phoneNo: userSnapshot!["phoneNo"] as? String)
            completion(publicUser)
        }
        
    }
    
    
    
    
    
//    func getUserPosts(completion: @escaping ([Posts]) -> ()) {
//
//        let userId = Auth.auth().currentUser?.uid
//        userDatabaseRef.child(userId!).child("posts").observeSingleEvent(of: .value) { (snapshot) in
//            for value in snapshot.children.allObjects {
//                let data = value as! DataSnapshot
//                print(data)
//                let postIdKey = data.key
//                var postArr = [Posts]()
//
//                self.databaseRef.child("Posts").child(postIdKey).observeSingleEvent(of: .value, with: { (snapshot) in
//                    let postSnapshot = snapshot.value as? Dictionary<String, Any>
//                    let post = Posts(postId: postIdKey, userId: postSnapshot!["userId"] as! String, description: postSnapshot!["description"] as! String, timestamp: postSnapshot!["timestamp"] as! Int, postImageUrl: postSnapshot!["postImageUrl"] as! String, userObj: nil)
//
//                    postArr.append(post)
//                    print(postArr)
//                    completion(postArr)
//                })
//            }
//        }
//    }
    
    
    //MARK:- All Users Except Current User
    func getAllUsersExceptCurrentUser(completion: @escaping ([PublicUser]) -> ()){
        
       var userObjArr = [PublicUser]()
        
        let userId = Auth.auth().currentUser?.uid
        userDatabaseRef.observeSingleEvent(of: .value) { (snapshot) in
            if let allUserSnapshot = snapshot.value as? Dictionary<String, Any>{
            
                
                for item in allUserSnapshot {
                    
                    let user = item.value as? Dictionary<String, Any>
                    print("\n \(user) \n")
                    let userObj = PublicUser(firstName: user!["firstName"] as? String, lastName: user!["lastName"] as? String, password: user!["password"] as? String, userId: item.key, email: user!["email"] as? String, profileImageUrl: user!["profileImageUrl"] as? String, postId: nil, phoneNo: user!["phoneNo"] as? String)
                    print("\n \(userObj) \n")
                    
                    if userObj.userId != userId{
                        userObjArr.append(userObj)
                    }
                    
                    completion(userObjArr)
                }
            }
        }
    }
    
    
    
    
    
    func addFollowing(userId: String, currentUserId: String) {
        let followingDict = [userId: "userId"]
        userDatabaseRef.child(currentUserId).child("following").updateChildValues(followingDict) { (error, dbRef) in
            if let err = error {
                print(err.localizedDescription)
            }else{
                print("successful")
            }
        }
    }
    
    func removeFollowing(userId: String, currentUserId: String) {
       userDatabaseRef.child(currentUserId).child("following").child(userId).removeValue()
    }
    
    
    func getFollowingUsers(CurrentuserId: String, completion: @escaping ([PublicUser]) -> ()){
        userDatabaseRef.child(CurrentuserId).child("following").observeSingleEvent(of: .value) { (snapshot) in
            var userArr = [PublicUser]()
            if let values = snapshot.value as? Dictionary<String, Any>{
                print(values)
                for data in values{
                    self.getUser(userId: data.key, completion: { (publicUser) in
                        userArr.append(publicUser)
                         completion(userArr)
                    })
                   
                }
                print(userArr)
                
            }
        }
    }
    
    
    
    func getCurrentUserFollowing(CurrentuserId: String, completion: @escaping ([String]) -> ()){
        userDatabaseRef.child(CurrentuserId).child("following").observeSingleEvent(of: .value) { (snapshot) in
            var userArr = [String]()
            if let values = snapshot.value as? Dictionary<String, Any>{
                print(values)
                for data in values{
                    userArr.append(data.key)
                }
                 completion(userArr)
                print(userArr)
            }
        }
    }
    
    
    
    
    
    
    
    func postComments(commentDes: String, postId: String, completion: @escaping (Error?) -> ()){
        
        let commentId = databaseRef.child("Comments").childByAutoId().key
        let userId = Auth.auth().currentUser?.uid
        let timestamp = Int(Date().timeIntervalSince1970)
        let commentdict = ["postId": postId, "userId": userId!, "timestamp": timestamp, "commentDes":commentDes] as [String : Any]
        databaseRef.child("Comments").child(commentId).updateChildValues(commentdict) { (error, dbRef) in
            if error == nil {
                let dict = [userId! : "commentBy"]
                self.databaseRef.child("Posts").child(postId).child("commentBy").updateChildValues(dict)
                completion(nil)
            }else{
                completion(error)
            }
        }
    }
    
    
    
    func getComments(postId: String, completion: @escaping ([PublicUser], [Comment]) -> ()){
        
        var publicUserArr = [PublicUser]()
        var commentsArr = [Comment]()
        
        databaseRef.child("Posts").child(postId).child("commentBy").observeSingleEvent(of: .value) { (snapshot) in
            
            if let commentBySnapshot = snapshot.value as? Dictionary<String, Any> {
                
                for item in commentBySnapshot {
                    self.getUser(userId: item.key, completion: { (publicUser) in
                        self.databaseRef.child("Comments").observeSingleEvent(of: .value, with: { (commentSnapshot) in
                            if let commentSnap = commentSnapshot.value as? Dictionary<String, Any> {
                                
                                for item in commentSnap {
                                    if let data = item.value as? Dictionary<String, Any> {
                                        if let userId = data["userId"] as? String, let postIdInComments = data["postId"] as? String {
                                            if userId == publicUser.userId && postIdInComments == postId {
                                                
                                                let commentObj = Comment(commentId: item.key, userId: data["userId"] as? String, commentDes: data["commentDes"] as? String, postId: data["postId"] as? String, timestamp: data["timestamp"] as? Int)
                                                
                                                publicUserArr.append(publicUser)
                                                commentsArr.append(commentObj)
                                                print(publicUserArr)
                                                print(commentsArr)
                                                completion(publicUserArr, commentsArr)
                                            }
                                            
                                        }
                                    }
                                }
                            }
                        })
                    })
                }
            }
        }
 
    }
    
    
    func userLikePost(postObj: Posts, userId: String, completion: @escaping (Int) -> ()) {
        let userDict = [userId: "userId"]
        databaseRef.child("Posts/\(postObj.postId!)").child("likedBy").updateChildValues(userDict)
        let dict = ["numOfLikes": postObj.numOfLikes! + 1]
//        databaseRef.child("Posts/\(postObj.postId!)").child("numOfLikes").updateChildValues(dict)
        databaseRef.child("Posts/\(postObj.postId!)").updateChildValues(dict)
//        completion(postObj.numOfLikes!)
        completion(dict["numOfLikes"]!)
    }
    
    func userUnlikePost(postObj: Posts, userId: String, completion: @escaping (Int) -> ()) {
        databaseRef.child("Posts/\(postObj.postId!)").child("likedBy").child(userId).removeValue()
        let dict = ["numOfLikes": postObj.numOfLikes! - 1]
//        databaseRef.child("Posts/\(postObj.postId!)").child("numOfLikes").updateChildValues(dict)
        databaseRef.child("Posts/\(postObj.postId!)").updateChildValues(dict)
        completion(dict["numOfLikes"]!)
    }
    
    
    func getUserLikedPosts(completion: @escaping ([String]) -> ()) {
        
        databaseRef.child("Posts").observeSingleEvent(of: .value) { (snapshot) in
            
             if let value = snapshot.value as? Dictionary<String, Any> {
                print(value)
                var userLikedPostIdArr = [String]()
                for item in value {
                    self.databaseRef.child("Posts").child(item.key).child("likedBy").observeSingleEvent(of: .value, with: { (likedBySnapshot) in
                        
                        if let values = likedBySnapshot.value as? Dictionary<String, Any>{
                            print(values)
                            
                            for i in values {
                                if i.key == self.currentUser.userId{
                                userLikedPostIdArr.append(item.key)
                                }
                                
                            }
                             print(userLikedPostIdArr)
                            completion(userLikedPostIdArr)
                        }
                    })
                }
            }
        }
    }
    
    
    func getLikedUsers(completion: @escaping ([PublicUser]) -> ()) {
        
        databaseRef.child("Posts").observeSingleEvent(of: .value) { (snapshot) in
            
            if let value = snapshot.value as? Dictionary<String, Any> {
                print(value)
                var likedUsersArr = [PublicUser]()
                for item in value {
                    self.databaseRef.child("Posts").child(item.key).child("likedBy").observeSingleEvent(of: .value, with: { (likedBySnapshot) in
                        
                        if let values = likedBySnapshot.value as? Dictionary<String, Any>{
                            print(values)
                            
                            for i in values {

                                self.getUser(userId: i.key, completion: { (publicUser) in
                                    
                                    if !likedUsersArr.contains(where: { $0.userId == publicUser.userId }) {
                                        likedUsersArr.append(publicUser)
                                    }
                                    print(likedUsersArr)
                                    completion(likedUsersArr)
                                })
                            }
                        }
                    })
                }
            }
        }
    }
    
    
    
    func addConversation(dict: Dictionary<String, Any>){
        databaseRef.child("Conversation").updateChildValues(dict)
    }
  
    func notification(msg: String, receiverId: String, currentUserId: String) {
        let notificationId = databaseRef.child("Notification").childByAutoId().key
        let dict = ["msg":msg, "recieverId": receiverId, "senderId": currentUserId]
        databaseRef.child("Notification").child(notificationId).updateChildValues(dict)
    }
    
    
    
    
 
    
    func getChatHistory(receiverId: String, currentUserId: String, completion: @escaping ([Message]) -> ()) {
        
        var msgArr = [Message]()
        var convKey: String = ""
        if receiverId < currentUser.userId!{
            convKey = receiverId + currentUser.userId!
        }else{
            convKey = currentUser.userId! + receiverId
        }

        databaseRef.child("Conversation").child(convKey).observeSingleEvent(of: .value) { (snapshot) in
            if let msgDict = snapshot.value as? Dictionary<String, Any> {
                print(msgDict)
                
                for item in msgDict {
//                    print(item)
//                    print(item.key)
                  let conversationData = item.value as? Dictionary<String, Any>
                    let msgText = conversationData!["message"] as? String
                    let msgSenderId = conversationData!["senderId"] as? String
                    let msgIncoming = (msgSenderId != currentUserId)
                   
                 
                    let msg = Message(incoming: msgIncoming, text: msgText, timestamp: Int(item.key))
//                   print(conversationData)
                    msgArr.append(msg)
                }
                completion(msgArr)
                
//                print(msgArr[0].text, msgArr[0].timestamp, msgArr[0].incoming)
                
            }
        }
    }

    
}



