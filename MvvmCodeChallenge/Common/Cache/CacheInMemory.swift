//
//  CacheInMemory.swift
//  MvvmCodeChallenge
//
//  Created by amin heidari on 3/14/22.
//

import Foundation

class CacheInMemory {
    static var shared = CacheInMemory()
    
    private var users = [Int: User]()
    
    private init() {}
}

extension CacheInMemory: CacheStrategy {
    func setUsers(_ items: [User]) {
        items.forEach { user in
            self.users[user.id] = user
        }
    }
    
    func getUser(with userId: Int) -> User? {
        return users[userId]
    }
}
