//
//  CollectionViewCell.swift
//  Virtuak-Tourist-Renad
//
//  Created by renad saleh on 15/02/2019.
//  Copyright © 2019 Udacity. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    @IBOutlet weak var photoImageView: UIImageView!
    
    func startAnActivityIndicator() -> UIActivityIndicatorView {
        self.addSubview(activityIndicator)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        return activityIndicator
    }

}
