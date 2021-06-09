//
//  MineKitInboundChannel.swift
//  
//
//  Created by Conor on 09/06/2021.
//

import Foundation
import NIO

class InboundHandler : ChannelInboundHandler {
    typealias InboundIn = Packet
    
    public func channelActive(context: ChannelHandlerContext) {
        print("Client connected to \(context.remoteAddress!)")
        context.writeAndFlush(NIOAny(HandshakePacket()), promise: nil)
        context.writeAndFlush(NIOAny(StatusRequestPacket()), promise: nil)
    }
    
    public func channelRead(context: ChannelHandlerContext, data: NIOAny) {
        let packet = self.unwrapInboundIn(data)
        
        if let packet = packet as? StatusResponsePacket {
            print("Server status: \(packet.json)")
        } else {
            print("No handler for packet \(packet)")
        }
    }
    
    public func errorCaught(context: ChannelHandlerContext, error: Error) {
        print("An error has been caught by InboundChannel: ", error)
    }
}
