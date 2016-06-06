//
//  CustomProfileImage.swift
//  Showcase
//
//  Created by Peyman Attarzadeh on 6/5/16.
//  Copyright © 2016 PeymaniuM. All rights reserved.
//

import UIKit

class CustomProfileImage: UIImageView {


    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.cornerRadius = self.frame.width / 2
        self.clipsToBounds = true
    }
    

}
