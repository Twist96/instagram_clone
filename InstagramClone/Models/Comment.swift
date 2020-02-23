//
//  Comment.swift
//  InstagramClone
//
//  Created by Tochi on 20/02/2020.
//  Copyright © 2020 martins. All rights reserved.
//

import Foundation

class Comment {
    var text: String?
    var authorId: String?
}

extension Comment{
    static func transformComment(dict: [String: Any]) -> Comment{
        let comment = Comment()
        comment.text = dict["commentText"] as? String
        comment.authorId = dict["authorId"] as? String
        return comment
    }
}
