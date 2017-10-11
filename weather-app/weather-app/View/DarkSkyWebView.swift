//
//  ViewController.swift
//  weather-app
//
//  Created by Annie Tang on 10/10/17.
//  Copyright © 2017 Annie Tang. All rights reserved.
//

import UIKit

class DarkSkyWebView: UIViewController, UIWebViewDelegate {
    
    /* credit to stack overflow, question 39682344 */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupWebView()
    }
    
    func setupWebView() {
        let webView = UIWebView(frame: UIScreen.main.bounds)
        webView.delegate = self
        view.addSubview(webView)
        
        if let url = URL(string: "https://darksky.net/poweredby/") {
            let request = URLRequest(url: url)
            webView.loadRequest(request)
        }
    }
    
    func setupBackButton() {
        let backButton: UIButton = UIButton(frame:
            CGRect(x: 0,
                   y: 117,
                   width: 375,
                   height: 600))
        backButton.addTarget(self, action: #selector(goBack), for: .touchDown)
        backButton.setTitle("Close", for: .normal)
        self.view.addSubview(backButton)
    }
    
    @objc func goBack() {
        self.view.removeFromSuperview()
    }
}
