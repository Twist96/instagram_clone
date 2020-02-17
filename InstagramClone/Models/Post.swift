//
//  Post.swift
//  InstagramClone
//
//  Created by Tochi on 17/02/2020.
//  Copyright © 2020 martins. All rights reserved.
//

import Foundation

class Post {
    var caption: String?
    var photoUrl: String?
}

extension Post{
    static func transformPostPhoto(dict: [String: Any]) -> Post {
        let post = Post()
        post.caption = dict["caption"] as? String
        post.photoUrl = dict["photoUrl"] as? String
        return post
    }
}
