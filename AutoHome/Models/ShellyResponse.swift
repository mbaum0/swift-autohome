//
//  ShellyResponse.swift
//  AutoHome
//
//  Created by Michael Baumgarten on 10/24/21.
//

import Foundation

struct ShellyResponse: Decodable {
    var ison: Bool?
    var has_timer: Bool?
    var timer_remaining: Int?
}
