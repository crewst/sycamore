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
    
    let settings = UserDefaults.standard
    var firstRun = true
    
    // MARK: UI Outlets
    
    @IBOutlet weak var TitleLabel: UILabel!
    @IBOutlet weak var MainProgress: KDCircularProgress!
    @IBOutlet weak var progressLabel: UICountingLabel!
    
    
    //MARK: Overrides
    
    override func viewDidLoad() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(ProcessFinished), name: NSNotification.Name(rawValue: "ProcessFinished"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ProcessUpdating), name: NSNotification.Name(rawValue: "ProcessUpdating"), object: nil)
        
        progressLabel.format = "%d%%"
        
        if settings.string(forKey: "measurementUnits") != nil {
            
        } else {
            settings.set("megabits per second", forKey: "measurementUnits")
        }
        Globals.shared.speedUnits = settings.value(forKey: "measurementUnits") as! String
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        Globals.shared.DownComplete = false
        
        Globals.shared.currentSSID = Networking.fetchSSIDInfo()
        Globals.shared.IPaddress = Networking.getWiFiAddress()
        Globals.shared.iAccess = Networking.isConnectedToNetwork()
        Globals.shared.externalIP = Networking.getExternalAddress()
        Globals.shared.currentBSSID = Networking.getBSSID()
        Globals.shared.DNSaddress = Networking.getDNS()
        Globals.shared.IPv6address = Networking.getWiFiAddressV6()
        
        PlainPing.ping("www.google.com", withTimeout: 1.0, completionBlock: { (timeElapsed:Double?, error:Error?) in
            if let latency = timeElapsed {
                print("Ping time is \(latency) ms.")
                Globals.shared.latency = String(Int(latency)) + " ms"
            }
            
            if error != nil {
                print("Ping time is unknown.")
                Globals.shared.latency = "Unknown"
            }
        })
        
        
        // This is needed because my getWiFiAddress func returns a weird string without a network
        //    (in the simulator, at least)
        if Globals.shared.currentSSID == "" {
            Globals.shared.IPaddress = ""
        }
        
        print("External IP: " + Globals.shared.externalIP)
        
        self.progressLabel.count(from: 0, to: 17, withDuration: 1)
        self.MainProgress.animate(fromAngle: 0, toAngle: 60, duration: 1, completion: nil)
        
        Networking().testSpeed()
    }
    
    func ProcessFinished(notification: Notification) {
        // perform yout segue
        if firstRun {
        print("processFinished")
        
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "LoadCompleteSegue", sender: self)
        }
            firstRun = false
        }
    }
    
    func ProcessUpdating(notification: Notification) {
        // update UI
        if firstRun {
        let dProgress = notification.userInfo!["progress"]! as! Double
        let progress = Int(dProgress)
        print(progress)
        if progress < 17 {
        } else {
            progressLabel.text = String(progress) + "%"
            MainProgress.animate(fromAngle: self.MainProgress.angle, toAngle: Double(progress * 3) + 60, duration: 1, completion: nil)
        }
        }
    }
}


// S.D.G.
