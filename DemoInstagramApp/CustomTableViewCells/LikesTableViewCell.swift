//
//  LikesTableViewCell.swift
//  DemoInstagramApp
//
//  Created by Ady on 8/10/18.
//  Copyright © 2018 RJTCompuquest. All rights reserved.
//

import UIKit

class LikesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var userImgView: UIImageView!
    @IBOutlet weak var userNameLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        userImgView.layer.cornerRadius = userImgView.frame.size.height/2
        userImgView.layer.borderWidth = 1.0
        userImgView.layer.borderColor = UIColor.lightGray.cgColor
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
