//
//  OverviewViewController.swift
//  Radar
//
//  Created by Thomas Crews on 2/1/17.
//  Copyright © 2017 Thomas Crews. All rights reserved.
//

import UIKit
import UICountingLabel

class OverviewViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var RescanButton: UIButton!
    @IBOutlet weak var DiagnoseButton: UIButton!
    @IBOutlet weak var BandwidthLabel: UICountingLabel!
    @IBOutlet weak var IPLabel: UILabel!
    @IBOutlet weak var SSIDLabel: UILabel!
    @IBOutlet weak var InternetImage: UIImageView!
    @IBOutlet weak var UnitButton: UIButton!
    @IBOutlet weak var IPImage: UIImageView!
    @IBOutlet weak var UnitPicker: UIPickerView!
    @IBOutlet weak var SSIDImage: UIImageView!
    
    let UnitPickerData = ["megabits per second","megabytes per second","kilobits per second","kilobytes per second"]

    
    override func viewDidLoad() {
        super.viewDidLoad()

        RescanButton.layer.cornerRadius = 5
        DiagnoseButton.layer.cornerRadius = 5
        UnitButton.layer.cornerRadius = 5
        UnitPicker.setValue(UIColor.white, forKey: "textColor")
        
        BandwidthLabel.method = UILabelCountingMethod.easeOut
        BandwidthLabel.format = "%d"
        BandwidthLabel.adjustsFontSizeToFitWidth = true
        
        
        if Globals.shared.currentSSID == "didntGoIn" {
            loadError(code: 1)
        } else if Globals.shared.iAccess == false {
            loadError(code: 2)
        } else if Globals.shared.IPaddress == nil {
            loadError(code: 3)

        } else {
            BandwidthLabel.count(from: 0, to: CGFloat(Globals.shared.bandwidth))
            IPLabel.text = Globals.shared.IPaddress
            SSIDLabel.text = Globals.shared.currentSSID
        }
        
    }
    
    func loadError(code: Int) {
        
        view.backgroundColor = UIColor(red: 190/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0)
        DiagnoseButton.setTitleColor(UIColor(red: 190/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0), for: .normal)
        RescanButton.setTitleColor(UIColor(red: 190/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0), for: .normal)
        BandwidthLabel.count(from: CGFloat(Globals.shared.bandwidth), to: 0)
        Globals.shared.bandwidth = 0
        
        switch code {
        case 1:
            SSIDImage.alpha = 0.5
            IPImage.image = UIImage(named: "warning.png")
            InternetImage.image = UIImage(named: "warning.png")
            SSIDLabel.text = "No Network"
        case 2:
            InternetImage.image = UIImage(named: "warning.png")
            IPLabel.text = Globals.shared.IPaddress
        case 3:
            IPImage.image = UIImage(named: "warning.png")
            InternetImage.image = UIImage(named: "warning.png")
        default:
            SSIDImage.alpha = 0.5
            IPImage.image = UIImage(named: "warning.png")
            InternetImage.image = UIImage(named: "warning.png")
            SSIDLabel.text = "No Network"
        }

        
    }
    
    @IBAction func RescanButtonClick(_ sender: Any) {
        self.dismiss(animated: true, completion: {})
    }
    
    @IBAction func UnitButtonPress(_ sender: Any) {
        UnitPicker.isHidden = false
        UnitButton.isHidden = true
    }
    
    func updateBandwidth(units: String) {
        switch units {
        case "megabits per second":
            BandwidthLabel.count(from: BandwidthLabel.currentValue(), to: CGFloat(Globals.shared.bandwidth))
            case "megabytes per second":
            BandwidthLabel.count(from: BandwidthLabel.currentValue(), to: CGFloat((Globals.shared.bandwidth)/8))
            case "kilobits per second":
            BandwidthLabel.count(from: BandwidthLabel.currentValue(), to: CGFloat((Globals.shared.bandwidth)*1000))
            case "kilobytes per second":
            BandwidthLabel.count(from: BandwidthLabel.currentValue(), to: CGFloat(((Globals.shared.bandwidth)*1000)/8))
        default:
            return
        }
        Globals.shared.speedUnits = units
        print("Changed units to: " + Globals.shared.speedUnits)
    }
    
    
    // pickerView Data Sources
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return UnitPickerData.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return UnitPickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        UnitButton.setTitle(UnitPickerData[row], for: .normal)
        UnitPicker.isHidden = true
        UnitButton.isHidden = false
        updateBandwidth(units: UnitPickerData[row])
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .center
        let pickerLabel = UILabel()
        let titleData = UnitPickerData[row]
        let myTitle = NSAttributedString(string: titleData, attributes: [NSFontAttributeName:UIFont(name: "System Font", size: 22.0)!,NSForegroundColorAttributeName:UIColor.white, NSParagraphStyleAttributeName: paragraph])
        pickerLabel.attributedText = myTitle
        return pickerLabel
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
