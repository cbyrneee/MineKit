//
//  PacketHandlerController.swift
//  
//
//  Created by Conor on 10/06/2021.
//

import Foundation
import NIO

class PacketHandlerController {
    private let packetHandlers = [
        0x00: StatusResponsePacketHandler(),
        0x01: EncryptionRequestPacketHandler()
    ] as [UInt8 : PacketHandler]
    
    func handle(with context: ChannelHandlerContext, and packet: Packet) -> PacketHandlerResponse {
        guard let handler = packetHandlers[packet.packetID] else {
            return .error("No handler available for \(packet) (\(packet.packetID))")
        }
        
        return handler.handle(with: context, and: packet)
    }
}
