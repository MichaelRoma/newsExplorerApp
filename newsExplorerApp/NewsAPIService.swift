//
//  NewsAPIService.swift
//  newsExplorerApp
//
//  Created by Mikhayl Romanovsky on 2023/8/8.
//

import Foundation

final class NewsAPIService {
    private let apikey = "549aa53a47b24437adcc04e0c50a7d78"
    private var urlComponents: URLComponents {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "newsapi.org"
        urlComponents.path = "/v2/everything"
        return urlComponents
    }
    
    enum APIError: Error {
        case noData, jasonDecodingError, requestFaild
    }
    
    
    func fetchArticles(query: String, from: String?, to: String?, sortBy: String, completion: @escaping (Result<[Article], APIError>)-> Void) {
        var urlComponents = self.urlComponents
        urlComponents.queryItems = [
            URLQueryItem(name: "q", value: query),
            URLQueryItem(name: "from", value: from),
            URLQueryItem(name: "to", value: to),
            URLQueryItem(name: "sortBy", value: sortBy),
            URLQueryItem(name: "apiKey", value: apikey)
        ]
        
        guard let url = urlComponents.url else { return }
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                completion(.failure(.requestFaild))
                return
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            do {
                let apiResponse = try JSONDecoder().decode(APIResponse.self, from: data)
                completion(.success(apiResponse.articles ?? [Article]()))
            } catch {
                completion(.failure(.jasonDecodingError))
            }
        }.resume()
    }
}
