
import UIKit

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
    //var postRef: DatabaseReference?
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
        
        self.updateLike(post: post!)
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
        Api.post.incrementLikes(postId: post!.id!) { (error, post) in
            if error != nil{
                ProgressHUD.showError(error?.localizedDescription)
                return
            }
            self.post?.likes = post?.likes
            self.post?.isLiked = post?.isLiked
            self.post?.likesCount = post?.likesCount
            self.updateLike(post: post!)
        }
        //increamentLikes(forRef: postRef!)
    }

    
    override func prepareForReuse() {
        super.prepareForReuse()
        aviImageView.image = UIImage(named: "placeholderImg")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
