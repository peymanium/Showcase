//
//  postCellTableViewCell.swift
//  Showcase
//
//  Created by Peyman Attarzadeh on 5/29/16.
//  Copyright © 2016 PeymaniuM. All rights reserved.
//

import UIKit
import Alamofire
import Firebase

class PostCell: UITableViewCell {

    @IBOutlet weak var lbl_username : UILabel!
    @IBOutlet weak var img_profile : UIImageView!
    @IBOutlet weak var img_post : UIImageView!
    @IBOutlet weak var txt_postDesc : UITextView!
    @IBOutlet weak var lbl_likes : UILabel!
    @IBOutlet weak var img_heart : UIImageView!
    @IBOutlet weak var lbl_postDate : UILabel!

    var post : Post!
    var firebaseRequest : Request?
    var likeRef : FIRDatabaseReference!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
        
        //Add tapGesture for Img_Heart
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(IMG_Heart_Tapped))
        tapGesture.numberOfTapsRequired = 1
        self.img_heart.addGestureRecognizer(tapGesture)
        self.img_heart.userInteractionEnabled = true
    }
    
    
    override func drawRect(rect: CGRect)
    {
        self.img_post.clipsToBounds = true
        
        //just to start the UITextView from the top of the text
        self.txt_postDesc.contentOffset = CGPointZero
        
    }

    
    func ConfigureCell(post : Post, cachedImage : UIImage?)
    {
        self.post = post

        self.txt_postDesc.text = self.post.postDescription
        self.lbl_postDate.text = self.post.postDate
        self.lbl_likes.text = "\(self.post.likes)"
        
        
        
        //GET Username and his profile image
        let userRef = DataServices.ds.REF_USERS.child(self.post.userID)
        userRef.observeSingleEventOfType(.Value) { (snapshot : FIRDataSnapshot) in
            
            if let details = snapshot.value as? Dictionary<String, AnyObject>
            {
                if let profileImageName = details["profileImageName"] as? String
                {
                    DataServices.ds.LoadImageFromFirebase("profile", imageName : profileImageName, completion: { (resultImage) in
                        
                        if let image = resultImage
                        {
                            self.img_profile.image = image
                        }
                    })
                }
                
                if let username = details["username"] as? String
                {
                    self.lbl_username.text = username
                }
                
            }
            
        }
        
        
        
        if self.post.imageUrl == nil //There is no image set by user in firebase
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
                DataServices.ds.LoadImageFromFirebase("images", imageName : self.post.imageName, completion: { (resultImage) in
                    
                    if let image = resultImage
                    {
                        self.img_post.image = image
                        FeedsViewController.imageCache.setObject(image, forKey: self.post.imageUrl!)
                    }
                    
                })
                
                /*DataServices.ds.LoadImageFromAlamofire(self.post.imageUrl, completion: { (imageResult) in
                    
                    if let image = resultImage
                    {
                        self.img_post.image = image
                        FeedsViewController.imageCache.setObject(image, forKey: self.post.imageUrl!)
                    }
                    
                })*/
                
            }
        }
        
        
        //Now check the heart image
        likeRef = DataServices.ds.REF_CURRENT_USER.child("likes").child(post.postID)
        likeRef.observeSingleEventOfType(.Value) { (snapshot : FIRDataSnapshot!) in
            
            //if let value = snapshot.value as? NSNull
            if let value = snapshot.value where value is NSNull
            {
                self.img_heart.image = UIImage(named: "heart-empty")
            }
            else
            {
                self.img_heart.image = UIImage(named: "heart-full")
            }
        }
        
    }

    
    
    @IBAction func IMG_Heart_Tapped (sender : UIGestureRecognizer)
    {
        likeRef.observeSingleEventOfType(.Value) { (snapshot : FIRDataSnapshot!) in
            
            if let value = snapshot.value where value is NSNull
            {
                self.img_heart.image = UIImage(named: "heart-full")
                self.post.UpdateLikes(true)
                self.likeRef.setValue(NSDate.timeIntervalSinceReferenceDate())
            }
            else
            {
                self.img_heart.image = UIImage(named: "heart-empty")
                self.post.UpdateLikes(false)
                self.likeRef.removeValue()
            }
        }
        
    }
    
    
}
