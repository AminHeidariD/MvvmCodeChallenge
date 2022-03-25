//
//  PostsViewController.swift
//  MvvmCodeChallenge
//
//  Created by amin heidari on 3/13/22.
//

import UIKit
import Combine

class PostsViewController: UIViewController {
    
    // MARK: Outlets
    @IBOutlet private var collectionView: UICollectionView! {
        didSet {
            setupCollectionView()
        }
    }
    
    // MARK: - Properties
    private var cancellables = Set<AnyCancellable>()
    private let viewModel: PostsViewModelProtocol = PostsViewModel()
    private let refreshControl = UIRefreshControl()
}

// MARK: Controller Lifecycle
extension PostsViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        //
        bindViewModel()
        viewModel.input.viewDidLoad.send()
        // TODO: get title from viewModel
        title = "Posts"
    }
}

// MARK: Private methods
extension PostsViewController {
    
    func bindViewModel() {
        viewModel.output.posts
            .receive(on: DispatchQueue.main, options: nil)
            .sink { [weak self] _ in
                self?.collectionView.reloadData()
            }.store(in: &cancellables)
        //
        viewModel.output.error
            .receive(on: DispatchQueue.main, options: nil)
            .sink(receiveValue: { [weak self] error in
                self?.handleError(error)
            })
            .store(in: &cancellables)
        //
        viewModel.output.isLoading
            .receive(on: DispatchQueue.main, options: nil)
            .sink(receiveValue: { [weak self] isLoading in
                self?.handleLoading(isLoading)
            })
            .store(in: &cancellables)
        //
        viewModel.output.showDetail
            .receive(on: DispatchQueue.main, options: nil)
            .sink(receiveValue: { [weak self] postCellViewModel in
                self?.showDetail(postCellViewModel)
            })
            .store(in: &cancellables)
    }
    
    func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: PostCollectionViewCell.cellIdentifier, bundle: nil), forCellWithReuseIdentifier: PostCollectionViewCell.cellIdentifier)
        setupRefreshControl(collectionView)
    }
    
    func setupRefreshControl(_ collectionView: UICollectionView) {
        collectionView.refreshControl = refreshControl
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refreshListData(_:)), for: .valueChanged)
    }
    
    @objc func refreshListData(_ sender: Any) {
        viewModel.input.reloadData.send()
    }
    
    func handleError(_ error: Error?) {
        // TODO: Hanle errors
        print("Error: \(error?.localizedDescription ?? "")")
    }
    
    func handleLoading(_ isLoading: Bool) {
        // TODO: Hanle show and hide loading
        if !isLoading {
            refreshControl.endRefreshing()
        }
        print("isLoading: \(isLoading)")
    }
    
    func showDetail(_ post: PostCellViewModel) {
        let detailViewController = initiateDetailViewController(with: post)
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    func initiateDetailViewController(with post: PostCellViewModel) -> PostDetailViewController {
        let mainStroyboard = UIStoryboard(name: "PostDetail", bundle: nil)
        return mainStroyboard.instantiateViewController(identifier: PostDetailViewController.identifier) { coder in
                   return PostDetailViewController(coder: coder, post: post)
        }
    }
}

// MARK: UICollectionViewDataSource
extension PostsViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.datasource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PostCollectionViewCell.cellIdentifier, for: indexPath) as? PostCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.viewModel = viewModel.datasource[indexPath.row]
        return cell
    }
}

// MARK: UICollectionViewDelegate
extension PostsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.input.didSelectPostAtIndex.send(indexPath.row)
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension PostsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // TODO: Remove hard coded and calculate size dynamically
        let width = collectionView.frame.width
        return CGSize(width: width - 32, height: 90)
    }
}
