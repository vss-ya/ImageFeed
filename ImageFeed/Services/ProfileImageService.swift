//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by vs on 29.02.2024.
//

import Foundation

final class ProfileImageService {
    
    static let didChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    static let shared = ProfileImageService()
    
    private (set) var avatarURL: String?
    
    private let urlSession = URLSession.shared
    private let notificationCenter = NotificationCenter.default
    private let oauth2TokenStorage = OAuth2TokenStorage()
    
    private var currentTask: URLSessionTask?
    private var lastToken: String?
    
    private  init() { }
    
    func clean() {
        avatarURL = nil
        currentTask?.cancel()
    }
    
    func fetchProfileImageURL(_ username: String, completion: @escaping (Result<String, Error>) -> Void) {
        let token = oauth2TokenStorage.token ?? ""
        if lastToken == token {
            return
        }
        currentTask?.cancel()
        lastToken = token
        
        let request = makeRequest(token, username)
        let task = urlSession.objectTask(with: request) { (result: Result<UserResult, Error>) in
            switch result {
            case .success(let userResult):
                let avatarURL = userResult.profileImage.large.absoluteString
                self.avatarURL = avatarURL
                completion(.success(avatarURL))
                self.notificationCenter.post(name: ProfileImageService.didChangeNotification,
                                        object: self,
                                        userInfo: ["url": avatarURL])
            case .failure(let error):
                Logger.logError(message: "\(error.localizedDescription)")
                completion(.failure(error))
            }
        }
        currentTask = task
        task.resume()
    }
    
    private func makeRequest(_ token: String, _ username: String) -> URLRequest {
        let accessKey = ApiConstants.accessKey
        let url = URL(string: "\(ApiConstants.unsplashUsersURLString)/\(username)?client_id=\(accessKey)")!
        var request = URLRequest(url: url)
        request.setValue("Bearer \(OAuth2TokenStorage().token ?? "")", forHTTPHeaderField: "Authorization")
        return request
    }
    
}
