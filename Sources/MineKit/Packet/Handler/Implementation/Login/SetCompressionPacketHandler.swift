//
//  SetCompressionPacketHandler.swift
//  
//
//  Created by Conor on 10/06/2021.
//

import Foundation
import NIO

class SetCompressionPacketHandler : PacketHandler {
    var packetID: Int = 0x03
    
    func handle(with context: ChannelHandlerContext, and packet: Packet) -> PacketHandlerResponse {
        guard let _ = packet as? SetCompressionPacket else {
            return .error("Failed to cast packet as SetCompressionPacket")
        }
        
        // TODO: actually set compression level
        return .success
    }
}
