import XCTest
import NIO
import Logging

@testable import MineKit

class ChannelHandler : ChannelInboundHandler {
    typealias InboundIn = Packet
    let connection: ServerConnection
    
    init(with connection: ServerConnection) {
        self.connection = connection
    }
    
    public func channelRead(context: ChannelHandlerContext, data: NIOAny) {
        let packet = self.unwrapInboundIn(data)
        if let packet = packet as? StatusResponsePacket {
            print("S -> C: \(packet) - \(packet.json)")
            connection.channel?.close(mode: .all, promise: nil)
        }
    }
}

final class MineKitTests: XCTestCase {
    func testConnection() throws {
        let connection = try ServerConnection.createConnection(to: ServerDetails(address: "127.0.0.1"))
        try connection.channel?.pipeline.addHandler(ChannelHandler(with: connection)).wait()
        try connection.blockUntilDisconnect()
    }
}
