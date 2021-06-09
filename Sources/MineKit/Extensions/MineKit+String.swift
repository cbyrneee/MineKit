//
//  File.swift
//  
//
//  Created by Conor on 09/06/2021.
//

import Foundation

extension StringProtocol {
    var bytes: [UInt8] { .init(utf8) }
}
