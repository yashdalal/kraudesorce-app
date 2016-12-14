//
//  Globals.swift
//  KraudeSorce
//
//  Created by Ross Arkin on 12/7/16.
//  Copyright © 2016 Yash Dalal. All rights reserved.
//

import Foundation

struct Globals{
    
    func getDay()-> Int?{
        let today = NSDate()
        let myCalendar = NSCalendar(calendarIdentifier: NSGregorianCalendar)
        let myComponents = myCalendar?.components(.Weekday, fromDate: today)
        let weekDay = myComponents?.weekday
        return weekDay
    }
    
    func convertWeekday(day: Int)->String?{
        if(day == 1){
            return "Sunday"
        }
        else if (day == 2){
            return "Monday"
        }
        else if (day == 3){
            return "Tuesday"
        }
        else if (day == 4){
            return "Wednesday"
        }
        else if (day == 5){
            return "Thursday"
        }
        else if (day == 6){
            return "Friday"
        }
        else if (day == 7){
            return "Saturday"
        }
        return "Sunday"
    }
    
}