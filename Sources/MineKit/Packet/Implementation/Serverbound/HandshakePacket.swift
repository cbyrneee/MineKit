//
//  File.swift
//  
//
//  Created by Conor on 09/06/2021.
//

import Foundation

class HandshakePacket : Packet {
    var packetID: UInt8 = 0x00
    
    private let serverDetails: ServerDetails
    
    init (using serverDetails: ServerDetails) {
        self.serverDetails = serverDetails
    }
    
    func writePacket(to buffer: inout WrappedBuffer) {
        buffer.writeVarInt(755)
        buffer.writeString(self.serverDetails.address)
        buffer.writeShort(self.serverDetails.port)
        buffer.writeVarInt(1)
    }
    
    func toString() -> String {
        return "(\(packetID)): {}"
    }
}
