//
//  FutureForcastCollectionCellView.swift
//  weather-app
//
//  Created by Annie Tang on 10/10/17.
//  Copyright © 2017 Annie Tang. All rights reserved.
//

import UIKit

class FutureForecastCollectionCell: UICollectionViewCell {
    var dayLabel: UILabel!
    var weatherIcon: UIImageView!
    var tempLabel: UILabel!
    var farenLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupDayLabel()
        setupWeatherIcon()
        setupTempInfo()
    }
    
    /* UI: setting up day of the week label */
    func setupDayLabel() {
        dayLabel = UILabel(frame:
            CGRect(x: 8,
                   y: 5,
                   width: 46.63,
                   height: 21))
        dayLabel.textAlignment = .center
        dayLabel.textColor = .white
        dayLabel.font = Constants.avenir
        dayLabel.font = dayLabel.font.withSize(25)
        contentView.addSubview(dayLabel)
    }
    
    /* UI: setting up weather icon */
    func setupWeatherIcon() {
        weatherIcon = UIImageView(frame:
            CGRect(x: 13.31,
                   y: 33.03,
                   width: 39.62,
                   height: 39.62))
        self.contentView.addSubview(weatherIcon)
    }
    
    /* UI: setting up temperature info */
    func setupTempInfo() {
        tempLabel = UILabel(frame:
            CGRect(x: 13,
                   y: 72.99,
                   width: 26,
                   height: 30))
        tempLabel.text = ""
        tempLabel.textAlignment = .right
        tempLabel.textColor = .white
        tempLabel.font = Constants.avenir
        tempLabel.font = tempLabel.font.withSize(22)
        contentView.addSubview(tempLabel)
        
        farenLabel = UILabel(frame:
            CGRect(x: 40,
                   y: 85,
                   width: 13,
                   height: 10))
        farenLabel.text = "°F"
        farenLabel.textAlignment = .left
        farenLabel.textColor = .white
        
        farenLabel.font = Constants.avenir
        farenLabel.font = farenLabel.font.withSize(10)
        contentView.addSubview(farenLabel)
    }
}
