//
//  MainViewController.swift
//  weather-app
//
//  Created by Annie Tang on 10/9/17.
//  Copyright © 2017 Annie Tang. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UIWebViewDelegate  {
    let blue: UIColor = UIColor(hexString: "#6CB6F5")
    let avenir: UIFont = UIFont(name: "AvenirNext-Regular", size: 40)!
    
    // sun, cloudy, semi-cloudy, rain, lightning
    let weatherIcons = [#imageLiteral(resourceName: "sun"), #imageLiteral(resourceName: "cloudy"), #imageLiteral(resourceName: "semi-cloudy"), #imageLiteral(resourceName: "rain"), #imageLiteral(resourceName: "lightening")]
    
    var locationLabel: UILabel!
    
    var hourLabel: UILabel!
    var minuteLabel: UILabel!
    var amPMLabel: UILabel!
    
    var tempLabel: UILabel!
    var conditionLabel: UILabel!
    
    var descLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = blue
        setupShapes()
        setupPoweredBy()
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
        darkSkyLabel.font = avenir
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
        leftBlock.layer.backgroundColor = blue.cgColor
        leftBlock.clipsToBounds = true
        self.view.addSubview(leftBlock)
        
        let rightBlock = UIView(frame: CGRect(x: 225,
                                              y: 209,
                                              width: 88,
                                              height: 128))
        rightBlock.layer.backgroundColor = blue.cgColor
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
        mainLine.layer.borderColor = blue.cgColor
        mainLine.layer.borderWidth = 3
        mainLine.layer.shadowColor = UIColor.black.cgColor
        mainLine.layer.shadowOpacity = 0.4
        mainLine.layer.shadowOffset = CGSize(width: 0, height: 4)
        mainLine.layer.shadowRadius = 3
        mainLine.layer.shouldRasterize = true
        self.view.addSubview(mainLine)
    }
    
    /* UI: setting up main temperature */
    func setupMainTemperature() {
        hourLabel = UILabel(frame:
            CGRect(x: 59,
                   y: 175,
                   width: 253,
                   height: 85))
        hourLabel.text = "SIGNUP"
        hourLabel.textAlignment = .center
        hourLabel.textColor = .white
        hourLabel.font = UIFont(name: "HelveticaNeue-BoldItalic", size: 50)
        view.addSubview(hourLabel)
    }
}
