//
//  User.swift
//  KraudeSorce
//
//  Created by Yash Dalal on 9/23/16.
//  Copyright © 2016 Yash Dalal. All rights reserved.
//

import Foundation
import Firebase

class User {
    let uid : String
    let email : String
    
    init(authData: FIRUser){
        self.uid = authData.uid
        self.email = authData.email!
    }
    
    init(uid: String, email: String){
        self.uid = uid
        self.email = email
    }
}