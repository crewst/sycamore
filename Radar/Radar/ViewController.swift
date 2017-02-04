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
    
    override func viewDidLoad() {
        self.performSegue(withIdentifier: "LoadCompleteSegue", sender: self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if SSID.fetchSSIDInfo() == "didntGoIn" {
            loadError.error = "NoNet"
            self.performSegue(withIdentifier: "ErrorSegue", sender: self)
        }
    }
    
    func uncaughtExceptionHandler(exception: NSException) {
        self.performSegue(withIdentifier: "ErrorSegue", sender: self)
    }


}

