//
//  StatusResponsePacket.swift
//  
//
//  Created by Conor on 09/06/2021.
//

import Foundation
import NIO

class StatusResponsePacket : Packet {
    var packetID: UInt8 = 0x00
    var json: String
    
    init(json: String) {
        self.json = json
    }
    
    func writePacket(to buffer: inout ByteBuffer) {
        // NO-OP
    }
    
    func toString() -> String {
        return "(\(packetID)): {\"response\": \(json)}"
    }
}
