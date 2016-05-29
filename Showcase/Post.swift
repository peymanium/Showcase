//
//  Post.swift
//  Showcase
//
//  Created by Peyman Attarzadeh on 5/30/16.
//  Copyright © 2016 PeymaniuM. All rights reserved.
//

import Foundation

class Post
{
    private var _postDescription : String!
    private var _imageUrl : String?
    private var _likes : Int!
    private var _key : String!
    private var _username : String!
    
    
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

    init(postKey : String!, dictionary : Dictionary<String, AnyObject>)
    {
        self._key = postKey
        
        if let postDesc = dictionary["description"] as? String
        {
            self._postDescription = postDesc
        }
        if let imageUrl = dictionary["imgaeUrl"] as? String
        {
            self._imageUrl = imageUrl
        }
        if let likes = dictionary["likes"] as? Int
        {
            self._likes = likes
        }
        
    }
    
}