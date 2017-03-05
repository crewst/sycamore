//
//  DiagnosticView.swift
//  Radar
//
//  Created by Thomas Crews on 2/19/17.
//  Copyright © 2017 Thomas Crews. All rights reserved.
//

import UIKit

class DiagnosticView: UIViewController {

    @IBOutlet weak var DismissalButton: UIButton!
    @IBOutlet weak var NetStatusLabel: UILabel!
    
    override func viewDidLoad() {
        
        DismissalButton.layer.cornerRadius = 5
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func DismissView(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        
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
