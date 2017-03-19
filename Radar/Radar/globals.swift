//
//  Globals.swift
//  Radar
//
//  Created by Thomas Crews on 2/19/17.
//  Copyright © 2017 Thomas Crews. All rights reserved.
//

import Foundation
import UIKit

final class Globals {
    static let shared = Globals()
    
    var currentSSID: String!
    var IPaddress: String!
    var iAccess: Bool!
    var bandwidth: Int!
    var latency: String!
    var DownComplete: Bool!
    var externalIP: String!
    var currentBSSID: String!
    var DNSaddress: String!
    
    var speedUnits: String!
    var dataUse: Double! = 0.0
    
    var netIsGood: Bool! = true
}


// S.D.G.
