//
//  DiningHallViewController.swift
//  KraudeSorce
//
//  Created by Labuser on 10/7/16.
//  Copyright © 2016 Yash Dalal. All rights reserved.
//

import UIKit
import Charts
import Firebase

class DiningHallViewController: UIViewController {
    
//    var location: String
    @IBOutlet weak var notificationSwitch: UISwitch!
    @IBOutlet weak var notificationLabel: UILabel!
    let notificationsKey = "notificationsKey"
    let switchKey = "switchKey"
    
    @IBOutlet weak var crowdedLabel: UILabel!
    //ROSS CODE FOR GRAPH
    
    @IBOutlet weak var lineChart: LineChartView!
    var ref = FIRDatabase.database().reference()
    var day: Int = 0
    var times: NSDictionary = NSDictionary()
    var crowdtimes: [String] = []
    var crowddata: [Double] = []
    var sortedData: [Double] = []
    var currentCrowdedNess = 0
    var pastCrowdedness = 0
    
    //ROSS CODE OVER
    
    override func viewDidLoad() {
        super.viewDidLoad()
        notificationSwitch.addTarget(self, action: #selector(DiningHallViewController.switchIsChanged(_:)), forControlEvents: UIControlEvents.ValueChanged)
        createChart()
        compareCrowdedness()
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
    

    
//ROSS CODE FOR CHARTS STARTS HERE -- GET READY FOR A WILD RIDE
    func compareCrowdedness(){
        
        ref.observeEventType(.Value, withBlock: { snapshot in
        self.currentCrowdedNess = snapshot.value!.objectForKey("count")!.objectForKey("locations")!.objectForKey("duc") as! Int
        })
        ref.observeEventType(.Value, withBlock: { snapshot in
            self.pastCrowdedness = snapshot.value!.objectForKey("predictedtimes")!.objectForKey("duc")!.objectForKey("Wednesday")?.objectForKey("13:00") as! Int
        })
        
        if(currentCrowdedNess > pastCrowdedness){
            crowdedLabel.text = "More crowded than ususal"
        }
        else{
            crowdedLabel.text = "less crowded than usual"
        }
        
      
        
    }
    
    func nextFifteenMinutes() -> NSDate? {
        let calendar = NSCalendar.currentCalendar()
        let date = NSDate()
        let minuteComponent = calendar.components(NSCalendarUnit.Minute, fromDate: date)
        let components = NSDateComponents()
        let minutes = minuteComponent.minute/15
        components.minute = minutes as Int
        components.minute = components.minute*15
        return calendar.dateByAddingComponents(components, toDate: date, options: [])
    }
    
    
    func createChart(){
        day = getDay()!
        let weekday = convertWeekday(day)
        ref.observeEventType(.Value, withBlock: { snapshot in
            //print(snapshot.value!.objectForKey("predictions")!.objectForKey(weekday))
            self.times = snapshot.value!.objectForKey("predictedtimes")!.objectForKey("duc")!.objectForKey(weekday) as! NSDictionary
            self.crowdtimes = self.times.allKeys as! [String]
            let sortedTimes = self.crowdtimes.sort()
            for item in sortedTimes{
                
            self.sortedData.append(self.times.objectForKey(item) as! Double)
            }
            
            self.crowddata = self.times.allValues as! [Double]
            self.setChart(sortedTimes, values: self.sortedData)
            
            }, withCancelBlock: { error in
                print(error.description)
        })
        
    }
    
    func getDay()-> Int?{
        let today = NSDate()
        let myCalendar = NSCalendar(calendarIdentifier: NSGregorianCalendar)
        let myComponents = myCalendar?.components(.Weekday, fromDate: today)
        let weekDay = myComponents?.weekday
        return weekDay
    }
    
    func setChart(datapoints:[String], values:[Double]){
        lineChart.noDataText = "You need to provide data for the chart."
        var yVals1 : [ChartDataEntry] = [ChartDataEntry]()
        for i in 0...(datapoints.count - 1){
            yVals1.append(ChartDataEntry(value: self.sortedData[i], xIndex: i))
        }
        
        let set1: LineChartDataSet = LineChartDataSet(yVals: yVals1, label: "Historical Crowdedness")
        set1.axisDependency = .Left
        set1.setColor(UIColor.redColor().colorWithAlphaComponent(0.5))
        set1.setCircleColor(UIColor.redColor())
        set1.lineWidth = 2.0
        set1.circleRadius = 2.0 // the radius of the node circle
        set1.fillAlpha = 65 / 255.0
        set1.fillColor = UIColor.redColor()
        set1.highlightColor = UIColor.blackColor()
        set1.drawCircleHoleEnabled = true
        
        lineChart.leftAxis.axisMinValue = 0
        lineChart.leftAxis.granularityEnabled = true
        lineChart.leftAxis.granularity = 1.0
        lineChart.rightAxis.drawLabelsEnabled = false
        lineChart.legend.enabled = false
        lineChart.descriptionText = ""
        lineChart.leftAxis.drawAxisLineEnabled = false
        lineChart.leftAxis.drawGridLinesEnabled = false
        lineChart.rightAxis.enabled = false
        lineChart.drawGridBackgroundEnabled = false
        lineChart.xAxis.labelPosition = .Bottom
        lineChart.xAxis.setLabelsToSkip(1)
        lineChart.leftAxis.valueFormatter = NSNumberFormatter()
        lineChart.leftAxis.valueFormatter?.minimumFractionDigits = 0
        
        var dataSets : [LineChartDataSet] = [LineChartDataSet]()
        dataSets.append(set1)
        let data: LineChartData = LineChartData(xVals: datapoints, dataSets: dataSets)
        data.setDrawValues(false)
        
        self.lineChart.data = data
        
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
    
    //ROSS CODE OVER
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
}
