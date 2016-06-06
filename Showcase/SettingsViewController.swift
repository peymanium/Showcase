//
//  SettingsViewController.swift
//  Showcase
//
//  Created by Peyman Attarzadeh on 6/5/16.
//  Copyright © 2016 PeymaniuM. All rights reserved.
//

import UIKit
import Firebase

class SettingsViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var IMG_Profile: CustomProfileImage!
    @IBOutlet weak var TXT_Username: CustomTextField!
    @IBOutlet weak var PRG_Loading: UIActivityIndicatorView!
    @IBOutlet weak var VIEW_Loading: UIView!
    
    var imagePicker = UIImagePickerController()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        
        self.VIEW_Loading.hidden = false
        self.PRG_Loading.hidden = false
        self.PRG_Loading.startAnimating()
        self.LoadDetails()

    }
    func LoadDetails()
    {
        DataServices.ds.REF_CURRENT_USER.observeSingleEventOfType(.Value) { (snapshot : FIRDataSnapshot!) in
            
            if let details = snapshot.value as? Dictionary<String, AnyObject>
            {
                if let profileImageName = details["profileImageName"] as? String
                {
                    DataServices.ds.LoadImageFromFirebase("profile", imageName : profileImageName, completion: { (resultImage) in
                        
                        if let image = resultImage
                        {
                            self.IMG_Profile.image = image
                            self.PRG_Loading.stopAnimating()
                            self.PRG_Loading.hidden = true
                            self.VIEW_Loading.hidden = true
                        }
                    })
                }
                
                if let username = details["username"] as? String
                {
                    self.TXT_Username.text = username
                }

            }
            
        }
            
        
        
    }

    
    @IBAction func IMG_Profile_Taped(sender: AnyObject)
    {
        self.presentViewController(imagePicker, animated: true, completion: nil)
        
    }
    
    
    //ImagePicker Delegate function
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        self.IMG_Profile.image = image
        imagePicker.dismissViewControllerAnimated(true, completion: nil)
    }

    
    @IBAction func BTN_Update_Taped(sender: AnyObject)
    {
        let imageName = "profile_\(NSDate.timeIntervalSinceReferenceDate())"
        let imageData = UIImageJPEGRepresentation(self.IMG_Profile.image!, 0.2)
        
        DataServices.ds.AddImageToFirebase("profile", imageName: imageName, imageData: imageData) { (imageURL) in
            
            let profile : Dictionary<String,String> = [
                "username" : self.TXT_Username.text!,
                "profileImageUrl" : imageURL!,
                "profileImageName" : imageName
            ]
            
            DataServices.ds.REF_CURRENT_USER.updateChildValues(profile)
            
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
}
