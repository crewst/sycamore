//
//  ViewController.swift
//  Radar
//
//  Created by Thomas Crews on 1/11/17.
//  Copyright © 2017 Thomas Crews. All rights reserved.
//

import UIKit
import Dispatch
import CoreTelephony
import UICountingLabel

class ViewController: UIViewController {
    
    // MARK: UI Outlets
    
    @IBOutlet weak var TitleLabel: UILabel!
    @IBOutlet weak var MainProgress: KDCircularProgress!
    @IBOutlet weak var progressLabel: UICountingLabel!
    
    
    //MARK: Overrides
    
    override func viewDidLoad() {
        
        progressLabel.format = "%d%%"
        
    }
    
    var bandwidth = 0.0
    
    override func viewDidAppear(_ animated: Bool) {
        
        Globals.shared.DownComplete = false
        
        Globals.shared.currentSSID = SSID.fetchSSIDInfo()
        let IPmodule = IP()
        Globals.shared.IPaddress = IPmodule.getWiFiAddress()
        Globals.shared.iAccess = Reachability.isConnectedToNetwork()
        
        let url = URL(string: "https://api.ipify.org/")
        let ipAddress = try? String(contentsOf: url!, encoding: String.Encoding.utf8)
        Globals.shared.externalIP = ipAddress
        print("External IP: " + Globals.shared.externalIP)

        
        
        progressLabel.count(from: 0, to: 85, withDuration: 1)
        MainProgress.animate(fromAngle: 0, toAngle: 306, duration: 1, completion: {(finished:Bool) in
            self.testSpeed()
            while Globals.shared.DownComplete == false {
                
            }
            self.progressLabel.count(from: 85, to: 100, withDuration: 0.5)
            self.MainProgress.animate(toAngle: 360, duration: 0.5, completion: {(finished:Bool) in
                self.performSegue(withIdentifier: "LoadCompleteSegue", sender: self)
                
                })
            
        })
        
    }
    
    // TODO: To be removed or commented
    
    override func viewWillAppear(_ animated: Bool) {
        MainProgress.angle = 0
        progressLabel.text = "0%"
    }
    
    
    // MARK: Custom Methods
    
    func reloadVC() {
        print("User requested reload.")
        
        Globals.shared.DownComplete = false
        
        Globals.shared.currentSSID = SSID.fetchSSIDInfo()
        let IPmodule = IP()
        Globals.shared.IPaddress = IPmodule.getWiFiAddress()
        Globals.shared.iAccess = Reachability.isConnectedToNetwork()
        
        let url = URL(string: "https://api.ipify.org/")
        let ipAddress = try? String(contentsOf: url!, encoding: String.Encoding.utf8)
        Globals.shared.externalIP = ipAddress
        print("External IP: " + Globals.shared.externalIP)
        
        testSpeed()
        while Globals.shared.DownComplete == false {
            
        }

    }
    
    func testSpeed()  {
        
        let startTime = Date()
        
        let url = URL(string: "https://dl.dropboxusercontent.com/s/yjv93wu1mprq2nw/LargeTestFile")
        let request = URLRequest(url: url!)
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request) { (data, resp, error) in
            
            guard error == nil && data != nil else{
                
                print("Connection error or data is nil")
                
                Globals.shared.iAccess = false
                
                Globals.shared.DownComplete = true
                return
            }
            
            guard resp != nil else{
                
                print("Response is nil")
                
                Globals.shared.DownComplete = true
                return
            }
            
            
            let length  = CGFloat( (resp?.expectedContentLength)!) / 1000000.0
            
            print("Test download size: \(length) MB")
            
            
            
            let elapsed = CGFloat( Date().timeIntervalSince(startTime))
            
            print("Elapsed download time: \(elapsed)")
            
            Globals.shared.bandwidth = Int((length/elapsed) * 8000)
            
            Globals.shared.DownComplete = true
            
            
        }
        
        task.resume()
        
        while Globals.shared.DownComplete == false {
            
        }
        
        session.invalidateAndCancel()
    }
    
}


// S.D.G.
