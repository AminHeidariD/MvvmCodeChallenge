//
//  Endpoints.swift
//  MvvmCodeChallenge
//
//  Created by amin heidari on 3/13/22.
//

import Foundation

enum Endpoints {
    
    case posts
    case users
    case postDetail(postId: Int)
    case comments(postId: Int)
    
    var url: URL {
        guard let url = URL(string: path) else {
            fatalError("The URL mustn't be null.")
        }
        return url
    }
    
    private var baseUrl: String {
        return "https://jsonplaceholder.typicode.com"
    }
    
    private var path: String {
        switch self {
        case .posts:
            return "\(baseUrl)/posts"
        case .users:
            return "\(baseUrl)/users"
        case .postDetail(let postId):
            return "\(baseUrl)/posts/\(postId)"
        case .comments(let postId):
            return "\(baseUrl)/posts/\(postId)/comments"
        }
    }
}
