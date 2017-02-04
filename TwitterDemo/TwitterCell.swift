//
//  TwitterCell.swift
//  TwitterDemo
//
//  Created by Richard Du on 2/4/17.
//  Copyright © 2017 Richard Du. All rights reserved.
//

import UIKit

class TwitterCell: UITableViewCell {

    
    @IBOutlet weak var tweetTextLabel: UILabel!
    
    @IBOutlet weak var favoritesImageView: UIImageView!
    @IBOutlet weak var retweetImageView: UIImageView!
    @IBOutlet weak var retweetsLabel: UILabel!
    @IBOutlet weak var favoritesLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var tweetImageView: UIImageView!
    @IBOutlet weak var profileImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        profileImageView.layer.cornerRadius = 3
        profileImageView.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
