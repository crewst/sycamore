//
//  Networking.swift
//  Radar
//
//  Created by Thomas Crews on 3/8/17.
//  Copyright © 2017 Thomas Crews. All rights reserved.
//

import Foundation
import SystemConfiguration.CaptiveNetwork
import UIKit

public class Networking {
    
    class func isConnectedToNetwork() -> Bool {
        
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
            return false
        }
        
        let isReachable = flags == .reachable
        let needsConnection = flags == .connectionRequired
        
        return isReachable && !needsConnection
        
    }
    
    
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
    
    
    class func getWiFiAddress() -> String? {
        var address : String?
        
        // Get list of all interfaces on the local machine:
        var ifaddr : UnsafeMutablePointer<ifaddrs>?
        guard getifaddrs(&ifaddr) == 0 else { return nil }
        guard let firstAddr = ifaddr else { return nil }
        
        // For each interface ...
        for ifptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
            let interface = ifptr.pointee
            
            // Check for IPv4 or IPv6 interface:
            let addrFamily = interface.ifa_addr.pointee.sa_family
            if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {
                
                // Check interface name:
                let name = String(cString: interface.ifa_name)
                if  name == "en0" {
                    
                    // Convert interface address to a human readable string:
                    var addr = interface.ifa_addr.pointee
                    var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                    getnameinfo(&addr, socklen_t(interface.ifa_addr.pointee.sa_len),
                                &hostname, socklen_t(hostname.count),
                                nil, socklen_t(0), NI_NUMERICHOST)
                    address = String(cString: hostname)
                }
            }
        }
        freeifaddrs(ifaddr)
        
        return address
        
    }
    
    
    class func getExternalAddress() -> String? {
        
        let url = URL(string: "https://api.ipify.org/")
        let ipAddress = try? String(contentsOf: url!, encoding: String.Encoding.utf8)
        
        return ipAddress
    }
    
    
    class func testSpeed() {
        
        let startTime = Date()
        let url = URL(string: "https://dl.dropboxusercontent.com/s/yjv93wu1mprq2nw/LargeTestFile")
        let request = URLRequest(url: url!)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, resp, error) in
    
            guard error == nil && data != nil else{
                
                print("Connection error or data is nil")
                Globals.shared.iAccess = false
                Globals.shared.DownComplete = true
                return
            }
            
            guard resp != nil else{
                
                print("Response is nil")
                Globals.shared.DownComplete = true
                return
            }

            let length  = CGFloat( (resp?.expectedContentLength)!) / 1000000.0
            
            print("Test download size: \(length) MB")
            let elapsed = CGFloat( Date().timeIntervalSince(startTime))
            print("Elapsed download time: \(elapsed)")
            Globals.shared.bandwidth = Int((length/elapsed) * 8000)
            Globals.shared.DownComplete = true
        }
        
        task.resume()
        while Globals.shared.DownComplete == false {
            
        }
        
        session.invalidateAndCancel()
    }
    
}


// S.D.G.

