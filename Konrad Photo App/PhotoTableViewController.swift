//
//  PhotoTableViewController.swift
//  Konrad Photo App
//
//  Created by Chris Wong on 2016-06-23.
//  Copyright © 2016 Chris Wong. All rights reserved.
//

import UIKit

class PhotoTableViewController: UITableViewController, PhotoObserver {

    // MARK: Properties
    let photoManager = PhotoManager()
    var photos: [Photo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Start listening for updates to photo data
        photoManager.addObserver(self)
        
        // Get Photos
        photoManager.refreshPhoto()
        
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension        
    }

    
    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("photoCell", forIndexPath: indexPath) as! PhotoTableViewCell
        cell.photo = photos[indexPath.row]
        return cell
    }
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if let cell = sender as? UITableViewCell {
            if let indexPath = tableView.indexPathForCell(cell) {
                let photoData = photos[indexPath.row]
                let viewController = segue.destinationViewController as! PhotoDetailViewController
                viewController.photo = photoData
                
            }
        }

        
    }
    
    // MARK: PhotoManagerDelegate
    func photoUpdated(photos: [Photo]) {
        self.photos = photos
        
        //reload the table view
        tableView.reloadData()
    }
}
