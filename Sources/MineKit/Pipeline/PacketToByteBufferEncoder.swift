//
//  PacketToByteBufferEncoder.swift
//  
//
//  Created by Conor on 09/06/2021.
//

import Foundation
import NIO
import Logging

class PacketToByteBufferEncoder : MessageToByteEncoder {
    private let logger = Logger(label: "MineKit.PacketToByteBufferEncoder")
    typealias OutboundIn = Packet
    
    /// Converts a packet instance to a byte buffer
    /// - Parameters:
    ///   - data: the packet to encode
    ///   - out: the buffer to write to
    func encode(data: Packet, out: inout ByteBuffer) throws {
        logger.info("Encoding packet \(data) with id \(data.packetID)")
        
        // Create a copy of out so we can properly use it later
        var outCopy = out.copy()
        outCopy.writeVarInt(Int(data.packetID))
        data.writePacket(to: &outCopy)
        
        // Write the length of the packet, then the actual packet data from our copy we made of out earlier
        out.writeVarInt(outCopy.readableBytes)
        out.writeBuffer(&outCopy)
    }
}
