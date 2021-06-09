//
//  MineKit.swift
//
//
//  Created by Conor on 09/06/2021.
//

import NIO
import Logging

/// The main class for MineKit
///
/// Documentation coming soon
public struct MineKit {
    private let logger = Logger(label: "dev.cbyrne.MineKit")
    private var context: ChannelHandlerContext? = nil
    
    private let inboundHandler = InboundHandler()
    private let outboundHandler = OutboundHandler()
    
    private let packetEncoder = PacketToByteBufferEncoder()
    private let packetDecoder = ByteBufferToPacketDecoder()
    
    public init() {
    }
    
    /// Connects to a Minecraft Server with the provided [ServerDetails] instance.
    func connect(server: ServerDetails) throws {
        logger.info("Connecting to server: \(server.address):\(server.port)")

        let eventloopGroup = MultiThreadedEventLoopGroup(numberOfThreads: 1)
        let bootstrap = ClientBootstrap(group: eventloopGroup)
            .channelOption(ChannelOptions.socketOption(.so_reuseaddr), value: 1)
            .channelInitializer { channel in
                channel.pipeline.addHandlers(
                    ByteToMessageHandler(packetDecoder),
                    MessageToByteHandler(packetEncoder),
                    inboundHandler
                )
            }
        defer {
            try! eventloopGroup.syncShutdownGracefully()
        }
        
        let channel = try bootstrap.connect(host: server.address, port: server.port).wait()
        try channel.closeFuture.wait()
        
        logger.info("Disconnected from server!")
    }
}
