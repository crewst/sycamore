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
    
    @IBOutlet weak var TitleLabel: UILabel!
    @IBOutlet weak var MainProgress: KDCircularProgress!
    @IBOutlet weak var progressLabel: UICountingLabel!
    
    
    
    override func viewDidLoad() {
        
        print("Good print")
        
        progressLabel.format = "%d%%"
        
    }
    
    var bandwidth = 0.0
    
    override func viewDidAppear(_ animated: Bool) {
        
        Globals.shared.DownComplete = false
        
        Globals.shared.currentSSID = SSID.fetchSSIDInfo()
        let IPmodule = IP()
        Globals.shared.IPaddress = IPmodule.getWiFiAddress()
        Globals.shared.iAccess = Reachability.isConnectedToNetwork()
        
        
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
    
    override func viewWillAppear(_ animated: Bool) {
        MainProgress.angle = 0
        progressLabel.text = "0%"
    }
    
    func testSpeed()  {
        
        print("Call successful")
        
        let startTime = Date()
        
        let url = URL(string: "https://dl.dropboxusercontent.com/s/yjv93wu1mprq2nw/LargeTestFile")
        let request = URLRequest(url: url!)
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request) { (data, resp, error) in
            
            guard error == nil && data != nil else{
                
                print("connection error or data is nill")
                
                return
            }
            
            guard resp != nil else{
                
                print("respons is nill")
                return
            }
            
            
            let length  = CGFloat( (resp?.expectedContentLength)!) / 1000000.0
            
            print(length)
            
            
            
            let elapsed = CGFloat( Date().timeIntervalSince(startTime))
            
            print("elapsed: \(elapsed)")
            
            Globals.shared.bandwidth = Int((length/elapsed) * 8)
            
            Globals.shared.DownComplete = true
            
            
        }
        
        task.resume()
        
        while Globals.shared.DownComplete == false {
            
        }
        
        session.invalidateAndCancel()
    }
    
}


// S.D.G.
