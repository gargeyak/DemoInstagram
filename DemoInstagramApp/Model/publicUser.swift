//
//  publicUser.swift
//  DemoInstagramApp
//
//  Created by Ady on 8/6/18.
//  Copyright © 2018 RJTCompuquest. All rights reserved.
//

import Foundation

class PublicUser {
    
    
    var firstName : String?
    var lastName : String?
    var password: String?
    var userId: String?
    var email: String?
    var profileImageUrl: String?
    var postId: String?
    var phoneNo: String?
    
    init(firstName : String?, lastName : String?, password: String?, userId: String?, email: String?, profileImageUrl: String?, postId: String?, phoneNo: String?){
        
        self.firstName = firstName
        self.lastName = lastName
        self.password = password
        self.userId = userId
        self.email = email
        self.profileImageUrl = profileImageUrl
        self.postId = postId
        self.phoneNo = phoneNo
    }
}



