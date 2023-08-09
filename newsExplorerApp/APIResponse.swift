//
//  APIResponse.swift
//  newsExplorerApp
//
//  Created by Mikhayl Romanovsky on 2023/8/8.
//

import Foundation

struct APIResponse: Codable {
    let status: String?
    let totalResults: Int?
    let articles: [Article]?
}

struct Article: Codable, Hashable{

    private var identifier = UUID()
    func hash(into hasher: inout Hasher) { hasher.combine(identifier)}
    static func == (lhs: Article, rhs: Article) -> Bool { return lhs.identifier == rhs.identifier}
    
    let source: Source?
    let author: String?
    let title: String?
    let description: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String?
    let content: String?
    
    struct Source:Codable {
        let id: String?
        let name: String?
    }
    
    enum CodingKeys: String, CodingKey {
        case source, author, title, description, url, urlToImage, publishedAt, content
    }
}

