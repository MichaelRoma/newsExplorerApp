//
//  ImageLoader.swift
//  newsExplorerApp
//
//  Created by Mikhayl Romanovsky on 2023/8/9.
//

import UIKit
final class ImageLoader {
    enum NetworkError: Error {
        case cantCreateUrl, networkError, imageCreatingError
    }
    func loadImage(from urlString: String, completion: @escaping (Result<UIImage, NetworkError>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(.cantCreateUrl))
            return
        }
        URLSession.shared.dataTask(with: url) { data, _, error in
            if error != nil { completion(.failure(.networkError))}
            if let data = data, let image = UIImage(data: data) {
                completion(.success(image))
            } else { completion(.failure(.imageCreatingError)) }
        }.resume()
    }
}
