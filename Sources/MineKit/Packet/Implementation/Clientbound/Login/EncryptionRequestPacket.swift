//
//  EncryptionRequestPacket.swift
//  
//
//  Created by Conor on 10/06/2021.
//

import Foundation

class EncryptionRequestPacket : Packet {
    var packetID: UInt8 = 0x01
    
    let publicKey: [UInt8]
    let verifyToken: [UInt8]
    
    init(with publicKey: [UInt8], and verifyToken: [UInt8]) {
        self.publicKey = publicKey
        self.verifyToken = verifyToken
    }
    
    func writePacket(to buffer: inout WrappedBuffer) {
        // NO-OP
    }
    
    func toString() -> String {
        "(\(self.packetID)): {\"publicKey\": \(self.publicKey), \"verifyToken\": \(self.verifyToken)}"
    }
}
