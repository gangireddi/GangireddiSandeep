//
//  Address.swift
//  Gangireddi
//
//  Created by Sandeep on 07/02/22.
//

import Foundation
struct Address: Decodable {
    let street: String
    let suite: String
    let city: String
    let zipcode: String
    let geo: Geo
}

