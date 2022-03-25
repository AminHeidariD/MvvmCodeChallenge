//
//  ApiServiceStrategy.swift
//  MvvmCodeChallenge
//
//  Created by amin heidari on 3/13/22.
//

import Foundation
import Combine

protocol ApiServiceStrategy {
    func getPosts() -> AnyPublisher<[Post]?, Error>
    func getPostDetail(with postId: Int) -> AnyPublisher<PostDetail, Error>
    func getUser(with userId: Int) -> AnyPublisher<User?, Error>
    func getComments(with postId: Int) -> AnyPublisher<[Comment]?, Error>
}
