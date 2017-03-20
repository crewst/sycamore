//
//  OverviewViewController.swift
//  Radar
//
//  Created by Thomas Crews on 2/1/17.
//  Copyright © 2017 Thomas Crews. All rights reserved.
//

import UIKit
import UICountingLabel
import Foundation
import PlainPing

class OverviewViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    
    // MARK: UI Outlets
    @IBOutlet weak var DiagnoseButton: UIButton!
    @IBOutlet weak var BandwidthLabel: UICountingLabel!
    @IBOutlet weak var IPLabel: UILabel!
    @IBOutlet weak var SSIDLabel: UILabel!
    @IBOutlet weak var InternetImage: UIImageView!
    @IBOutlet weak var UnitButton: UIButton!
    @IBOutlet weak var IPImage: UIImageView!
    @IBOutlet weak var UnitPicker: UIPickerView!
    @IBOutlet weak var SSIDImage: UIImageView!
    
    
    // MARK: Global Declarations
    
    let UnitPickerData = ["megabits per second","megabytes per second","kilobits per second","kilobytes per second"]
    
    let startupVC = ViewController()
    
    let settings = UserDefaults.standard
    
    var avgBandwidthArray = [0, 0, 0, 0, 0]
    var avgBandwidth = 0
    var iterationCount = 0
    
    var reloadTimer: Timer!
    
    var isFirstRun = true
    
    
    // MARK: UI Actions
    
    @IBAction func UnitButtonPress(_ sender: Any) {
        UnitPicker.isHidden = false
        UnitButton.isHidden = true
    }
    
    
    // MARK: Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DiagnoseButton.layer.cornerRadius = 5
        UnitButton.layer.cornerRadius = 5
        UnitPicker.setValue(UIColor.white, forKey: "textColor")
        
        BandwidthLabel.method = UILabelCountingMethod.easeOut
        BandwidthLabel.format = "%d"
        BandwidthLabel.adjustsFontSizeToFitWidth = true
        
        for i in 0...4 {
            avgBandwidthArray[i] = Globals.shared.bandwidth
            print(String(avgBandwidthArray[i]))
        }
        
        avgBandwidth = Globals.shared.bandwidth
        
        reloadTimer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(backgroundRescan), userInfo: nil, repeats: true)
        
        updateBandwidth()
        
        loadVC()
        
        refreshUI()
        
    }
    
    
    //MARK: Custom Functions
    
    func backgroundRescan() {
        DispatchQueue.global(qos: .background).async {
            self.loadVC()
            
            DispatchQueue.main.async {
                self.refreshUI()
            }
        }
    }
    
    
    func loadError(code: Int) {
        
        Globals.shared.netIsGood = false
        
        view.backgroundColor = UIColor(red: 190/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0)
        DiagnoseButton.setTitleColor(UIColor(red: 190/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0), for: .normal)
        BandwidthLabel.count(from: BandwidthLabel.currentValue(), to: 0)
        Globals.shared.bandwidth = 0
        
        avgBandwidth = 0
        
        switch code {
        case 1:
            print("error1")
            SSIDImage.alpha = 0.5
            IPImage.image = UIImage(named: "warning.png")
            InternetImage.image = UIImage(named: "warning.png")
            SSIDLabel.text = "No Network"
        case 2:
            print("error2")
            InternetImage.image = UIImage(named: "warning.png")
            IPLabel.text = Globals.shared.IPaddress
        case 3:
            print("error3")
            IPImage.image = UIImage(named: "warning.png")
            InternetImage.image = UIImage(named: "warning.png")
        default:
            print("error4")
            SSIDImage.alpha = 0.5
            IPImage.image = UIImage(named: "warning.png")
            InternetImage.image = UIImage(named: "warning.png")
            SSIDLabel.text = "No Network"
        }
    }
    
    
    func updateBandwidth() {
        switch Globals.shared.speedUnits {
        case "megabits per second":
            BandwidthLabel.count(from: BandwidthLabel.currentValue(), to: CGFloat((avgBandwidth) / 1000))
            UnitPicker.selectRow(0, inComponent: 0, animated: false)
        case "megabytes per second":
            BandwidthLabel.count(from: BandwidthLabel.currentValue(), to: CGFloat((avgBandwidth) / 8000))
            UnitPicker.selectRow(1, inComponent: 0, animated: false)
        case "kilobits per second":
            BandwidthLabel.count(from: BandwidthLabel.currentValue(), to: CGFloat(avgBandwidth))
            UnitPicker.selectRow(2, inComponent: 0, animated: false)
        case "kilobytes per second":
            BandwidthLabel.count(from: BandwidthLabel.currentValue(), to: CGFloat((avgBandwidth) / 8))
            UnitPicker.selectRow(3, inComponent: 0, animated: false)
        default:
            return
        }
    }
    
    
    func loadVC() {
        
        if isFirstRun == false {
            print("\nMultithreading initialized background reload.")
            
            Globals.shared.DownComplete = false
            
            Globals.shared.currentSSID = Networking.fetchSSIDInfo()
            Globals.shared.IPaddress = Networking.getWiFiAddress()
            Globals.shared.iAccess = Networking.isConnectedToNetwork()
            Globals.shared.externalIP = Networking.getExternalAddress()
            Globals.shared.currentBSSID = Networking.getBSSID()
            Globals.shared.DNSaddress = Networking.getDNS()
            Globals.shared.IPv6address = Networking.getWiFiAddressV6()
            
            // TODO: Doesn't work here. Seems like it's locked from initial use.
            
            //            PlainPing.ping("www.google.com", withTimeout: 1.0, completionBlock: { (timeElapsed:Double?, error:Error?) in
            //                if let latency = timeElapsed {
            //                    print("Ping time is \(latency) ms.")
            //                    Globals.shared.latency = String(Int(latency)) + " ms"
            //                }
            //
            //                if error != nil {
            //                    print("Ping time is unknown.")
            //                    Globals.shared.latency = "Unknown"
            //                }
            //            })
            
            
            
            // This is needed because my getWiFiAddress func returns a weird string without a network
            //    (in the simulator, at least)
            if Globals.shared.currentSSID == "" {
                Globals.shared.IPaddress = ""
            }
            
            print("External IP: " + Globals.shared.externalIP)
            
            Networking.testSpeed()
            
            while Globals.shared.DownComplete == false {
            }
        } else {
            refreshUI()
            print("first run")
            isFirstRun = false
        }
        
        avgBandwidthArray[iterationCount] = Globals.shared.bandwidth
        
        avgBandwidth = Int((avgBandwidthArray[0] + avgBandwidthArray[1] + avgBandwidthArray[2] + avgBandwidthArray[3] + avgBandwidthArray[4]) / 5)
        
        updateBandwidth()
        
        if iterationCount == 4 {
            iterationCount = 0
        } else {
            iterationCount += 1
        }
        
        print(Globals.shared.currentSSID)
        
    }
    
    func refreshUI() {
        if Globals.shared.currentSSID == "" {
            loadError(code: 1)
        } else if Globals.shared.iAccess == false {
            loadError(code: 2)
        } else if Globals.shared.IPaddress == nil {
            loadError(code: 3)
            
        } else {
            if Globals.shared.netIsGood == false {
                for i in 0...4 {
                    avgBandwidthArray[i] = Globals.shared.bandwidth
                }
            }
            Globals.shared.netIsGood = true
            view.backgroundColor = UIColor(red: 0/255, green: 160/255, blue: 0/255, alpha: 1.0)
            DiagnoseButton.setTitleColor(UIColor(red: 0/255.0, green: 160/255.0, blue: 0/255.0, alpha: 1.0), for: .normal)
            IPLabel.text = Globals.shared.IPaddress
            SSIDLabel.text = Globals.shared.currentSSID
            SSIDImage.alpha = 1.0
            IPImage.image = UIImage(named: "check.png")
            InternetImage.image = UIImage(named: "check.png")
        }
        
        print("[" + String(avgBandwidthArray[0]) + "] [" + String(avgBandwidthArray[1]) + "] [" + String(avgBandwidthArray[2]) + "] [" + String(avgBandwidthArray[3]) + "] [" + String(avgBandwidthArray[4]) + "]")
        
        IPLabel.text = Globals.shared.IPaddress
        UnitButton.setTitle(Globals.shared.speedUnits, for: .normal)
        
    }
    
    
    // MARK: pickerView Data Control
    
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
        UnitPicker.isHidden = true
        UnitButton.isHidden = false
        Globals.shared.speedUnits = UnitPickerData[row]
        settings.set(UnitPickerData[row], forKey: "measurementUnits")
        UnitButton.setTitle(Globals.shared.speedUnits, for: .normal)
        print("Changed units to: " + Globals.shared.speedUnits)
        updateBandwidth()
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
    
    
}


// S.D.G.
