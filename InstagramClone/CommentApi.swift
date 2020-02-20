
import Foundation
import FirebaseDatabase

class CommentApi {
    
    var REF_COMMENT = Database.database().reference().child("comments");
    
    func observeComment(commentId: String, onComplete: @escaping (_ comment: Comment) -> Void) {
        REF_COMMENT.child(commentId).observe(.value) { (snapshot) in
            let dict = snapshot.value as? [String: Any]
            let comment = Comment.transformComment(dict: dict!)
            onComplete(comment)
        }
    }

}
