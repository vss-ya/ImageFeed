//
//  ProfileService.swift
//  ImageFeed
//
//  Created by vs on 26.02.2024.
//

import Foundation

final class ProfileService {
    
    static let shared = ProfileService()
    
    private(set) var profile: Profile?
    
    private let urlSession = URLSession.shared
    
    private var currentTask: URLSessionTask?
    private var lastToken: String?
    
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        if lastToken == token {
            return
        }
        currentTask?.cancel()
        lastToken = token
        
        let request = makeRequest(token)
        let task = urlSession.objectTask(with: request) {  (data: Result<ProfileResult, Error>) in
            switch data {
            case .success(let profileResult):
                let username = profileResult.username
                let name = "\(profileResult.first_name) \(profileResult.last_name ?? "")"
                let loginName = "@\(profileResult.username)"
                let bio = profileResult.bio ?? ""
                
                let profile = Profile(username: username,
                                      name: name,
                                      loginName: loginName, 
                                      bio: bio)
                self.profile = profile
                completion(.success(profile))
            case .failure(let error):
                Logger.logError(message: "\(error.localizedDescription)")
                completion(.failure(error))
            }
        }
        currentTask = task
        task.resume()
    }
    
    private func makeRequest(_ token: String) -> URLRequest {
        let url = URL(string: ApiConstants.unsplashMeURLString)!
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
    
}



