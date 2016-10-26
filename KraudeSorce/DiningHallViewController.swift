//
//  DiningHallViewController.swift
//  KraudeSorce
//
//  Created by Labuser on 10/7/16.
//  Copyright © 2016 Yash Dalal. All rights reserved.
//

import UIKit

class DiningHallViewController: UIViewController {
    
//    var location: String
    @IBOutlet weak var notificationSwitch: UISwitch!
    @IBOutlet weak var notificationLabel: UILabel!
    let notificationsKey = "notificationsKey"
    let switchKey = "switchKey"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        notificationSwitch.addTarget(self, action: #selector(DiningHallViewController.switchIsChanged(_:)), forControlEvents: UIControlEvents.ValueChanged)
//        location = ""
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(animated: Bool) {
        let status: Bool = NSUserDefaults.standardUserDefaults().boolForKey(switchKey)
        self.notificationSwitch.setOn(status, animated:false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func switchIsChanged(mySwitch: UISwitch) {
        if mySwitch.on {
            scheduleNotification()
            setSwitchStatus(true)
        } else {
            unscheduleNotification()
            setSwitchStatus(false)
        }
    }
    
    // persists state of switch, currently doesn't work for different locations
    func setSwitchStatus(selected: Bool){
        NSUserDefaults.standardUserDefaults().setBool(selected, forKey: switchKey)
    }
    
    func scheduleNotification(){
        let notificationDictionary = NSUserDefaults.standardUserDefaults().dictionaryForKey(notificationsKey) ?? NSDictionary()
        if var x = notificationDictionary["itemID"] as? [String:String]{
            x = ["title": "holmes", "day": "Tuesday", "time": "1pm", "id": "itemID"]
            NSUserDefaults.standardUserDefaults().setObject(x, forKey: notificationsKey)
        }
        
        let notification = UILocalNotification()
        notification.alertBody = "Holmes lounge is busy right now! See places that aren't."
        notification.fireDate = NSDate().dateByAddingTimeInterval(30)
        notification.repeatInterval =  NSCalendarUnit.WeekOfYear
        notification.userInfo = ["title": "holmes", "uid": "itemID"]
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
        print (UIApplication.sharedApplication().scheduledLocalNotifications)
        print (NSUserDefaults.standardUserDefaults().dictionaryForKey(notificationsKey))
    }
    
    func unscheduleNotification(){
        let scheduledNotifications: [UILocalNotification]? = UIApplication.sharedApplication().scheduledLocalNotifications
        guard scheduledNotifications != nil else {return}
//        UIApplication.sharedApplication().cancelAllLocalNotifications()
        for notification in scheduledNotifications! {
            if (notification.userInfo!["uid"] as! String == "itemID"){
        
                UIApplication.sharedApplication().cancelLocalNotification(notification)
                break
            }
        }
        
        if var notifDictionary = NSUserDefaults.standardUserDefaults().dictionaryForKey(notificationsKey) {
            notifDictionary.removeValueForKey("itemID")
        }
        print (UIApplication.sharedApplication().scheduledLocalNotifications)
        print (NSUserDefaults.standardUserDefaults().dictionaryForKey(notificationsKey))
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
