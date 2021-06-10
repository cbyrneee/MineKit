//
//  BufferError.swift
//  
//
//  Created by Conor on 09/06/2021.
//

import Foundation

enum BufferError : Error {
    case read(String)
    case write(String)
}
