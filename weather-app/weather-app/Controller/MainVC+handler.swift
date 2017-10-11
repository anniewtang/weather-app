//
//  MainVC+handler.swift
//  weather-app
//
//  Created by Annie Tang on 10/10/17.
//  Copyright © 2017 Annie Tang. All rights reserved.
//

import UIKit
import Foundation
import Alamofire
import CoreLocation

extension MainViewController: CLLocationManagerDelegate {    
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
    func getWeather() {
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
    func jsonProcessing() {        
        //If you want the name of the day of that particular day you can do this
        let day = NSDate(timeIntervalSince1970: ((weekArray[0] as! NSDictionary).object(forKey: "time") as! Double))
        let dayName = Calendar.current.component(.day, from: day as Date)
        
        hourlySummary = ((((jsonResponse.object(forKey: "hourly") as! NSDictionary).object(forKey: "data") as! NSArray)[0] as! NSDictionary).object(forKey: "summary")) as! String
        
        hourlyTemp = ((((jsonResponse.object(forKey: "hourly") as! NSDictionary).object(forKey: "data") as! NSArray)[0] as! NSDictionary).object(forKey: "temperature")) as! Double
        
        dailySummary = (jsonResponse.object(forKey: "daily") as! NSDictionary).object(forKey: "summary") as! String
        
        conditionDesc = (jsonResponse.object(forKey: "daily") as! NSDictionary).object(forKey: "icon") as! String
        
        //Parse the object for the minute that rain starts
        let minuteData = (jsonResponse.object(forKey: "minutely") as! NSDictionary).object(forKey: "data") as! NSArray
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
        setupShapes()
        setupPoweredBy()
        
        setupLocation()
        setupMainWeatherIcon()
        setupMainTemperature()
        setupRainInfo()
        setupWeatherDescription()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        latitude = locValue.latitude
        longitude = locValue.longitude
        
        //If user location changes update the weather location
        getWeather()
    }
}
