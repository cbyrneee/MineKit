//
//  File.swift
//  
//
//  Created by Conor on 09/06/2021.
//

import Foundation
import NIO

class HandshakePacket : Packet {
    var packetID: UInt8 = 0x00
    
    private let serverDetails: ServerDetails
    private let state: ConnectionState
    
    init (using serverDetails: ServerDetails, state: ConnectionState) {
        self.serverDetails = serverDetails
        self.state = state
    }
    
    func writePacket(to buffer: inout ByteBuffer) {
        buffer.writeVarInt(755)
        buffer.writeStringPrefixedWithLength(self.serverDetails.address)
        buffer.writeShort(self.serverDetails.port)
        buffer.writeVarInt(self.state.rawValue)
    }
    
    func toString() -> String {
        return "(\(packetID)): {}"
    }
}
