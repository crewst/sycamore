//
//  NoNetworkView.swift
//  Radar
//
//  Created by Thomas Crews on 2/1/17.
//  Copyright © 2017 Thomas Crews. All rights reserved.
//

import UIKit

class NoNetworkView: UIViewController {
    @IBOutlet weak var ErrorLabel: UILabel!
    @IBOutlet weak var ActionButton: UIButton!
    
    var loads = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        ActionButton.layer.cornerRadius = 5
        
        loads += 1
        
        if loadError.error == "UNDEF" {
            ErrorLabel.text = "Successful Read"
        } else if loadError.error == "NoNet" {
            ErrorLabel.text = "No Network Detected"
            ActionButton.setTitle("Connect to Network", for: .normal)
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func ActionButtonClick(_ sender: Any) {
        
        if loadError.error == "UNDEF" {
            self.dismiss(animated: false, completion: {})
        } else if loadError.error == "NoNet" {
            
            UIApplication.shared.openURL(URL(string: "App-Prefs:root=WIFI")!)
            
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
