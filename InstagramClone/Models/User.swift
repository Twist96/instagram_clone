//
//  User.swift
//  InstagramClone
//
//  Created by Tochi on 19/02/2020.
//  Copyright © 2020 martins. All rights reserved.
//

import Foundation

class User {
    var id: String?
    var email: String?
    var username: String?
    var profileImageUrl: String?
    var isFollowing: Bool?
}

extension User{
    static func transformUser(uid: String, dict: [String: Any]) -> User{
        let user = User()
        user.id = uid
        user.email = dict["email"] as? String
        user.username = dict["username"] as? String
        user.profileImageUrl = dict["profileImageUrl"] as? String
        return user
    }
}
