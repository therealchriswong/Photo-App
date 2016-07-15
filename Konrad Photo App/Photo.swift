//
//  Photo.swift
//  Konrad Photo App
//
//  Created by Chris Wong on 2016-06-24.
//  Copyright © 2016 Chris Wong. All rights reserved.
//

import UIKit
import SwiftyJSON
import MapKit

class Photo: NSObject, MKAnnotation {
    
    // MARK: Properties
    var title: String?
    var paragraph: String?
    var thumbnail: String?
    var image: String?
    var coordinate: CLLocationCoordinate2D
    
    // MARK: Init
    init(title: String, description: String, coordinate: CLLocationCoordinate2D){
        self.title = title
        self.paragraph = description
        self.coordinate = coordinate
    }
    
    convenience init(json: JSON){
        
        let coordinate = CLLocationCoordinate2D(latitude: json["latitude"].double!, longitude: json["longitude"].double!)
        
        self.init(title: json["title"].stringValue, description: json["description"].stringValue, coordinate: coordinate)
        self.thumbnail = json["thumb"].stringValue
        self.image = json["image"].stringValue
      
        //print("\(self.title), \(self.description), \(self.thumbnail), \(self.image), \(self.latitude), \(self.longitude)")
        
    }
}

