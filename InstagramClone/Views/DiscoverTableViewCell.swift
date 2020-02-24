//
//  DiscoverTableViewCell.swift
//  InstagramClone
//
//  Created by Tochi on 24/02/2020.
//  Copyright © 2020 martins. All rights reserved.
//

import UIKit
import SDWebImage

class DiscoverTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    
    var user: User?{
        didSet{
            updateUser()
        }
    }
    
    func updateUser(){
        usernameLabel.text = user?.username
        if let photo = user?.profileImageUrl {
            let photoUrl = URL(string: photo)
            profileImageView.sd_setImage(with: photoUrl, placeholderImage: UIImage(named: "placeholderImg"))
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
