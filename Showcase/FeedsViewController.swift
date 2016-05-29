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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        
        //To read firebase for new posts
        DataServices.ds.REF_POSTS.observeEventType(.Value) { (snapshotData : FDataSnapshot!) in
            
            self.posts = []
            if let snapshot = snapshotData.children.allObjects as? [FDataSnapshot]
            {
                for snap in snapshot
                {
                    if let dictionaryValues = snap.value as? Dictionary<String,AnyObject>
                    {
                        print (snap)
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
        
        let post = self.posts[indexPath.row]
        
        if let cell = tableView.dequeueReusableCellWithIdentifier("CellID") as? PostCellTableViewCell
        {
            return cell
        }
        else
        {
            return UITableViewCell()
        }
        
    }
    
    

}
