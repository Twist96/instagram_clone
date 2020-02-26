//
//  HelperClass.swift
//  InstagramClone
//
//  Created by Tochi on 23/02/2020.
//  Copyright © 2020 martins. All rights reserved.
//

import Foundation
import FirebaseStorage
import FirebaseDatabase

class HelperClass {
    
    static func UploadPost(imageData: Data, caption: String, onCompletion: @escaping (_ error: Error?) -> Void){
        let photoIdString = NSUUID().uuidString
        let storageRef = Storage.storage().reference().child("posts").child(photoIdString)
        storageRef.putData(imageData, metadata: nil) { (metaData, error) in
            if error != nil{
                onCompletion(error)
            }
            storageRef.downloadURL(completion: { (url, error) in
                if error != nil{
                    onCompletion(error)
                }
                self.saveDataToDatabase(photoUrl: url!.description, caption: caption, onCompletion: onCompletion)
            })
        }
    }
    
    static func saveDataToDatabase(photoUrl: String, caption: String, onCompletion: @escaping (_ error: Error?) -> Void) {
        let postRef = Api.post.REF_POST
        let newPostId = Api.post.REF_POST.childByAutoId().key!
        let newPostReference = postRef.child(newPostId)
        guard let uid = Api.user.CURRENT_USER?.uid  else {
            return
        }
        newPostReference.setValue(["authorId": uid, "photoUrl": photoUrl, "caption": caption]) { (error, dbRef) in
            if error != nil{
                onCompletion(error)
            }
            
            Database.database().reference().child("feed").child(Api.user.CURRENT_USER!.uid).child(newPostId).setValue(true)
            
            let myPostRef = Api.MyPosts.REF_MY_POST.child(uid).child(newPostId)
            myPostRef.setValue(true, withCompletionBlock: { (error, dbRef) in
                if error != nil{
                    onCompletion(error)
                }
            })
            ProgressHUD.showSuccess()
            onCompletion(nil)
        }
    }
}
