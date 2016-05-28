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
import Firebase

class ViewController: UIViewController {

    
    @IBOutlet weak var TXT_Email: CustomTextField!
    @IBOutlet weak var TXT_Password: CustomTextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if NSUserDefaults.standardUserDefaults().valueForKey(KEY_UID) != nil
        {
            self.performSegueWithIdentifier(SEGUE_LOGGED_IN, sender: nil)
        }
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
                
                DataServices.ds.REF_BASE.authWithOAuthProvider("facebook", token: accessToken, withCompletionBlock: { (error : NSError!, authData : FAuthData!) in
                    
                    if error != nil
                    {
                        print ("Login failed \(error)")
                    }
                    else
                    {
                        print ("Logged in \(authData)")
                        
                        NSUserDefaults.standardUserDefaults().setValue(authData.uid, forKey: KEY_UID)
                        
                        //After sucessflly logged in
                        self.performSegueWithIdentifier(SEGUE_LOGGED_IN, sender: nil)
                    }
                    
                })
                
            }
            
        }
    }
    
    @IBAction func BTN_Login_Tapped(sender: AnyObject)
    {
        if let email = self.TXT_Email.text where email != "", let password = self.TXT_Password.text where password != ""
        {
            
            DataServices.ds.REF_BASE.authUser(email, password: password, withCompletionBlock: { (errorAuthUser: NSError!, authData : FAuthData!) in
                
                if errorAuthUser != nil //there is an error
                {
                    print (errorAuthUser)
                    if errorAuthUser.code == STATUS_USER_NONEXIST //if user does not exist
                    {
                        //Create user
                        DataServices.ds.REF_BASE.createUser(email, password: password, withValueCompletionBlock: { (errorCreateUser : NSError!, result : [NSObject : AnyObject]!) in
                            
                            if errorCreateUser != nil
                            {
                                self.ShowAlertView("Error creating user", message: "Cannot create user at the moment.")
                            }
                            else
                            {
                                NSUserDefaults.standardUserDefaults().setValue(result[KEY_UID], forKey: KEY_UID)
                                
                                DataServices.ds.REF_BASE.authUser(email, password: password, withCompletionBlock: nil)
                                
                                self.performSegueWithIdentifier(SEGUE_LOGGED_IN, sender: nil)
                                
                            }
                            
                        })
                    }
                    else if errorAuthUser.code == STATUS_PASSWORD_INCORRECT
                    {
                        self.ShowAlertView("Incorrect passwrod", message: "Password is incorrect")
                    }
                    
                }
                else //if there is no error and user successfully authorized
                {
                    print ("User authorized")
                    self.performSegueWithIdentifier(SEGUE_LOGGED_IN, sender: nil)
                }
                
            })
            
        }
        else
        {
            self.ShowAlertView("Error", message: "Please enter email/password")
        }
    }
    
    
    func ShowAlertView (title : String, message : String)
    {
        let alertView = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let action = UIAlertAction(title: "Ok", style: .Default, handler: nil)
        
        alertView.addAction(action)
        self.presentViewController(alertView, animated: true, completion: nil)
    }
    

}

