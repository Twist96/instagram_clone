//
//  Post.swift
//  InstagramClone
//
//  Created by Tochi on 17/02/2020.
//  Copyright © 2020 martins. All rights reserved.
//

import Foundation
import FirebaseAuth

class Post {
    var id: String?
    var caption: String?
    var photoUrl: String?
    var authorId: String?
    var likesCount: Int?
    var likes: Dictionary<String, Any>?
    var isLiked: Bool?
}

extension Post{
    static func transformPostPhoto(postId: String, dict: [String: Any]) -> Post {
        let post = Post()
        post.id = postId
        post.caption = dict["caption"] as? String
        post.photoUrl = dict["photoUrl"] as? String
        post.authorId = dict["authorId"] as? String
        post.likesCount = dict["likesCount"] as? Int
        post.likes = dict["likes"] as? Dictionary<String, Any>
        if let uid = Auth.auth().currentUser?.uid{
            if post.likes != nil{
                post.isLiked = post.likes![uid] != nil
            }
        }
        
        return post
    }
}
