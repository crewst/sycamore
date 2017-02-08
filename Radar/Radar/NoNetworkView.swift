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
    @IBOutlet weak var SubLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        ActionButton.layer.cornerRadius = 5
        
        if loadError.error == "UNDEF" {
            ErrorLabel.text = "Unknown Error"
        } else if loadError.error == "NoNet" {
            ErrorLabel.text = "No Network Detected"
            SubLabel.text = "Connect to a WiFi network."
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func ActionButtonClick(_ sender: Any) {
        
        self.dismiss(animated: false)
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


// S.D.G.
