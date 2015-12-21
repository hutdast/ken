//
//  AddressCaptureViewController.swift
//  KenelLaraque
//
//  Created by nikenson midi on 12/19/15.
//  Copyright © 2015 pnmidi. All rights reserved.
//

import UIKit
import SwiftyJSON
class AddressCaptureViewController: UIViewController, UIPickerViewDelegate {
    
    
    
    
    
    @IBOutlet weak var statePicker: UIPickerView!
    @IBOutlet weak var rendezVous: UISegmentedControl!
    @IBOutlet weak var comment: UITextField!
    @IBOutlet weak var city: UITextField!
    @IBOutlet weak var result: UILabel!
    @IBOutlet weak var nameOfAddress: UITextField!
    @IBOutlet weak var addressOfLocation: UITextField!
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
    
    
    
    
    
    @IBAction func checkInputs(sender: UITextField) {
        if sender.editing == true{
            prepareForDatabase()
        }
    }
    
    @IBAction func sendResult(sender: UIButton) {
    }
    
    func prepareForDatabase()
    {
        let name: String = nameOfAddress.text!
        let location: String = addressOfLocation.text!
        let citY: String = city.text!
        var lat = Double()
        var lng  = Double()
        
        
        if name.isEmpty || location.isEmpty || citY.isEmpty
        {
            result.text = "OU BLIYE REMPLI YOUN"
            
        }else
        {
            let modified = tempDB.modifyAddressForAPiUse(location, city: citY, state: stateAdr)
            let session =  tempDB.connectToGoogleAPI( modified).apiSession
            let urlRequest = tempDB.connectToGoogleAPI( modified).urlRequest
            
            
            let task = session.dataTaskWithRequest(urlRequest,completionHandler: { (data, response, error) in
                if(error != nil){ print("there is an error")}
                guard let responseData = data else {  return}
                guard error == nil else { return}
                
                
                
                
                let results = JSON(data: responseData)
                /** cannot send the JSON object out needs to be parsed into a dictionary
                otherwise you will get a nil err => 😡unexpectedly found nil while unwrapping an Optional value
                */
                //if status is ok first
                
                if results["status"] == "ZERO_RESULTS"
                {
                    self.result.text = "On erè nan adrès la"
                }else
                {
                    lat = results["results"][0]["geometry"]["location"]["lat"].doubleValue
                    lng = results["results"][0]["geometry"]["location"]["lng"].doubleValue
                    if  self.tempDB.insertIntoDatabase(name, comment: self.comment.text!, rendezvous: self.haveRendezVous , lat: lat, lng: lng)
                    {
                        self.result.text = "Anrijistre \n non: \(name)\n adrès: \(location)"
                        print("IT IS SAVED ....")
                    }else
                    {
                        self.result.text = "Ou gen \(name) sa deja"
                    }
                    
                }
                
                
                
                
                
            })
            task.resume()
            
        }
        
        
        
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
