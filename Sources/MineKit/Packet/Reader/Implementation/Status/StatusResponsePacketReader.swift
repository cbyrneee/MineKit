//
//  StatusResponsePacketReader.swift
//  
//
//  Created by Conor on 09/06/2021.
//

import Foundation
import NIO

class StatusResponsePacketReader : PacketReader {
    var packetID: Int = 0x00
    
    func toPacket(from buffer: inout ByteBuffer) throws -> Packet {
        guard let json = try buffer.readString(ofLength: 32767) else {
            throw PacketReaderError.read("StatusResponsePacketReader failed to read JSON string from buffer!")
        }
        
        return StatusResponsePacket(json: json)
    }
}
