//
//  ArticleDetailViewController.swift
//  newsExplorerApp
//
//  Created by Mikhayl Romanovsky on 2023/8/9.
//

import UIKit

final class ArticleDetailViewController: UIViewController {
    private let article: Article
    private let imageView = UIImageView()
    init(article: Article) {
        self.article = article
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        imageSetup()
        
        let title = UILabel()
        title.text = article.title
        title.font = UIFont.preferredFont(forTextStyle: .title1)
        title.numberOfLines = 0
        title.textAlignment = .center
        
        let description = UILabel()
        description.text = article.description
        description.numberOfLines = 0
        description.textAlignment = .center
        
        let author = UILabel()
        author.text = "Author: \(article.author ?? "")"
        author.numberOfLines = 0
        author.textAlignment = .center
        
        let source = UILabel()
        source.text = "Source: \(article.source?.name ?? "")"
        source.numberOfLines = 0
        source.textAlignment = .center
        
        let publishedAt = UILabel()
        publishedAt.text = "Published at: \(article.publishedAt ?? "")"
        publishedAt.numberOfLines = 0
        publishedAt.textAlignment = .center
        
        let stack = UIStackView(arrangedSubviews: [title, description, author, source, publishedAt])
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.spacing = 10
        stack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stack)
      
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        ])
    }
    
    private func imageSetup() {
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            imageView.heightAnchor.constraint(equalToConstant: 200)
        ])
        
        ImageLoader().loadImage(from: article.urlToImage ?? "") { reuslt in
            switch reuslt {
            case .success(let success):
                DispatchQueue.main.async { [weak self] in
                    self?.imageView.image = success
                }
            case .failure(let failure):
                print(failure)
            }
        }
    }
}
