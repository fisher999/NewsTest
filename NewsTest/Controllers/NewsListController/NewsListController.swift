//
//  NewsListController.swift
//  NewsTest
//
//  Created by Victor on 15/08/2019.
//  Copyright © 2019 Victor. All rights reserved.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa

class NewsListController: UIViewController {
    fileprivate var (lifetime, token) = Lifetime.make()
    
    @IBOutlet fileprivate weak var tableView: UITableView!
    @IBOutlet fileprivate weak var activityIndicator: UIActivityIndicatorView!
    
    fileprivate var refreshControl = UIRefreshControl(frame: .zero)
    
    private var viewModel: NewsListViewModel
    
    init(viewModel: NewsListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        bind()
    }

    func setup() {
        viewModel.preload()
        
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .none
        self.tableView.delegate = self
        self.tableView.allowsSelection = false
        
        self.tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(update), for: .valueChanged)
        
        self.tableView.estimatedRowHeight = 370
        self.tableView.rowHeight = UITableView.automaticDimension
        
        self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 40, right: 0)
        
        self.tableView.register(NewsCell.nib, forCellReuseIdentifier: NewsCell.defaultReuseIdentifier)
    }
    
    func bind() {
        self.insertRows <~ viewModel.newsDidLoad
        self.activityIndicator.reactive.isAnimating <~ viewModel.loading
        self.activityIndicator.reactive.isHidden <~ viewModel.loading.map({ (isLoading) -> Bool in
            return !isLoading
        })
        self.alert <~ viewModel.alert
        self.tableView.reactive.reloadData <~ viewModel.reload
        self.refreshControl.reactive.isRefreshing <~ viewModel.refresh
    }
}

//MARK: -Binding targets
extension NewsListController {
    private var insertRows: BindingTarget<[IndexPath]> {
        return BindingTarget<[IndexPath]>.init(lifetime: lifetime, action: { [weak self] (indexPaths) in
            DispatchQueue.main.async {
                self?.tableView.beginUpdates()
                self?.tableView.insertRows(at: indexPaths, with: .automatic)
                self?.tableView.endUpdates()
                self?.viewModel.didInsertRows()
            }
        })
    }
    
    private var alert: BindingTarget<(String, (() -> Void)?)> {
        return BindingTarget<(String, (() -> Void)?)>.init(lifetime: lifetime, action: { (message, completion) in
            self.alert(message: message, handler: completion)
        })
    }
}

//Actions
extension NewsListController {
    @objc private func update() {
        viewModel.reloadNews()
    }
}

extension NewsListController: UITableViewDelegate {
    
}

//MARK: -Data source
extension NewsListController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.count()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NewsCell.defaultReuseIdentifier, for: indexPath) as! NewsCell
        cell.model = viewModel.cellForRowAtIndexPath(indexPath)
        
        return cell
    }
}

extension NewsListController: UIScrollViewDelegate {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let contentHeight = scrollView.contentSize.height
        print(contentHeight)
        print(scrollView.contentOffset.y)
        
        if scrollView.contentOffset.y + scrollView.frame.height > contentHeight {
            viewModel.preloadNextPage()
        }
    }
}
