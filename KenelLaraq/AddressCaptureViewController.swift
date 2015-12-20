//
//  AddressCaptureViewController.swift
//  KenelLaraque
//
//  Created by nikenson midi on 12/19/15.
//  Copyright © 2015 pnmidi. All rights reserved.
//

import UIKit

class AddressCaptureViewController: UIViewController, UIPickerViewDelegate {
    
  
   
    @IBOutlet weak var rendezVous: UISegmentedControl!
    @IBOutlet weak var city: UITextField!
    @IBOutlet weak var statePicker: UIPickerView!
    @IBOutlet weak var result: UILabel!
    @IBOutlet weak var comment: UITextField!
    @IBOutlet weak var addressOfLocation: UITextField!
    @IBOutlet weak var nameOfAddress: UITextField!
    var haveRendezVous = Bool()
    var pickerData: [String] = [String]()
    var tempDB =  DataManager()
    var stateAdr: String = String()
    
    override func viewWillAppear(animated: Bool) {
       comment.text = "Fè yon remak sou plas sa"
        self.statePicker.delegate = self
        
       pickerData = [
            "Alabama", "Alaska", "American Samoa", "Arizona", "Arkansas", "California", "Colorado", "Connecticut", "Delaware", "District of Columbia", "Florida", "Georgia", "Guam", "Hawaii", "Idaho", "Illinois", "Indiana", "Iowa", "Kansas", "Kentucky", "Louisiana", "Maine", "Maryland", "Massachusetts", "Michigan", "Minnesota", "Mississippi", "Missouri", "Montana", "Nebraska", "Nevada", "New Hampshire", "New Jersey", "New Mexico", "New York", "North Carolina", "North Dakota", "Northern Marianas Islands", "Ohio", "Oklahoma", "Oregon", "Pennsylvania", "Puerto Rico", "Rhode Island", "South Carolina", "South Dakota", "Tennessee", "Texas", "Utah", "Vermont", "Virginia", "Virgin Islands", "Washington", "West Virginia", "Wisconsin", "Wyoming"]
 
        
          }
    
    
  
    @IBAction func getselectedValueOfRendezvous(sender: AnyObject) {
        switch rendezVous.selectedSegmentIndex
        {
        case 0:
            //wi is selected
            haveRendezVous = true
        case 1:
            //non is selected
            haveRendezVous = false
        default:
            break;
        }
        
    }
    
    @IBAction func sendResult(sender: AnyObject)
{
        if prepareForDatabase().isSafe
        {
            
            tempDB.insertIntoDatabase(prepareForDatabase().name, comment: comment.text!, rendezvous: haveRendezVous, lat: prepareForDatabase().latitude, lng: prepareForDatabase().longitude)
        }
        
}
   
    func prepareForDatabase()->(name:String,latitude:Double, longitude:Double, isSafe:Bool)
    {
        let name: String = nameOfAddress.text!
        let location: String = addressOfLocation.text!
        let citY: String = city.text!
         var lat = Double()
        var lng  = Double()
        var isItSafe = Bool()
        
        if name.isEmpty || location.isEmpty || citY.isEmpty
        {
            result.text = "OU BLIYE REMPLI YOUN"
           isItSafe = false
        }else
        {
            let modified = tempDB.modifyAddressForAPiUse(location, city: citY, state: stateAdr)
            let session =  tempDB.getDataFromService( modified).apisSession
            let urlRequest = tempDB.getDataFromService( modified).urlrequest
                        
            if !tempDB.getGridCoordinates(session, urlRequest: urlRequest).notSuccessful
            {
                result.text = "Cheke adrès la"
                isItSafe = false
            }else
            {
                lat = tempDB.getGridCoordinates(session, urlRequest: urlRequest).latitude
                lng = tempDB.getGridCoordinates(session, urlRequest: urlRequest).longitude
                isItSafe = true
            }

            }
            
            
        return(name, lat, lng, isItSafe)
    }
    
    // The number of columns of data
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    // Catpure the picker view selection
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        stateAdr = "\(pickerData[row])"
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
}//end of class
