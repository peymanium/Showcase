//
//  Post.swift
//  Showcase
//
//  Created by Peyman Attarzadeh on 5/30/16.
//  Copyright © 2016 PeymaniuM. All rights reserved.
//

import Foundation
import Firebase

class Post
{
    private var _description : String!
    private var _imageUrl : String?
    private var _imageName : String?
    private var _likes : Int!
    private var _postID : String!
    private var _userID : String!
    private var _postDate : String!
    
    private var _postRef : FIRDatabaseReference!
    
    var postDescription : String!
        {
        return self._description
    }
    var imageUrl : String?
    {
        return self._imageUrl
    }
    var likes : Int!
    {
        return self._likes
    }
    var userID : String!
    {
        return self._userID
    }
    var postID : String!
    {
        return self._postID
    }
    var postDate : String!
    {
        return self._postDate
    }
    var imageName : String?
    {
        return self._imageName
    }

    
    
    init(postKey : String!, dictionary : Dictionary<String, AnyObject>)
    {
        self._postID = postKey
        
        if let postDesc = dictionary["description"] as? String
        {
            self._description = postDesc
        }
        if let imageUrl = dictionary["imageUrl"] as? String
        {
            self._imageUrl = imageUrl
        }
        if let likes = dictionary["likes"] as? Int
        {
            self._likes = likes
        }
        if let postDate = dictionary["date"] as? String!
        {
            self._postDate = postDate
        }
        if let imageName = dictionary["imageName"] as? String
        {
            self._imageName = imageName
        }
        if let userID = dictionary["userID"] as? String
        {
            self._userID = userID
        }
        
        
        //Add a reference to post in firebase
        _postRef = DataServices.ds.REF_POSTS.child(self._postID)
    }
    
    
    func UpdateLikes(liked : Bool)
    {
        if liked
        {
            self._likes = self._likes + 1
        }
        else
        {
            self._likes = self._likes - 1
        }
        
        //update likes field for Post
        _postRef.child("likes").setValue(self._likes)
    }
    
}