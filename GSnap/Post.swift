//
//  Post.swift
//  GSnap
//
//  Created by Naoki Muroya on 2019/02/08.
//  Copyright © 2019 thatnaoki. All rights reserved.
//

import Foundation

class Post: Codable {
    
    let id: Int
    let body: String
    let image_url: String
    var liked: Bool
    let user: User
    
}
