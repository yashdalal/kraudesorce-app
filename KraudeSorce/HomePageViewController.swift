//
//  HomePageViewController.swift
//  KraudeSorce
//
//  Created by Yash Dalal on 9/20/16.
//  Copyright © 2016 Yash Dalal. All rights reserved.
//

import UIKit
import CoreLocation

class HomePageViewController: UIViewController, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManager(manager: CLLocationManager,
                                    didUpdateLocations locations: [CLLocation]){
        print(locations)
    }
    
    
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        <#code#>
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
