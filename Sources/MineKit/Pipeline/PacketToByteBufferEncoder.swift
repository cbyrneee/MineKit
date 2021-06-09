//
//  PacketToByteBufferEncoder.swift
//  
//
//  Created by Conor on 09/06/2021.
//

import Foundation
import NIO

class PacketToByteBufferEncoder : MessageToByteEncoder {
    typealias OutboundIn = Packet
    
    func encode(data: Packet, out: inout ByteBuffer) throws {
        // First, we must write the identifier of the packet to the buffer
        out.writeVarInt(Int(data.packetID))
        
        // Then, we create a wrapped buffer to write the data of the packet to the buffer
        var wrappedBuffer = WrappedBuffer(with: out)
        data.writePacket(to: &wrappedBuffer)
        
        // We create another wrapper of WrappedBuffer so we can prefix the data with the length
        var finalBuffer = WrappedBuffer(with: out)
        finalBuffer.writeVarInt(wrappedBuffer.buffer.readableBytes)
        finalBuffer.buffer.writeBuffer(&wrappedBuffer.buffer)
        
        // Set the passed byte buffer reference to our copy
        out = finalBuffer.buffer
    }
}
