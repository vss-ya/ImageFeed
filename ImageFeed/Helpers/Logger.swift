//
//  Logger.swift
//  ImageFeed
//
//  Created by vs on 29.02.2024.
//

import Foundation

class Logger {
    
    static func logError(file: String = #file, function: String = #function, line: Int = #line, message: String = "", userInfo: [AnyHashable : Any] = [:]) {
        let file = (file as NSString).lastPathComponent
        let function = function
        let message = message
        let userInfo = userInfo
        print("Error! File: \(file), function: \(function), line: \(line), message: \(message), userInfo: \(userInfo)")
    }
    
}
