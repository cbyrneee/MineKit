import XCTest
import NIO
import Logging

@testable import MineKit

final class MineKitTests: XCTestCase {
    func testConnection() throws {
        let handler: ConnectionHandler = {
            class Handler : ConnectionHandlerAdapter {
                private let logger = Logger(label: "MineKit.Tests.Handler")
                
                override func on(packet: Packet, connection: ChannelHandlerContext) {
                    if let packet = packet as? SetCompressionPacket {
                        logger.info("Compression threshold: \(packet.threshold)")
                    } else {
                        logger.info("Received unknown packet: \(packet)")
                    }
                }
            }
            
            return Handler()
        }()
        
        let minekit = MineKit()
        try minekit.connect(to: ServerDetails(address: "127.0.0.1"), using: .login, with: handler)
    }
}
