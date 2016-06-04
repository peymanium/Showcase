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
        
        if let user = FIRAuth.auth()?.currentUser
        {
            print ("\(user.uid) logged in")
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
                let facebookAccessToken = FBSDKAccessToken.currentAccessToken().tokenString
                let credential = FIRFacebookAuthProvider.credentialWithAccessToken(facebookAccessToken)
                
                FIRAuth.auth()?.signInWithCredential(credential, completion: { (user : FIRUser?, error : NSError?) in
                    
                    if error != nil
                    {
                        print ("Login failed \(error)")
                    }
                    else
                    {
                        
                        let userData = ["provider" : credential.provider]
                        DataServices.ds.CreateFirebaseUser(user!.uid, user: userData)
                        
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
            
            FIRAuth.auth()?.signInWithEmail(email, password: password, completion: { (user : FIRUser?, error : NSError?) in
                
                if let errorAuthUser = error //there is an error
                {
                    print (errorAuthUser)
                    if errorAuthUser.code == STATUS_USER_NONEXIST //if user does not exist
                    {
                        //Create user
                        FIRAuth.auth()?.createUserWithEmail(email, password: password, completion: { (user : FIRUser?, errorCreateUser : NSError?) in
                            
                            if errorCreateUser != nil
                            {
                                self.ShowAlertView("Error creating user", message: "Cannot create user at the moment.")
                            }
                            else
                            {
                                //Create user in Firebase
                                let userData = ["provider" : "email"]
                                DataServices.ds.CreateFirebaseUser(user!.uid, user: userData)
                                
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

