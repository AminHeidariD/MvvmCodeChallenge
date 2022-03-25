//
//  PostDetailViewController.swift
//  MvvmCodeChallenge
//
//  Created by amin heidari on 3/14/22.
//

import UIKit
import Combine

class PostDetailViewController: UIViewController {
    
    // MARK: Section
    enum Section {
        case postDetail
        case comments
    }
    
    // MARK: Constants
    static let identifier = "PostDetailViewController"
    
    // MARK: Outlets
    @IBOutlet private var tableView: UITableView! {
        didSet {
            setupTableView()
        }
    }
    
    //MARK: Properties
    private var cancellables = Set<AnyCancellable>()
    private var viewModel: PostDetailViewModelProtocol
    private var sections: [Section] = []
    
    // MARK: Init
    init?(coder: NSCoder, post: PostCellViewModel) {
        viewModel = PostDetailViewModel(with: post.id, userId: post.userId)
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("You must create this view controller with a url.")
    }
}

// MARK: Controller Lifecycle
extension PostDetailViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // TODO: get title from viewModel
        title = "Post details"
        bindViewModel()
        viewModel.input.viewDidLoad.send()
    }
}

// MARK: Private methods
private extension PostDetailViewController {
    func bindViewModel() {
        viewModel.output.postDetailUpdated
            .receive(on: DispatchQueue.main, options: nil)
            .sink(receiveValue: { [weak self] in
                self?.updateData()
            })
            .store(in: &cancellables)
        
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
    }
    
    func setupTableView() {
        tableView.dataSource = self
        tableView.register(UINib(nibName: CommentTableViewCell.cellIdentifier, bundle: nil), forCellReuseIdentifier: CommentTableViewCell.cellIdentifier)
        tableView.register(UINib(nibName: PostDetailTableViewCell.cellIdentifier, bundle: nil), forCellReuseIdentifier: PostDetailTableViewCell.cellIdentifier)
    }
    
    func handleError(_ error: Error?) {
        // TODO: Hanle errors
        print("Error: \(error?.localizedDescription ?? "")")
    }
    
    func handleLoading(_ isLoading: Bool) {
        // TODO: Hanle show and hide loading
        print("isLoading: \(isLoading)")
    }
    
    func updateData() {
        arrangeTableSections()
        tableView.reloadData()
    }
    
    func arrangeTableSections() {
        guard let commentsCount = viewModel.datasource?.commentsCount,
              commentsCount > 0 else {
                  sections = [.postDetail]
                  return
              }
        sections = [.postDetail, .comments]
    }
}

// MARK: UITableViewDataSource
extension PostDetailViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch sections[section] {
        case .postDetail:
            return 1
        case .comments:
            return viewModel.datasource?.commentsCount ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        // TODO: get these titles from viewModel
        switch sections[section] {
        case .postDetail:
            return "Post"
        case .comments:
            return "Comments(\(viewModel.datasource?.commentsCount ?? 0))"
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch sections[indexPath.section] {
        case .postDetail:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: PostDetailTableViewCell.cellIdentifier, for: indexPath) as? PostDetailTableViewCell else {
                return UITableViewCell()
            }
            cell.model = viewModel.datasource
            return cell
        case .comments:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CommentTableViewCell.cellIdentifier, for: indexPath) as? CommentTableViewCell else {
                return UITableViewCell()
            }
            // TODO: Check out of range exception
            cell.comment = viewModel.datasource?.comments?[indexPath.row]
            return cell
        }
    }
}
