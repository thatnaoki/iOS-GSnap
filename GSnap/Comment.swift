//
//  Comment.swift
//  GSnap
//
//  Created by Naoki Muroya on 2019/02/22.
//  Copyright © 2019 thatnaoki. All rights reserved.
//

import Foundation

class Comment: Codable {
    let id: Int
    let post_id: Int
    let user_id: Int
    let comment: String
}
