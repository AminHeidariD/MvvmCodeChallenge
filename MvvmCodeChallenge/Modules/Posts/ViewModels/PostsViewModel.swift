//
//  PostsViewModel.swift
//  MvvmCodeChallenge
//
//  Created by amin heidari on 3/13/22.
//

import Foundation
import Combine

protocol PostsViewModelProtocol {
    var input: PostsViewModelInputProtocol { get }
    var output: PostsViewModelOutputProtocol { get }
    var datasource: [PostCellViewModel] { get }
}

class PostsViewModel: PostsViewModelProtocol {
    
    // MARK: - Dependencies
    private var apiService: ApiServiceStrategy
    
    // MARK: - Properties
    private var cancellables = Set<AnyCancellable>()
    
    var datasource = [PostCellViewModel]()
    var title: String = "Posts"
    var input: PostsViewModelInputProtocol
    var output: PostsViewModelOutputProtocol
    
    // MARK: - Subjects
    private var reloadData = PassthroughSubject<Void, Never>()
    private var viewDidLoadSubject = PassthroughSubject<Void, Never>()
    private var didSelectPostAtIndexSubject = PassthroughSubject<Int, Never>()
    
    private var postsSubject = CurrentValueSubject<[PostCellViewModel], Never>([])
    private var errorSubject = PassthroughSubject<Error, Never>()
    private var isLoadingSubject = PassthroughSubject<Bool, Never>()
    private var showDetailSubject = PassthroughSubject<PostCellViewModel, Never>()
    
    init(apiService: ApiServiceStrategy = RestApiService()) {
        self.apiService = apiService
        //
        input = Input(reloadData: reloadData, viewDidLoad: viewDidLoadSubject, didSelectPostAtIndex: didSelectPostAtIndexSubject)
        output = Output(posts: postsSubject.eraseToAnyPublisher(), error: errorSubject.eraseToAnyPublisher(), isLoading: isLoadingSubject.eraseToAnyPublisher(), showDetail: showDetailSubject.eraseToAnyPublisher())
        //
        setupBindings()
    }
}

// MARK: Private methods
private extension PostsViewModel {
    func setupBindings() {
        
        viewDidLoadSubject.sink { [weak self] _ in
            self?.getData()
        }.store(in: &cancellables)
        //
        reloadData.sink { [weak self] _ in
            self?.getData()
        }.store(in: &cancellables)
        //
        didSelectPostAtIndexSubject
            .compactMap {self.datasource[$0]}
            .sink { [weak self] post in
                self?.showDetailSubject.send(post)
            }.store(in: &cancellables)
    }
    
    func getData() {
        isLoadingSubject.send(true)
        apiService.getPosts()
            .map(mapData)
            .sink(receiveCompletion: handleCompletion, receiveValue: handleSuccess)
            .store(in: &cancellables)
    }
    
    func mapData(posts: [Post]?) -> [PostCellViewModel]? {
        posts?.compactMap { PostCellViewModel(post: $0) }
    }
    
    func handleCompletion(_ completion: Subscribers.Completion<Error>) {
        isLoadingSubject.send(false)
        switch completion {
        case .failure(let error):
            errorSubject.send(error)
        case .finished:
            break
        }
    }
    
    func handleSuccess(_ posts: [PostCellViewModel]?) {
        guard let posts = posts else {
            // TODO: Hanle to show empty list
            return
        }
        datasource = posts
        postsSubject.send(datasource)
    }
}

extension PostsViewModel {
    struct Input: PostsViewModelInputProtocol {
        var reloadData: PassthroughSubject<Void, Never>
        var viewDidLoad: PassthroughSubject<Void, Never>
        var didSelectPostAtIndex: PassthroughSubject<Int, Never>
    }
    
    struct Output: PostsViewModelOutputProtocol {
        var posts: AnyPublisher<[PostCellViewModel], Never>
        var error: AnyPublisher<Error, Never>
        var isLoading: AnyPublisher<Bool, Never>
        var showDetail: AnyPublisher<PostCellViewModel, Never>
    }
}
