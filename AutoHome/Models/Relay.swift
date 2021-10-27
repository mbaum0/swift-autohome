//
//  Relay.swift
//  AutoHome
//
//  Created by Michael Baumgarten on 10/24/21.
//

import Foundation

class Relay: Identifiable, ObservableObject {
    var id: UUID
    var name: String
    var ip: String
    @Published var on: Bool

    init(name: String, ip: String, on: Bool) {
        self.name = name
        self.ip = ip
        self.id = UUID()
        self.on = on
    }
    
    func updateRelayStatus() {
        let url = URL(string:"http://" + self.ip + "/relay/0")
        if let url = url {
            URLSession.shared.dataTask(with: url) { data, resp, err in
                if err == nil {
                    // decode the JSON response
                    do {
                        let result = try JSONDecoder().decode(ShellyOneResponse.self, from: data!)
                        DispatchQueue.main.async {
                            // set the on state of the relay
                            self.on = result.ison!
                            print("relay with id \(self.id) has been set to \(self.on)")
                        }
                    } catch {
                        print(error)
                    }
                }
            }.resume()
        }
    }
    
    func setRelayOn(on:Bool) {
        
        var urlComponents = URLComponents(string:"http://" + self.ip + "/relay/0")
        urlComponents?.queryItems = [URLQueryItem(name: "turn", value: on ? "on" : "off")]
        let url = urlComponents?.url!
        
        if let url = url {
            URLSession.shared.dataTask(with: url) { data, resp, err in
                if err == nil {
                    // decode the JSON response
                    do {
                        let result = try JSONDecoder().decode(ShellyOneResponse.self, from: data!)
                        DispatchQueue.main.async {
                            // set the on state of the relay
                            self.on = result.ison!
                        }
                    } catch {
                        print(error)
                    }
                }
            }.resume()
        }
    }
}
