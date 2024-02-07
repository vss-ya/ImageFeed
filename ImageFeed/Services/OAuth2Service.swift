//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by vs on 07.02.2024.
//

import Foundation

final class OAuth2Service {
    
    private let urlSession = URLSession.shared
    
    private (set) var token: String? {
        get {
            return OAuth2TokenStorage().token
        }
        set {
            OAuth2TokenStorage().token = newValue
        }
    }
    
    func fetchOAuthToken(_ code: String, completion: @escaping (Result<String, Error>) -> Void) {
        let request = authTokenRequest(code: code)
        let task = authTokenResponseBody(for: request) { [weak self] result in
            guard let self = self else {
                return
            }
            switch result {
            case .success(let body):
                let token = body.access_token
                self.token = token
                completion(.success(token))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
}

private extension OAuth2Service {
    
    private func authTokenRequest(code: String) -> URLRequest {
        let path = "/oauth/token"
            + "?client_id=\(AccessKey)"
            + "&client_secret=\(SecretKey)"
            + "&redirect_uri=\(RedirectURI)"
            + "&code=\(code)"
            + "&grant_type=authorization_code"
        let url = URL(string: path, relativeTo: OAuth2BaseURL)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        return request
    }
    
    private func authTokenResponseBody(
        for request: URLRequest,
        completion: @escaping (Result<OAuthTokenResponseBody, Error>) -> Void) -> URLSessionTask
    {
        return urlSession.data(for: request) { (result: Result<Data, Error>) in
            let response = result.flatMap { data -> Result<OAuthTokenResponseBody, Error> in
                Result { try JSONDecoder().decode(OAuthTokenResponseBody.self, from: data) }
            }
            completion(response)
        }
    }
    
}

// MARK: - URLSession

private enum NetworkError: Error {
    case statusCode(Int)
    case requestError(Error)
}

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

