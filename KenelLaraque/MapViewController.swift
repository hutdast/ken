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
class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet weak var kenMap: MKMapView!
        {
            didSet
            {
            kenMap.mapType = .Hybrid
                kenMap.delegate = self
            }
        }
    @IBOutlet weak var resultHeader: UILabel!
    var name: String!
    var tempDB: DataManager!
    var locationManager: CLLocationManager!
    var course: CLLocationDirection!
    var timeStamp: NSDate!
    override func viewWillAppear(animated: Bool)
    {
        
        if (CLLocationManager.locationServicesEnabled())
        {
            /*
            locationManager = CLLocationManager()
            locationManager!.delegate = self
            locationManager!.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager!.requestAlwaysAuthorization()
            locationManager!.startUpdatingLocation()
        
            //print(" is service enabled..: \(locationManager.location )!\n")
            //var annotations: [MKAnnotation]
            //callouts make a callout with a accesory view button (left)  UIBUttontypeDetaildisclosure
            // addAnnotation or anotations, similarly remove annotation  or (s)
            // annotation has to enable canShowCallout to true to be able to use callouts
            //var kenLocation: MKUserLocaltion
*/
        }//end of if
        let indeX = tempDB.displayAllFromDatabase().name.indexOf(name)
        let aPlace = MKPointAnnotation()
        aPlace.title = tempDB.displayAllFromDatabase().name[indeX!]
        aPlace.subtitle = tempDB.displayAllFromDatabase().comment[indeX!]
    
        let lat = tempDB.displayAllFromDatabase().latitude[indeX!]
        let lng = tempDB.displayAllFromDatabase().longitude[indeX!]
       aPlace.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lng)
        let spot = MKCoordinateRegionMakeWithDistance(aPlace.coordinate, 1000,1000)
        kenMap.addAnnotation(aPlace)
            kenMap.setRegion(spot, animated: true)
         
    
    }
    
    
    
    //Creating Annotations
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView?
    {
        let rendevou = "RENDEVOU"
        var view = mapView.dequeueReusableAnnotationViewWithIdentifier(rendevou) as? MKPinAnnotationView
        if view == nil
        {
          view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: rendevou)
            view?.canShowCallout = true
        view?.animatesDrop = true
            
   view?.rightCalloutAccessoryView = UIButton(type:UIButtonType.DetailDisclosure)
        }else
        {
            view?.annotation = annotation

        }
       
        return view
    }


    
/**
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        manager.stopUpdatingLocation()
        print("locationManager func is invoked!\n")
        let location = locations[0] as CLLocation
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(location, completionHandler: { (data, error)  in
            let placeMarks = data! as [CLPlacemark]
            let loc: CLPlacemark = placeMarks[0]
            
            self.kenMap.centerCoordinate = location.coordinate
            let addr = loc.subLocality
            self.resultHeader.text = addr
            let reg = MKCoordinateRegionMakeWithDistance(location.coordinate, 1500, 1500)
            
        self.kenMap.setRegion(reg, animated: true)
            
        })
        
        
        
    }//end of locationManager

*/
    
    /**
     
    func mapView(mapView: MKMapView, didDeselectAnnotationView view: MKAnnotationView)
    {
    
    }

     func mapView(mapView: MKMapView, didUpdateUserLocation userLocation: MKUserLocation) {
     <#code#>
     }

    func locationManager(manager: CLLocationManager, didEnterRegion region: CLRegion) {
    
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        <#code#>
    let appointment = CLCircularRegion(center: <#T##CLLocationCoordinate2D#>, radius: <#T##CLLocationDistance#>, identifier: <#T##String#>)
    KCLerrolocationunknown
    .....errorDenied
    ....errorHeadingFailure
    }
    
    */
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showList" {
            if let destination = segue.destinationViewController as? WelcomeViewController {
                destination.tempDB = tempDB
            }
        }
    }//end of segue
    
    
    
    
    
    
    
    
    
    
    
}//end of class
