//
//  ChoicesTableViewController.swift
//  KenelLaraque
//
//  Created by nikenson midi on 12/18/15.
//  Copyright © 2015 pnmidi. All rights reserved.
//

import UIKit

class ChoicesTableViewController: UITableViewController {

   
    var tempDB: DataManager!
    var getOptions: String!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = false
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.rightBarButtonItem = self.editButtonItem()
        self.navigationItem.rightBarButtonItem!.title = "Korije"
       
    }
    
    override func viewWillAppear(animated: Bool) {
      
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
         return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tempDB.displayAllFromDatabase().name.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("uiCell",forIndexPath: indexPath) as UITableViewCell
         getOptions = tempDB.displayAllFromDatabase().name[indexPath.row]
        cell.textLabel!.text = getOptions
        if  tempDB.displayAllFromDatabase().rendezvous[indexPath.row] == true
        {
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
            cell.detailTextLabel!.text = "Ou genyen randevou nan zòn sa a"
        }else
        {
            cell.detailTextLabel!.text = ""
        }
        
        
        /**
         let dimensions =  CGRect(x:0 , y: 0, width: 50, height: 50)
        let infoView = UIView(frame: dimensions )
        let infoLabel = UILabel()
        infoLabel.text = "\(tempDB.displayAllFromDatabase().comment[indexPath.row])"
        infoView.addSubview(infoLabel)
        cell.editingAccessoryView = infoView
*/
        return cell
     
    }


    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tempDB.deleteEntriesFromDb(tempDB.displayAllFromDatabase().name[indexPath.row])
            
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    
    override func tableView(tableView: UITableView, titleForDeleteConfirmationButtonForRowAtIndexPath indexPath: NSIndexPath) -> String?
    {
        return "Anile?"
    }
    
    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        if editing {
            self.editButtonItem().title = "Ou fini Ken?"
        }else
        {
          self.editButtonItem().title = "Korije"
        }
    
    
    }
    
    
    
    
   
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        let indexPath: NSIndexPath = self.tableView.indexPathForSelectedRow!
        if segue.identifier == "showMap"
        {
            if let destination = segue.destinationViewController as? MapViewController
            {
                destination.name = tempDB.displayAllFromDatabase().name[indexPath.row]
                destination.tempDB = tempDB
            }
        }
       
    }//end of segue
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return false if you do not want the specified item to be editable.
    return true
    }
    */
    

    

}//end of class
