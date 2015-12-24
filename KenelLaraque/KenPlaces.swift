//
//  KenPlaces.swift
//  KenelLaraque
//
//  Created by nikenson midi on 12/24/15.
//  Copyright © 2015 pnmidi. All rights reserved.
//

import Foundation

import MapKit

class KenPlaces: NSObject, MKAnnotation {
    
    var title: String?
    var subtitle: String?
   
    var coordinate: CLLocationCoordinate2D
    
    init(title: String,data:DataManager)
    {
        let indeX = data.displayAllFromDatabase().name.indexOf(title)
        if indeX != nil
        {
            self.title = data.displayAllFromDatabase().name[indeX!]
            self.subtitle = data.displayAllFromDatabase().comment[indeX!]
            let lat = data.displayAllFromDatabase().latitude[indeX!]
            let lng = data.displayAllFromDatabase().longitude[indeX!]
            self.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lng)
            
        }
        self.title = ""
        self.subtitle = ""
       
        self.coordinate = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
        super.init()

    }
    
    
    var getTitle: String
        {
        return title!
    }
    
    var getSubtitle: String
        {
        return subtitle!
       }
}
