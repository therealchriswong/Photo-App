//
//  MapViewController.swift
//  Konrad Photo App
//
//  Created by Chris Wong on 2016-06-23.
//  Copyright © 2016 Chris Wong. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, PhotoObserver, MKMapViewDelegate {
    
    // TODO: Set the map when annotation is selected
    
    
    // MARK: Properties
    @IBOutlet var mapView: MKMapView!
    let photoManager = PhotoManager()
    var photos: [Photo] = []
    var location: CLLocation?
    let regionRadius: CLLocationDistance = 2000

    // MARK: Constants
    let baseURL = "http://ios.kg-dev.com/api/photos/"

    override func viewDidLoad() {
        super.viewDidLoad()

        self.mapView.delegate = self;

        setInitialLocation()
        
        photoManager.addObserver(self)
        photoManager.refreshPhoto()
        
    }


    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "photoDetail" {
        
            let viewController = segue.destinationViewController as! PhotoDetailViewController
            
            if let photo = sender?.annotation as? Photo {
                viewController.photo = photo
            }
            
        }
    }
 
    // MARK: MKMapViewDelegate
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        if let annotation = annotation as? Photo {
         
            var view: MKPinAnnotationView
            if let dequeuedView = mapView.dequeueReusableAnnotationViewWithIdentifier("pin") as? MKPinAnnotationView {
                dequeuedView.annotation = annotation
                view = dequeuedView
            }
            else {
                
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pin")
                view.canShowCallout = true
                view.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
                
                // TODO: Cache Image using NSCache()
                NSURLSession.sharedSession().dataTaskWithURL(NSURL(string: "\(baseURL)\(annotation.thumbnail!)")!, completionHandler: { (data, response, error) -> Void in
                    if error == nil {
                        let image = UIImage(data: data!)
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            
                            let photoImageView = UIImageView(image: image)
                            photoImageView.frame = CGRectMake(0,0,40,40);
                            view.leftCalloutAccessoryView = photoImageView

                        })
                    }
                    else {
                        print(error)
                        return
                    }
                    
                }).resume()

                
            }
            return view
        }
        return nil
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            self.performSegueWithIdentifier("photoDetail", sender: view)
        }
    }

    // MARK: PhotoManagerDelegate
    func photoUpdated(photos: [Photo]) {
        self.photos = photos
        // reload annotations
        loadAnnotations()

    }
    
    // MARK: Helper functions
    func loadAnnotations(){
        for photo in photos {
            mapView.addAnnotation(photo)
            
        }
    }
    
    // TODO: Use Corelocation to find users location or use annotation for the location
    func setInitialLocation(){
        
        location = CLLocation(latitude: 43.6456623, longitude: -79.3948895)
        
        centerMapOnLocation(location!)
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 2 , regionRadius * 2)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
}
