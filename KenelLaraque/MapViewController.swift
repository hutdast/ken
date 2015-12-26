//
//  MapViewController.swift
//  KenelLaraque
//
//  Created by nikenson midi on 12/24/15.
//  Copyright © 2015 pnmidi. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
class Capital: NSObject, MKAnnotation {
    var title: String?
    var coordinate: CLLocationCoordinate2D
    var info: String
    
    init(title: String, coordinate: CLLocationCoordinate2D, info: String) {
        self.title = title
        self.coordinate = coordinate
        self.info = info
    }
}
class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    private struct Constants
    {
        static let AnnotationViewReuseIdentifier = "KenPlaces"
        static let ShowImageSegue = "ShowInfo"
        
    }
    
    @IBOutlet weak var selectedFromTable: UIButton!
    @IBOutlet weak var kenMap: MKMapView!
        {
            didSet
            {
            kenMap.mapType = .Standard
            kenMap.delegate = self
            }
        }

     var name: String!
     var tempDB: DataManager!
    var locationManager: CLLocationManager!
    var course: CLLocationDirection!
    var timeStamp: NSDate!
    
    
    override func viewDidLoad()
{
        let btnName = NSAttributedString(string: name)
        selectedFromTable.setAttributedTitle(btnName, forState: .Normal)
   
    kenMap.addAnnotations(makeKenPlacesAnnotations(tempDB))
    kenMap.showAnnotations(makeKenPlacesAnnotations(tempDB), animated: true)
    
    }

    
    func locationManager(locationManager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("location is invoked")
        let location = locations.last! as CLLocation
       
        
       
             
    }
    
    
    

    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView?
    {
        
        var view = kenMap.dequeueReusableAnnotationViewWithIdentifier(Constants.AnnotationViewReuseIdentifier) as? MKPinAnnotationView
        if view == nil
        {
            view = MKPinAnnotationView(annotation:  KenPlaces(title: name, data: tempDB), reuseIdentifier: Constants.AnnotationViewReuseIdentifier)
            view?.canShowCallout = true
            view?.animatesDrop = true
            
            view?.rightCalloutAccessoryView = UIButton(type:UIButtonType.DetailDisclosure)
        }else
        {
            view!.annotation = annotation
            
        }
        
        return view
    }

   

    
    
      
    func makeKenPlacesAnnotations(data:DataManager) -> [Capital]
    {
        var targetRegion = [Capital]()
        
        for element in data.displayAllFromDatabase().name
        {
            let index = data.displayAllFromDatabase().name.indexOf(element)
            let lat = data.displayAllFromDatabase().latitude[index!]
            let lng = data.displayAllFromDatabase().longitude[index!]
            let info = data.displayAllFromDatabase().comment[index!]
            let spot =  CLLocationCoordinate2D(latitude: lat, longitude: lng)
            let temp =  Capital(title: element, coordinate: spot, info: info)
            
            targetRegion.append(temp)
        }
        return targetRegion
    }
    
    
    
    
    
}//end of class
