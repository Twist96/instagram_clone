
import UIKit
import FirebaseDatabase
import FirebaseAuth

class HomeTableViewCell: UITableViewCell {

    @IBOutlet weak var aviImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var likeImageView: UIImageView!
    @IBOutlet weak var commentImageView: UIImageView!
    @IBOutlet weak var shareImageView: UIImageView!
    @IBOutlet weak var likesNumberCount: UIButton!
    @IBOutlet weak var captionLabel: UILabel!
    
    var homeVC: HomeViewController?
    var postRef: DatabaseReference?
    var post: Post?{
        didSet{
           updateView()
        }
    }
    
    var author: User?{
        didSet{
            updateAuthorsDetails()
        }
    }
    
    func updateView() {
        captionLabel.text = post!.caption
        if let photoUrl = post?.photoUrl{
            postImageView.sd_setImage(with: URL(string: photoUrl), completed: nil)
        }
        
        Api.post.REF_POST.child(post!.id!).observeSingleEvent(of: .value) { (snapshot) in
            let post = Post.transformPostPhoto(postId: snapshot.key, dict: snapshot.value! as! [String : Any])
            self.updateLike(post: post)
        }
        
        Api.post.REF_POST.child(post!.id!).observe(.childChanged) { (snapshot) in
            //self.updateLike(post: self.post!)
            if let value = snapshot.value as? Int{
                self.likesNumberCount.setTitle("\(value) likes", for: .normal)
            }
        }
    }
    
    func updateAuthorsDetails() {
        usernameLabel.text = author?.username
        if let photoUrl = author?.profileImageUrl{
            self.aviImageView!.sd_setImage(with: URL(string: photoUrl), placeholderImage: UIImage(named: "placeholderImg"))
        }
    }
    
    func updateLike(post: Post) {
        let imageName = post.likes == nil || !post.isLiked! ? "like" : "likeSelected"
        likeImageView.image = UIImage(named: imageName)
        
        
        if let count = post.likesCount, count != 0 {
            likesNumberCount.setTitle("\(count) likes", for: .normal)
        }else{
            likesNumberCount.setTitle("Be the first to like this post", for: .normal)
        }
        
        Api.post.REF_POST.child(post.id!).observe(.childChanged) { (snapshot) in
            if let value = snapshot.value as? Int{
                self.likesNumberCount.setTitle("\(value) likes", for: .normal)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        usernameLabel.text = ""
        captionLabel.text = ""
        
        let commentTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.commentTapped))
        commentImageView.addGestureRecognizer(commentTapGesture)
        commentImageView.isUserInteractionEnabled = true
        
        let likeTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.likeImage_TouchUpInside))
        likeImageView.addGestureRecognizer(likeTapGesture)
        likeImageView.isUserInteractionEnabled = true
    }
    
    @objc func commentTapped() {
        if let  postId = post?.id{
            homeVC!.performSegue(withIdentifier: "comment_segue", sender: postId)
        }
    }
    
    @objc func likeImage_TouchUpInside(){
        postRef = Api.post.REF_POST.child(post!.id!)
        increamentLikes(forRef: postRef!)
    }
    
    func increamentLikes(forRef ref: DatabaseReference) {
        ref.runTransactionBlock({ (currentData) -> TransactionResult in
            if var post = currentData.value as? [String: AnyObject], let uid = Auth.auth().currentUser?.uid{
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
                print(error.localizedDescription)
            }
            let post = Post.transformPostPhoto(postId: snapshot!.key, dict: snapshot!.value! as! [String : Any])
            self.updateLike(post: post)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        aviImageView.image = UIImage(named: "placeholderImg")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
