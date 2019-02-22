//
//  User.swift
//  GSnap
//
//  Created by Naoki Muroya on 2019/02/08.
//  Copyright © 2019 thatnaoki. All rights reserved.
//

import Foundation

struct User: Codable {
    
    let id: Int
    let name: String
    let avatar_url: String
    let api_token: String
    
}
