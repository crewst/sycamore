//
//  DiagnosticView.swift
//  Radar
//
//  Created by Thomas Crews on 2/19/17.
//  Copyright © 2017 Thomas Crews. All rights reserved.
//

import UIKit

class DiagnosticView: UIViewController {
    
    let settings = UserDefaults.standard
    
    
    // MARK: UI Outlets
    
    @IBOutlet weak var DismissalButton: UIButton!
    @IBOutlet weak var NetStatusLabel: UILabel!
    
    @IBOutlet weak var SSIDlabel: UILabel!
    @IBOutlet weak var DataUseLabel: UILabel!
    @IBOutlet weak var BSSIDlabel: UILabel!
    @IBOutlet weak var IPv4Label: UILabel!
    @IBOutlet weak var ExIPlabel: UILabel!
    @IBOutlet weak var DNSlabel: UILabel!
    @IBOutlet weak var GatewayLabel: UILabel!
    @IBOutlet weak var MAClabel: UILabel!
    @IBOutlet weak var IPv6Label: UILabel!
    @IBOutlet weak var BandwidthLabel: UILabel!
    @IBOutlet weak var LatencyLabel: UILabel!
    @IBOutlet weak var ChannelLabel: UILabel!
    
    @IBOutlet weak var RecommendationLabel0: UILabel!
    @IBOutlet weak var RecommendationLabel1: UILabel!
    @IBOutlet weak var RecommendationLabel2: UILabel!
    @IBOutlet weak var RecommendationLabel3: UILabel!
    
    // MARK: UI Actions
    
    @IBAction func DismissView(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: Overrides
    
    override func viewDidLoad() {
        DismissalButton.layer.cornerRadius = 5
        
        RecommendationLabel0.text = ""
        RecommendationLabel1.text = ""
        RecommendationLabel2.text = ""
        RecommendationLabel3.text = ""
        
        NetStatusLabel.adjustsFontSizeToFitWidth = true
        
        SSIDlabel.adjustsFontSizeToFitWidth = true
        DataUseLabel.adjustsFontSizeToFitWidth = true
        BSSIDlabel.adjustsFontSizeToFitWidth = true
        IPv4Label.adjustsFontSizeToFitWidth = true
        ExIPlabel.adjustsFontSizeToFitWidth = true
        DNSlabel.adjustsFontSizeToFitWidth = true
        GatewayLabel.adjustsFontSizeToFitWidth = true
        MAClabel.adjustsFontSizeToFitWidth = true
        IPv6Label.adjustsFontSizeToFitWidth = true
        BandwidthLabel.adjustsFontSizeToFitWidth = true
        LatencyLabel.adjustsFontSizeToFitWidth = true
        ChannelLabel.adjustsFontSizeToFitWidth = true
        
        refreshUI()
    }
    
    func refreshUI() {
        
        SSIDlabel.text = Globals.shared.currentSSID
        DataUseLabel.text = (String(Int(Globals.shared.dataUse)) + " MB")
        IPv4Label.text = Globals.shared.IPaddress
        ExIPlabel.text = Globals.shared.externalIP
        BSSIDlabel.text = Globals.shared.currentBSSID
        DNSlabel.text = Globals.shared.DNSaddress
        LatencyLabel.text = Globals.shared.latency
        IPv6Label.text = Globals.shared.IPv6address
        
        
        // Consolidated Missing Info Handler
        
        if Globals.shared.currentSSID == "" {
            SSIDlabel.text = "N/A"
            BSSIDlabel.text = "N/A"
            IPv4Label.text = "N/A"
            ExIPlabel.text = "N/A"
            DNSlabel.text = "N/A"
            GatewayLabel.text = "N/A"
            IPv6Label.text = "N/A"
            BandwidthLabel.text = "N/A"
            LatencyLabel.text = "N/A"
            ChannelLabel.text = "N/A"
            
            fillRecommendations(Status: NSLocalizedString("STATUS_WIFI_DISCONNECTED", comment: ""), Rec0: NSLocalizedString("RECOMMENDATION_WIFI_DISCONNECTED", comment: ""), Rec1: "", Rec2: "", Rec3: "")
        }
        
        if Globals.shared.netIsGood {
            fillRecommendations(Status: NSLocalizedString("STATUS_OK", comment: ""), Rec0: NSLocalizedString("RECOMMENDATION_OK", comment: ""), Rec1: "", Rec2: "", Rec3: "")
            
        }
        
        
        switch Globals.shared.speedUnits {
        case "megabits per second":
            BandwidthLabel.text = ((String((Globals.shared.bandwidth) / 1000)) + " Mb/s")
        case "megabytes per second":
            BandwidthLabel.text = ((String((Globals.shared.bandwidth) / 8000)) + " MB/s")
        case "kilobits per second":
            BandwidthLabel.text = ((String(Globals.shared.bandwidth)) + " Kb/s")
        case "kilobytes per second":
            BandwidthLabel.text = ((String((Globals.shared.bandwidth) / 8)) + " KB/s")
        default:
            return
        }
    }
    
    func fillRecommendations(Status: String, Rec0: String, Rec1: String, Rec2: String, Rec3: String) {
        NetStatusLabel.text = Status
        RecommendationLabel0.text = Rec0
        RecommendationLabel1.text = Rec1
        RecommendationLabel2.text = Rec2
        RecommendationLabel3.text = Rec3
    }
    
}


// S.D.G.
