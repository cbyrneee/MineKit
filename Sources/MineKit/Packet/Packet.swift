//
//  File.swift
//  
//
//  Created by Conor on 09/06/2021.
//

import Foundation
import NIO

public protocol Packet {
    var packetID: UInt8 { get }
    func writePacket(to buffer: inout WrappedBuffer)
    func toString() -> String
}
