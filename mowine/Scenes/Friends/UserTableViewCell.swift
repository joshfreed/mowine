//
//  UserTableViewCell.swift
//  mowine
//
//  Created by Josh Freed on 3/6/18.
//  Copyright © 2018 Josh Freed. All rights reserved.
//

import UIKit

class UserTableViewCell: UITableViewCell {
    @IBOutlet weak var profilePictureImageView: UIImageView!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var addFriendButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(user: Friends.DisplayedUser) {
        profilePictureImageView.image = user.profilePicture
        fullNameLabel.text = user.fullName
        addFriendButton.isHidden = user.isFriend
    }
    
    @IBAction func tappedAddFriend(_ sender: UIButton) {
    }
}
