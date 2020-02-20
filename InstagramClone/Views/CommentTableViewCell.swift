
import UIKit

class CommentTableViewCell: UITableViewCell {

    @IBOutlet weak var aviImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    
    var comment: Comment?{
        didSet{
            updateComment()
        }
    }
    
    var author: User?{
        didSet{
            updateAuhorsInformation()
        }
    }
    
    func updateComment() {
        commentLabel.text = comment?.text
    }
    
    func updateAuhorsInformation(){
        if let photoUrl = author?.profileImageUrl {
            aviImageView!.sd_setImage(with: URL(string: photoUrl), placeholderImage: UIImage(named: "placeholderImg"))
        }
        nameLabel.text = author?.username
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        nameLabel.text = ""
        commentLabel.text = ""
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
