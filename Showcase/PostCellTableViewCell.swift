//
//  postCellTableViewCell.swift
//  Showcase
//
//  Created by Peyman Attarzadeh on 5/29/16.
//  Copyright © 2016 PeymaniuM. All rights reserved.
//

import UIKit

class PostCellTableViewCell: UITableViewCell {

    @IBOutlet weak var img_profile : UIImageView!
    @IBOutlet weak var img_post : UIImageView!
    @IBOutlet weak var txt_postDesc : UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func drawRect(rect: CGRect) {
        
        self.img_profile.layer.cornerRadius = self.img_profile.frame.width / 2
        self.img_profile.clipsToBounds = true
        
        self.img_post.clipsToBounds = true
        
        //just to start the UITextView from the top of the text
        self.txt_postDesc.contentOffset = CGPointZero
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}