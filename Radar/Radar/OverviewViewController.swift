//
//  OverviewViewController.swift
//  Radar
//
//  Created by Thomas Crews on 2/1/17.
//  Copyright © 2017 Thomas Crews. All rights reserved.
//

import UIKit

class OverviewViewController: UIViewController {

    @IBOutlet weak var RescanButton: UIButton!
    @IBOutlet weak var DiagnoseButton: UIButton!
    @IBOutlet weak var BandwidthLabel: UILabel!
    @IBOutlet weak var IPLabel: UILabel!
    @IBOutlet weak var SSIDLabel: UILabel!
    @IBOutlet weak var InternetImage: UIImageView!
    @IBOutlet weak var IPImage: UIImageView!
    
    let IPAddress = IP()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        RescanButton.layer.cornerRadius = 5
        DiagnoseButton.layer.cornerRadius = 5
        
        IPLabel.text = IPAddress.getWiFiAddress()
        
        if loadError.error == "NoIP" {
            view.backgroundColor = UIColor(red: 220/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0)
            DiagnoseButton.setTitleColor(UIColor(red: 220/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0), for: .normal)
            RescanButton.setTitleColor(UIColor(red: 220/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0), for: .normal)
            IPImage.image = UIImage(named: "warning.png")
            InternetImage.image = UIImage(named: "warning.png")
        } else if loadError.error == "NoNet" {
            view.backgroundColor = UIColor(red: 220/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0)
            DiagnoseButton.setTitleColor(UIColor(red: 220/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0), for: .normal)
            RescanButton.setTitleColor(UIColor(red: 220/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0), for: .normal)
            IPImage.image = UIImage(named: "warning.png")
            InternetImage.image = UIImage(named: "warning.png")
            SSIDLabel.text = "No Network"
            countAnimation(label: BandwidthLabel, initString: "100", termString: "0")
        }
        
        
    }
    
    func countAnimation(label: UILabel, initString: String, termString: String)
    {
        UIView.transition(with: label,
                                  duration: 2.0,
                                  options: [.curveEaseOut],
                                  animations: { () -> Void in
                                    label.text = initString
                                    label.text = termString
        }, completion: nil)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func RescanButtonClick(_ sender: Any) {
        self.dismiss(animated: false, completion: {})
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
