//
//  MainVC+handler.swift
//  weather-app
//
//  Created by Annie Tang on 10/10/17.
//  Copyright © 2017 Annie Tang. All rights reserved.
//

import UIKit
extension MainViewController {
    @objc func segueToDarkSky() {
        performSegue(withIdentifier: "segueToWebView", sender: self)
    }
}
    
