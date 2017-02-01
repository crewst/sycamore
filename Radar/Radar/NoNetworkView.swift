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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        ActionButton.layer.cornerRadius = 5
        
        if globalInstance.error == "UNDEF" {
            ErrorLabel.text = "Successful Read"
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
