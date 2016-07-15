//
//  PhotoTableViewCell.swift
//  Konrad Photo App
//
//  Created by Chris Wong on 2016-06-23.
//  Copyright © 2016 Chris Wong. All rights reserved.
//

import UIKit

class PhotoTableViewCell: UITableViewCell {
    
    // MARK: Constants
    let baseURL = "http://ios.kg-dev.com/api/photos/"
    
    // MARK: Properties
    @IBOutlet var photoUIImageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    
   
    
    var photo: Photo? {
        didSet {
            if let photo = self.photo {
                titleLabel.text = photo.title
                descriptionLabel.text = photo.paragraph
                // TODO: Use AlamoFire
                NSURLSession.sharedSession().dataTaskWithURL(NSURL(string: "\(baseURL)\(photo.thumbnail!)")!, completionHandler: { (data, response, error) -> Void in
                    if error == nil {
                        let image = UIImage(data: data!)
                        // TODO: Cache Image using NSCache()
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            self.photoUIImageView.image = image
                        })
                    }
                    else {
                        print(error)
                        return
                    }
                    
                }).resume()
                
            }
            else {
                titleLabel.text = nil
                descriptionLabel.text = nil
                photoUIImageView.image = nil
            }
        }
    }
    
}
