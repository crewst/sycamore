//
//  Globals.swift
//  Radar
//
//  Created by Thomas Crews on 2/19/17.
//  Copyright © 2017 Thomas Crews. All rights reserved.
//

import Foundation

final class Globals {
    static let shared = Globals()
    
    var currentSSID: String!
    var IPaddress: String!
    var iAccess: Bool!
    var bandwidth: Int!
    var latency: Int!
    var DownComplete: Bool!
}
