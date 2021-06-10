//
//  SetCompressionPacket.swift
//  
//
//  Created by Conor on 10/06/2021.
//

import Foundation
import NIO

class SetCompressionPacket : Packet {
    var packetID: UInt8 = 0x03
    
    let threshold: Int
    
    init(threshold: Int) {
        self.threshold = threshold
    }
    
    func writePacket(to buffer: inout ByteBuffer) {
        // NO-OP
    }
    
    func toString() -> String {
        return "(\(self.packetID)): {\"threshold\": \(self.threshold)}"
    }
}

