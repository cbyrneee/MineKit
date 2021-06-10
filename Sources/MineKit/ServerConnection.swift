//
//  ServerConnection.swift
//  
//
//  Created by Conor on 10/06/2021.
//

import Foundation
import NIO
import Logging

public struct ServerDetails {
    let address: String
    let port: Int = 25565
}

public class ServerConnection : ChannelInboundHandler {
    public typealias InboundIn = Packet
    public var channel: Channel? = nil
    public var server: ServerDetails
    
    private init(to server: ServerDetails) {
        self.server = server
    }
    
    public func channelActive(context: ChannelHandlerContext) {
        self.channel = context.channel
        channel?.writeAndFlush(NIOAny(HandshakePacket(using: server, state: .status)), promise: nil)
        channel?.writeAndFlush(NIOAny(StatusRequestPacket()), promise: nil)
    }
    
    public func blockUntilDisconnect() throws {
        try channel?.closeFuture.wait()
    }
    
    static func createConnection(to server: ServerDetails) throws -> ServerConnection {
        let instance = ServerConnection(to: server)
        let group = MultiThreadedEventLoopGroup(numberOfThreads: 1)
        let bootstrap = ClientBootstrap(group: group)
            .channelOption(ChannelOptions.socketOption(.so_reuseaddr), value: 1)
            .channelInitializer { channel in
                channel.pipeline.addHandlers(
                    ByteToMessageHandler(ByteBufferToPacketDecoder()),
                    MessageToByteHandler(PacketToByteBufferEncoder()),
                    instance
                )
            }
        
        instance.channel = try bootstrap.connect(host: server.address, port: server.port).wait()
        return instance
    }
}
