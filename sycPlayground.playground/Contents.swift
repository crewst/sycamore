//: Playground - noun: a place where people can play

import UIKit
import SystemConfiguration.CaptiveNetwork

func getSSID() -> String{
    
    var currentSSID = ""
    
    let interfaces = CNCopySupportedInterfaces()
    
    if interfaces != nil {
        
        let interfacesArray = interfaces.takeRetainedValue() as! [String]
        
        if interfacesArray.count > 0 {
            
            let interfaceName = interfacesArray[0] as String
            
            let unsafeInterfaceData = CNCopyCurrentNetworkInfo(interfaceName)
            
            if unsafeInterfaceData != nil {
                
                let interfaceData = unsafeInterfaceData.takeRetainedValue() as Dictionary!
                
                currentSSID = interfaceData[kCNNetworkInfoKeySSID] as! String
                
                let ssiddata = NSString(data:interfaceData[kCNNetworkInfoKeySSIDData]! as! NSData, encoding:NSUTF8StringEncoding) as! String
                
                //ssid data from hex
                printl(ssiddata)
            }
        }
        
    }
    
    return currentSSID
    
}


