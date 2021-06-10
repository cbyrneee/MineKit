//
//  StatusResponsePacketHandler.swift
//  
//
//  Created by Conor on 10/06/2021.
//

import Foundation
import NIO
import Logging

class StatusResponsePacketHandler : PacketHandler {
    private let logger = Logger(label: "MineKit.StatusResponsePacketHandler")
    var packetID = 0x00
    
    func handle(with context: ChannelHandlerContext, and packet: Packet) -> PacketHandlerResponse {
        guard let packet = packet as? StatusResponsePacket else {
            return .error("I have no clue what happened here, this really should not happen...")
        }
                
        logger.info("Packet JSON: \(packet.json)")
        return .success
    }
}
