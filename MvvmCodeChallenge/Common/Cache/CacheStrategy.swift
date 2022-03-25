//
//  CacheStrategy.swift
//  MvvmCodeChallenge
//
//  Created by amin heidari on 3/14/22.
//

import Foundation

protocol CacheStrategy {
    // TODO: Implement with generic type for enhancement
    func setUsers(_ items: [User])
    func getUser(with userId: Int) -> User?
}
