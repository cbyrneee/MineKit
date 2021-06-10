import XCTest
import NIO
import Logging

@testable import MineKit

class ChannelHandler : ConnectionChannelHandler {
    let connection: ServerConnection
    init(with connection: ServerConnection) {
        self.connection = connection
    }
    
    override func on(packet: Packet, context: ChannelHandlerContext) {
        if let packet = packet as? StatusResponsePacket {
            print("S -> C: \(packet) - \(packet.json)")
            context.channel.close(mode: .all, promise: nil)
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
