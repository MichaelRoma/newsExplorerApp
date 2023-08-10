//
//  ViewController.swift
//  newsExplorerApp
//
//  Created by Mikhayl Romanovsky on 2023/8/8.
//

import UIKit

class ArticleListViewController: ListViewViewController {
    private let newsAPIService: NewsAPIService
    private enum SortOption: String, CaseIterable {
        case relevancy, popularity, publishedAt
    }
    private var sortOprion = SortOption.publishedAt
    private let searchBar = UISearchBar()
    
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
        let sortButton = UIBarButtonItem(title: "Sort", style: .plain, target: self, action: #selector(showActionSheet))
        let timePeriodButton = UIBarButtonItem(title: "Time period", style: .plain, target: self, action: #selector(timePeriodButtonTapped))
        
        navigationItem.rightBarButtonItems = [sortButton, timePeriodButton]
        searchBar.showsCancelButton = true
        searchBar.placeholder = "Type here"
        searchBar.delegate = self
        navigationItem.titleView = searchBar
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let articleDetailViewController = ArticleDetailViewController(article: articles[indexPath.item])
        navigationController?.pushViewController(articleDetailViewController, animated: true)
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
