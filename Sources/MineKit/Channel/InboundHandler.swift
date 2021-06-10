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
    private let controller = PacketHandlerController()
    
    private let serverDetails: ServerDetails
    private let connectionState: ConnectionState
    
    typealias InboundIn = Packet
    
    init (serverDetails: ServerDetails, connectionState: ConnectionState) {
        self.serverDetails = serverDetails
        self.connectionState = connectionState
    }
    
    public func channelActive(context: ChannelHandlerContext) {
        logger.info("Client connected to server")
        
        context.writeAndFlush(NIOAny(HandshakePacket(using: self.serverDetails)), promise: nil)
        
        if (connectionState == .status) {
            context.writeAndFlush(NIOAny(StatusRequestPacket()), promise: nil)
        } else if (connectionState == .login) {
            // TODO: Implement login
        }
    }
    
    public func channelInactive(context: ChannelHandlerContext) {
        logger.info("Client disconnected from server")
    }
    
    public func channelRead(context: ChannelHandlerContext, data: NIOAny) {
        let packet = self.unwrapInboundIn(data)
        let result = controller.handle(with: context, and: packet)
        
        switch result {
        case .success:
            logger.info("Successfully handled packet \(packet) of id \(packet.packetID)")
        case .error(let error):
            logger.error("Failed to handle packet \(packet) of id \(packet.packetID): \(error)")
        }
    }
    
    public func errorCaught(context: ChannelHandlerContext, error: Error) {
        logger.error("An error has been caught: \(error)")
    }
}
