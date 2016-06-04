//
//  DataServices.swift
//  Showcase
//
//  Created by Peyman Attarzadeh on 5/28/16.
//  Copyright © 2016 PeymaniuM. All rights reserved.
//

import Foundation
import Firebase

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
        let uid = NSUserDefaults.standardUserDefaults().valueForKey(KEY_UID) as! String
        let currentUser = _REF_CURRENT_USER.child(uid)
        
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
}