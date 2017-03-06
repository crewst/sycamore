//
//  DiagnosticView.swift
//  Radar
//
//  Created by Thomas Crews on 2/19/17.
//  Copyright © 2017 Thomas Crews. All rights reserved.
//

import UIKit

class DiagnosticView: UIViewController {
    
    // MARK: UI Outlets
    
    @IBOutlet weak var DismissalButton: UIButton!
    @IBOutlet weak var NetStatusLabel: UILabel!
    
    
    // MARK: UI Actions
    
    @IBAction func DismissView(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: Overrides
    
    override func viewDidLoad() {
        DismissalButton.layer.cornerRadius = 5
    }
    
}
