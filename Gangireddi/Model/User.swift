//
//  User.swift
//  Gangireddi
//
//  Created by Sandeep on 07/02/22.
//

import Foundation
struct User: Decodable {
    let id: Int
    let name: String
    let username: String
    let email: String
    let address: Address
}
