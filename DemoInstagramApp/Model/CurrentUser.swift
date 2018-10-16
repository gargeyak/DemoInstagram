//
//  CurrentUser.swift
//  DemoInstagramApp
//
//  Created by Ady on 8/2/18.
//  Copyright © 2018 RJTCompuquest. All rights reserved.
//

import Foundation

//class CurrentUser {
//
//var firstName : String?
//var lastName : String?
//var email : String?
//var phoneNo : Int?
//var password : String?
//var confirmPassword : String?
//var userId : String?
//
////var profileImageUrl: URL?
//var website: String?
//var bio: String?
//var gender: String?
//var posts: [String] = []
//var following: [String] = []
//var followers: [String] = []
//
//    init(firstName: String, lastName: String, email: String, phoneNo: Int, password: String, confirmPassword: String, userId: String, /*profileImageUrl: URL,*/ website: String, bio: String, gender: String, posts: [String], following: [String], followers: [String]) {
//
//        self.firstName = firstName
//        self.lastName = lastName
//        self.email = email
//        self.phoneNo = phoneNo
//        self.password = password
//        self.confirmPassword = confirmPassword
//        self.userId = userId
////        self.profileImageUrl = profileImageUrl
//        self.website = website
//        self.bio = bio
//        self.gender = gender
//        self.posts = posts
//        self.following = following
//        self.followers = followers
//    }
//}


class CurrentUser: NSObject {
    struct Static {
        static var instance: CurrentUser?
    }

    class var sharedInstance: CurrentUser {
        if Static.instance == nil
        {
            Static.instance = CurrentUser()
        }

        return Static.instance!
    }

    func dispose() {
        CurrentUser.Static.instance = nil
        print("Disposed Singleton instance")
    }

    private override init() {}

    var firstName : String?
    var lastName : String?
    var email : String?
    var phoneNo : Int?
    var password : String?
    var confirmPassword : String?
    var userId : String?

    var profileImageUrl: String?
    var website: String?
    var bio: String?
    var gender: String?
    var posts: [String] = []
    var following: [String] = []
    var followers: [String] = []
}
