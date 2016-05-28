//
//  ViewController.swift
//  Showcase
//
//  Created by Peyman Attarzadeh on 5/27/16.
//  Copyright © 2016 PeymaniuM. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func BTN_Facebook_Tapped(sender: AnyObject)
    {
        let facebookLogin = FBSDKLoginManager()
        let permission : [String] = ["email"]
        
        facebookLogin.logInWithReadPermissions(permission, fromViewController: self) { (facebookResult : FBSDKLoginManagerLoginResult!, facebookError : NSError!) in
            
            if facebookError != nil
            {
                print ("Error login with Facebook")
            }
            else
            {
                let accessToken = FBSDKAccessToken.currentAccessToken().tokenString
                print ("Successfully logged in with Facebook")
            }
            
        }
    }

}

