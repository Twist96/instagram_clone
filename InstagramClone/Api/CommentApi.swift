
import Foundation
import FirebaseDatabase

class CommentApi {
    
    var REF_COMMENTS = Database.database().reference().child("comments");
    
    func observeComment(commentId: String, onComplete: @escaping (_ comment: Comment) -> Void) {
        REF_COMMENTS.child(commentId).observe(.value) { (snapshot) in
            let dict = snapshot.value as? [String: Any]
            let comment = Comment.transformComment(dict: dict!)
            onComplete(comment)
        }
    }

}
