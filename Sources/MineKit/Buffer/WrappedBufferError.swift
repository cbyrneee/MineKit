//
//  File.swift
//  
//
//  Created by Conor on 09/06/2021.
//

import Foundation

enum WrappedBufferError : Error {
    case read(String)
    case write(String)
}
