//
//  ViewController.swift
//  Radar
//
//  Created by Thomas Crews on 1/11/17.
//  Copyright © 2017 Thomas Crews. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var mainButton: UIButton!
    @IBOutlet weak var MainProgress: KDCircularProgress!
    @IBOutlet weak var progressLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        mainButton.layer.cornerRadius = 5
        var progressPct = 0
        for index in 1...100 {
            
        }
        
        
    }
    @IBAction func mainButtonPress(_ sender: Any) {
        mainButton.backgroundColor = UIColor.lightGray
    }
    @IBAction func mainButtonLeave(_ sender: Any) {
        mainButton.backgroundColor = UIColor.white
    }
    @IBAction func mainButtonRelease(_ sender: Any) {
        mainButton.backgroundColor = UIColor.white
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

