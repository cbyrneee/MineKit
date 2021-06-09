//
//  File.swift
//  
//
//  Created by Conor on 09/06/2021.
//

import Foundation

class HandshakePacket : Packet {
    var packetID: UInt8 = 0x00
    
    func writePacket(to buffer: inout WrappedBuffer) {
        buffer.writeVarInt(755)
        buffer.writeString("starship.dedi.koding.dev")
        buffer.writeShort(25565)
        buffer.writeVarInt(1)
    }
    
    func toString() -> String {
        return "(\(packetID)): {}"
    }
}
