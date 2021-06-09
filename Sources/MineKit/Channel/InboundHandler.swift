//
//  MineKitInboundChannel.swift
//  
//
//  Created by Conor on 09/06/2021.
//

import Foundation
import NIO
import Logging

class InboundHandler : ChannelInboundHandler {
    private let logger = Logger(label: "MineKit.Inbound")
    typealias InboundIn = Packet
    
    public func channelActive(context: ChannelHandlerContext) {
        logger.info("Client connected to server")
        context.writeAndFlush(NIOAny(HandshakePacket()), promise: nil)
        context.writeAndFlush(NIOAny(StatusRequestPacket()), promise: nil)
    }
    
    public func channelInactive(context: ChannelHandlerContext) {
        logger.info("Client disconnected from server")
    }
    
    public func channelRead(context: ChannelHandlerContext, data: NIOAny) {
        let packet = self.unwrapInboundIn(data)
        
        if let packet = packet as? StatusResponsePacket {
            logger.info("Server status: \(packet.json)")
        } else {
            logger.warning("No handler for packet \(packet)")
        }
    }
    
    public func errorCaught(context: ChannelHandlerContext, error: Error) {
        logger.error("An error has been caught: \(error)")
    }
}
