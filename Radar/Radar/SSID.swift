import Foundation
import SystemConfiguration.CaptiveNetwork

public class SSID {
    class func fetchSSIDInfo() -> String {
        var currentSSID = ""
        if let interfaces = CNCopySupportedInterfaces() {
            for i in 0..<CFArrayGetCount(interfaces) {
                let interfaceName: UnsafeRawPointer = CFArrayGetValueAtIndex(interfaces, i)
                let rec = unsafeBitCast(interfaceName, to: AnyObject.self)
                let unsafeInterfaceData = CNCopyCurrentNetworkInfo("\(rec)" as CFString)
                if unsafeInterfaceData != nil {
                    let interfaceData = unsafeInterfaceData! as NSDictionary
                    currentSSID = interfaceData["SSID"] as! String
                }
            }
        }
        
        if currentSSID != "" {
        
        return currentSSID
        } else {
            return "didntGoIn"
        }
    }
}


// S.D.G.
