//
//  ConnectionHandler.swift
//  
//
//  Created by Conor on 10/06/2021.
//

import Foundation
import NIO

class ConnectionChannelHandler : ChannelInboundHandler {
    typealias InboundIn = Packet
    
    public func channelRead(context: ChannelHandlerContext, data: NIOAny) {
        let packet = self.unwrapInboundIn(data)
        self.on(packet: packet, context: context)
    }
    
    public func on(packet: Packet, context: ChannelHandlerContext) {
        // NO-OP
    }
    
    public func sendPacket(_ packet: Packet, context: ChannelHandlerContext) {
        context.writeAndFlush(NIOAny(packet), promise: nil)
    }
}
