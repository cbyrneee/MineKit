//
//  StatusRequestPacket.swift
//  
//
//  Created by Conor on 09/06/2021.
//

import Foundation

class StatusRequestPacket : Packet {
    var packetID: UInt8 = 0x00
    
    func writePacket(to buffer: inout WrappedBuffer) {
        // NO-OP
    }
    
    func toString() -> String {
        return "(\(packetID)): {}"
    }
}
