//
//  File.swift
//  Virtuak-Tourist-Renad
//
//  Created by renad saleh on 20/02/2019.
//  Copyright © 2019 Udacity. All rights reserved.
//

import Foundation
import UIKit


class ActivityIndicator {
    private init() {}
    
    //1
    static let shared = ActivityIndicator()
    
    //2
    let activityLabel = UILabel(frame: CGRect(x: 24, y: 0, width: 0, height: 0))
    let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
    let activityView = UIView()
    
    func animateActivity(title: String, view: UIView, navigationItem: UINavigationItem) {
        //3
        guard navigationItem.titleView == nil else { return }
        
        //4
        activityIndicator.style = .gray
        activityLabel.text = title
        
        //5
        activityLabel.sizeToFit()
        
        //6
        let xPoint = view.frame.midX
        let yPoint = navigationItem.accessibilityFrame.midY
        let widthForActivityView = activityLabel.frame.width + activityIndicator.frame.width
        activityView.frame = CGRect(x: xPoint, y: yPoint, width: widthForActivityView, height: 30)
        
        activityLabel.center.y = activityView.center.y
        activityIndicator.center.y = activityView.center.y
        
        //7
        activityView.addSubview(activityIndicator)
        activityView.addSubview(activityLabel)
        
        //8
        navigationItem.titleView = activityView
        activityIndicator.startAnimating()
    }
    
    //9
    func stopAnimating(navigationItem: UINavigationItem) {
        activityIndicator.stopAnimating()
        navigationItem.titleView = nil
    }
}
