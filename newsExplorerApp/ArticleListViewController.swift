//
//  ViewController.swift
//  newsExplorerApp
//
//  Created by Mikhayl Romanovsky on 2023/8/8.
//

import UIKit

class ArticleListViewController: UIViewController {
    private let newsAPIService: NewsAPIService
    private var articles: [Article] = [] {
        didSet {
            collectionView.isHidden = articles.isEmpty
            applySnapshot() }
    }
    
    private var collectionView: UICollectionView! = nil
    private var dataSource: UICollectionViewDiffableDataSource<Section, Article>! = nil
    private enum Section {
        case main
    }
    
    private enum SortOption: String, CaseIterable {
        case relevancy, popularity, publishedAt
    }
    private var sortOprion = SortOption.publishedAt
    private let searchBar = UISearchBar()
    
    private let labelInfo = UILabel()
    
    //Since the plan is basic, the search by dates is limited to those not older than one month
    //Also dont use current day
    private var fromDate: String?
    private var toDate: String?
    
    init(newsAPIService: NewsAPIService) {
        self.newsAPIService = newsAPIService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        let sortButton = UIBarButtonItem(title: "Sort", style: .plain, target: self, action: #selector(showActionSheet))
        let timePeriodButton = UIBarButtonItem(title: "Time period", style: .plain, target: self, action: #selector(timePeriodButtonTapped))
        
        navigationItem.rightBarButtonItems = [sortButton, timePeriodButton]
        searchBar.showsCancelButton = true
        searchBar.placeholder = "Type here"
        searchBar.delegate = self
        navigationItem.titleView = searchBar
        
        labelInfo.text = "It's empty now. Type what kind of articles you want to find and press the 'Explore' button"
        labelInfo.numberOfLines = 0
        labelInfo.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(labelInfo)
        NSLayoutConstraint.activate([
            labelInfo.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            labelInfo.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            labelInfo.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            labelInfo.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30)
        ])
        
        configureHierarchy()
        configureDataSource()
    }
    
    @objc private func showActionSheet() {
        let actionSheet = UIAlertController(title: "Sort oprion", message: "Current sort option is \(sortOprion.rawValue)", preferredStyle: .actionSheet)
        _ = SortOption.allCases.map { sortOprion in
            let action = UIAlertAction(title: sortOprion.rawValue, style: .default) { [weak self] _ in self?.sortOprion = sortOprion }
            actionSheet.addAction(action)
        }
        present(actionSheet, animated: true)
    }
    
    @objc private func timePeriodButtonTapped() {
        let childVC = TimePeriodViewController()
        childVC.completionHandler = { [weak self] timePeriod in
            self?.fromDate = timePeriod.from
            self?.toDate = timePeriod.to
        }
        navigationController?.pushViewController(childVC, animated: true)
    }
}

extension ArticleListViewController: UISearchBarDelegate {
    private func searchBarAction(_ searchBar: UISearchBar) {
        startWaitingIndicator()
        newsAPIService.fetchArticles(query: searchBar.text ?? "",
                                     from: fromDate,
                                     to: toDate,
                                     sortBy: sortOprion.rawValue) { result in
            switch result {
            case .success(let articals):
                DispatchQueue.main.async { [weak self] in
                    self?.articles = articals
                    self?.stopWaitingIndicatore()
                }
            case .failure(let error):
                print(error)
                DispatchQueue.main.async { [weak self] in
                    self?.stopWaitingIndicatore()
                }
            }
        }
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBarAction(searchBar)
    }
}

extension ArticleListViewController: UICollectionViewDelegate {
    private func configureHierarchy() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.isHidden = true
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        ])
    }
    
    private func createLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout.list(using: .init(appearance: .insetGrouped))
    }
    
    private func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, Article> { cell, indexPath, itemIdentifier in
            var content = cell.defaultContentConfiguration()
            content.text = "\(itemIdentifier.title ?? "")"
            content.secondaryText = "\(itemIdentifier.description ?? "")"
            cell.contentConfiguration = content
        }
        
        dataSource = UICollectionViewDiffableDataSource<Section, Article>(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
        })
        applySnapshot()
    }
    
    private func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Article>()
        snapshot.appendSections([.main])
        snapshot.appendItems(articles)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let articleDetailViewController = ArticleDetailViewController(article: articles[indexPath.item])
        navigationController?.pushViewController(articleDetailViewController, animated: true)
    }
}
