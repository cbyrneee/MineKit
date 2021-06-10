//
//  StatusResponsePacketReader.swift
//  
//
//  Created by Conor on 09/06/2021.
//

import Foundation

class StatusResponsePacketReader : PacketReader {
    var packetID: Int = 0x00
    
    func toPacket(from buffer: inout WrappedBuffer) throws -> Packet {
        guard let json = try buffer.readString(ofLength: 32767) else {
            throw PacketReaderError.read("StatusResponsePacketReader failed to read JSON string from buffer!")
        }
        
        return StatusResponsePacket(json: json)
    }
}
