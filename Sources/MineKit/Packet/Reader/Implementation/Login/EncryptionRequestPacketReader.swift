//
//  EncryptionRequestPacketReader.swift
//  
//
//  Created by Conor on 10/06/2021.
//

import Foundation

class EncryptionRequestPacketReader : PacketReader {
    var packetID: Int = 0x01
    
    func toPacket(from buffer: inout WrappedBuffer) throws -> Packet {
        // The encryption request packet contains a string of length 20 which appears to be empty
        let _ = try buffer.readString(ofLength: 20)

        guard let publicKey = try buffer.readBytesPrefixedWithLength() else {
            throw PacketReaderError.read("Failed to read public key")
        }
        
        guard let verifyToken = try buffer.readBytesPrefixedWithLength() else {
            throw PacketReaderError.read("Failed to read verify token")
        }
        
        return EncryptionRequestPacket(with: publicKey, and: verifyToken)
    }
}
