//
//  PostsViewModelProtocols.swift
//  MvvmCodeChallenge
//
//  Created by amin heidari on 3/13/22.
//

import Foundation
import Combine

protocol PostsViewModelInputProtocol {
    var reloadData: PassthroughSubject<Void, Never> { get }
    var viewDidLoad: PassthroughSubject<Void, Never> { get }
    var didSelectPostAtIndex: PassthroughSubject<Int, Never> { get }
}

protocol PostsViewModelOutputProtocol {
    var posts: AnyPublisher<[PostCellViewModel], Never> { get }
    var showDetail: AnyPublisher<PostCellViewModel, Never> { get }
    var error: AnyPublisher<Error, Never> { get }
    var isLoading: AnyPublisher<Bool, Never> { get }
}
