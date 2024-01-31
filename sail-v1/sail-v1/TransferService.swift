/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Transfer service and characteristics UUIDs
*/

import Foundation
import CoreBluetooth

struct TransferService {
    static let serviceUUID = CBUUID(string: "CE060000-43E5-11E4-916C-0800200C9A66")
    static let characteristicUUID = CBUUID(string: "CE060000-43E5-11E4-916C-0800200C9A66")
}
