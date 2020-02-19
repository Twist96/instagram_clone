
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
        aviImageView.image = UIImage.init(named: "photo1")
        usernameLabel.text = "Twist"
        captionLabel.text = post!.caption
        if let photoUrl = post?.photoUrl{
            postImageView.sd_setImage(with: URL(string: photoUrl), completed: nil)
        }
    }
    
    func updateAuthorsDetails() {
        self.usernameLabel.text = author?.username
        if let photoUrl = author?.profileImageUrl{
            self.aviImageView!.sd_setImage(with: URL(string: photoUrl), placeholderImage: UIImage(named: "placeholderImg")) //sd_setImage(with: URL(string: photoUrl), completed: nil)
        }
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        usernameLabel.text = ""
        captionLabel.text = ""
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        aviImageView.image = UIImage(named: "placeholderImg")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
