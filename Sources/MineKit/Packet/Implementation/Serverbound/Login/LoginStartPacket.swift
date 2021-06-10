//
//  LoginStartPacket.swift
//  
//
//  Created by Conor on 10/06/2021.
//

import Foundation
import NIO

class LoginStartPacket : Packet {
    var packetID: UInt8 = 0x00
    
    private let username: String
    
    init(username: String) {
        self.username = username
    }
    
    func writePacket(to buffer: inout ByteBuffer) {
        buffer.writeStringPrefixedWithLength(self.username)
    }
    
    func toString() -> String {
        "(\(self.packetID)): {\"username\": \"\(self.username)\"}"
    }
}
