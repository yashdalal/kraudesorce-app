//
//  HomePageViewController.swift
//  KraudeSorce
//
//  Created by Yash Dalal on 9/20/16.
//  Copyright © 2016 Yash Dalal. All rights reserved.
//

import UIKit
import CoreLocation
import Firebase

class HomePageViewController: UIViewController, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()
    var user : User!
    let ref = FIRDatabase.database().referenceWithPath("count")
//    var holmesRegion: CLRegion!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        let holmesRegion = CLCircularRegion(center: CLLocationCoordinate2D(latitude: 38.648155,longitude: -90.306414), radius: 200, identifier: "holmes")
        locationManager.startMonitoringForRegion(holmesRegion)
        
        FIRAuth.auth()?.addAuthStateDidChangeListener{ auth, user in
            guard let user = user else { return }
            self.user = User(authData: user)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    func locationManager(manager: CLLocationManager,
//                                    didUpdateLocations locations: [CLLocation]){
//        let currentLocation = locations[0]
//        let lat = currentLocation.coordinate.latitude
//        let long = currentLocation.coordinate.longitude
//        let inHolmes = self.isInHolmes(lat, longitude: long)
//        print(inHolmes)
//    }
    
//    func isInHolmes(latitude: CLLocationDegrees, longitude: CLLocationDegrees) -> Bool {
//        return (latitude > 38) && (latitude < 39) && (longitude < (-90)) && (longitude > (-91))
//    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print(error)
    }
    
    func locationManager(manager: CLLocationManager, didEnterRegion region: CLRegion) {
        self.view.backgroundColor = UIColor.greenColor()
        ref.setValue(1)
    }
    
    func locationManager(manager: CLLocationManager, didExitRegion region: CLRegion) {
        self.view.backgroundColor = UIColor.redColor()
        ref.setValue(0)
    }
    
    func locationManager(manager: CLLocationManager, monitoringDidFailForRegion region: CLRegion?, withError error: NSError) {
        print("\(error)")
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
