//
//  DataServices.swift
//  Showcase
//
//  Created by Peyman Attarzadeh on 5/28/16.
//  Copyright © 2016 PeymaniuM. All rights reserved.
//

import Foundation
import Firebase
import Alamofire

let URL_BASE = FIRDatabase.database().reference()
let STORAGE_BASE = FIRStorage.storage().reference()//.referenceForURL("gs://peymanium-showcase.appspot.com")

class DataServices
{
    static let ds = DataServices()
    
    private var _REF_BASE = URL_BASE
    private var _REF_POSTS = URL_BASE.child("Posts")
    private var _REF_USERS = URL_BASE.child("Users")
    private var _REF_CURRENT_USER = URL_BASE.child("Users")
    private var _REF_STORAGE = STORAGE_BASE
    
    var REF_BASE : FIRDatabaseReference
        {
        return self._REF_BASE
    }
    var REF_POSTS : FIRDatabaseReference
        {
        return self._REF_POSTS
    }
    var REF_USERS : FIRDatabaseReference
        {
        return self._REF_USERS
    }
    var REF_CURRENT_USER : FIRDatabaseReference
    {
        let uid = FIRAuth.auth()?.currentUser?.uid
        let currentUser = _REF_CURRENT_USER.child(uid!)
        
        return currentUser
    }
    var REF_STORAGE : FIRStorageReference
    {
        return self._REF_STORAGE
    }
    
    
    func CreateFirebaseUser (uid : String, user : Dictionary<String,String>)
    {
        //REF_USERS.child(uid).setValue(user)  //OR
        REF_USERS.child(uid).updateChildValues(user)
    }

    
    //POST
    func PostToFirebase(postData : Dictionary<String, AnyObject>, completion : () -> Void)
    {
        let postRef = DataServices.ds.REF_POSTS.childByAutoId()
        postRef.setValue(postData)
        
        
        //Add this post in Users table
        DataServices.ds.REF_CURRENT_USER.child("posts").child(postRef.key).setValue(NSDate.timeIntervalSinceReferenceDate())
        
        completion()
    }
    
    
    //ADD IMAGE
    func AddImageToFirebase(folder : String!, imageName : String!, imageData : NSData!, completion : (imageURL : String?) -> Void)
    {
        
        DataServices.ds.REF_STORAGE.child(folder).child(imageName).putData(imageData, metadata: nil, completion: { (metadata : FIRStorageMetadata?, error : NSError?) in
            
            if error == nil
            {
                let imageLink = metadata!.downloadURL()
                completion(imageURL: imageLink?.URLString)
            }
            else
            {
                print (error.debugDescription)
                completion(imageURL : nil)
            }
            
        })
    }
    
    
    //LOAD IMAGE
    func LoadImageFromAlamofire(imageUrl : String!, completion : (imageResult : UIImage?) -> Void)
    {
        let url = NSURL(string: imageUrl)
        
        Alamofire.request(.GET, url!).validate(contentType: ["image/*"]).response(completionHandler: { (request : NSURLRequest?, response : NSHTTPURLResponse?, data : NSData?, error : NSError?) in
            
            if error == nil
            {
                let imageFromData = UIImage(data: data!)
                completion(imageResult: imageFromData)
            }
            else
            {
                print (error.debugDescription)
                completion(imageResult: nil)
            }
            
        })
    }
    func LoadImageFromFirebase(folder : String, imageName : String!, completion : (resultImage : UIImage?) -> Void)
    {
        
        DataServices.ds.REF_STORAGE.child(folder).child(imageName).dataWithMaxSize(1*1024*1024, completion: { (data : NSData?, error : NSError?) in
            
            if error == nil
            {
                let imageFromData = UIImage(data: data!)
                completion(resultImage:  imageFromData)
                
            }
            else
            {
                print (error.debugDescription)
                completion(resultImage: nil)
            }
            
        }).observeStatus(.Progress) { (snapshot : FIRStorageTaskSnapshot) in
            
            if let progress = snapshot.progress where progress.totalUnitCount > 0
            {
                let percentComplete = (Int)(100 * (Double)(progress.completedUnitCount) / (Double)(progress.totalUnitCount))
                print ("\(percentComplete)% Completed")
            }
        }
    }
}