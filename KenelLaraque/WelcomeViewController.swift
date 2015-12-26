//
//  ViewController.swift
//  KenelLaraque
//
//  Created by nikenson midi on 12/14/15.
//  Copyright © 2015 pnmidi. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {

    var tempDB: DataManager!
   
    
    override func viewDidLoad() {
        tempDB = DataManager()
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
       
        
     
    }
    
   
    // How to set the orientation.
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.All
    }
       
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showList" {
            if let destination = segue.destinationViewController as? ChoicesTableViewController {
                    destination.tempDB = tempDB
            }
        }else if segue.identifier == "registerInfo" {
            if let destination = segue.destinationViewController as? AddressCaptureViewController {
            destination.tempDB = tempDB
          
            }

        }
}//end of prepareForSegue
        
    @IBAction func redirectToWelcome(segue: UIStoryboardSegue)
    {
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillDisappear(animated: Bool) {
     
        print("Welcome WillDisappear evoke!")
    }

    
 
    
    
    
    
    

}//end of class

