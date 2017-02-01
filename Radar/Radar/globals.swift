//
//  globals.swift
//  Radar
//
//  Created by Thomas Crews on 2/1/17.
//  Copyright © 2017 Thomas Crews. All rights reserved.
//

import Foundation

class Globals {
    var error:String
    init(error:String) {
        self.error = error
    }
}
var globalInstance = Globals(error:"UNDEF")
