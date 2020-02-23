//
//  AuthService.swift
//  InstagramClone
//
//  Created by Tochi on 15/02/2020.
//  Copyright © 2020 martins. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

class AuthService {
    
    
    static func SignIn(email: String, password: String, onComplete: @escaping (_ error: Error?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if error != nil{
                onComplete(error)
                return
            }
            onComplete(nil)
        }
    }
    
    static func SignUp(profileImage: UIImage, username: String, email: String, password: String, onComplete: @escaping (_ error: Error?) -> Void){
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if error != nil{
                onComplete(error)
                return
            }
            let uid = result!.user.uid
            
            let storageRef = Storage.storage().reference().child("users_profile").child(uid)
            if let data = profileImage.jpegData(compressionQuality: 0.1){
                storageRef.putData(data, metadata: nil, completion: { (metaData, error) in
                    if error != nil{
                        return
                    }
                    storageRef.downloadURL(completion: { (url, error) in
                        if error != nil{
                            return
                        }
                        self.setUserInformation(username: username, email: email, imageUrl: url!.absoluteString, uid: uid, onComplete: onComplete)
                    })
                })
            }else{
            }
            
        }
    }
    
    static func setUserInformation(username: String, email: String, imageUrl: String, uid: String, onComplete: @escaping (_ error: Error?) -> Void) {
        let ref = Database.database().reference()
        let userReference = ref.child("user")
        let newUserRefernce = userReference.child(uid)
        newUserRefernce.setValue(["username": username, "email": email, "profileImageUrl": imageUrl])
        onComplete(nil)
    }
}
