//
//  PhotoDetailViewController.swift
//  Konrad Photo App
//
//  Created by Chris Wong on 2016-06-24.
//  Copyright © 2016 Chris Wong. All rights reserved.
//

import UIKit

class PhotoDetailViewController: UIViewController {

    // MARK: Properties
    @IBOutlet var ImageUIImageView: UIImageView!
    @IBOutlet var DescriptionTextView: UITextView!
    var photo: Photo?
    
    // MARK: Constant
    let baseURL = "http://ios.kg-dev.com/api/photos/"
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        setTitle()
        setPhotoImage()
        setDescription()
        
    }

    // MARK: Setup Helper Methods
    func setPhotoImage() {
        
        if let photo = photo {
            // TODO: Use AlamoFire
            NSURLSession.sharedSession().dataTaskWithURL(NSURL(string: "\(baseURL)\(photo.image!)")!, completionHandler: { (data, response, error) -> Void in
                if error == nil {
                    let image = UIImage(data: data!)
                    // TODO: Cache Image using NSCache()
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.ImageUIImageView.image = image
                    })
                }
                else {
                    print(error)
                    return
                }
                
            }).resume()

        }
        
        
    }
    
    func setDescription(){
        if let photo = photo {
            self.DescriptionTextView.text = photo.paragraph

        }
    }
    
    func setTitle(){
        if let photo = photo {
            self.title = photo.title
        }
    }
    
    
}
