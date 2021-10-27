//
//  RelayService.swift
//  AutoHome
//
//  Created by Michael Baumgarten on 10/26/21.
//

import Foundation

class RelayService {
    /**
     * Interact with the Shelly relay API
     * @return True is the operation was succesful, False otherwise
     */
    func setRelayOn(relay: Relay, on:Bool, completition: @escaping ((Data) -> Void)) {
        
        // generate request URL from relay
        var urlComp = URLComponents(string:"http://" + relay.ip + "/relay/0")
        urlComp?.queryItems = [URLQueryItem(name: "turn", value: on ? "on" : "off")]
        let url = urlComp?.url!
        
        // make request to relay
        URLSession.shared.dataTask(with: url!) { data, response, error in
            if let error = error {
                fatalError("Network error: " + error.localizedDescription)
            }
            
            guard let response = response as? HTTPURLResponse else {
                fatalError("Not an HTTP response")
            }
            
            guard response.statusCode <= 200, response.statusCode > 300 else {
                fatalError("Invalid HTTP status code")
            }
            
            guard let data = data else {
                fatalError("No HTTP data")
            }
            let respRelay = try JSONDecoder().deoode(ShellyResponse.self, from: data)
            completition(respRelay)
        }.resume()
    }
}
