//
//  HomeModel.swift
//  AutoHome
//
//  Created by Michael Baumgarten on 10/24/21.
//

import Foundation

class HomeModel: ObservableObject {
    @Published var relays = [Relay]()
    
    init() {
        // populate relays with predefined structs

        self.relays.append(Relay(name:"Back Light", ip: "10.0.0.37", on: false))
        self.relays.append(Relay(name:"Front Light", ip: "10.0.0.38", on: false))
        updateRelayModels()
    }
    
    func updateRelayModels() {
        for relay in self.relays {
            relay.updateRelayStatus()
        }
    }
    
    func getRelayModelWithID(id:UUID) -> Relay? {
        for relay in self.relays {
            if relay.id == id {
                return relay
            }
        }
        return nil
    }
    
    func setRelayModelOn(id:UUID, on:Bool) {
        let relay = getRelayModelWithID(id: id)
        if let relay = relay {
            print("Setting relay with id \(id)")
            relay.setRelayOn(on:on)
        } else {
            print("No relay with id \(id)")
        }
    }
}
