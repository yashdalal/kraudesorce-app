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

class HomePageViewController: UITableViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var holmesCount: UILabel!
    let locationManager = CLLocationManager()
    var user : User!
    var ref = FIRDatabase.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        let holmesRegion = CLCircularRegion(center: CLLocationCoordinate2D(latitude: 38.648155,longitude: -90.306414), radius: 20, identifier: "holmes")
        let ducRegion = CLCircularRegion(center: CLLocationCoordinate2D(latitude: 38.647950,longitude: -90.310592), radius: 15, identifier: "duc")
        
        locationManager.startMonitoringForRegion(holmesRegion)
        locationManager.startMonitoringForRegion(ducRegion)
        ref.observeEventType(.Value, withBlock: { snapshot in
            let val = snapshot.value as? Int
//            if (val == nil){
//                val = 0;
//            }
            self.holmesCount.text = String(val)
        })
        
        FIRAuth.auth()?.addAuthStateDidChangeListener{ auth, user in
            guard let user = user else { return }
            self.user = User(authData: user)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print(error)
    }
    
    func locationManager(manager: CLLocationManager, didEnterRegion region: CLRegion) {
        let locationRef = ref.child("locations/\(region.identifier)")
        NSLog("\(locationRef.description()), \(ref.description())")
        self.view.backgroundColor = UIColor.greenColor()
        self.updateLocationCount(locationRef, region: region, diff: 1)
    }
    
    func locationManager(manager: CLLocationManager, didExitRegion region: CLRegion) {
        let locationRef = ref.child("locations/\(region.identifier)")
        NSLog("\(locationRef.description()), \(ref.description())")
        self.view.backgroundColor = UIColor.redColor()
        self.updateLocationCount(locationRef, region: region, diff: -1)
    }
    
    func updateLocationCount(ref: FIRDatabaseReference, region: CLRegion, diff: Int){
        ref.runTransactionBlock({ (currentData: FIRMutableData) -> FIRTransactionResult in
            var count = currentData.value as? Int
            //not sure if this block is necessary
            if (count == nil){
                count = 0;
            }
            currentData.value = count! + diff
            return FIRTransactionResult.successWithValue(currentData)
        })
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
