//
//  RestApiService.swift
//  MvvmCodeChallenge
//
//  Created by amin heidari on 3/13/22.
//

import Foundation
import Combine

class RestApiService {
   
    // MARK: Properties
    private let httpGateway: HttpGatewayProtocol = HttpGateway()
    private let jsonDecoder = JSONDecoder()
    private let cacheStrategy: CacheStrategy
    
    init(cacheStrategy: CacheStrategy = CacheInMemory.shared) {
        self.cacheStrategy = cacheStrategy
    }
}

// MARK: ApiServiceStrategy
extension RestApiService: ApiServiceStrategy {
    func getPosts() -> AnyPublisher<[Post]?, Error> {
        return httpGateway.getRequest(url: Endpoints.posts.url)
            .compactMap { $0 }
            .decode(type: [Post]?.self, decoder: jsonDecoder)
            .eraseToAnyPublisher()
    }
    
    func getPostDetail(with postId: Int) -> AnyPublisher<PostDetail, Error> {
        return httpGateway.getRequest(url: Endpoints.postDetail(postId: postId).url)
            .compactMap { $0 }
            .decode(type: PostDetail.self, decoder: jsonDecoder)
            .eraseToAnyPublisher()
    }
    
    func getComments(with postId: Int) -> AnyPublisher<[Comment]?, Error> {
        return httpGateway.getRequest(url: Endpoints.comments(postId: postId).url)
            .compactMap { $0 }
            .decode(type: [Comment]?.self, decoder: jsonDecoder)
            .eraseToAnyPublisher()
    }
    
    func getUser(with userId: Int) -> AnyPublisher<User?, Error> {
       guard let user = cacheStrategy.getUser(with: userId) else {
           return getUserFromApi(with: userId)
        }
        print("Get user from cache")
        return Just(user)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}

// MARK: Methods
extension RestApiService {
    private func getUserFromApi(with userId: Int) -> AnyPublisher<User?, Error> {
        return httpGateway.getRequest(url: Endpoints.users.url)
            .compactMap { $0 }
            .decode(type: [User].self, decoder: jsonDecoder)
            .compactMap { [weak self] users in
                self?.cacheStrategy.setUsers(users)
                return self?.cacheStrategy.getUser(with: userId)
            }
            .eraseToAnyPublisher()
    }
}
