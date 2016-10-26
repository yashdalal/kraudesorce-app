//
//  Location.swift
//  KraudeSorce
//
//  Created by Yash Dalal on 10/8/16.
//  Copyright © 2016 Yash Dalal. All rights reserved.
//

import Foundation
import Firebase

class Location{
    let name: String
    let coordinates: Coordinates
    let numberOfPeople: Int
    
    init(name: String, coordinates: Coordinates, numberOfPeople: Int){
        self.name = name
        self.coordinates = coordinates
        self.numberOfPeople = numberOfPeople
    }
}