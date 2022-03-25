//
//  PostDetailViewModelProtocol.swift
//  MvvmCodeChallenge
//
//  Created by amin heidari on 3/14/22.
//

import Foundation
import Combine

protocol PostDetailViewModelInputProtocol {
    var viewDidLoad: PassthroughSubject<Void, Never> { get }
}

protocol PostDetailViewModelOutputProtocol {
    var postDetailUpdated: AnyPublisher<Void, Never> { get }
    var error: AnyPublisher<Error, Never> { get }
    var isLoading: AnyPublisher<Bool, Never> { get }
}
