//
//  MainViewController.swift
//  weather-app
//
//  Created by Annie Tang on 10/9/17.
//  Copyright © 2017 Annie Tang. All rights reserved.
//

import UIKit
import Foundation
import Alamofire
import CoreLocation

class MainViewController: UIViewController, UIWebViewDelegate  {
    
    /* rain info */
    var minuteLabel: UILabel!
    var colonLabel: UILabel!
    var rainAtLabel: UILabel!
    
    /* temperature info */
    var tempLabel: UILabel!
    var farenLabel: UILabel!
    var conditionLabel: UILabel!
    
    /* main info */
    var titleLabel: UILabel!
    var mainWeatherIcon: UIImageView!
    var descriptionTextView: UITextView!
    
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
    var hourlyTemp : Double!
    var minuteRain : Int!
    var conditionDesc: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Constants.blue
        
        setupLocation()
        let notifKey = "com.test.specialNotificationKey"
        NotificationCenter.default.addObserver(self, selector: #selector(setupLocation), name: NSNotification.Name(rawValue: notifKey), object: nil)

    }
    
    /* UI: setting up Powered By Dark Sky */
    func setupPoweredBy() {
        let darkSkyLogo = UIImageView(frame:
            CGRect(x: 175,
                   y: 611,
                   width: 26,
                   height: 26))
        darkSkyLogo.image = #imageLiteral(resourceName: "darkskylogo")
        view.addSubview(darkSkyLogo)
        
        let darkSkyLabel = UILabel(frame:
            CGRect(x: 101,
                   y: 637,
                   width: 173,
                   height: 22))
        darkSkyLabel.text = "powered by Dark Sky"
        darkSkyLabel.textAlignment = .center
        darkSkyLabel.textColor = .white
        darkSkyLabel.font = Constants.avenir
        darkSkyLabel.font = darkSkyLabel.font.withSize(15)
        view.addSubview(darkSkyLabel)
        
        let darkSkyWebView = UIButton(frame:
            CGRect(x: 101,
                   y: 637,
                   width: 173,
                   height: 22))
        darkSkyWebView.addTarget(self, action: #selector(segueToDarkSky), for: .touchUpInside)
        view.addSubview(darkSkyWebView)
    }
    
    @objc func segueToDarkSky() {
        performSegue(withIdentifier: "segueToWebView", sender: self)
    }

    
    /* UI: setting up main circles */
    func setupShapes() {
        let mainCircle = UIView(frame: CGRect(x: 74,
                                              y: 67 + 114,
                                              width: 228,
                                              height: 228))
        mainCircle.layer.cornerRadius = 114
        mainCircle.layer.borderColor = UIColor.white.cgColor
        mainCircle.layer.borderWidth = 5
        mainCircle.clipsToBounds = true
        self.view.addSubview(mainCircle)
        
        let leftBlock = UIView(frame: CGRect(x: 74,
                                             y: 67 + 130,
                                             width: 88,
                                             height: 130))
        leftBlock.layer.backgroundColor = Constants.blue.cgColor
        leftBlock.clipsToBounds = true
        self.view.addSubview(leftBlock)
        
        let rightBlock = UIView(frame: CGRect(x: 225,
                                              y: 67 + 209,
                                              width: 88,
                                              height: 128))
        rightBlock.layer.backgroundColor = Constants.blue.cgColor
        rightBlock.clipsToBounds = true
        self.view.addSubview(rightBlock)
        
        let topLeft = UIView(frame: CGRect(x: 121,
                                              y: 67 + 118,
                                              width: 25,
                                              height: 25))
        topLeft.layer.cornerRadius = 12.5
        topLeft.layer.backgroundColor = UIColor.white.cgColor
        topLeft.clipsToBounds = true
        self.view.addSubview(topLeft)
        
        let topRight = UIView(frame: CGRect(x: 220,
                                           y: 67 + 317,
                                           width: 25,
                                           height: 25))
        topRight.layer.cornerRadius = 12.5
        topRight.layer.backgroundColor = UIColor.white.cgColor
        topRight.clipsToBounds = true
        self.view.addSubview(topRight)
        
        let bottomBG = UIView(frame: CGRect(x: 0,
                                            y: 456,
                                            width: 375,
                                            height: 211))
        bottomBG.layer.backgroundColor = Constants.lightBlue.cgColor
        bottomBG.clipsToBounds = true
        self.view.addSubview(bottomBG)
        
        setupLines()
    }
    
    /* UI: setting up all three lines */
    func setupLines() {
        let leftLine = UIView(frame: CGRect(x: 55.5,
                                            y: 67 + 258.5,
                                            width: 54,
                                            height: 5))
        leftLine.layer.borderColor = UIColor.white.cgColor
        leftLine.layer.borderWidth = 5
        self.view.addSubview(leftLine)
        
        let rightLine = UIView(frame: CGRect(x: 269.5,
                                            y: 67 + 209.5,
                                            width: 54,
                                            height: 5))
        rightLine.layer.borderColor = UIColor.white.cgColor
        rightLine.layer.borderWidth = 5
        self.view.addSubview(rightLine)

        let mainLine = UIView(frame: CGRect(x: 0,
                                             y: 455.5,
                                             width: 375,
                                             height: 3))
        mainLine.layer.borderColor = Constants.blue.cgColor
        mainLine.layer.borderWidth = 3
        mainLine.layer.shadowColor = UIColor.black.cgColor
        mainLine.layer.shadowOpacity = 0.4
        mainLine.layer.shadowOffset = CGSize(width: 0, height: 4)
        mainLine.layer.shadowRadius = 3
        mainLine.layer.shouldRasterize = true
        self.view.addSubview(mainLine)
    }
   
    /* UI: setting up current location */
    @objc func setupTitle() {
        titleLabel = UILabel(frame:
            CGRect(x: 0,
                   y: 67 + 55,
                   width: 375,
                   height: 26))
        titleLabel.text = "today's weather"
        titleLabel.textAlignment = .center
        titleLabel.textColor = .white
        titleLabel.font = Constants.avenir
        titleLabel.font = titleLabel.font.withSize(25)
        view.addSubview(titleLabel)
    }
    
    /* UI: setting up main weather icon */
    func setupMainWeatherIcon() {
        mainWeatherIcon = UIImageView(frame:
                            CGRect(x: 131,
                                   y: 57 + 180,
                                   width: 120,
                                   height: 120))
        getMainWeatherImage()
        self.view.addSubview(mainWeatherIcon)
    }
    
    func getMainWeatherImage() {
        switch conditionDesc {
            case "clear-day":
                mainWeatherIcon.image = #imageLiteral(resourceName: "sun")
            case "rain":
                mainWeatherIcon.image = #imageLiteral(resourceName: "rain")
            case "cloudy":
                mainWeatherIcon.image = #imageLiteral(resourceName: "cloudy")
            default:
                mainWeatherIcon.image = #imageLiteral(resourceName: "semi-cloudy")
        }
    }
    
    
    /* UI: setting up main temperature */
    func setupMainTemperature() {
        tempLabel = UILabel(frame:
            CGRect(x: 267,
                   y: 65 + 205,
                   width: 60,
                   height: 80))
        tempLabel.text = String(Int(hourlyTemp))
        tempLabel.textAlignment = .right
        tempLabel.textColor = .white
        tempLabel.font = Constants.avenirDemiBold
        tempLabel.font = tempLabel.font.withSize(45)
        view.addSubview(tempLabel)
        
        farenLabel = UILabel(frame:
            CGRect(x: 269,
                   y: 75 + 254,
                   width: 55,
                   height: 23))
        farenLabel.text = "°F"
        farenLabel.textAlignment = .right
        farenLabel.textColor = .white
        farenLabel.font = Constants.avenir
        farenLabel.font = farenLabel.font.withSize(20)
        view.addSubview(farenLabel)
    }
    
    /* UI: setting up condition for non-rainy days */
    func setupNonRainCondition() {
        conditionLabel = UILabel(frame:
            CGRect(x: 56,
                   y: 67 + 237,
                   width: 55,
                   height: 17))
        conditionLabel.textAlignment = .left
        conditionLabel.textColor = .white
        conditionLabel.font = Constants.avenirMedium
        conditionLabel.font = conditionLabel.font.withSize(10.5)
        view.addSubview(conditionLabel)
        getConditionLabelText()
    }
    
    
    func getConditionLabelText() {
        switch conditionDesc {
            case "clear-day":
                conditionLabel.text = "C L E A R"
            case "cloudy":
                conditionLabel.text = "C L O U D Y"
            default:
                conditionLabel.removeFromSuperview()
        }
    }
    
    /* UI: setting up rain info */
    func setupRainInfo() {
        minuteLabel = UILabel(frame:
            CGRect(x: 55,
                   y: 67 + 225,
                   width: 57,
                   height: 35))
        minuteLabel.text = String(minuteRain)
        minuteLabel.textAlignment = .right
        minuteLabel.textColor = .white
        minuteLabel.font = Constants.avenirDemiBold
        minuteLabel.font = minuteLabel.font.withSize(35)
        view.addSubview(minuteLabel)
        
        colonLabel = UILabel(frame:
            CGRect(x: 53,
                   y: 67 + 217,
                   width: 10,
                   height: 44))
        colonLabel.text = ":"
        colonLabel.textAlignment = .right
        colonLabel.textColor = .white
        colonLabel.font = Constants.avenirDemiBold
        colonLabel.font = colonLabel.font.withSize(30)
        view.addSubview(colonLabel)
        
        rainAtLabel = UILabel(frame:
            CGRect(x: 55,
                   y: 67 + 210,
                   width: 55,
                   height: 13))
        rainAtLabel.text = "R A I N  A T"
        rainAtLabel.textAlignment = .left
        rainAtLabel.textColor = .white
        rainAtLabel.font = Constants.avenirMedium
        rainAtLabel.font = rainAtLabel.font.withSize(10.5)
        view.addSubview(rainAtLabel)
    }

    /* UI: setting up description */
    func setupWeatherDescription() {
        descriptionTextView = UITextView(frame:
            CGRect(x: 49,
                   y: 499,
                   width: 285,
                   height: 89))
        descriptionTextView.isEditable = false
        descriptionTextView.text = dailySummary
        descriptionTextView.textAlignment = .center
        descriptionTextView.textColor = .white
        descriptionTextView.backgroundColor = Constants.lightBlue
        descriptionTextView.font = Constants.avenir
        descriptionTextView.font = descriptionTextView.font?.withSize(20)
        
        view.addSubview(descriptionTextView)
    }
}
