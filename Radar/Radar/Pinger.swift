import Foundation

public typealias SimplePingClientCallback = (String?)->()

public class Pinger: NSObject {
    static let singletonPC = Pinger()
    
    var resultCallback: SimplePingClientCallback?
    var pingClinet: SimplePing?
    var dateReference: NSDate?
    
    public static func pingHostname(hostname: String, andResultCallback callback: SimplePingClientCallback?) {
        singletonPC.pingHostname(hostname: hostname, andResultCallback: callback)
    }
    
    public func pingHostname(hostname: String, andResultCallback callback: SimplePingClientCallback?) {
        resultCallback = callback
        pingClinet = SimplePing(hostName: hostname)
        pingClinet?.delegate = self
        pingClinet?.start()
    }
}

extension Pinger: SimplePingDelegate {
    public func simplePing(_ pinger: SimplePing, didStartWithAddress address: Data) {
        pinger.send(with: nil)
    }
    
    public func simplePing(_ pinger: SimplePing, didFailWithError error: Error) {
        resultCallback?(nil)
    }
    
    public func simplePing(_ pinger: SimplePing!, didSendPacket packet: NSData!) {
        dateReference = NSDate()
    }
    
    public func simplePing(_ pinger: SimplePing!, didFailToSendPacket packet: NSData!, error: NSError!) {
        pinger.stop()
        resultCallback?(nil)
    }
    
    public func simplePing(_ pinger: SimplePing, didReceiveUnexpectedPacket packet: Data) {
        pinger.stop()
        resultCallback?(nil)
    }
    
    public func simplePing(_ pinger: SimplePing!, didReceivePingResponsePacket packet: NSData!) {
        pinger.stop()
        
        guard let dateReference = dateReference else { return }
        
        //timeIntervalSinceDate returns seconds, so we convert to milis
        let latency = NSDate().timeIntervalSince(dateReference as Date) * 1000
        
        Globals.shared.latency = String(latency)
        
        resultCallback?(String(format: "%.f", latency))
    }
}
