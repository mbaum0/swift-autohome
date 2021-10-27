//
//  HomeModel.swift
//  AutoHome
//
//  Created by Michael Baumgarten on 10/24/21.
//

import Foundation
import CloudKit

class HomeModel: ObservableObject {
    @Published var relays = [Relay]()
    
    init() {
        // populate relays with predefined structs

        self.relays.append(Relay(name:"Back Light", ip: "10.0.0.37", on: false))
        self.relays.append(Relay(name:"Front Light", ip: "10.0.0.38", on: false))
    }
    
    func getRelayWithID(id:UUID) -> Relay? {
        for relay in self.relays {
            if relay.id == id {
                return relay
            }
        }
        return nil
    }
    
    func updateRelayModel(id:UUID, name:String, ip:String, on:Bool) {
        for (index, _) in self.relays.enumerated() {
            if self.relays[index].id == id {
                self.relays[index].update(name: name, ip: ip, on: on)
            }
        }
    }
    
    func setRelayOn(id:UUID, on:Bool) {
        let relay = self.getRelayWithID(id: id)
        if let relay = relay {
            var urlComp = URLComponents(string:"http://" + relay.ip + "/relay/0")
            urlComp?.queryItems = [URLQueryItem(name: "turn", value: on ? "on" : "off")]
            let url = urlComp?.url
            
            if let url = url {
                var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10.0)
                request.httpMethod = "GET"
                
                let session = URLSession.shared
                
                let datatask = session.dataTask(with: request) { data, response, error in
                    if error == nil {
                        do {
                            let decoder = JSONDecoder()
                            let result = try decoder.decode(ShellyResponse.self, from: data!)
                            
                            DispatchQueue.main.async {
                                self.updateRelayModel(id: relay.id, name: relay.name, ip: relay.ip, on: result.ison!)
                                    
                            }
                        } catch {
                            print(error)
                        }
                    }
                }
                datatask.resume()
            }
        }
    }
    
    func toggleRelay(id:UUID) {
        let relay = self.getRelayWithID(id: id)
        if relay != nil {
            var urlComp = URLComponents(string:"http://" + (relay?.ip)! + "/relay/0")
            urlComp?.queryItems = [URLQueryItem(name: "turn", value: "toggle")]
            let url = urlComp?.url
            
            if let url = url {
                var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10.0)
                request.httpMethod = "GET"
                
                let session = URLSession.shared
                
                let datatask = session.dataTask(with: request) { data, response, error in
                    if error == nil {
                        do {
                            let decoder = JSONDecoder()
                            let result = try decoder.decode(ShellyResponse.self, from: data!)
                            
                            DispatchQueue.main.async {
                                self.setRelayOn(id: id, on: result.ison!)
                            }
                        } catch {
                            print(error)
                        }
                    }
                }
                datatask.resume()
            }
        }
    }
}
