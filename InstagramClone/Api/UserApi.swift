//
//  UserApi.swift
//  InstagramClone
//
//  Created by Tochi on 20/02/2020.
//  Copyright © 2020 martins. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth

class UserApi {
    
    var REF_USER = Database.database().reference().child("user");
    var REF_CURRENT_USER: DatabaseReference?{
        guard let uid = Auth.auth().currentUser?.uid else {
            return nil
        }
        return REF_USER.child(uid)
    }
    

    
    func observeUser(userId: String, onComplete: @escaping (_ post: User) -> Void) {
        REF_USER.child(userId).observeSingleEvent(of: .value) { (snapshot) in
            if let dict = snapshot.value as? [String: Any]{
                let user = User.transformUser(dict: dict)
                onComplete(user)
            }
        }
    }
    
    func observeCurrentUser(onComplete: @escaping (_ post: User) -> Void) {
        REF_CURRENT_USER!.observeSingleEvent(of: .value) { (snapshot) in
            if let dict = snapshot.value as? [String: Any]{
                let user = User.transformUser(dict: dict)
                onComplete(user)
            }
        }
    }
    
}
