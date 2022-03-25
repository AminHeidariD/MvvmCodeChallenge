//
//  PostCellViewModel.swift
//  MvvmCodeChallenge
//
//  Created by amin heidari on 3/13/22.
//

import Foundation

struct PostCellViewModel {

    let id: Int
    let userId: Int
    let title: String?

    init(post: Post) {
        self.id = post.id
        self.userId = post.userId
        self.title = post.title ?? "Unknown"
    }
}
