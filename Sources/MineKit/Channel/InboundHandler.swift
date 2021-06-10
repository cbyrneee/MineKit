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
    private let connectionHandler: ConnectionHandler
    
    typealias InboundIn = Packet
    
    init (serverDetails: ServerDetails, connectionState: ConnectionState, connectionHandler: ConnectionHandler) {
        self.serverDetails = serverDetails
        self.connectionState = connectionState
        self.connectionHandler = connectionHandler
    }
    
    public func channelActive(context: ChannelHandlerContext) {
        logger.info("Client connected to server")
        
        context.writeAndFlush(NIOAny(HandshakePacket(using: self.serverDetails, state: self.connectionState)), promise: nil)
        
        if (self.connectionState == .status) {
            context.writeAndFlush(NIOAny(StatusRequestPacket()), promise: nil)
        } else if (self.connectionState == .login) {
            context.writeAndFlush(NIOAny(LoginStartPacket(username: "test")), promise: nil)
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
                logger.info("Successfully internally handled packet \(packet) of id \(packet.packetID)")
            case .error(let error):
                logger.error("Failed to internally handle packet \(packet) of id \(packet.packetID): \(error)")
            default:
                break
        }
        
        self.connectionHandler.on(packet: packet, connection: context)
    }
    
    public func errorCaught(context: ChannelHandlerContext, error: Error) {
        logger.error("An error has been caught: \(error)")
    }
}
