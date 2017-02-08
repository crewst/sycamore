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

class ViewController: UIViewController {

    @IBOutlet weak var TitleLabel: UILabel!
    @IBOutlet weak var MainProgress: KDCircularProgress!
    @IBOutlet weak var progressLabel: UILabel!
    
    var error = "UNDEF"
    
    let IPAddress = IP()
    
    override func viewDidLoad() {
        
        loadError.error = "UNDEF"
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if SSID.fetchSSIDInfo() == "didntGoIn" {
            loadError.error = "NoNet"
            self.performSegue(withIdentifier: "ErrorSegue", sender: self)
        } else {
            MainProgress.angle = 133
            progressLabel.text = "37%"
        }
        
        if IPAddress.getWiFiAddress() != nil {
            progressLabel.text = "81%"
            MainProgress.angle = 292
        } else {
            loadError.error = "NoIP"
            self.performSegue(withIdentifier: "LoadCompleteSegue", sender: self)
        }
        
        if Reachability.isConnectedToNetwork() == false {
            loadError.error = "NoInternet"
            self.performSegue(withIdentifier: "LoadCompleteSegue", sender: self)
        }
        
        
    }
    
    func uncaughtExceptionHandler(exception: NSException) {
        self.performSegue(withIdentifier: "ErrorSegue", sender: self)
    }


}


// S.D.G.
