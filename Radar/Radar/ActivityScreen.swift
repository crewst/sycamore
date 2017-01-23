//
//  ActivityScreen.swift
//  Radar
//
//  Created by Thomas Crews on 1/22/17.
//  Copyright © 2017 Thomas Crews. All rights reserved.
//

import UIKit

class ActivityScreen: UIViewController {
    
    @IBOutlet weak var mainStepper: UIStepper!
    @IBOutlet weak var progressWheel: KDCircularProgress!
    @IBOutlet weak var percentLabel: UILabel!
    @IBOutlet weak var mainSlider: UISlider!
    
    override func viewDidLoad() {
            
        }
    @IBAction func sliderMove(_ sender: Any) {
        progressWheel.animate(fromAngle: progressWheel.angle, toAngle: Double(mainSlider.value), duration: 0.1, completion: nil)
        percentLabel.text = String(Int(mainSlider.value / 3.6))
        mainStepper.value = Double(mainSlider.value)
    }
    @IBAction func useStepper(_ sender: Any) {
        progressWheel.angle = Double(mainStepper.value)
        percentLabel.text = String(Int(mainStepper.value / 3.6))
        progressWheel.animate(fromAngle: progressWheel.angle, toAngle: Double(mainStepper.value), duration: 0.1, completion: nil)
        mainSlider.value = Float(mainStepper.value)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}


