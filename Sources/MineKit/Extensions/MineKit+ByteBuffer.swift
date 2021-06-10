//
//  MineKit+ByteBuffer.swift
//  
//
//  Created by Conor on 09/06/2021.
//

import Foundation
import NIO

extension ByteBuffer {
    /// Writes a byte to this `ByteBuffer`
    /// - Parameter byte: a byte of type `Int`
    public mutating func writeByte(_ byte: Int) {
        self.writeBytes([UInt8(byte)])
    }
    
    /// Writes a `VarInt` to this `ByteBuffer`.
    ///
    /// A `VarInt` is a number which uses fewer bytes to store. The 7 least significant bits are used to encode the value and the most significant bit indicates whether there's another byte after it for the next part of the number. The least significant group is written first, followed by each of the more significant groups; thus, VarInts are effectively little endian (however, groups are 7 bits, not 8).
    /// - Parameter int: the integer to write as a `VarInt`
    public mutating func writeVarInt(_ int: Int) {
        var value = int
        
        repeat {
            var temp = value & 0b01111111
            value = value >> 7
            
            if (value != 0) {
                temp = temp | 0b10000000
            }
            
            self.writeByte(temp)
        } while (value != 0)
    }
}
