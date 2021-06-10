//
//  ConnectionHandler.swift
//  
//
//  Created by Conor on 10/06/2021.
//

import Foundation
import NIO

/// Allows you to listen to packets, state changes and disconnect
protocol ConnectionHandler {
    func on(packet: Packet, connection: ChannelHandlerContext)
    func on(state: ConnectionState, connection: ChannelHandlerContext)
    func on(disconnect: String, connection: ChannelHandlerContext)
}

/// The class which you will implement when calling MineKit#connect
class ConnectionHandlerAdapter : ConnectionHandler {
    func on(packet: Packet, connection: ChannelHandlerContext) {
    }
    
    func on(state: ConnectionState, connection: ChannelHandlerContext) {
    }
    
    func on(disconnect: String, connection: ChannelHandlerContext) {
    }
}
