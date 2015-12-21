//
//  DataManager.swift
//  trymap
//
//  Created by nikenson midi on 12/14/15.
//  Copyright © 2015 pnmidi. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import SQLite

class DataManager: NSObject{
    
     private var databasePath = NSString()
    private var placeDB = FMDatabase()
    
   override init() {
        print("init from data manager is invoked")
        let filemgr = NSFileManager.defaultManager()
        let path = NSSearchPathForDirectoriesInDomains(
            .DocumentDirectory, .UserDomainMask, true
            ).first!
        databasePath = String(path) + "/place.db"
        
        if !filemgr.fileExistsAtPath(databasePath as String) {
            placeDB = FMDatabase(path: databasePath as String)
            if placeDB.open() {
                let sql_stmt = "CREATE TABLE IF NOT EXISTS place (ID INTEGER PRIMARY KEY AUTOINCREMENT, NAME TEXT UNIQUE, COMMENT TEXT, RENDEZVOUS TEXT, LATITUDE DOUBLE, LONGITUDE DOUBLE)"
                print("statement is executed")
                
                if !placeDB.executeStatements(sql_stmt) {
                    print("Error: \(placeDB.lastErrorMessage())")
                }
                placeDB.close()
            } else {
                print("Error: \(placeDB.lastErrorMessage())")
            }

        }else{
             placeDB = FMDatabase(path: databasePath as String)
        }

        
    }//end of startHelper()
    
    
    
    
    
    
     func displayAllFromDatabase() ->
        (id: [Int32], name: [String], comment:[String], rendezvous:[Bool], latitude: [Double],longitude:[Double])
    {
       
        var id: [Int32] = [Int32]()
        
        var name: [String] = [String]()
        var comment:[String] = [String]()
        var rendezvous:[Bool] = [Bool]()
        var latitude: [Double] = [Double]()
        var longitude:[Double] = [Double]()
        
        
        if placeDB.open() {
            let querySQL = "SELECT * FROM place"
            
            let results:FMResultSet? = placeDB.executeQuery(querySQL,
                withArgumentsInArray: nil)
            
            while  (results?.next() == true){
                //Cannot use subsbscript on arrays use append()
                
                id.append((results?.intForColumn("id"))!)
                name.append((results?.stringForColumn("name"))!)
                comment.append((results?.stringForColumn("comment"))!)
                let temp: NSString = (results?.stringForColumn("rendezvous"))!
                latitude.append((results?.doubleForColumn("latitude"))!)
                longitude.append((results?.doubleForColumn("longitude"))!)
                rendezvous.append(temp.boolValue)
                
            }
            
            
            placeDB.close()
        } else {
            print("Error: \(placeDB.lastErrorMessage())")
        }
        
        return(id, name,comment, rendezvous, latitude, longitude)
    }
    
    
    
    func insertIntoDatabase(name: String,comment:String, rendezvous:Bool,lat:Double, lng: Double) ->(Bool)
    {
      var isSaved = Bool()
        
        if placeDB.open() {
            
            let insertSQL = "INSERT INTO place (name, comment, rendezvous, latitude, longitude) VALUES ('\(name)', '\(comment)', '\(rendezvous)','\(lat)','\(lng)')"
            
            let result = placeDB.executeUpdate(insertSQL,
                withArgumentsInArray: nil)
           
            isSaved = true
            if !result {
                isSaved = false
                print("Error: \(placeDB.lastErrorMessage())")
            } else {
                
            }
        } else {
            isSaved = false
            print("Error: \(placeDB.lastErrorMessage())")
        }
        
         placeDB.close()
        return  isSaved
        
    }//end of insertIntoDatabase
    
    
    func modifyAddressForAPiUse(streetAddress: String, city:String, state:String)-> String{
        let streetAddressArr = streetAddress.componentsSeparatedByString(" ")
        let cityArr = city.componentsSeparatedByString(" ")
        
        var returnAddress = ""
        for element in streetAddressArr{
            returnAddress += "+"+element.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        }
        returnAddress += ","
        for element in cityArr{
            returnAddress += "+"+element.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        }
        returnAddress += ",+"+state.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        
        return returnAddress
    }
    
    func connectToGoogleAPI(modifiedAddress: String)->(apiSession:NSURLSession, urlRequest:NSURLRequest){
        let googleKey : String = "AIzaSyBVmwkvF5l4lJndXR3_lw_DtWKZ9DdqwxQ"//server key
        
        
        
        let stringUrl: String = "https://maps.googleapis.com/maps/api/geocode/json?address=\(modifiedAddress)&key=\(googleKey)"
        
        let urlObject = NSURL(string:stringUrl)
        
        let urlRequest = NSURLRequest(URL: urlObject!)
        let config = NSURLSessionConfiguration.ephemeralSessionConfiguration()
        //NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: config)
        return(session,urlRequest )

    }
    
    
   
    
    func getApiResponse(apiSession:NSURLSession, urlRequest:NSURLRequest) ->(JSON)
    {
       
     
        var success:Bool = Bool()
        let forSakeOfOptional = "{\"entryID\": 1,\"from\": \"String\",\"to\": \"String\",\"value\": \"String\"}"
        var  results: JSON! = JSON(forSakeOfOptional)
        
            
        let task = apiSession.dataTaskWithRequest(urlRequest,completionHandler: { (data, response, error) in
            if(error != nil){
                print("there is an error")
            }
            guard let responseData = data else {
                print("Error: did not receive data")
                success = false
                return
            }
            guard error == nil else {
                print("error calling the api")
                print(error)
               success = false
                return
            }
            
            print("Success after guard error..:\(success)\n")
            results = JSON(data: responseData)
        
            
                      
        })
        task.resume()
        return (results)
        
    }//end of searchService()

    
    
    
       
    
    deinit{
        
        print("Datamanager is now leaving the scene!\n")
    }
    
    
    
    
    
    
}//end of DatManager