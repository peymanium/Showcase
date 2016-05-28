//
//  DataServices.swift
//  Showcase
//
//  Created by Peyman Attarzadeh on 5/28/16.
//  Copyright © 2016 PeymaniuM. All rights reserved.
//

import Foundation
import Firebase

class DataServices
{
    static let ds = DataServices()
    
    private var _REF_BASE = Firebase(url: "https://peymanium-showcase.firebaseio.com")
    var REF_BASE : Firebase
        {
        return self._REF_BASE
    }
    
}