//
//  SetCompressionPacketReader.swift
//  
//
//  Created by Conor on 10/06/2021.
//

import Foundation
import NIO

class SetCompressionPacketReader : PacketReader {
    var packetID = 0x03
    
    func toPacket(from buffer: inout ByteBuffer) throws -> Packet {
        let threshold = try buffer.readVarInt()
        return SetCompressionPacket(threshold: threshold)
    }
}
