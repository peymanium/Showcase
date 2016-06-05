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
    private var _postDescription : String!
    private var _imageUrl : String?
    private var _imageName : String?
    private var _likes : Int!
    private var _key : String!
    private var _username : String!
    private var _postDate : String!
    private var _postRef : FIRDatabaseReference!
    
    var postDescription : String!
        {
        return self._postDescription
    }
    var imageUrl : String?
    {
        return self._imageUrl
    }
    var likes : Int!
    {
        return self._likes
    }
    var username : String!
    {
        return self._username
    }
    var key : String!
    {
        return self._key
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
        self._key = postKey
        
        if let postDesc = dictionary["description"] as? String
        {
            self._postDescription = postDesc
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
        
        
        //Add a reference to post in firebase
        _postRef = DataServices.ds.REF_POSTS.child(self._key)
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