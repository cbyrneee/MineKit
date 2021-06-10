//
//  PacketHandler.swift
//  
//
//  Created by Conor on 10/06/2021.
//

import Foundation
import NIO

enum PacketHandlerResponse {
    case success
    case error(String)
}

/// The protocol which all packet handlers should implement
protocol PacketHandler {
    /// The identifier of the packet as listed on wiki.vg
    var packetID: Int { get }
    
    /// Called from InboundHandler when a packet is ready to be handled
    /// This method should not throw any exceptions, and if one does occur, you can return PacketHandlerResponse.error
    func handle(with context: ChannelHandlerContext, and packet: Packet) -> PacketHandlerResponse
}
