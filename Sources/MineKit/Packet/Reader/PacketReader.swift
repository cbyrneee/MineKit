//
//  PacketReader.swift
//  
//
//  Created by Conor on 09/06/2021.
//

import Foundation

/// The protocol which all packet readers should implement
protocol PacketReader {
    /// The identifier of the packet as listed on wiki.vg
    var packetID: Int { get }
    
    /// The reader should read from this buffer and return a Packet instance
    /// If the packet is invalid, or any other error occurs while parsing this packet, a WrappedBuffer exception should be thrown
    /// - Parameters:
    ///   - buffer: the buffer containing the packet's data
    func toPacket(from buffer: inout WrappedBuffer) throws -> Packet
}
