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
    
    func observeLikeCount(postId: String, onCompletion: @escaping (_ likes: Int) -> Void) {
        REF_POST.child(postId).observe(.childChanged) { (snapshot) in
            //self.updateLike(post: self.post!)
            if let likes = snapshot.value as? Int{
                onCompletion(likes)
            }
        }
    }
    
    func incrementLikes(postId: String, onCompletion: @escaping (_ error: Error?, _ post: Post?) -> Void) {
        let postRef = Api.post.REF_POST.child(postId)
        postRef.runTransactionBlock({ (currentData) -> TransactionResult in
            if var post = currentData.value as? [String: AnyObject], let uid = Api.user.CURRENT_USER?.uid{
                var likes: Dictionary<String, Bool>
                likes = post["likes"] as? [String: Bool] ?? [:]
                var likesCount = post["likesCount"] as? Int ?? 0
                if let _ = likes[uid]{
                    likesCount -= 1
                    likes.removeValue(forKey: uid)
                }else{
                    likesCount += 1
                    likes[uid] = true
                }
                post["likesCount"] = likesCount as AnyObject
                post["likes"] = likes as AnyObject
                
                currentData.value = post
                return TransactionResult.success(withValue: currentData)
            }
            return TransactionResult.success(withValue: currentData)
        }) { (error, commited, snapshot) in
            if let error = error{
                onCompletion(error, nil)
            }
            let post = Post.transformPostPhoto(postId: snapshot!.key, dict: snapshot!.value! as! [String : Any])
            onCompletion(nil, post)
        
        }
    }
}
