//
//  TodayViewController.swift
//  RadarWidget
//
//  Created by Thomas Crews on 2/19/17.
//  Copyright © 2017 Thomas Crews. All rights reserved.
//

import UIKit
import NotificationCenter
import QuartzCore

class TodayViewController: UIViewController, NCWidgetProviding {
    @IBOutlet weak var BandwidthLabel: UILabel!
    @IBOutlet weak var UnitsLabel: UILabel!
    @IBOutlet weak var SSIDlabel: UILabel!
    @IBOutlet weak var LatencyLabel: UILabel!
    
    let settings = UserDefaults(suiteName: "group.sycamore.defaults")!
    var firstRun = true
    
    override func viewDidLoad() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(ProcessFinished), name: NSNotification.Name(rawValue: "ProcessFinished"), object: nil)
        
        SSIDlabel.layer.backgroundColor = UIColor(white: 1, alpha: 0).cgColor
        SSIDlabel.layer.cornerRadius = 5
        SSIDlabel.adjustsFontSizeToFitWidth = true
        BandwidthLabel.adjustsFontSizeToFitWidth = true
        LatencyLabel.adjustsFontSizeToFitWidth = true
        
        
        loadUI()
        
        print("FIRST RUN")
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        
        if firstRun == false {
            print("NOT FIRST RUN")
            loadUI()
            
        }
        
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
    }
    
    func formatUnits() {
        var unit = "Mb/s"
        var display = ""
        
        switch Globals.shared.speedUnits {
        case "megabits per second":
            unit = "Mb/s"
            display = String(Globals.shared.bandwidth / 1000)
        case "megabytes per second":
            unit = "MB/s"
            display = String(Globals.shared.bandwidth / 8000)
        case "kilobits per second":
            unit = "Kb/s"
            display = String(Globals.shared.bandwidth)
        case "kilobytes per second":
            unit = "KB/s"
            display = String(Globals.shared.bandwidth / 8)
        default:
            unit = "Mb/s"
            display = String(Globals.shared.bandwidth / 1000)
        }
        
        BandwidthLabel.text = display
        UnitsLabel.text = unit
    }
    
    func loadUI() {
        
        let redcolor = UIColor(red: 255/255.0, green: 60/255.0, blue: 47/255.0, alpha: 1.0).cgColor
        let greencolor = UIColor(red: 76/255.0, green: 217/255.0, blue: 100/255.0, alpha: 1.0).cgColor
        
        Globals.shared.currentSSID = Networking.fetchSSIDInfo()
        Networking.pingHost()
        
        if settings.string(forKey: "measurementUnits") == nil {
            settings.set("megabits per second", forKey: "measurementUnits")
        }
        
        Globals.shared.speedUnits = settings.value(forKey: "measurementUnits") as! String
        
        Globals.shared.iAccess = Networking.isConnectedToNetwork()
        
        Networking().testSpeed()
        
        if Globals.shared.currentSSID == "" {
            SSIDlabel.text = "No Network"
            SSIDlabel.layer.backgroundColor = redcolor
            LatencyLabel.text = "Connect to Wi-Fi."
        } else {
            if Globals.shared.iAccess {
                SSIDlabel.layer.backgroundColor = greencolor
            } else {
                SSIDlabel.layer.backgroundColor = redcolor
            }
            SSIDlabel.text = Globals.shared.currentSSID
        }
        
    }
    
    func ProcessFinished(notification: Notification) {
        formatUnits()
        LatencyLabel.text = "Ping time: " + Globals.shared.latency
        firstRun = false
    }
    
    
}


// S.D.G.

