//
//  PostDetailModel.swift
//  MvvmCodeChallenge
//
//  Created by amin heidari on 3/14/22.
//

import Foundation

struct PostDetailModel {
    
    let author: String?
    let title: String?
    let body: String?
    let comments: [Comment]?

    var commentsCount: Int {
        return comments?.count ?? 0
    }
    
    init(postDetail: PostDetail, user: User?, comments: [Comment]?) {
        author = "Author: \(user?.name ?? "Unknown")"
        title = postDetail.title
        body = postDetail.body
        self.comments = comments
    }
}
