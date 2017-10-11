//
//  MainViewController.swift
//  weather-app
//
//  Created by Annie Tang on 10/9/17.
//  Copyright © 2017 Annie Tang. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UIWebViewDelegate  {
    // clear, cloudy, rain
    let weatherIcons: [String: UIImage] = ["clear": #imageLiteral(resourceName: "sun"), "cloudy": #imageLiteral(resourceName: "cloudy"), "rain": #imageLiteral(resourceName: "rain")]
    
    /* rain info */
    var minuteLabel: UILabel!
    var colonLabel: UILabel!
    var rainAtLabel: UILabel!
    
    /* temperature info */
    var tempLabel: UILabel!
    var farenLabel: UILabel!
    var conditionLabel: UILabel!
    
    /* main info */
    var locationLabel: UILabel!
    var mainWeatherIcon: UIImageView!
    var descriptionTextView: UITextView!
    
    /* future weather */
    var collectionView: UICollectionView!
    
    /* data taken from JSON */
    var rainTime : NSDate!
    var userLocation : String = "berkeley, ca"
    var dailySummary : String!
    var hourlySummary : String!
    var hourlyTemp : Int = 62
    var minuteRain: Int!
    
    var futureForecasts: [String: Any]!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Constants.blue
        setupShapes()
        setupPoweredBy()
        
        setupLocation()
        setupMainWeatherIcon()
        setupMainTemperature()
        setupRainInfo()
        setupWeatherDescription()
        
        setupFutureWeather()
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
    
    /* UI: setting up main circles */
    func setupShapes() {
        let mainCircle = UIView(frame: CGRect(x: 74,
                                              y: 114,
                                              width: 228,
                                              height: 228))
        mainCircle.layer.cornerRadius = 114
        mainCircle.layer.borderColor = UIColor.white.cgColor
        mainCircle.layer.borderWidth = 5
        mainCircle.clipsToBounds = true
        self.view.addSubview(mainCircle)
        
        let leftBlock = UIView(frame: CGRect(x: 74,
                                             y: 130,
                                             width: 88,
                                             height: 130))
        leftBlock.layer.backgroundColor = Constants.blue.cgColor
        leftBlock.clipsToBounds = true
        self.view.addSubview(leftBlock)
        
        let rightBlock = UIView(frame: CGRect(x: 225,
                                              y: 209,
                                              width: 88,
                                              height: 128))
        rightBlock.layer.backgroundColor = Constants.blue.cgColor
        rightBlock.clipsToBounds = true
        self.view.addSubview(rightBlock)
        
        let topLeft = UIView(frame: CGRect(x: 121,
                                              y: 118,
                                              width: 25,
                                              height: 25))
        topLeft.layer.cornerRadius = 12.5
        topLeft.layer.backgroundColor = UIColor.white.cgColor
        topLeft.clipsToBounds = true
        self.view.addSubview(topLeft)
        
        let topRight = UIView(frame: CGRect(x: 220,
                                           y: 317,
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
        bottomBG.layer.backgroundColor = UIColor(hexString: "#7FC1F8").cgColor
        bottomBG.clipsToBounds = true
        self.view.addSubview(bottomBG)
        
        setupLines()
    }
    
    /* UI: setting up all three lines */
    func setupLines() {
        let leftLine = UIView(frame: CGRect(x: 55.5,
                                            y: 258.5,
                                            width: 54,
                                            height: 5))
        leftLine.layer.borderColor = UIColor.white.cgColor
        leftLine.layer.borderWidth = 5
        self.view.addSubview(leftLine)
        
        let rightLine = UIView(frame: CGRect(x: 269.5,
                                            y: 209.5,
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
    func setupLocation() {
        locationLabel = UILabel(frame:
            CGRect(x: 0,
                   y: 55,
                   width: 375,
                   height: 26))
        locationLabel.text = userLocation.lowercased()
        locationLabel.textAlignment = .center
        locationLabel.textColor = .white
        locationLabel.font = Constants.avenir
        locationLabel.font = locationLabel.font.withSize(25)
        view.addSubview(locationLabel)
    }
    
    /* UI: setting up main weather icon */
    func setupMainWeatherIcon() {
        mainWeatherIcon = UIImageView(frame:
                            CGRect(x: 131,
                                   y: 180,
                                   width: 120,
                                   height: 120))
        mainWeatherIcon.image = weatherIcons["rain"]
        self.view.addSubview(mainWeatherIcon)
        
    }
    
    /* UI: setting up main temperature */
    func setupMainTemperature() {
        tempLabel = UILabel(frame:
            CGRect(x: 267,
                   y: 205,
                   width: 60,
                   height: 67))
        tempLabel.text = String(hourlyTemp)
        tempLabel.textAlignment = .right
        tempLabel.textColor = .white
        tempLabel.font = Constants.avenirDemiBold
        tempLabel.font = tempLabel.font.withSize(49)
        view.addSubview(tempLabel)
        
        farenLabel = UILabel(frame:
            CGRect(x: 269,
                   y: 254,
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
                   y: 237,
                   width: 55,
                   height: 17))
        conditionLabel.text = "C L E A R"
        conditionLabel.textAlignment = .left
        conditionLabel.textColor = .white
        conditionLabel.font = Constants.avenirMedium
        conditionLabel.font = conditionLabel.font.withSize(10.5)
        view.addSubview(conditionLabel)
    }
    
    /* UI: setting up rain info */
    func setupRainInfo() {
        minuteLabel = UILabel(frame:
            CGRect(x: 55,
                   y: 225,
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
                   y: 217,
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
                   y: 210,
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
            CGRect(x: 55,
                   y: 363,
                   width: 266,
                   height: 70))
        descriptionTextView.isEditable = false
        descriptionTextView.text = "Partly cloudy starting this afternoon, continuing until tomorrow morning."
        descriptionTextView.textAlignment = .center
        descriptionTextView.textColor = .white
        descriptionTextView.backgroundColor = Constants.blue
        descriptionTextView.font = Constants.avenir
        descriptionTextView.font = descriptionTextView.font?.withSize(15)
        view.addSubview(descriptionTextView)
    }

    /* UI: setting up future forecasts */
    func setupFutureWeather() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        collectionView = UICollectionView(frame:
            CGRect(x: 24,
                   y: UIApplication.shared.statusBarFrame.maxY + view.frame.height * 0.1 + 10,
                   width: 329,
                   height: 111), collectionViewLayout: layout)
        collectionView.register(FutureForecastCollectionCell.self, forCellWithReuseIdentifier: "collectionViewCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = Constants.blue
        view.addSubview(collectionView)
    }
}
