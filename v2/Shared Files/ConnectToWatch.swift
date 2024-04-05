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
    
//    var watchView = WatchView()
    
    @Published var pattern:MadePattern = MadePattern()
    @Published var receivedInitial:Bool = false
    @Published var recPat:Bool = false
    @Published var received:Bool = false
    @Published var updating:Bool = false
    @Published var patternPackage:Pattern = Pattern()
    @Published var patternPackageSent:Bool = false
    @Published var patternPackageReceived:Bool = false
    
//    var play = PlayOnWatch()
    
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
    
    func activateSession() -> Bool{
        if WCSession.isSupported() {
            session.delegate = self
            session.activate()
            print("Supported and activated watch session")
            return true
        } else{
            Swift.print("watch not supported")
            return false
        }
    }
    
    // Convert Pattern to Data to send to watch
    public func sendDataToWatch(sendObject: Pattern){
        Swift.print("send method")
        if activateSession(){
            if (session.isReachable){
                Swift.print("reached")
                let data:[String:Any] = ["data":sendObject.encoder()]
                Swift.print("sending data: \(data)")
                patternPackageSent = true
                session.sendMessage(data, replyHandler: nil)
            }
            else{
                print("failed to send haptics because it is not reachable")
            }
        }
        else {
            print("not activated")
        }
    }
    
    public func sendDataToWatch(sendObject: MadePattern){
        Swift.print("send method")
        if activateSession(){
            if (session.isReachable){
                Swift.print("reached")
                let data:[String:Any] = ["data":sendObject.encoder()]
                Swift.print("sending data: \(data)")
                session.sendMessage(data, replyHandler: nil)
            }
            else{
                print("failed to send haptics because it is not reachable")
            }
        }
        else {
            print("not activated")
        }
    }
    
    public func dataPackageReceivedFromPhone(_ info:[String:Any]) {
        if !session.isReachable{
            Swift.print("couldn't retrieve data from phone")
            return
        }
        print("dataReceivedFromPhone")
        
        Swift.print("Receiving Package...")
        DispatchQueue.main.async {
            let data:Data = info["data"] as! Data
            var decodedPattern = MadePattern.decoder(data)
            print("decoded: ", decodedPattern)
            if (decodedPattern.name == "ERROR"){
                self.patternPackage = Pattern.decoder(data)
                print("ERRRO: ", self.patternPackage)
                self.patternPackageReceived = true
            }
//            
//            self.patternPackage = decodedPattern
//            Swift.print("pattern package received")
           
        }
    }
    
    
    
    
    // Convert Data from phone to a Pattern object to be set in TimerControls
    public func dataReceivedFromPhone(_ info:[String:Any]) {
//        if !session.isReachable{
//            Swift.print("couldn't retrieve data from phone")
//            return
//        }
//        print("dataReceivedFromPhone")
//
//        
//        
//        
//        Swift.print("Receiving..")
//        DispatchQueue.main.async {
//            let data:Data = info["data"] as! Data
//            let decodedPattern = MadePattern.decoder(data)
//                
//            self.pattern = decodedPattern
//            Swift.print("pattern received: \(self.pattern.name)")
//            self.received = true
//            self.receivedInitial = true
//        }
        
        
        
        if !session.isReachable{
            Swift.print("couldn't retrieve data from phone")
            return
        }
        print("dataReceivedFromPhone")
        
        Swift.print("Receiving Package...")
        DispatchQueue.main.async {
            let data:Data = info["data"] as! Data
            var decodedPattern = MadePattern.decoder(data)
            print("decoded: ", decodedPattern)
            if (decodedPattern.name == "ERROR"){
                self.patternPackage = Pattern.decoder(data)
                print("ERROR: ", self.patternPackage)
                self.patternPackageReceived = true
            }
            self.received = true
            //            self.receivedInitial = true
//
//            self.patternPackage = decodedPattern
//            Swift.print("pattern package received")
           
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
    
    func session(_ session: WCSession, didReceiveMessage info: [String : Any]) {
        dataReceivedFromPhone(info)
//        if(patternPackageSent){
//           
//        }
//        else{
//            dataReceivedFromPhone(info)
//        }
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


