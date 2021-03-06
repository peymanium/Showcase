//
//  FeedsViewController.swift
//  Showcase
//
//  Created by Peyman Attarzadeh on 5/29/16.
//  Copyright © 2016 PeymaniuM. All rights reserved.
//

import UIKit
import Firebase
import Alamofire

class FeedsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var TXT_Post: CustomTextField!
    @IBOutlet weak var IMG_Post: UIImageView!

    
    var posts = [Post]()
    static var imageCache = NSCache() //for caching images in the memory buffer, use static to be a singleton and call from any file in the project
    var imagePicker : UIImagePickerController!
    var imageSelected = false
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.estimatedRowHeight = 411
        
        self.imagePicker = UIImagePickerController()
        self.imagePicker.delegate = self
        
        self.ReadDataFromFirebase()

    }
    func ReadDataFromFirebase()
    {
        //To read firebase for new posts
        let postRef = DataServices.ds.REF_POSTS.queryOrderedByChild("order")
        
        postRef.observeEventType(.Value) { (snapshotData : FIRDataSnapshot!) in
            
            self.posts = []
            if let snapshot = snapshotData.children.allObjects as? [FIRDataSnapshot]
            {
                for snap in snapshot
                {
                    if let dictionaryValues = snap.value as? Dictionary<String,AnyObject>
                    {
                        //print (snap)
                        let key = snap.key
                        
                        let post = Post(postKey: key, dictionary: dictionaryValues)
                        self.posts.append(post)
                    }
                }
            }
            
            self.tableView.reloadData()
        }
        
    }
    
    
    //TableView Delegate functions
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.posts.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let post = self.posts[indexPath.row]
        
        if let cell = tableView.dequeueReusableCellWithIdentifier("CellID") as? PostCell
        {
            cell.firebaseRequest?.cancel() //cancel the Alamofire request if the new row loaded
            
            var cachedImage : UIImage?
            if let imageUrl = post.imageUrl
            {
                cachedImage = FeedsViewController.imageCache.objectForKey(imageUrl) as? UIImage
            }
            
            cell.ConfigureCell(post, cachedImage: cachedImage)
            return cell
        }
        else
        {
            return PostCell()
        }
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        
        let post = posts[indexPath.row]
        
        if post.imageUrl == nil
        {
            return 200
        }
        else
        {
            return tableView.estimatedRowHeight
        }
        
    }
    
    
    @IBAction func IMG_Post_Tapped(sender: UITapGestureRecognizer)
    {
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    //UIImagePicker delegate function
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        imagePicker.dismissViewControllerAnimated(true, completion: nil)
        
        self.IMG_Post.image = image
        self.imageSelected = true
        
    }
    
    
    //Image post function using Firebase
    @IBAction func BTN_Post_Tapped(sender: AnyObject)
    {
        
        if let textPost = self.TXT_Post.text where self.TXT_Post.text != ""
        {
            
            if let img = self.IMG_Post.image where imageSelected
            {
                if let imageData = UIImageJPEGRepresentation(img, 0.2)
                {
                    let imageName = "image_\(NSDate.timeIntervalSinceReferenceDate()).jpg"
                    
                    DataServices.ds.AddImageToFirebase("images", imageName: imageName, imageData: imageData, completion: { (imageURL) in
                        
                        if let imageUrl = imageURL
                        {
                            self.PostFeed(textPost, postImageUrl: imageUrl, postImageName : imageName)
                        }
                        
                    })
                }
            }
            else
            {
                self.PostFeed(textPost, postImageUrl: nil, postImageName: nil)
            }
            
        }
        
    }
    func PostFeed(postText : String, postImageUrl : String?, postImageName : String?)
    {
        //creat the keys and values
        var postData : Dictionary<String, AnyObject> =
            [ "description" : postText,
              "likes" : 0,
              "order" : -1 * NSDate.timeIntervalSinceReferenceDate(),
              "date" : "\(NSDate())",
              "userID" : (FIRAuth.auth()?.currentUser!)!
        ]
        
        if postImageUrl != nil
        {
            postData["imageUrl"] = postImageUrl
            postData["imageName"] = postImageName
        }
        
        
        DataServices.ds.PostToFirebase(postData) { 
            
            self.TXT_Post.text = ""
            self.imageSelected = false
            self.IMG_Post.image = UIImage(named: "camera")
            
        }
        
    }
    
    
    @IBAction func BTN_Signout_Tapped(sender: AnyObject)
    {
        
        let alertViewAction_OK = UIAlertAction(title: "Yes", style: .Default) { (action : UIAlertAction) in
            
            do
            {
                try FIRAuth.auth()?.signOut()
                self.dismissViewControllerAnimated(true, completion: nil)
            }
            catch let error as NSError
            {
                print (error.debugDescription)
            }
            
        }
        let alertViewAction_Cancel = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
            
            let alertView = UIAlertController(title: "Logout?", message: "Are you sure you want to logout?", preferredStyle: .Alert)
            alertView.addAction(alertViewAction_OK)
            alertView.addAction(alertViewAction_Cancel)

        self.presentViewController(alertView, animated: true, completion: nil)
    }
    
    
    @IBAction func BTN_Setting_Tapped(sender: AnyObject)
    {
        self.performSegueWithIdentifier(SEGUE_SETTING, sender: nil)
        
    }
    
    
    

}
