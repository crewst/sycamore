//
//  InitViewController.swift
//  Radar
//
//  Created by Thomas Crews on 1/11/17.
//  Copyright © 2017 Thomas Crews. All rights reserved.
//

import UIKit
import Dispatch
import CoreTelephony
import UICountingLabel
import PlainPing

class InitViewController: UIViewController {
    
    // MARK: Global Definitions
    
    let settings = UserDefaults(suiteName: "group.sycamore.defaults")!
    var firstRun = true
    
    var readyToPresent = false
    
    
    // MARK: UI Outlets
    
    @IBOutlet weak var TitleLabel: UILabel!
    @IBOutlet weak var MainProgress: KDCircularProgress!
    @IBOutlet weak var progressLabel: UICountingLabel!
    
    
    // MARK: Overrides
    
    override func viewDidAppear(_ animated: Bool) {
        
        NotificationCenter.default.addObserver(self, selector: #selector(ProcessFinished), name: NSNotification.Name(rawValue: "ProcessFinished"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ProcessUpdating), name: NSNotification.Name(rawValue: "ProcessUpdating"), object: nil)
        
        progressLabel.format = "%d%%"
        
        if settings.string(forKey: "measurementUnits") == nil {
            settings.set("megabits per second", forKey: "measurementUnits")
        }
        Globals.shared.speedUnits = settings.value(forKey: "measurementUnits") as! String
        
        firstPhase()
    }
    
    
    // MARK: Custom Functions
    
    
    func firstPhase() {
        
        Globals.shared.currentSSID = Networking.fetchSSIDInfo()
        
        print("Current SSID: " + Globals.shared.currentSSID)
        
        switch Globals.shared.currentSSID {
        case "":
            Globals.shared.IPaddress = ""
            Globals.shared.iAccess = false
            Globals.shared.externalIP = "Unavailable"
            Globals.shared.currentSSID = ""
            Globals.shared.DNSaddress = ""
            Globals.shared.IPv6address = ""
            Globals.shared.latency = "Unknown"
            Globals.shared.bandwidth = 0
            self.performSegue(withIdentifier: "LoadCompleteSegue", sender: self)
        default:
            secondPhase()
        }
    }
    
    func secondPhase() {
        
        Globals.shared.IPaddress = Networking.getWiFiAddress()
        Globals.shared.iAccess = Networking.isConnectedToNetwork()
        Globals.shared.externalIP = Networking.getExternalAddress()
        Globals.shared.currentBSSID = Networking.getBSSID()
        Globals.shared.DNSaddress = Networking.getDNS()
        Globals.shared.IPv6address = Networking.getWiFiAddressV6()
        
        Networking.pingHost()
        
        print("External IP: " + Globals.shared.externalIP)
        
        DispatchQueue.global().async {
            
            Networking().testSpeed()
            
        }
        progressLabel.count(from: 0, to: 17, withDuration: 1)
        MainProgress.animate(fromAngle: 0, toAngle: 60, duration: 1, completion: nil)
        
    }
    
    
    // MARK: Notification Observers
    
    func ProcessFinished(notification: Notification) {
        if firstRun {
            firstRun = false
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "LoadCompleteSegue", sender: self)
            }
        }
    }
    
    func ProcessUpdating(notification: Notification) {
        // update UI
        if firstRun {
            let dProgress = notification.userInfo!["progress"]! as! Double
            let progress = Int(dProgress)
            DispatchQueue.global().async {
                if progress < 17 {
                } else {
                    DispatchQueue.main.sync {
                        self.progressLabel.text = String(progress) + "%"
                        self.MainProgress.animate(fromAngle: self.MainProgress.angle, toAngle: Double(progress * 3) + 60, duration: 1, completion: nil)
                    }
                }
            }
        }
    }
}


// S.D.G.
