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
        + "?client_id=\(ApiConstants.accessKey)"
        + "&client_secret=\(ApiConstants.secretKey)"
        + "&redirect_uri=\(ApiConstants.redirectURI)"
            + "&code=\(code)"
            + "&grant_type=authorization_code"
        let url = URL(string: path, relativeTo: ApiConstants.oauth2BaseURL)!
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
