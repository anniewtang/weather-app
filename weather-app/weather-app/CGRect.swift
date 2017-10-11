//
//  CGRect.swift
//  weather-app
//
//  Created by Annie Tang on 10/10/17.
//  Copyright © 2017 Annie Tang. All rights reserved.
//

import Foundation
import UIKit

extension CGRect {
    init(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat) {
        
        let screenSize = UIScreen.main.bounds
        let frameWidth = screenSize.width
        let frameHeight = screenSize.height
        
        let xdWidth: CGFloat = 1/375
        let xdHeight: CGFloat = 1/667
        
        let x = x * xdWidth * frameWidth
        let width = width * xdWidth * frameWidth
        let y = y * xdHeight * frameHeight
        let height = height * xdHeight * frameHeight
        
        
        self.init(x:x, y:y, width:width, height:height)
    }
}

