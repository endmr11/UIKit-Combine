//
//  ViewController.swift
//  UIKit+Combine
//
//  Created by Eren Demir on 1.04.2023.
//

import UIKit
import Combine

private enum HomeViewConstant {
    static let cellReuseIdentifier = "TableViewCell"
    static let navigationBarTitle = "Home"
    static let emptyLabelText = "Not Found!"
    static let searchText = "Search"
    static let fontSize = 20.0
}

protocol IHomeView: AnyObject {
    func setUpNavigationBar()
    func setUpUI()
    func setUpBinding()
    func closeLoading()
    func showLoading()
}

final class HomeViewController: UIViewController {
    
    private lazy var searchBarController: UISearchController = {
        let searchVC = UISearchController(searchResultsController: nil)
        searchVC.searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchVC
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(TableViewCell.self, forCellReuseIdentifier: HomeViewConstant.cellReuseIdentifier)
        return tableView
    }()
    
    private lazy var viewModel: IHomeViewModel = HomeViewModel(view: self)
    var subscriptions = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.viewDidLoad()
        view.backgroundColor = .red
    }
    
}

//MARK: - SearchBar Delegate
extension HomeViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else { return }
        self.viewModel.searchText.send(text)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.viewModel.getAllColors()
    }
    
}

//MARK: - TableView DataSource
extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRowsInSection
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeViewConstant.cellReuseIdentifier,for: indexPath) as? TableViewCell else {
            return UITableViewCell()
        }
        cell.setCell(model: viewModel.colorList.value[indexPath.row])
        cell.selectionStyle = .gray
        return cell
    }
}

//MARK: - TableView Delegate
extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.didSelectRowAt(index: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        viewModel.heightForRowAt
    }
    
    private func handleDelete(index: Int) {
        viewModel.colorList.value.remove(at: index)
    }
    
    
    func tableView(_ tableView: UITableView,trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let trash = UIContextualAction(style: .destructive,
                                       title: "Delete") { [weak self] (action, view, completionHandler) in
            self?.handleDelete(index: indexPath.row)
            completionHandler(true)
        }
        trash.backgroundColor = .systemRed
        
        let configuration = UISwipeActionsConfiguration(actions: [trash])
        return configuration
    }
    
}


// MARK: - HomeViewInterface
extension HomeViewController:IHomeView {
    
    func setUpBinding() {
        viewModel.colorList.sink { completion in
        } receiveValue: { val in
            self.tableView.reloadData()
        }.store(in: &subscriptions)
        
        let searchTextPublisher = NotificationCenter.default
            .publisher(for: UISearchTextField.textDidChangeNotification,
                       object: searchBarController.searchBar.searchTextField)
        
        //        searchTextPublisher
        //            .compactMap {
        //                ($0.object as? UISearchTextField)?.text
        //            }
        //            .sink { [unowned self] (str) in
        //                self.viewModel.searchText.send(str)
        //            }.store(in: &subscriptions)
        
        searchTextPublisher
            .compactMap {
                ($0.object as? UISearchTextField)?.text
            }
            .assign(to: \.searchText.value, on: viewModel)
            .store(in: &subscriptions)
        
        
        viewModel.errorText.sink { text in
            self.showToast(title: "Error", text: text, delay: 2)
        }.store(in: &subscriptions)
        
        
        ThemeManager.shared.themeColor.sink { value in
            self.tableView.backgroundColor = UIColor(hex: value ?? "")
            
        }.store(in: &subscriptions)
    }
    
    func setUpNavigationBar() {
        navigationItem.hidesBackButton = true
        navigationItem.searchController = searchBarController
        searchBarController.searchBar.delegate = self
        searchBarController.searchBar.placeholder = HomeViewConstant.searchText
        navigationItem.title = HomeViewConstant.navigationBarTitle
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    func setUpUI() {
        self.view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.centerYAnchor.constraint(equalTo:view.centerYAnchor),
            tableView.centerXAnchor.constraint(equalTo:view.centerXAnchor),
            tableView.heightAnchor.constraint(equalTo:view.heightAnchor),
            tableView.widthAnchor.constraint(equalTo:view.widthAnchor),
        ])
    }
    
    func showLoading() {
        DispatchQueue.main.async {
            self.showLoadingCircularIndicator()
        }
    }
    
    func closeLoading() {
        DispatchQueue.main.asyncAfter(wallDeadline: .now() + .milliseconds(30), execute: {
            self.closeLoadingCircularIndicator()
        })
    }
}

