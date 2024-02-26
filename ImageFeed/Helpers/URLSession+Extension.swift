//
//  URLSession+Extension.swift
//  ImageFeed
//
//  Created by vs on 26.02.2024.
//

import Foundation

extension URLSession {
    
    func data(
        for request: URLRequest,
        completion: @escaping (Result<Data, Error>) -> Void
    ) -> URLSessionTask {
        let callCompletion: (Result<Data, Error>) -> Void = { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
        let task = dataTask(with: request) { data, response, error in
            if let error = error {
                callCompletion(.failure(NetworkError.requestError(error)))
                return
            }
            let statusCode = (response as! HTTPURLResponse).statusCode
            if 200 ..< 300 ~= statusCode, let data = data {
                callCompletion(.success(data))
            } else {
                callCompletion(.failure(NetworkError.statusCode(statusCode)))
            }
        }
        task.resume()
        return task
    }
    
}
