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
        hourlySummary = ((((jsonResponse.object(forKey: "hourly") as! NSDictionary).object(forKey: "data") as! NSArray)[0] as! NSDictionary).object(forKey: "summary")) as! String
        print(hourlySummary)
        
        hourlyTemp = ((((jsonResponse.object(forKey: "hourly") as! NSDictionary).object(forKey: "data") as! NSArray)[0] as! NSDictionary).object(forKey: "temperature")) as! Double
        print(hourlyTemp)
        
        dailySummary = (jsonResponse.object(forKey: "daily") as! NSDictionary).object(forKey: "summary") as! String
        print(dailySummary)
        
        //Parse the object for the minute that rain starts
        let minuteData = (jsonResponse.object(forKey: "minutely") as! NSDictionary).object(forKey: "data") as! NSArray
        //print(minuteData)
        for i in minuteData {
            if ((i as! NSDictionary).object(forKey: "precipProbability") as! Float) > 0.4 {
                let time = (i as! NSDictionary).object(forKey: "time") as! Double
                rainTime = NSDate(timeIntervalSince1970: time)
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

