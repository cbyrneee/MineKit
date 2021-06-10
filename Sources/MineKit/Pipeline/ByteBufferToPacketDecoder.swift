//
//  ByteBufferToPacketDecoder.swift
//  
//
//  Created by Conor on 09/06/2021.
//

import Foundation
import NIO
import Logging

/// Converts a ByteBuffer instance to a Packet instance
class ByteBufferToPacketDecoder : ByteToMessageDecoder {
    private let logger = Logger(label: "MineKit.ByteBufferToPacketDecoder")
    private let handler = PacketReaderHandler()

    typealias InboundOut = Packet
    
    /// Converts a byte buffer to a packet
    /// This implementation carefully checks the data we are receiving vs the packet length. We also make sure that we read the packet length correctly by requesting more data if we run out of bytes.
    /// If the buffer's readable bytes is less than the packet length, we will not decode the packet any further and the reader index is reset to what it was at earlier in the decoding process.
    ///
    /// - Parameters:
    ///   - context: the channel context
    ///   - buffer: the buffer to read from
    /// - Returns: a DecodingState, if we need more data to parse this packet, .needMoreData will be returned
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
                logger.error("Not enough bytes left to parse packet length... requesting more data!")
                
                buffer.moveReaderIndex(to: startingReaderIndex)
                return .needMoreData
            }
            
            guard let byte = wrappedBuffer.readByte() else {
                logger.error("Not enough bytes left to parse packet length... requesting more data!")

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
            logger.error("Not enough bytes left to parse packet length... requesting more data!")

            buffer.moveReaderIndex(to: startingReaderIndex)
            return .needMoreData
        }
        
        let packetID = try wrappedBuffer.readVarInt()
        do {
            let packet = try handler.readPacket(of: packetID, with: length, from: &wrappedBuffer)
            
            logger.info("Parsed \(packetID) with a length of \(length) bytes.")
            context.fireChannelRead(NIOAny(packet))
            
            return .continue
        } catch PacketReaderError.read(let reason) {
            logger.error("Failed to parse packet. Read error: \(reason).")
        } catch PacketReaderError.noHandler {
            logger.info("Packet 0x\(String(format:"%02X", packetID)) of length \(length) does not have a read handler!")
        } catch {
            logger.error("Failed to parse 0x\(String(format:"%02X", packetID)) because of an unexpected error: \(error).")
        }
        
        return .needMoreData
    }
}
