//
//  Posts.swift
//  DemoInstagramApp
//
//  Created by Ady on 8/6/18.
//  Copyright © 2018 RJTCompuquest. All rights reserved.
//

import Foundation

class Posts {
    
    var postId : String?
    var userId : String?
    var description : String?
    var timestamp : Int?
    var postImageUrl: String?
    var userObj : PublicUser?
    var numOfLikes: Int?
    var likedBy: [String]?
    
    init(postId: String, userId:String, description: String, timestamp: Int, postImageUrl: String, userObj: PublicUser?, numOfLikes: Int?, likedBy: [String]?){
        
        self.postId = postId
        self.userId = userId
        self.description = description
        self.timestamp = timestamp
        self.postImageUrl = postImageUrl
        self.userObj = userObj
        self.numOfLikes = numOfLikes
        self.likedBy = likedBy
    }
}
