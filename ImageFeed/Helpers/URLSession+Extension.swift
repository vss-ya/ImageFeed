//
//  URLSession+Extension.swift
//  ImageFeed
//
//  Created by vs on 26.02.2024.
//

import Foundation

extension URLSession {
    
    func objectTask<T: Decodable>(
            with request: URLRequest,
            completion: @escaping (Result<T, Error>) -> Void
    ) -> URLSessionTask {
        let task = dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(NetworkError.requestError(error)))
                return
            }
            let statusCode = (response as! HTTPURLResponse).statusCode
            if 200..<300 ~= statusCode, let data = data {
                do {
                    let decoder = JSONDecoder()
                    let result = try decoder.decode(T.self, from: data)
                    completion(.success(result))
                } catch {
                    completion(.failure(error))
                }
            } else {
                completion(.failure(NetworkError.statusCode(statusCode)))
            }
        }
        task.resume()
        return task
    }
    
}
