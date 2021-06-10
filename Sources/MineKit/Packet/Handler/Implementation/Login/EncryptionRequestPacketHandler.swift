//
//  EncryptionRequestPacketHandler.swift
//  
//
//  Created by Conor on 10/06/2021.
//

import Foundation
import NIO
import Logging

class EncryptionRequestPacketHandler : PacketHandler {
    private let logger = Logger(label: "MineKit.EncryptionRequestPacketHandler")
    var packetID = 0x01
    
    func handle(with context: ChannelHandlerContext, and packet: Packet) -> PacketHandlerResponse {
        guard let packet = packet as? EncryptionRequestPacket else {
            return .error("I have no clue what happened here... but this shouldn't have happened... (failed to cast packet as EncryptionRequestPacket)")
        }
        
        logger.info("The server has requested us to encrypt our connection. Public key: \(packet.publicKey). Verify token: \(packet.verifyToken)")
        return .success
    }
}
