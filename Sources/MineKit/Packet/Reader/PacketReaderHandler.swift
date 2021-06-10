//
//  File.swift
//  
//
//  Created by Conor on 09/06/2021.
//

import Foundation

class PacketReaderHandler {
    let readers = [
        0x00: StatusResponsePacketReader(),
        0x01: EncryptionRequestPacketReader()
    ] as [Int : PacketReader]
    
    func readPacket(of id: Int, with length: Int, from buffer: inout WrappedBuffer) throws -> Packet {
        guard let reader = readers[id] else {
            throw PacketReaderError.noHandler
        }
        
        return try reader.toPacket(from: &buffer)
    }
}
