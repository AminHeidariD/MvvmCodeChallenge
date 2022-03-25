//
//  Comment.swift
//  MvvmCodeChallenge
//
//  Created by amin heidari on 3/13/22.
//

import Foundation

struct Comment: Decodable {
    let id: Int
    let name: String?
    let body: String?
}
