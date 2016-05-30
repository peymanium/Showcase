//
//  postCellTableViewCell.swift
//  Showcase
//
//  Created by Peyman Attarzadeh on 5/29/16.
//  Copyright © 2016 PeymaniuM. All rights reserved.
//

import UIKit

class PostCell: UITableViewCell {

    @IBOutlet weak var img_profile : UIImageView!
    @IBOutlet weak var img_post : UIImageView!
    @IBOutlet weak var txt_postDesc : UITextView!
    @IBOutlet weak var lbl_likes : UILabel!
    
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

    func ConfigureCell(post : Post, cachedImage : UIImage?)
    {
        self.txt_postDesc.text = post.postDescription
        self.lbl_likes.text = "\(post.likes)"
        
        if post.imageUrl == nil
        {
            self.img_post.hidden = true
        }
        else
        {
            if cachedImage != nil
            {
                self.img_post.image = cachedImage
            }
        }
        
    }
    
}
