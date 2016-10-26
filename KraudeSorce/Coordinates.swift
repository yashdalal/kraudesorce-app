//
//  Coordinates.swift
//  KraudeSorce
//
//  Created by Yash Dalal on 10/8/16.
//  Copyright © 2016 Yash Dalal. All rights reserved.
//

import Foundation
import CoreLocation

class Coordinates{
    let latitude: CLLocationCoordinate2D
    let longitude: CLLocationCoordinate2D
    let radius: Int
    
    init(latitude: CLLocationCoordinate2D, longitude: CLLocationCoordinate2D, radius: Int){
        self.latitude = latitude
        self.longitude = longitude
        self.radius = radius
    }
}