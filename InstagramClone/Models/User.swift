//
//  User.swift
//  InstagramClone
//
//  Created by Tochi on 19/02/2020.
//  Copyright © 2020 martins. All rights reserved.
//

import Foundation

class User {
    var email: String?
    var username: String?
    var profileImageUrl: String?
}

extension User{
    static func transformUser(dict: [String: Any]) -> User{
        let user = User()
        user.email = dict["email"] as? String
        user.username = dict["username"] as? String
        user.profileImageUrl = dict["profileImageUrl"] as? String
        return user
    }
}
