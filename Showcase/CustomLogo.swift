//
//  CustomLogo.swift
//  Showcase
//
//  Created by Peyman Attarzadeh on 5/27/16.
//  Copyright © 2016 PeymaniuM. All rights reserved.
//

import UIKit

class CustomLogo: UIImageView {

    override func awakeFromNib() {
        
        layer.cornerRadius = 5
        layer.masksToBounds = true
    }

}
