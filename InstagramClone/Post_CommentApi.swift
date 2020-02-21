//
//  Post_CommentApi.swift
//  InstagramClone
//
//  Created by Tochi on 21/02/2020.
//  Copyright © 2020 martins. All rights reserved.
//

import Foundation
import FirebaseDatabase

class Post_CommentApi {
    var REF_COMMENTS = Database.database().reference().child("post-comments")
    
    func observeComment(postId: String, onComplete: @escaping (_ postId: String) -> Void) {
        REF_COMMENTS.child(postId).observe(.childAdded) { (snapshot) in
            onComplete(snapshot.key)
        }
    }
}
