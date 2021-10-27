//
//  Relay.swift
//  AutoHome
//
//  Created by Michael Baumgarten on 10/24/21.
//

import Foundation

struct Relay: Identifiable {
    var id: UUID
    var name: String
    var ip: String
    var on: Bool

    init(name: String, ip: String, on: Bool) {
        self.name = name
        self.ip = ip
        self.id = UUID()
        self.on = on
    }
    
    mutating func update(name:String, ip:String, on:Bool) {
        self.name = name
        self.ip = ip
        self.on = on
    }
}
