//
//  FriendsChatTableViewCell.swift
//  DemoInstagramApp
//
//  Created by Ady on 8/20/18.
//  Copyright © 2018 RJTCompuquest. All rights reserved.
//

import UIKit

class FriendsChatTableViewCell: UITableViewCell {

    @IBOutlet weak var friendImageView: UIImageView!
    @IBOutlet weak var friendNameLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        friendImageView.layer.cornerRadius = friendImageView.frame.size.height/2
        friendImageView.layer.borderColor = UIColor.lightGray.cgColor
        friendImageView.layer.borderWidth = 1.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
