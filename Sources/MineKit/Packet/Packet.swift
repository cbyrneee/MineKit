//
//  Packet.swift
//  
//
//  Created by Conor on 09/06/2021.
//

import Foundation
import NIO

/// A protocol representing a clientbound or serverbound packet
public protocol Packet {
    /// The identifier of the packet, these are mostly unique, with a few overlapping IDs between states
    var packetID: UInt8 { get }
    
    
    /// Writes a packet's data to a buffer
    ///
    /// - Parameters:
    ///   - buffer: the buffer to write to
    func writePacket(to buffer: inout ByteBuffer)
    
    /// Converts this packet into a human readable string, formatted as JSON
    ///
    /// Example of what your response should look like
    /// ```json
    /// (0x00): {"response": "hello world!"}
    /// ```
    func toString() -> String
}
