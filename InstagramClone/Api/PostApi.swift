//
//  PostApi.swift
//  InstagramClone
//
//  Created by Tochi on 20/02/2020.
//  Copyright © 2020 martins. All rights reserved.
//

import Foundation
import FirebaseDatabase
class PostApi {
    
    var REF_POST = Database.database().reference().child("posts");
    
    func observePosts(onComplete: @escaping (_ post: Post) -> Void) {
        REF_POST.observe(.childAdded) { (snapshot) in
            if let dict = snapshot.value as? [String: Any]{
                let post = Post.transformPostPhoto(postId: snapshot.key, dict: dict)
                onComplete(post)
            }
        }
    }
    
    func observePost(withId id: String, onCompletion: @escaping (_ post: Post) -> Void) {
        REF_POST.child(id).observeSingleEvent(of: .value) { (snapshot) in
            if let dict = snapshot.value as? [String: Any]{
                let post = Post.transformPostPhoto(postId: snapshot.key, dict: dict)
                onCompletion(post)
            }
        }
    }
}
