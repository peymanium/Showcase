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
        let postRef = DataServices.ds.REF_POSTS.queryOrderedByChild("date")
        
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
    
    
    //Post function using Alamofire and ImageShack
    /*@IBAction func BTN_Post_Tapped(sender: AnyObject)
    {
        
        if let textPost = self.TXT_Post.text where self.TXT_Post.text != ""
        {
            
            if let img = self.IMG_Post.image where imageSelected
            {
                //Upload image using Alamofire Request
                let url = NSURL(string: "https://post.imageshack.us/upload_api.php")!
                
                //Get everything as data
                let keyData = "FZGAV8K6088c481756f752d9816419977ea5062f".dataUsingEncoding(NSUTF8StringEncoding)!
                let imageData = UIImageJPEGRepresentation(img, 0.2)!
                let jSonData = "json".dataUsingEncoding(NSUTF8StringEncoding)!
                
                Alamofire.upload(.POST, url, multipartFormData: { (multipartFormData : MultipartFormData) in
                    
                    //Append all data to multipartFormData
                    multipartFormData.appendBodyPart(data: keyData, name: "key")
                    multipartFormData.appendBodyPart(data: imageData, name: "fileupload", fileName: "image_\(NSDate.timeIntervalSinceReferenceDate())", mimeType: "image/jpg")
                    multipartFormData.appendBodyPart(data: jSonData, name: "format")
                    
                    
                    }, encodingCompletion: { (encodingResult : Manager.MultipartFormDataEncodingResult) in
                       
                        switch encodingResult
                        {
                            
                        case .Success(let upload, _, _):
                            upload.responseJSON(completionHandler: { (response : Response<AnyObject, NSError>) in
                                
                                if let json = response.result.value as? Dictionary<String,AnyObject>
                                {
                                    if let links = json["links"] as? Dictionary<String, AnyObject>
                                    {
                                        if let imageLink = links["image_link"] as? String
                                        {
                                            print (imageLink)
                                            self.PostToFirebase(textPost, postImageUrl: imageLink)
                                        }
                                    }
                                }
                                
                            })
                            
                        case .Failure(let encodingError):
                            print(encodingError)
                        }
                        
                })
                
                //
                
            }
            else
            {
                self.PostToFirebase(textPost, postImageUrl: nil)
            }
            
        }
        
    }*/
    //Image post function using Firebase
    @IBAction func BTN_Post_Tapped(sender: AnyObject)
    {
        
        if let textPost = self.TXT_Post.text where self.TXT_Post.text != ""
        {
            
            if let img = self.IMG_Post.image where imageSelected
            {
                if let imageData = UIImageJPEGRepresentation(img, 0.2)
                {
                    
                    DataServices.ds.REF_STORAGE.child("images").putData(imageData, metadata: nil, completion: { (metadata : FIRStorageMetadata?, error : NSError?) in
                        
                        if error == nil
                        {
                            let imageLink = metadata!.downloadURL()
                            print (imageLink)
                            self.PostToFirebase(textPost, postImageUrl: imageLink?.URLString)
                        }
                        else
                        {
                            print (error.debugDescription)
                        }
                        
                    })
                }
            }
            else
            {
                self.PostToFirebase(textPost, postImageUrl: nil)
            }
            
        }
        
    }
    func PostToFirebase(postText : String, postImageUrl : String?)
    {
        //creat the keys and values
        var postData : Dictionary<String, AnyObject> =
            [ "description" : postText,
              "likes" : 0,
              "date" : -1 * NSDate.timeIntervalSinceReferenceDate()
        ]
        
        if postImageUrl != nil
        {
            postData["imageUrl"] = postImageUrl
        }
        
        DataServices.ds.REF_POSTS.childByAutoId().setValue(postData)
        
        self.TXT_Post.text = ""
        self.imageSelected = false
        self.IMG_Post.image = UIImage(named: "camera")
        
    }

}
