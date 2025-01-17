//
//  File.swift
//  sail-v1
//
//  Created by Alice Mao on 12/7/23.
//

import Foundation
import UIKit
import WatchConnectivity
import Combine
      
final class ConnectToWatch: NSObject, ObservableObject {
    
    static let connect = ConnectToWatch()
    public let session = WCSession.default
    
    @Published var pattern:MadePattern = MadePattern()
    @Published var receivedInitial:Bool = false
    @Published var updating:Bool = false
    @Published var stopTest:Bool = false
    
    private override init(){
        super.init()
        
        if WCSession.isSupported() {
            session.delegate = self
            session.activate()
            print("Supported and activated watch session")
        } else{
            Swift.print("watch not supported")
        }
    }
    
    func activateSession(){
        if WCSession.isSupported() {
            session.delegate = self
            session.activate()
            print("Supported and activated watch session")
        } else{
            print("watch not supported")
        }
    }
    
    // Convert Pattern to Data to send to watch
    public func sendDataToWatch(sendObject: MadePattern){
        do {
            let data:[String:Any] = ["data":sendObject.encoder()]
            let _ = try session.updateApplicationContext(data)
            print("sent pattern")
        } catch {
            print("failed to send haptics because it is not reachable")
        }
    }
    
    
    // Tell the watch to stop playing
    public func sendDataToWatch(sendObject: Bool){
        do {
            let data:[String:Any] = ["endResponse":sendObject]
            let _ = try session.updateApplicationContext(data)
            print("sent end response")
        } catch {
            print("failed to send haptics because it is not reachable")
        }
    }
}


//  Other functions needed for WCSession
extension ConnectToWatch: WCSessionDelegate{
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if let error = error{
            Swift.print("Error starting WC Session \(error.localizedDescription)")
            return
        }
        
        if WCSession.default.isReachable{
            Swift.print("connected to watch")
        }
        else{
            Swift.print("failed to connect to watch")
        }
    }
    
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]){

        if let data = applicationContext["data"] as? Data {
            let decodedPattern = MadePattern.decoder(data)
            self.pattern = decodedPattern
            self.receivedInitial = true
            self.updating = true
            print("received pattern: \(self.pattern)")
        }
        
        if let endResponse = applicationContext["endResponse"] as? Bool {
            self.stopTest = endResponse
            print("stop test received")
        }
        
    }
    
    
    
#if os(iOS)
    public func sessionDidBecomeInactive(_ session: WCSession) {
        session.activate()
    }
    
    public func sessionDidDeactivate(_ session: WCSession) {
        session.activate()
    }
#endif
}

