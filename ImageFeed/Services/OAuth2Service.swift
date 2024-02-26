//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by vs on 07.02.2024.
//

import Foundation

enum AuthServiceError: Error {
    case invalidRequest
}

final class OAuth2Service {
    
    private let urlSession = URLSession.shared
    
    private var currentTask: URLSessionTask?
    private var lastCode: String?
    
    func fetchOAuthToken(_ code: String, completion: @escaping (Result<String, Error>) -> Void) {
        if lastCode == code {
            return
        }
        currentTask?.cancel()
        lastCode = code
        
        let request = makeRequest(code)
        let task = urlSession.objectTask(with: request) { [weak self](result: Result<OAuthTokenResponseBody, Error>) in
            switch result {
            case .success(let response):
                completion(.success(response.access_token))
            case .failure(let error):
                Logger.logError(message: "\(error.localizedDescription)")
                completion(.failure(error))
                self?.lastCode = nil
            }
            self?.currentTask = nil
        }
        currentTask = task
        task.resume()
    }
    
    private func makeRequest(_ code: String) -> URLRequest {
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
    
}
