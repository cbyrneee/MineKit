//
//  MineKitServerDetails.swift
//  
//
//  Created by Conor on 09/06/2021.
//

import Foundation

/// The structure providing the details of the server you wish to connect to
public struct ServerDetails {
    let address: String
    let port: Int = 25565
}
