//
//  PostDetail.swift
//  MvvmCodeChallenge
//
//  Created by amin heidari on 3/13/22.
//

import Foundation

struct PostDetail: Decodable {
    let id: Int
    let userId: Int
    let title: String?
    let body: String?
}
