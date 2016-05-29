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
    
    
    var REF_BASE : Firebase
        {
        return self._REF_BASE
    }
    
}