//
//  PacketReaderHandler.swift
//  
//
//  Created by Conor on 09/06/2021.
//

import Foundation
import NIO

/// The class which handles all the packet readers
/// When adding a new packet reader, you must add it to the `readers` dictionary
class PacketReaderHandler {
    let readers = [
        0x00: StatusResponsePacketReader(),
        0x01: EncryptionRequestPacketReader(),
        0x03: SetCompressionPacketReader()
    ] as [Int : PacketReader]
    
    /// Attempts to convert a buffer to a packet by calling the assigned reader for that packet
    ///
    /// - Parameters:
    ///   - id: the identifier for this packet
    ///   - length: the length of the packet
    ///   - buffer: the buffer containing the packet's data
    /// - Returns: An instance of the decoded packet, with all neccessary data parsed
    func readPacket(of id: Int, with length: Int, from buffer: inout ByteBuffer) throws -> Packet {
        guard let reader = readers[id] else {
            throw PacketReaderError.noHandler
        }
        
        return try reader.toPacket(from: &buffer)
    }
}
