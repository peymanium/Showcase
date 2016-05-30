//
//  FeedsViewController.swift
//  Showcase
//
//  Created by Peyman Attarzadeh on 5/29/16.
//  Copyright © 2016 PeymaniuM. All rights reserved.
//

import UIKit
import Firebase

class FeedsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var posts = [Post]()
    static var imageCache = NSCache() //for caching images in the memory buffer, use static to be a singleton and call from any file in the project
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.estimatedRowHeight = 411
        
        //To read firebase for new posts
        DataServices.ds.REF_POSTS.observeEventType(.Value) { (snapshotData : FDataSnapshot!) in
            
            self.posts = []
            if let snapshot = snapshotData.children.allObjects as? [FDataSnapshot]
            {
                for snap in snapshot
                {
                    if let dictionaryValues = snap.value as? Dictionary<String,AnyObject>
                    {
                        //print (snap)
                        let key = snap.key
                        
                        let post = Post(postKey: key, dictionary: dictionaryValues)
                        self.posts.append(post)
                    }
                }
            }
            
            self.tableView.reloadData()
        }

    }
    
    //TableView Delegate functions
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.posts.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        if let cell = tableView.dequeueReusableCellWithIdentifier("CellID") as? PostCell
        {
            cell.firebaseRequest?.cancel() //cancel the Alamofire request if the new row loaded
            
            let post = self.posts[indexPath.row]
            
            cell.ConfigureCell(post)
            return cell
        }
        else
        {
            return UITableViewCell()
        }
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        let post = posts[indexPath.row]
        if post.imageUrl == nil
        {
            return 200
        }
        else
        {
            return tableView.estimatedRowHeight
        }
        
    }
    
    

}
