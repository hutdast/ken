//
//  AddressCaptureViewController.swift
//  KenelLaraque
//
//  Created by nikenson midi on 12/19/15.
//  Copyright © 2015 pnmidi. All rights reserved.
//

import UIKit
import SwiftyJSON
import CoreLocation
class AddressCaptureViewController: UIViewController, UIPickerViewDelegate, UIScrollViewDelegate {
    
    enum MessageType
    {
        case NoErr
        //ok button, message: Ou gen \() deja..., nameOfAddress gain focus
        case DuplicateDBEntry(String)
        //ok button, messge:Ken ou bliye rempli yon pati,resultbuton enable:false title:POKO FINI state normal
        case EmptyUserInput
        //ok button, messge:adrès pa egziste, resultbuton title: Entre on lòt state:normal
        case AddressUnavailable
        //oui or non for alert button tiltes, message: eske se adrès..., oui=save to DB & result display, non=
        case AddressVerification(Double,Double)
    }
    enum AppProgressionChecks{
        case Regular
      case startView
        case stopView
        case NewEntry//clear out all inputs
        case UpdateRecord //if user accept the name that is already in DB
    }
    
    
    
    
    @IBOutlet var scrollingView: UIScrollView!
    @IBOutlet weak var savingActivity: UIActivityIndicatorView!
    @IBOutlet weak var resultButton: UIButton!
    @IBOutlet weak var statePicker: UIPickerView!
    @IBOutlet weak var rendezVous: UISegmentedControl!
    @IBOutlet weak var comment: UITextField!
    @IBOutlet weak var city: UITextField!
    @IBOutlet weak var result: UILabel!
    @IBOutlet weak var nameOfAddress: UITextField!
    @IBOutlet weak var addressOfLocation: UITextField!
    var haveRendezVous: Bool!
    var pickerData: [String]!
    var tempDB: DataManager!
    var stateAdr: String!
    var msgVar: MessageType!
    var appCheck: AppProgressionChecks!
    var nameFromTableView: String!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
         appCheck = AppProgressionChecks.startView
        initializeGlobals(appCheck)
    }
    
    override func viewWillAppear(animated: Bool) {
        //if nameFromtableView is not nil then it is from table view else it is from somewhere else
        if nameFromTableView != nil
        {
            
            let geoCoder = CLGeocoder()
            let indeX = tempDB.displayAllFromDatabase().name.indexOf(nameFromTableView)
            nameOfAddress.text = nameFromTableView
            comment.text = tempDB.displayAllFromDatabase().comment[indeX!]
            let lat = tempDB.displayAllFromDatabase().latitude[indeX!]
            let lng = tempDB.displayAllFromDatabase().longitude[indeX!]
            let location = CLLocation(latitude: lat, longitude: lng)
            geoCoder.reverseGeocodeLocation(location, completionHandler:
                { (data, error) in
                let placeMarks = data! as [CLPlacemark]
                let loc: CLPlacemark = placeMarks[0]
                    self.city.text = loc.locality
                    self.addressOfLocation.text = loc.name
            })
            if tempDB.displayAllFromDatabase().rendezvous[indeX!] == false
            {
                rendezVous.selectedSegmentIndex = 1
            }
            
        }
        
        
    }
    
    func initializeGlobals(app:AppProgressionChecks){
        switch app
        {
        case .startView:
            //let logo = UIView()
            //logo.frame = CGRect(x: 0, y: 0, width: 120, height: 120)
            //scrollingView.addSubview(logo)
            scrollingView.contentSize = CGSize(width: 0, height: 900)
           
            
             addressOfLocation.keyboardType = UIKeyboardType.NamePhonePad
            city.keyboardType = UIKeyboardType.NamePhonePad
            self.statePicker.delegate = self
            self.resultButton.setTitle("Kontinye", forState: UIControlState.Normal)
            haveRendezVous = true
            stateAdr = String()
            msgVar = MessageType.NoErr
            appCheck = AppProgressionChecks.Regular
            pickerData = [
                "Chwazi Eta ☟", "Alabama", "Alaska", "American Samoa", "Arizona", "Arkansas", "California", "Colorado", "Connecticut", "Delaware", "District of Columbia", "Florida", "Georgia", "Guam", "Hawaii", "Idaho", "Illinois", "Indiana", "Iowa", "Kansas", "Kentucky", "Louisiana", "Maine", "Maryland", "Massachusetts", "Michigan", "Minnesota", "Mississippi", "Missouri", "Montana", "Nebraska", "Nevada", "New Hampshire", "New Jersey", "New Mexico", "New York", "North Carolina", "North Dakota", "Northern Marianas Islands", "Ohio", "Oklahoma", "Oregon", "Pennsylvania", "Puerto Rico", "Rhode Island", "South Carolina", "South Dakota", "Tennessee", "Texas", "Utah", "Vermont", "Virginia", "Virgin Islands", "Washington", "West Virginia", "Wisconsin", "Wyoming"]
        case .stopView:
          
             self.statePicker.delegate = nil
            haveRendezVous = nil
            stateAdr = nil
             msgVar = nil
             appCheck = nil
        default:
            self.statePicker.delegate = nil
            haveRendezVous = nil
            stateAdr = nil
            msgVar = nil
            appCheck = nil
        }
       
    }//end of initializeGlobals()
    
    
    
    @IBAction func takeInfoFromMap(segue: UIStoryboardSegue)
    {
        if let mapVC = segue.sourceViewController as? MapViewController
        {
            let theIndex = tempDB.displayAllFromDatabase().name.indexOf(mapVC.name)
           comment.text = tempDB.displayAllFromDatabase().comment[theIndex!]
           nameOfAddress.text = tempDB.displayAllFromDatabase().name[theIndex!]
           // addressOfLocation.text =
            
        }
        
    }
    
    
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        scrollView.minimumZoomScale = 0.5
        scrollView.maximumZoomScale = 2.0
        return scrollView
    }
    
    @IBAction func deactivateResultButton(sender: AnyObject)
    {
        if nameOfAddress.editing == true
        {
            nameOfAddress.textColor = UIColor.blackColor()
        }
        self.resultButton.enabled = true
        self.resultButton.setTitle("Kontinye", forState: UIControlState.Normal)
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
        
    }//end of getselectedValueOfRendezvous(sender: AnyObject)
    
    
    func checkForEmptyInputs() -> (Bool)
    {
      
        let address = addressOfLocation.text!
        let userCity = city.text!
        let state  = stateAdr
       
        if address.isEmpty || userCity.isEmpty || state.isEmpty || state == "Chwazi Eta ☟"
        {
            return true
            
        }else
        {
            return false
        }        
    }
    
    
    
    
    @IBAction func saveUserInput(sender: UIButton) {
        let repeatedWords = (okBtn:"OK",poko:"POKO FINI", onlot:"Antre on lòt?")
        let address = addressOfLocation.text!
        let userCity = city.text!
        let state  = stateAdr
        let name: String = nameOfAddress.text!
         let tempStorage =  tempDB.displayAllFromDatabase().name.filter({$0 == name})
        if  checkForEmptyInputs() == true{
            msgVar = MessageType.EmptyUserInput
            alertMessageHandler(msgVar, bundler: ["Plas Vid"," Ken ou bliye ranpli yon pati",repeatedWords.okBtn,"", repeatedWords.poko], twoBtns: false)
        
        }else if !tempStorage.isEmpty
        {
            msgVar = MessageType.DuplicateDBEntry(name)
            alertMessageHandler(msgVar, bundler: ["Doubl", "Ou gen non \(name) sa deja", "Kembe'l","Chanje non", repeatedWords.onlot, repeatedWords.poko], twoBtns: true)
            
        }else
        {
            let modified = tempDB.modifyAddressForAPiUse(address, city: userCity, state: state)
            let session =  tempDB.connectToGoogleAPI( modified).apiSession
            let urlRequest = tempDB.connectToGoogleAPI( modified).urlRequest
            searchForLocationThruGoogle(session, urlRequest: urlRequest)
        }
        
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
    
    
    func searchForLocationThruGoogle(apiSession:NSURLSession, urlRequest:NSURLRequest)
    {
        var lat = Double()
        var lng  = Double()
        let priority = QOS_CLASS_USER_INTERACTIVE
         self.savingActivity.startAnimating()
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
           
            let task = apiSession.dataTaskWithRequest(urlRequest,completionHandler: { (data, response, error) in
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
                        self.savingActivity.stopAnimating()
                        self.msgVar = MessageType.AddressUnavailable
                        self.alertMessageHandler(self.msgVar, bundler: ["Pa egziste", "Adrès sa pa egziste","OK","","Antre on lòt?"], twoBtns: false)
                        
                    }else
                    {//There are results and we are about to save them
                        self.savingActivity.stopAnimating()
                        lat = results["results"][0]["geometry"]["location"]["lat"].doubleValue
                        lng = results["results"][0]["geometry"]["location"]["lng"].doubleValue
                        let tempAdr =  results["results"][0]["formatted_address"].stringValue
                        self.msgVar = MessageType.AddressVerification(lat, lng)
                        self.alertMessageHandler(self.msgVar, bundler: ["Verifye", "Eske se adrès sa ou vle?\n\(tempAdr)","OUI", "NON","Antre On lòt?", "POKO FINI"], twoBtns: true)
                        
                    }//End There are results and we are about to save them
                    
                }//end UI dispatch
                
                
            })
            
            
            task.resume()
            task.suspend()
        }//end of global dispatch
        
    }//end of searchForLocationThruGoogle(apiSession:NSURLSession, urlRequest:NSURLRequest)
    
    
    func alertMessageHandler( errType: MessageType, bundler:[String], twoBtns:Bool)
    {
       
        let alertController = UIAlertController(title: bundler[0], message: bundler[1], preferredStyle: .Alert)
        let OKAction = UIAlertAction(title: bundler[2], style: .Default) { (action) in
            
            switch errType
            {
                //ok button, messge:Ken ou bliye rempli yon pati,resultbuton enable:false title:POKO FINI state normal
            case .EmptyUserInput:
                alertController.dismissViewControllerAnimated(true, completion: nil)
                self.resultButton.setTitle(bundler[4], forState: UIControlState.Normal)
                
            case .DuplicateDBEntry(let recordName):
                    self.tempDB.updateEntriesToDb(recordName, comment: self.comment.text!, rendezvous: self.haveRendezVous, recordName: recordName)
                alertController.dismissViewControllerAnimated(true, completion: nil)
                self.resultButton.setTitle(bundler[4], forState: UIControlState.Normal)
            case .AddressVerification(let lat , let lng):
                alertController.dismissViewControllerAnimated(true, completion: nil)
                self.resultButton.setTitle(bundler[4], forState: UIControlState.Normal)
                self.tempDB.insertIntoDatabase(self.nameOfAddress.text!, comment: self.comment.text!, rendezvous: self.haveRendezVous, lat: lat, lng: lng)
            case .AddressUnavailable:
                alertController.dismissViewControllerAnimated(true, completion: nil)
                self.resultButton.setTitle(bundler[4], forState: UIControlState.Normal)
            default:
               alertController.dismissViewControllerAnimated(true, completion: nil)
            }
        }//end of OKbtn
        
        let cancelAction = UIAlertAction(title: bundler[3], style: .Cancel) { (action) in
            switch errType
            {
            case .DuplicateDBEntry( _):
                 alertController.dismissViewControllerAnimated(true, completion: nil)
                 self.nameOfAddress.becomeFirstResponder()
                 self.nameOfAddress.textColor = UIColor.colorWithAlphaComponent(UIColor.redColor())(0.7)
                self.resultButton.setTitle(bundler[5], forState: UIControlState.Normal)
            case .AddressVerification( _ , _):
                alertController.dismissViewControllerAnimated(true, completion: nil)
                self.resultButton.setTitle(bundler[5], forState: UIControlState.Normal)
            default:
                
              alertController.dismissViewControllerAnimated(true, completion: nil)
            }
        }//end of cancel btn
        
    if twoBtns == true
        {
            alertController.addAction(cancelAction)
            
        }
                alertController.addAction(OKAction)
                self.presentViewController(alertController, animated: true, completion: nil)
            
        
    }//end of alertMessageHandler( errType: MessageType, bundler:[String], twoBtns:Bool)
    
       
    override func viewWillDisappear(animated: Bool) {
       
        appCheck = AppProgressionChecks.stopView
        initializeGlobals(appCheck)

        print(" Address viewWillDisappear evoked!")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    
    }

    
    
    
}//end of class
