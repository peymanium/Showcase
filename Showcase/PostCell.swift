//
//  postCellTableViewCell.swift
//  Showcase
//
//  Created by Peyman Attarzadeh on 5/29/16.
//  Copyright © 2016 PeymaniuM. All rights reserved.
//

import UIKit
import Alamofire

class PostCell: UITableViewCell {

    @IBOutlet weak var img_profile : UIImageView!
    @IBOutlet weak var img_post : UIImageView!
    @IBOutlet weak var txt_postDesc : UITextView!
    @IBOutlet weak var lbl_likes : UILabel!
    
    var firebaseRequest : Request?
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    override func drawRect(rect: CGRect)
    {
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
        
        if post.imageUrl == nil //There is no image set by user in firebase
        {
            self.img_post.hidden = true
        }
        else
        {
            //Check if image with the key=ImageURL valid in cache, then send it to confirgure cell
            if cachedImage != nil
            {
                self.img_post.image = cachedImage
            }
            else //load image from interner
            {
                let url = NSURL(string: post.imageUrl!)
                
                firebaseRequest = Alamofire.request(.GET, url!).validate(contentType: ["image/*"]).response(completionHandler: { (request : NSURLRequest?, response : NSHTTPURLResponse?, data : NSData?, error : NSError?) in
                    
                    if error == nil
                    {
                        let imageFromData = UIImage(data: data!)
                        self.img_post.image = imageFromData
                        
                        FeedsViewController.imageCache.setObject(self.img_post.image!, forKey: post.imageUrl!)
                        
                    }
                    
                })
                
            }
        }
        
        print ("\(self.img_post.frame.origin.y) \(self.img_post.frame.origin.y)")
        
    }
    
}
