//
//  DataServices.swift
//  Showcase
//
//  Created by Peyman Attarzadeh on 5/28/16.
//  Copyright © 2016 PeymaniuM. All rights reserved.
//

import Foundation
import Firebase

let URL_BASE = "https://peymanium-showcase.firebaseio.com"

class DataServices
{
    static let ds = DataServices()
    
    private var _REF_BASE = Firebase(url: "\(URL_BASE)")
    private var _REF_POSTS = Firebase(url: "\(URL_BASE)/Posts")
    private var _REF_USERS = Firebase(url: "\(URL_BASE)/Users")
    private var _REF_CURRENT_USER = Firebase(url: "\(URL_BASE)").childByAppendingPath("Users")
    
    var REF_BASE : Firebase
        {
        return self._REF_BASE
    }
    var REF_POSTS : Firebase
        {
        return self._REF_POSTS
    }
    var REF_USERS : Firebase
        {
        return self._REF_USERS
    }
    var REF_CURRENT_USER : Firebase
    {
        let uid = NSUserDefaults.standardUserDefaults().valueForKey(KEY_UID) as! String
        let currentUser = _REF_CURRENT_USER.childByAppendingPath(uid)
        
        return currentUser
    }
    
    
    func CreateFirebaseUser (uid : String, user : Dictionary<String,String>)
    {
        REF_USERS.childByAppendingPath(uid).setValue(user)
    }
}