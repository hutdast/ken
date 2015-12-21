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
    
    
    
    
    
    @IBOutlet weak var savingActivity: UIActivityIndicatorView!
    @IBOutlet weak var resultButton: UIButton!
    @IBOutlet weak var statePicker: UIPickerView!
    @IBOutlet weak var rendezVous: UISegmentedControl!
    @IBOutlet weak var comment: UITextField!
    @IBOutlet weak var city: UITextField!
    @IBOutlet weak var result: UILabel!
    @IBOutlet weak var nameOfAddress: UITextField!
    @IBOutlet weak var addressOfLocation: UITextField!
    var haveRendezVous = Bool()
    var pickerData = [String]()
    var tempDB: DataManager!
    var stateAdr = String()
    var lat = Double()
    var lng  = Double()
    
    override func viewWillAppear(animated: Bool) {
        comment.text = "Fè yon remak sou plas sa"
        self.statePicker.delegate = self
        
        resultButton.setTitle("POKO FINI", forState: UIControlState.Normal)
        haveRendezVous = true
        pickerData = [
            "Alabama", "Alaska", "American Samoa", "Arizona", "Arkansas", "California", "Colorado", "Connecticut", "Delaware", "District of Columbia", "Florida", "Georgia", "Guam", "Hawaii", "Idaho", "Illinois", "Indiana", "Iowa", "Kansas", "Kentucky", "Louisiana", "Maine", "Maryland", "Massachusetts", "Michigan", "Minnesota", "Mississippi", "Missouri", "Montana", "Nebraska", "Nevada", "New Hampshire", "New Jersey", "New Mexico", "New York", "North Carolina", "North Dakota", "Northern Marianas Islands", "Ohio", "Oklahoma", "Oregon", "Pennsylvania", "Puerto Rico", "Rhode Island", "South Carolina", "South Dakota", "Tennessee", "Texas", "Utah", "Vermont", "Virginia", "Virgin Islands", "Washington", "West Virginia", "Wisconsin", "Wyoming"]
        
        
    }//end of viewWillAppear(animated: Bool)
    
    
    
    @IBAction func checkUserInputs(sender: UITextField)
    {
        
        if sender.text!.isEmpty
        {
            alertMessageHandler("Erè", messageToUser: "OU BLIYE REMPLI YOUN")
        }else if sender.text! == nameOfAddress.text!
        {
            for locationName in tempDB.displayAllFromDatabase().name
            {
                if sender.text! == locationName
                {
                    alertMessageHandler("Doubl", messageToUser: "Ou anrijistre \(locationName) deja")
                    
                }
            }
            
        }
    }//end of checkUserInputs(sender: UITextField)
    
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
        
    }//end of getselectedValueOfRendezvous(sender: AnyObject)
    
    func alertMessageHandler(title:String, messageToUser:String  ){
        let alertController = UIAlertController(title: title, message:
            messageToUser , preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Oke", style: UIAlertActionStyle.Default,handler: nil))
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    @IBAction func saveUserInputs(sender: AnyObject) {
        savingActivity.startAnimating()
        let modified = tempDB.modifyAddressForAPiUse(addressOfLocation.text!, city: city.text!, state: stateAdr)
        let session =  tempDB.connectToGoogleAPI( modified).apiSession
        let urlRequest = tempDB.connectToGoogleAPI( modified).urlRequest
        var isItSafe = true
        
        
        let priority = QOS_CLASS_USER_INTERACTIVE
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            
            
            let task = session.dataTaskWithRequest(urlRequest,completionHandler: { (data, response, error) in
                if(error != nil){ print("there is an error")}
                guard let responseData = data else {  return}
                guard error == nil else { return}
                
                let results = JSON(data: responseData)
                /** cannot send the JSON object out needs to be parsed into a dictionary
                otherwise you will get a nil err => 😡unexpectedly found nil while unwrapping an Optional value
                */
                //if status is ok first
                
                dispatch_async(dispatch_get_main_queue()) {
                    
                    if results["status"] == "ZERO_RESULTS"
                    {
                        isItSafe = false
                        
                        self.savingActivity.stopAnimating()
                        print("There are no results")
                    }else
                    {
                        print("There are results and we are about to get lat and save it")
                        isItSafe = true
                        self.lat = results["results"][0]["geometry"]["location"]["lat"].doubleValue
                        self.lng = results["results"][0]["geometry"]["location"]["lng"].doubleValue
                        
                        self.tempDB.insertIntoDatabase( self.nameOfAddress.text!, comment: self.comment.text!, rendezvous: self.haveRendezVous , lat: self.lat, lng: self.lng)
                        self.savingActivity.stopAnimating()
                        self.result.text = "Anrijistre \n non: \(self.nameOfAddress.text!)\n adrès: \(self.addressOfLocation.text!)"
                        
                        self.resultButton.setTitle("Kontinye", forState: UIControlState.Normal)
                        
                        
                        
                    }
                    print("right before we leave dispatch isItsafe is \(isItSafe).. lat is..:\(self.lat) ")
                }//end UI dispatch
                
                
            })
            
            task.resume()
        }//end of global dispatch
        
    }// End of saveUserInputs(sender: UITextField)
    
    
    
    
    
    
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
    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let attributedString = NSAttributedString(string: pickerData[row], attributes: [NSForegroundColorAttributeName : UIColor.colorWithAlphaComponent(UIColor.greenColor())(0.4)])
        return attributedString
    }
    
    
    
    
    
    
    
    
    
    
    
    
}//end of class
