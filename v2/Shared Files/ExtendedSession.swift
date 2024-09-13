//
//  Extended_Session.swift
//  sail-v1
//
//  Created by Alice Mao on 12/8/23.
//

import Foundation
import SwiftUI


class ExtendedSession : NSObject, ObservableObject{
    public var session: WKExtendedRuntimeSession!
    
    public func startExtendedSession(){
        session = WKExtendedRuntimeSession()
        session.delegate = self
        session.start()
        print("session start func")
    }
    
    public func stopExtendedSession(){
        session.invalidate()
    }
}


extension ExtendedSession: WKExtendedRuntimeSessionDelegate{
    func extendedRuntimeSessionDidStart(_ extendedRuntimeSession: WKExtendedRuntimeSession) {
        // Track when your session starts.
        print("Extened session started")
    }

    func extendedRuntimeSessionWillExpire(_ extendedRuntimeSession: WKExtendedRuntimeSession) {
        // Finish and clean up any tasks before the session ends.
        print("Extened session expired")
    }
        
    func extendedRuntimeSession(_ extendedRuntimeSession: WKExtendedRuntimeSession, didInvalidateWith reason: WKExtendedRuntimeSessionInvalidationReason, error: Error?) {
        // Track when your session ends.
        // Also handle errors here.
        
        print("Extened session stopped")
        if let error = error{
            print("Error: \(error.localizedDescription)")
            return
        }
    }
}






