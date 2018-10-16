//
//  HomeTableViewCell.swift
//  DemoInstagramApp
//
//  Created by Ady on 8/6/18.
//  Copyright © 2018 RJTCompuquest. All rights reserved.
//

import UIKit

class HomeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var userProfileImg: UIImageView!
    @IBOutlet weak var userProfileLabel: UILabel!
    @IBOutlet weak var userPostView: UIImageView!
    @IBOutlet weak var userPostDesc: UITextView!
    
    @IBOutlet weak var likeBtnOutlet: UIButton!
    @IBOutlet weak var commentBtnOutlet: UIButton!
    @IBOutlet weak var shareBtnOutlet: UIButton!
    @IBOutlet weak var timeStamp: UILabel!
    @IBOutlet weak var numberOfLikes: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        userProfileImg.layer.cornerRadius = userProfileImg.frame.size.height/2
        userProfileImg.layer.borderWidth = 1.0
        userProfileImg.layer.borderColor = UIColor.lightGray.cgColor
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
