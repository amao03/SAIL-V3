//
//  File.swift
//  sail-v1
//
//  Created by Alice Mao on 12/7/23.
//

import Foundation
import UIKit
import WatchConnectivity

class ConnectToWatch: NSObject, ObservableObject {
    
    static let connect = ConnectToWatch()
    public let session = WCSession.default
    
    @Published var pattern:Pattern = Pattern()
    @Published var rawValue:Double = 0.0
    @Published var receivedInitial:Bool = false
    @Published var updating:Bool = false
    
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
    public func sendDataToWatch(sendObject: Pattern){
        Swift.print("send method")
        if (session.isReachable){
            let data:[String:Any] = ["data":sendObject.encoder()]
            session.sendMessage(data, replyHandler: nil)
        }
        else{
            print("failed to send haptics because it is not reachable")
        }
    }
    
    
    // Convert Data from phone to a Pattern object to be set in TimerControls
    public func dataReceivedFromPhone(_ info:[String:Any]) {
        if !session.isReachable{
            Swift.print("couldn't retrieve data from phone")
            return
        }
        
        if !receivedInitial{
            self.receivedInitial = true
        } else{
            self.updating = true
        }
        
        print("Receiving... \(receivedInitial)")
        
        if let data = info["data"] as? Data {
            let decodedPattern = Pattern.decoder(data)
            self.pattern = decodedPattern
            print("received pattern: \(pattern)")
        }
        
        if let receivedRawVaue = info["value"] as? Double {
            self.rawValue = receivedRawVaue
            print("received value: \(rawValue)")
        }
        
        
      
//        DispatchQueue.main.async {
//            Swift.print("pattern received: \(decodedPattern)")
//            
//            
//        }
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
    
    func session(_ session: WCSession, didReceiveMessage info: [String : Any]) {
        dataReceivedFromPhone(info)
        //        #if os(iOS)
        //        iOSDelegate?.messageReceived(message: (session, info))
        //        #elseif os(watchOS)
        //        watchOSDelegate?.messageReceived(message: (session, info))
        //        #endif
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

