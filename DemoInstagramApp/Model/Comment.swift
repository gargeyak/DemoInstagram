//
//  Comment.swift
//  DemoInstagramApp
//
//  Created by Ady on 8/9/18.
//  Copyright © 2018 RJTCompuquest. All rights reserved.
//

import Foundation

class Comment{
    var commentId: String?
    var userId: String?
    var commentDes: String?
    var postId: String?
    var timestamp: Int?
    
    init(commentId: String?, userId: String?, commentDes: String?, postId: String?, timestamp: Int?)
    {
        self.commentId = commentId
        self.commentDes = commentDes
        self.userId = userId
        self.postId = postId
        self.timestamp = timestamp
    }
}
