//
//  PacketReaderError.swift
//  
//
//  Created by Conor on 09/06/2021.
//

import Foundation

enum PacketReaderError : Error {
    case noHandler
    case read(String)
}
