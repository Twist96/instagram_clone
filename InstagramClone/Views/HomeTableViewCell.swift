
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
    
    func updateView() {
        aviImageView.image = UIImage.init(named: "photo1")
        usernameLabel.text = "Twist"
        captionLabel.text = post!.caption
        if let photoUrl = post?.photoUrl{
            postImageView.sd_setImage(with: URL(string: photoUrl), completed: nil)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
