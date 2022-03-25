//
//  PostDetailViewModel.swift
//  MvvmCodeChallenge
//
//  Created by amin heidari on 3/14/22.
//

import Foundation
import Combine

protocol PostDetailViewModelProtocol {
    var datasource: PostDetailModel? { get }
    var input: PostDetailViewModelInputProtocol { get }
    var output: PostDetailViewModelOutputProtocol { get }
}

class PostDetailViewModel: PostDetailViewModelProtocol {
    
    // MARK: - Dependencies
    private var apiService: ApiServiceStrategy
    private var postId: Int
    private var userId: Int
    
    // MARK: - Properties
    private var cancellables = Set<AnyCancellable>()
    
    var input: PostDetailViewModelInputProtocol
    var output: PostDetailViewModelOutputProtocol
    var datasource: PostDetailModel?
    
    // MARK: - Subjects
    private var viewDidLoad = PassthroughSubject<Void, Never>()
    
    private var postDetailUpdatedSubject = PassthroughSubject<Void, Never>()
    private var errorSubject = PassthroughSubject<Error, Never>()
    private var isLoadingSubject = PassthroughSubject<Bool, Never>()
    
    init(with postId: Int, userId: Int, apiService: ApiServiceStrategy = RestApiService()) {
        self.postId = postId
        self.userId = userId
        self.apiService = apiService
        //
        input = Input(viewDidLoad: viewDidLoad)
        output = Output(postDetailUpdated: postDetailUpdatedSubject.eraseToAnyPublisher(), error: errorSubject.eraseToAnyPublisher(), isLoading: isLoadingSubject.eraseToAnyPublisher())
        //
        setupBindings()
    }
}

// MARK: Private methods
private extension PostDetailViewModel {
    func setupBindings() {
        viewDidLoad.sink { [weak self] _ in
            self?.getData()
        }.store(in: &cancellables)
    }
    
    func getData() {
        isLoadingSubject.send(true)
        Publishers.Zip3(apiService.getPostDetail(with: postId),
                        apiService.getUser(with: userId),
                        apiService.getComments(with: postId))
            .map(mapData)
            .sink(receiveCompletion: handleCompletion, receiveValue: handleSuccess)
            .store(in: &cancellables)
        
    }
    func mapData(postDetailAllData: (postDetail: PostDetail, user: User?, comments: [Comment]?)) -> PostDetailModel? {
        return PostDetailModel(postDetail: postDetailAllData.postDetail, user: postDetailAllData.user, comments: postDetailAllData.comments)
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
    
    func handleSuccess(_ postDetailModel: PostDetailModel?) {
        datasource = postDetailModel
        postDetailUpdatedSubject.send()
    }
}

extension PostDetailViewModel {
    struct Input: PostDetailViewModelInputProtocol {
        var viewDidLoad: PassthroughSubject<Void, Never>
    }
    
    struct Output: PostDetailViewModelOutputProtocol {
        var postDetailUpdated: AnyPublisher<Void, Never>
        var error: AnyPublisher<Error, Never>
        var isLoading: AnyPublisher<Bool, Never>
    }
}
