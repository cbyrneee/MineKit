//
//  PacketHandlerController.swift
//  
//
//  Created by Conor on 10/06/2021.
//

import Foundation
import NIO

/// The class which handles all packet handlers
/// When creating a new PacketHandler implementation, you must add it to the `handlers` dictionary.
class PacketHandlerController {
    private let handlers = [
        0x00: StatusResponsePacketHandler(),
        0x01: EncryptionRequestPacketHandler(),
        0x03: SetCompressionPacketHandler()
    ] as [UInt8 : PacketHandler]
    
    /// Attempts to handle a packet via its PacketHandler
    /// - Parameters:
    ///   - context: the channel context
    ///   - packet: the packet to handle
    /// - Returns: If the packet has been handled successfully, `.success` will be returned, otherwise `.error` will be returned along with a reason.
    func handle(with context: ChannelHandlerContext, and packet: Packet) -> PacketHandlerResponse {
        guard let handler = handlers[packet.packetID] else {
            return .ignored
        }
        
        return handler.handle(with: context, and: packet)
    }
}
