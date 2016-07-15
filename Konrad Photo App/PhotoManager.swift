//
//  PhotoManager.swift
//  Konrad Photo App
//
//  Created by Chris Wong on 2016-06-24.
//  Copyright © 2016 Chris Wong. All rights reserved.
//

import UIKit
import SwiftyJSON

// MARK: Protocol
protocol PhotoObserver {
    func photoUpdated(photos: [Photo])
}


class PhotoManager {
    
    // MARK: Properties
    var observers = [PhotoObserver]()
    
    // MARK: Constants
    let baseURL = "http://ios.kg-dev.com/api/photos/"
    let jsonEndPoint = "points.json"
    
    // MARK: Helper functions
    func addObserver(observer: PhotoObserver){
        observers.append(observer)
    }
    
    func refreshPhoto(){
        
        // TODO: Use AlamoFire
        NSURLSession.sharedSession().dataTaskWithURL(NSURL(string: baseURL+jsonEndPoint)!, completionHandler: { (data, response, error) -> Void in
            if error == nil {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    if let data = data {
                        let json = JSON(data: data)
                        if json["success"].bool == true {
                            for observer in self.observers {
                                observer.photoUpdated(self.createPhotos(json))
                            }
                        }
                        else {
                            print("JSON failed")
                        }
                    }
                })
            }
            else {
                print(error)
                return
            }
            
        }).resume()
        
    }
    
    func createPhotos(json: JSON) -> [Photo] {
        var photos = [Photo]()
        
        for (index,subJson):(String, JSON) in json["result"] {
            photos.append(Photo(json: subJson))
        }
        
        return photos
    }

}