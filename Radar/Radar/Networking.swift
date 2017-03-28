//
//  Networking.swift
//  Radar
//
//  Created by Thomas Crews on 3/8/17.
//  Copyright © 2017 Thomas Crews. All rights reserved.
//

import Foundation
import SystemConfiguration.CaptiveNetwork
import SystemConfiguration.SCNetwork
import UIKit
import PlainPing

public class Networking: NSObject, URLSessionDelegate, URLSessionDownloadDelegate {
    
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
        
        return currentSSID
    }
    
    
    class func getWiFiAddress() -> String? {
        var address : String?
        
        // Get list of all interfaces on the local machine
        var ifaddr : UnsafeMutablePointer<ifaddrs>?
        guard getifaddrs(&ifaddr) == 0 else { return nil }
        guard let firstAddr = ifaddr else { return nil }
        
        // For each interface
        for ifptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
            let interface = ifptr.pointee
            
            // Check for IPv4 or IPv6 interface
            let addrFamily = interface.ifa_addr.pointee.sa_family
            if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {
                
                // Check interface name:
                let name = String(cString: interface.ifa_name)
                if  name == "en0" {
                    
                    // Convert interface address to a human readable string
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
    
    class func getWiFiAddressV6() -> String? {
        var address : String?
        
        // Get list of all interfaces on the local machine
        var ifaddr : UnsafeMutablePointer<ifaddrs>?
        guard getifaddrs(&ifaddr) == 0 else { return nil }
        guard let firstAddr = ifaddr else { return nil }
        
        // For each interface
        for ifptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
            let interface = ifptr.pointee
            
            // Check for IPv4 or IPv6 interface
            let addrFamily = interface.ifa_addr.pointee.sa_family
            if addrFamily == UInt8(AF_INET6) {
                
                // Check interface name:
//                let name = String(cString: interface.ifa_name)
//                if  name == "en0" {
                
                    // Convert interface address to a human readable string
                    var addr = interface.ifa_addr.pointee
                    var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                    getnameinfo(&addr, socklen_t(interface.ifa_addr.pointee.sa_len),
                                &hostname, socklen_t(hostname.count),
                                nil, socklen_t(0), NI_NUMERICHOST)
                    address = String(cString: hostname)
                //}
            }
        }
        freeifaddrs(ifaddr)
        
        return address
        
    }

    
    
    class func getExternalAddress() -> String? {
        
        let url = URL(string: "https://api.ipify.org/")
        let ipAddress = try? String(contentsOf: url!, encoding: String.Encoding.utf8)
        
        if ipAddress != nil {
            return ipAddress
        } else {
            return "Unavailable"
        }
    }
    
    
    func testSpeed() {
        
        Globals.shared.dlStartTime = Date()
        Globals.shared.DownComplete = false
        
        if Globals.shared.currentSSID == "" {
            Globals.shared.bandwidth = 0
            Globals.shared.DownComplete = true
        } else {
            
            let url = URL(string: "https://dl.dropboxusercontent.com/s/lc1o5ld56jkkswj/LargeTestFile")
            let session = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: nil)
            let task = session.downloadTask(with: url!)
            
            
            task.resume()
        }
    }
    
    public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        
        Globals.shared.dlFileSize = (Double(totalBytesExpectedToWrite) * 8) / 1000
        
        //DispatchQueue.main.async() {
        
        
        let progress = (Double(totalBytesWritten) / Double(totalBytesExpectedToWrite)) * 100.0
        
        Globals.shared.dlprogress = Int(progress)
        
        //}
    }
    
    public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        
        let elapsed = Double( Date().timeIntervalSince(Globals.shared.dlStartTime))
        Globals.shared.bandwidth = Int(Globals.shared.dlFileSize / elapsed)
        Globals.shared.DownComplete = true
        Globals.shared.dataUse! += (Globals.shared.dlFileSize! / 8000)
        session.invalidateAndCancel()
    }
    
    class func getBSSID() -> String{
        var currentBSSID = ""
        if let interfaces = CNCopySupportedInterfaces() {
            for i in 0..<CFArrayGetCount(interfaces) {
                let interfaceName: UnsafeRawPointer = CFArrayGetValueAtIndex(interfaces, i)
                let rec = unsafeBitCast(interfaceName, to: AnyObject.self)
                let unsafeInterfaceData = CNCopyCurrentNetworkInfo("\(rec)" as CFString)
                if unsafeInterfaceData != nil {
                    let interfaceData = unsafeInterfaceData! as NSDictionary
                    currentBSSID = interfaceData["BSSID"] as! String
                }
            }
        }
        
        return currentBSSID
    }
    
    class func getDNS() -> String {
        var numAddress = ""
        let host = CFHostCreateWithName(nil,"www.google.com" as CFString).takeRetainedValue()
        CFHostStartInfoResolution(host, .addresses, nil)
        var success: DarwinBoolean = false
        if let addresses = CFHostGetAddressing(host, &success)?.takeUnretainedValue() as NSArray?,
            let theAddress = addresses.firstObject as? NSData {
            var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
            if getnameinfo(theAddress.bytes.assumingMemoryBound(to: sockaddr.self), socklen_t(theAddress.length),
                           &hostname, socklen_t(hostname.count), nil, 0, NI_NUMERICHOST) == 0 {
                numAddress = String(cString: hostname)
            }
        }
        
        return numAddress
    }

    
}


// S.D.G.

