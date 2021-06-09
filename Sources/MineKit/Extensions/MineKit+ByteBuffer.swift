//
//  MineKit+ByteBuffer.swift
//  
//
//  Created by Conor on 09/06/2021.
//

import Foundation
import NIO

extension ByteBuffer {
    public mutating func writeByte(_ byte: Int) {
        self.writeBytes([UInt8(byte)])
    }

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
