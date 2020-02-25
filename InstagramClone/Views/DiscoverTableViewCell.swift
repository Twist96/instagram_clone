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
    @IBOutlet weak var followButton: UIButton!
    
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
        if user!.isFollowing!{
            configureUnfollowButton()
        }else{
            configureFollowButton()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        profileImageView.layer.cornerRadius = 30
    }
    
    func configureFollowButton(){
        followButton.layer.borderWidth = 1
        followButton.layer.borderColor = UIColor(red: 226/255, green: 228/255, blue: 232/255, alpha: 1).cgColor
        followButton.layer.cornerRadius = 5
        followButton.clipsToBounds = true
        
        followButton.setTitleColor(UIColor.white, for: .normal)
        followButton.backgroundColor = UIColor(red: 69/255, green: 142/255, blue:  255/255, alpha: 1)
        followButton.setTitle("Follow", for: .normal)
        followButton.addTarget(self, action: #selector(self.followAction), for: .touchUpInside)

    }
    
    func configureUnfollowButton(){followButton.layer.borderWidth = 1
        followButton.layer.borderColor = UIColor(red: 226/255, green: 228/255, blue: 232/255, alpha: 1).cgColor
        followButton.layer.cornerRadius = 5
        followButton.clipsToBounds = true
        
        followButton.setTitleColor(UIColor.black, for: .normal)
        followButton.backgroundColor = UIColor.clear
        followButton.setTitle("Following", for: .normal)
        followButton.addTarget(self, action: #selector(self.unFollowAction), for: .touchUpInside)
    }
    
    
    @objc func followAction() {
        if !user!.isFollowing!{
            Api.Follow.followAction(withUser: user!.id!)
            configureUnfollowButton()
            user?.isFollowing = true
        }
    }
    
    @objc func unFollowAction() {
        if user!.isFollowing!{
            Api.Follow.unfollowAction(withUser: user!.id!)
            configureFollowButton()
            user?.isFollowing = false
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
