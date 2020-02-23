
import UIKit

class HeaderProfileCollectionReusableView: UICollectionReusableView {
    
    @IBOutlet weak var aviImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    
    var user: User! {
        didSet{
            updateView()
        }
    }
    func updateView(){
        self.usernameLabel.text = user.username
        if let imageUrlString = user.profileImageUrl{
            let photoUrl = URL(string: imageUrlString)
            self.aviImageView.sd_setImage(with: photoUrl)
        }
    }
        
}
