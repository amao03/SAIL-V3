//
//  Utils.swift
//  v2
//
//  Created by Lucas Drummond on 5/21/24.
//
import Foundation


//
func getElapsed(_ dateOne: Date?, _ dateTwo: Date?) -> TimeInterval {
    if(dateOne != nil && dateTwo != nil) {
        return dateOne!.distance(to: dateTwo!)
    }
    return 0;
}

//
func formatTime(_ date:Date?) -> String {
    return date?.formatted(date: .numeric, time: .standard) ?? ""
}
