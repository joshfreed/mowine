//
//  UserTableViewCell.swift
//  mowine
//
//  Created by Josh Freed on 3/6/18.
//  Copyright © 2018 Josh Freed. All rights reserved.
//

import UIKit

protocol UserTableViewCellDelegate: class {
    func addFriend(cell: UserTableViewCell, userId: String)
    func getProfilePicture(_ user: Friends.DisplayedUser, completion: @escaping (UIImage) -> ())
}

class UserTableViewCell: UITableViewCell {
    @IBOutlet weak var profilePictureImageView: UIImageView!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var addFriendButton: UIButton!
    
    weak var delegate: UserTableViewCellDelegate?
    
    private var user: Friends.DisplayedUser?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        
        profilePictureImageView.clipsToBounds = true
        profilePictureImageView.contentMode = .scaleAspectFill
        profilePictureImageView.layer.cornerRadius = self.profilePictureImageView.frame.size.width / 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(user: Friends.DisplayedUser) {
        self.user = user
        profilePictureImageView.image = user.profilePicture
        fullNameLabel.text = user.fullName
        addFriendButton.isHidden = user.isFriend
        
        delegate?.getProfilePicture(user) {
            self.profilePictureImageView.image = $0
        }
    }
    
    @IBAction func tappedAddFriend(_ sender: UIButton) {
        guard let userId = user?.userId else {
            return
        }
        
        addFriendButton.isHidden = true
        
        delegate?.addFriend(cell: self, userId: userId)
    }
    
    func displayIsFriend() {
        addFriendButton.isHidden = true
    }
    
    func displayNotFriend() {
        addFriendButton.isHidden = false
    }
    
    func displayFriendAdded() {
        displayIsFriend()
    }
    
    func displayAddFriendFailed() {
        displayNotFriend()
    }
}
