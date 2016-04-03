//
//  HeadFeedTableViewCell.swift
//  InstagramSwift
//
//  Created by Daramony on 4/2/16.
//  Copyright © 2016 Daramony. All rights reserved.
//

import UIKit

class HeadFeedTableViewCell: UITableViewCell {
    
    @IBOutlet weak var avatarImageView : UIImageView!
    @IBOutlet weak var fullnameLabel : UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
