//
//  UserApi.swift
//  InstagramClone
//
//  Created by Tochi on 20/02/2020.
//  Copyright © 2020 martins. All rights reserved.
//

import Foundation
import FirebaseDatabase

class UserApi {
    
    var REF_USER = Database.database().reference().child("user");
    
    func observeUser(userId: String, onComplete: @escaping (_ post: User) -> Void) {
        REF_USER.child(userId).observe(.value) { (snapshot) in
            if let dict = snapshot.value as? [String: Any]{
                let user = User.transformUser(dict: dict)
                onComplete(user)
            }
        }
    }
    
}
