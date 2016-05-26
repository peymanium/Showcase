//
//  CustomTextField.swift
//  Showcase
//
//  Created by Peyman Attarzadeh on 5/27/16.
//  Copyright © 2016 PeymaniuM. All rights reserved.
//

import UIKit

class CustomTextField: UITextField {


    override func awakeFromNib() {
        
        layer.cornerRadius = 3
        
        layer.borderColor = UIColor(red: SHADOW_COLOR, green: SHADOW_COLOR, blue: SHADOW_COLOR, alpha: 1.0).CGColor
        layer.borderWidth = 1.0
        
    }
    
    //for place holder
    override func textRectForBounds(bounds: CGRect) -> CGRect {
        return CGRectInset(bounds,10.0, 0)
    }
    
    //for Text
    override func editingRectForBounds(bounds: CGRect) -> CGRect {
        return CGRectInset(bounds, 10, 0)
    }

}
