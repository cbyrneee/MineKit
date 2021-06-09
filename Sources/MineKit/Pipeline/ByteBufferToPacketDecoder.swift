//
//  ByteBufferToPacketDecoder.swift
//  
//
//  Created by Conor on 09/06/2021.
//

import Foundation
import NIO

/// Converts a ByteBuffer instance to a Packet instance
class ByteBufferToPacketDecoder : ByteToMessageDecoder {
    typealias InboundOut = Packet
    private let handler = PacketReaderHandler()
    
    func decode(context: ChannelHandlerContext, buffer: inout ByteBuffer) throws -> DecodingState {
        let startingReaderIndex = buffer.readerIndex
        
        // If the buffer has no bytes to read, we must request that more data be read before decoding
        if (buffer.readableBytes == 0) {
            return .needMoreData
        }
        
        var wrappedBuffer = WrappedBuffer(with: buffer)
        var amountRead = 0
        var length = 0
        var lastRead: Int = 0
        
        // This is the same as a normal readVarInt function, except we keep checking how many more bytes are readable
        // If we run out of readable bytes whilst we are still checking for data, we must wait for more.
        // Due to the nature of TCP, we have to be careful when reading the packet's length, as that could also be not complete
        repeat {
            if (wrappedBuffer.buffer.readableBytes == 0) {
                print("Not enough bytes left to parse packet length... requesting more data!")
                
                buffer.moveReaderIndex(to: startingReaderIndex)
                return .needMoreData
            }
            
            guard let byte = wrappedBuffer.readByte() else {
                print("Not enough bytes left to parse packet length... requesting more data!")

                buffer.moveReaderIndex(to: startingReaderIndex)
                return .needMoreData
            }
            
            lastRead = Int(byte)
            let value = lastRead & 0b01111111
            
            length = length | (value << (7 * amountRead))
            amountRead += 1
            if(amountRead > 5) {
                throw WrappedBufferError.read("VarInt is too large!")
            }
        } while((lastRead & 0b10000000) != 0)
        
        // We have to check if we have the correct amount of bytes available to read via the packet length and compare it against
        // how many is in the buffer
        if (wrappedBuffer.buffer.readableBytes < length) {
            print("Not enough bytes left to parse packet length... requesting more data!")

            buffer.moveReaderIndex(to: startingReaderIndex)
            return .needMoreData
        }
        
        let packetID = try wrappedBuffer.readVarInt()
        print("Parsing \(packetID) with length \(length).")
        
        do {
            let packet = try handler.readPacket(of: packetID, with: length, from: &wrappedBuffer)
            context.fireChannelRead(NIOAny(packet))
        } catch PacketReaderError.read(let reason) {
            print("Failed to parse packet. Read error: \(reason).")
        } catch PacketReaderError.noHandler {
            print("Packet \(packetID) does not have a handler!")
        } catch {
            print("Failed to parse \(packetID) because of an unexpected error: \(error).")
        }
        
        return .needMoreData
    }
}
