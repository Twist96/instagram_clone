
import Foundation
import FirebaseDatabase

class FeedApi {
    let REF_POST = Database.database().reference().child("feed")
    
    func observeFeeds(withid id: String, onComplete: @escaping (Post) -> Void)  {
        REF_POST.child(id).observe(.childAdded) { (snapshot) in
            let key = snapshot.key
            Api.post.observePost(withId: key, onCompletion: { (post) in
                onComplete(post)
            })
        }
    }
    
    func observeRemoveFeeds(withid id: String, onComplete: @escaping (_ postId: String) -> Void) {
        REF_POST.child(id).observe(.childRemoved) { (snapshot) in
            let key = snapshot.key
            onComplete(snapshot.key)
        }
    }
}
