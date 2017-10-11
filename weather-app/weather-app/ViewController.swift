//
//  ViewController.swift
//  weather-app
//
//  Created by Annie Tang on 10/8/17.
//  Copyright © 2017 Annie Tang. All rights reserved.
//

import UIKit
import Foundation
import Alamofire
import CoreLocation

class ViewController: UIViewController {
    
    /*Create API call functions*/
    
    //API Key
    let apiKey: String = "295a15b47e1a3e4649c5f43bfa41a17e"
    
    //Create the location manager
    let locationManager = CLLocationManager()
    
    //User current latitude and longitude
    var latitude : CLLocationDegrees!
    var longitude : CLLocationDegrees!
    
    //JSON response
    var jsonResponse : NSDictionary!
    var rainTime : NSDate!
    var dailySummary : String!
    var hourlySummary : String!
    var hourlyTemp : Double!
    var minuteRain : Int!
    var weekArray : NSArray!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set up the location of the user
        setupLocation()
    }
    
    func setupLocation(){
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
    }
    
    //Get the weather using AlamoFire
    func getWeather(){
        print("Request: https://api.darksky.net/forecast/\(apiKey)/\(latitude!),\(longitude!)")
        Alamofire.request("https://api.darksky.net/forecast/\(apiKey)/\(latitude!),\(longitude!)").responseJSON { (response) in
            if let status = response.response?.statusCode {
                switch(status){
                case 200:
                    print("API Connection Success")
                    self.jsonResponse = response.result.value as! NSDictionary
                    
                    //Call JSON cleaner and update variables needed
                    self.jsonProcessing()
                default:
                    print("error with response status: \(status)")
                    return
                }
            }
        }
        
        
    }
    
    //JSON cleaner and variable updated
    func jsonProcessing(){
        //Pull the weeks information from the Json response
        weekArray = (jsonResponse.object(forKey: "daily") as! NSDictionary).object(forKey: "data") as! NSArray
        
        //You can access the next seven days using weekArray
        print(weekArray[0])
        
        //If you want the name of the day of that particular day you can do this
        let day = NSDate(timeIntervalSince1970: ((weekArray[0] as! NSDictionary).object(forKey: "time") as! Double))
        let dayName = Calendar.current.component(.day, from: day as Date)
        print(dayName)
        
        //If you want the temperature of that particular day or anything else then you first convert weekArray[0] to
        //a NSDictionary by weekArray[0] as! NSDictionary and then you can get attributes using
        //(weekArray[0] as! NSDictionary).object(forKey: "temperatureMin") as! Double and you can replace the key with
        //any key value in the JSON object. You can see all keys by running print((weekArray[0] as! NSDictionary).allKeys)
        print((weekArray[0] as! NSDictionary).allKeys)
        /*print(weekArray[1])
        print(weekArray[2])
        print(weekArray[3])
        print(weekArray[4])
        print(weekArray[5])*/
        
        hourlySummary = ((((jsonResponse.object(forKey: "hourly") as! NSDictionary).object(forKey: "data") as! NSArray)[0] as! NSDictionary).object(forKey: "summary")) as! String
        //print(hourlySummary)
        
        
        hourlyTemp = ((((jsonResponse.object(forKey: "hourly") as! NSDictionary).object(forKey: "data") as! NSArray)[0] as! NSDictionary).object(forKey: "temperature")) as! Double
        //print(hourlyTemp)
        
        dailySummary = (jsonResponse.object(forKey: "daily") as! NSDictionary).object(forKey: "summary") as! String
        //print(dailySummary)
        
        //Parse the object for the minute that rain starts
        let minuteData = (jsonResponse.object(forKey: "minutely") as! NSDictionary).object(forKey: "data") as! NSArray
        //print(minuteData)
        for i in minuteData {
            if ((i as! NSDictionary).object(forKey: "precipProbability") as! Float) > 0.4 {
                let time = (i as! NSDictionary).object(forKey: "time") as! Double
                rainTime = NSDate(timeIntervalSince1970: time)
                minuteRain = (Calendar.current.component(.minute, from: rainTime as Date))
                setupUI()
            }
        }
    }
    
    //Setup UI with JSON Values parsed
    func setupUI(){
        
    }
}

extension ViewController: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        latitude = locValue.latitude
        longitude = locValue.longitude
        
        //If user location changes update the weather location
        getWeather()
    }
}

