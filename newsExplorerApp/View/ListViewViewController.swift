//
//  ListViewViewController.swift
//  newsExplorerApp
//
//  Created by Mikhayl Romanovsky on 2023/8/9.
//

import UIKit

class ListViewViewController: UIViewController {
    var articles: [Article] = [] {
        didSet {
            collectionView.isHidden = articles.isEmpty
            applySnapshot() }
    }
    
    private var collectionView: UICollectionView! = nil
    private var dataSource: UICollectionViewDiffableDataSource<Section, Article>! = nil
    private enum Section {
        case main
    }
    
    private let labelInfo = UILabel()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        labelInfo.text = "It's empty now. Type what kind of articles you want to find"
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
}

extension ListViewViewController: UICollectionViewDelegate {
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
}
