//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by vs on 15.03.2024.
//

import Foundation

public final class ImagesListService {
    
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    public static let shared = ImagesListService()
    
    private let urlSession = URLSession.shared
    private let notificationCenter = NotificationCenter.default
    private let oauth2TokenStorage = OAuth2TokenStorage()
    private let dateFormatter = ISO8601DateFormatter()
    
    private(set) var photos: [Photo] = []
    private var currentPage: Int = 1
    private var perPage: Int = 10
    private var currentTask: URLSessionTask?
    
    private init() { }
    
    func clean() {
        photos = []
        currentPage = 1
        currentTask?.cancel()
    }
    
    func fetchPhotosNextPage() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            guard 
                let self,
                currentTask == nil
            else {
                return
            }
            
            let request = makePageRequest(page: currentPage, perPage: perPage)
            let task = urlSession.objectTask(with: request) { (result: Result<[PhotoResult], Error>) in
                DispatchQueue.main.async {
                    self.currentTask = nil
                    switch result {
                    case .success(let photoResults):
                        let photos = photoResults.map {
                            return Photo(
                                id: $0.id,
                                size: CGSize(width: $0.width, height: $0.height),
                                createdAt: self.dateFormatter.date(from: $0.createdAt ?? ""),
                                welcomeDescription: $0.description,
                                thumbImageURL: $0.urls.thumb,
                                largeImageURL: $0.urls.regular,
                                fullImageURL: $0.urls.full,
                                isLiked: $0.likedByUser
                            )
                        }
                        self.photos.append(contentsOf: photos)
                        self.currentPage += 1
                    case .failure(let error):
                        Logger.logError(message: "\(error.localizedDescription)")
                    }
                    NotificationCenter.default.post(name: ImagesListService.didChangeNotification, object: nil)
                }
            }
            task.resume()
            self.currentTask = task
        }
    }
    
    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {
        let request = makeChangeLikeRequest(photoId: photoId)
        let task = urlSession.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(NetworkError.requestError(error)))
                return
            }
            let statusCode = (response as! HTTPURLResponse).statusCode
            if 200..<300 ~= statusCode {
                completion(.success(()))
            } else {
                completion(.failure(NetworkError.statusCode(statusCode)))
            }
        }
        task.resume()
    }
    
    private func makePageRequest(page: Int, perPage: Int) -> URLRequest {
        let token = oauth2TokenStorage.token ?? ""
        let url = URL(string: "\(ApiConstants.unsplashPhotosURLString)?page=\(page)&per_page=\(perPage)")!
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    private func makeChangeLikeRequest(photoId: String) -> URLRequest {
        let token = oauth2TokenStorage.token ?? ""
        let url = URL(string: "\(ApiConstants.unsplashPhotosURLString)/\(photoId)/like")!
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"
        return request
    }
    
}
