
import Foundation
import FirebaseDatabase

class FollowApi {
    var REF_FOLLOWERS = Database.database().reference().child("followers")
    var REF_FOLLOWING = Database.database().reference().child("following")
    
    func followAction(withUser id: String) {
        Api.MyPosts.REF_MY_POST.child(id).observeSingleEvent(of: .value) { (snapshot) in
            if let dict = snapshot.value as? [String: Any]{
                for key in dict.keys{
                    Database.database().reference().child("feed").child(Api.user.CURRENT_USER!.uid).child(key).setValue(true)
                }
            }
        }
        Api.Follow.REF_FOLLOWERS.child(id).child(Api.user.CURRENT_USER!.uid).setValue(true)
        Api.Follow.REF_FOLLOWING.child(Api.user.CURRENT_USER!.uid).child(id).setValue(true)
    }
    
    func unfollowAction(withUser id: String) {
        Api.Follow.REF_FOLLOWERS.child(id).child(Api.user.CURRENT_USER!.uid).setValue(NSNull())
        Api.Follow.REF_FOLLOWING.child(Api.user.CURRENT_USER!.uid).child(id).setValue(NSNull())
    }
    
    func isFollowing(userId: String, onComplete: @escaping (Bool) -> Void) {
        Api.MyPosts.REF_MY_POST.child(userId).observeSingleEvent(of: .value) { (snapshot) in
            if let dict = snapshot.value as? [String: Any]{
                for key in dict.keys{
                    Database.database().reference().child("feed").child(Api.user.CURRENT_USER!.uid).child(key).removeValue()
                }
            }
        }
        REF_FOLLOWERS.child(userId).child(Api.user.CURRENT_USER!.uid).observeSingleEvent(of: .value) { (snapshot) in
            if let _ = snapshot.value as? NSNull{
                onComplete(false)
            }else{
                onComplete(true)
            }
        }
    }
}
