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
    case ignored
}

/// The protocol which all packet handlers should implement
protocol PacketHandler {
    /// The identifier of the packet as listed on wiki.vg
    var packetID: Int { get }
    
    /// Called from InboundHandler when a packet is ready to be handled
    /// This method should not throw any exceptions, and if one does occur, you can return PacketHandlerResponse.error
    /// - Parameters:
    ///   - context: the channel context
    ///   - packet: the packet to handle
    /// - Returns: If the packet has been handled successfully, `.success` will be returned, otherwise `.error` will be returned along with a reason.
    func handle(with context: ChannelHandlerContext, and packet: Packet) -> PacketHandlerResponse
}
