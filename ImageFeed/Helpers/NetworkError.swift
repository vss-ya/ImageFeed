//
//  NetworkError.swift
//  ImageFeed
//
//  Created by vs on 26.02.2024.
//

enum NetworkError: Error {
    case statusCode(Int)
    case requestError(Error)
}
