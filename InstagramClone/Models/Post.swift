//
//  Post.swift
//  InstagramClone
//
//  Created by Tochi on 17/02/2020.
//  Copyright © 2020 martins. All rights reserved.
//

import Foundation

class Post {
    var id: String?
    var caption: String?
    var photoUrl: String?
    var authorId: String?
}

extension Post{
    static func transformPostPhoto(postId: String, dict: [String: Any]) -> Post {
        let post = Post()
        post.id = postId
        post.caption = dict["caption"] as? String
        post.photoUrl = dict["photoUrl"] as? String
        post.authorId = dict["authorId"] as? String
        return post
    }
}
