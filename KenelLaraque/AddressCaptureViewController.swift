//
//  AddressCaptureViewController.swift
//  KenelLaraque
//
//  Created by nikenson midi on 12/19/15.
//  Copyright © 2015 pnmidi. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class AddressCaptureViewController: UIViewController, UIPickerViewDelegate {
    
    
    
   
    @IBOutlet weak var resultButton: UIButton!
    @IBOutlet weak var rendezVous: UISegmentedControl!
    @IBOutlet weak var city: UITextField!
    @IBOutlet weak var statePicker: UIPickerView!
    @IBOutlet weak var result: UILabel!
    @IBOutlet weak var comment: UITextField!
    @IBOutlet weak var addressOfLocation: UITextField!
    @IBOutlet weak var nameOfAddress: UITextField!
    var haveRendezVous = Bool()
    var pickerData: [String] = [String]()
    var tempDB:DataManager!
    var stateAdr: String = String()
    var lat = Double()
    var lng  = Double()
    
    override func viewWillAppear(animated: Bool) {
        comment.text = "Fè yon remak sou plas sa"
        self.statePicker.delegate = self
        self.resultButton.enabled = false
        self.resultButton.setTitle("POKO FINI", forState: UIControlState.Normal)
        pickerData = [
            "Alabama", "Alaska", "American Samoa", "Arizona", "Arkansas", "California", "Colorado", "Connecticut", "Delaware", "District of Columbia", "Florida", "Georgia", "Guam", "Hawaii", "Idaho", "Illinois", "Indiana", "Iowa", "Kansas", "Kentucky", "Louisiana", "Maine", "Maryland", "Massachusetts", "Michigan", "Minnesota", "Mississippi", "Missouri", "Montana", "Nebraska", "Nevada", "New Hampshire", "New Jersey", "New Mexico", "New York", "North Carolina", "North Dakota", "Northern Marianas Islands", "Ohio", "Oklahoma", "Oregon", "Pennsylvania", "Puerto Rico", "Rhode Island", "South Carolina", "South Dakota", "Tennessee", "Texas", "Utah", "Vermont", "Virginia", "Virgin Islands", "Washington", "West Virginia", "Wisconsin", "Wyoming"]
        
        
    }
    
    
    
    
    
    
    
    @IBAction func checkUserInputs(sender: UITextField) {
        if sender.editing{
            saveEntryTODatabase()
            print("comment is being edited")
        }
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
        //result.text = "longitude: \(lng)"
        
        print("GO TO NEXT VIEW IT IS SAFE TO SAVE!!!!")
        
        
    }
    
    func saveEntryTODatabase()
    {
        let name: String = nameOfAddress.text!
        let location: String = addressOfLocation.text!
        let citY: String = city.text!
        
        
        
        if name.isEmpty || location.isEmpty || citY.isEmpty
        {
            result.text = "OU BLIYE REMPLI YOUN"
        }
            
        else {//entry validation
            
            let modified = tempDB.modifyAddressForAPiUse(location, city: citY, state: stateAdr)
            let urlRequest = tempDB.connectToGoogleAPI(modified).urlRequest
            let apiSession = tempDB.connectToGoogleAPI(modified).apiSession
            let jsonData:JSON = tempDB.getApiResponse(apiSession, urlRequest: urlRequest)
            
            
            if jsonData["status"] == "ZERO_RESULTS"
            {
                self.result.text = "Cheke adrès la"
            }
            else{// save to db
                self.lat = jsonData["results"][0]["geometry"]["location"]["lat"].double
                
                self.lng = jsonData["results"][0]["geometry"]["location"]["lng"]?.double!
                
                if  self.tempDB.insertIntoDatabase(name, comment: self.comment.text!, rendezvous: self.haveRendezVous, lat:self.lat, lng: self.lng)
                {//check for duplicates
                    self.resultButton.enabled = true
                    self.resultButton.setTitle("Kontinye", forState: UIControlState.Normal)
                    self.result.text = "longitude: \(self.lng)"
                }
                else
                {
                    self.result.text = "OU rantre non sa deja"
                }
            }// end of save to db
            
            
        }// end of entry validation
    }//end of funcsaveEntryTODatabase()
    
    
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
