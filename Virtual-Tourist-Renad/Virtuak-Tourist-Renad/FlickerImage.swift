//
//  FlickerImage.swift
//  Virtuak-Tourist-Renad
//
//  Created by renad saleh on 15/02/2019.
//  Copyright © 2019 Udacity. All rights reserved.
//

import Foundation

struct FlickrImage {
    
    let id: String
    let secret: String
    let server: String
    let farm: Int
    
    
    init(id: String, secret: String, server: String, farm: Int) {
        self.id = id
        self.secret = secret
        self.server = server
        self.farm = farm
    }
    
    func imageURL() -> String {
        return "https://farm\(farm).staticflickr.com/\(server)/\(id)_\(secret)_q.jpg"
    }
    
}
