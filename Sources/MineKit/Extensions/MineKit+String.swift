//
//  File.swift
//  
//
//  Created by Conor on 09/06/2021.
//

import Foundation

extension StringProtocol {
    /// Returns the current string as a byte array
    var bytes: [UInt8] { .init(utf8) }
}
