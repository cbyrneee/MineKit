//
//  LoginStartPacket.swift
//  
//
//  Created by Conor on 10/06/2021.
//

import Foundation

class LoginStartPacket : Packet {
    var packetID: UInt8 = 0x00
    
    private let username: String
    
    init(username: String) {
        self.username = username
    }
    
    func writePacket(to buffer: inout WrappedBuffer) {
        buffer.writeString(self.username)
    }
    
    func toString() -> String {
        "(\(self.packetID)): {\"username\": \"\(self.username)\"}"
    }
}
