//
//  ApiService.swift
//  ImageDownloader
//
//  Created by EVGENY SYSENKA on 23/05/2025.
//

import SwiftUI

actor ApiService {
    enum ApiError: Error {
        case custom(message: String)
        case invalidResponse
        case invalidStatusCode(code: Int)
    }
    
    private let session: URLSession
    
    init() {
        self.session = URLSession(configuration: .default)
    }
    
    func perfomDataDownload(from urlString: String) async throws -> Data {
        guard let url = URL(string: urlString) else {
            throw ApiError.custom(message: "Invalid URL")
        }
        
        let result = try await session.data(from: url)
        
        guard let response = result.1 as? HTTPURLResponse, result.0.count > 0 else {
            throw ApiError.invalidResponse
        }
        
        guard (200...299).contains(response.statusCode) else {
            throw ApiError.invalidStatusCode(code: response.statusCode)
        }
        
        return result.0
    }
}

protocol DownloadImageProtocol: Actor {
    func downloadRandomImage(urlString: String) async throws -> UIImage
}

extension ApiService: DownloadImageProtocol {
    func downloadRandomImage(urlString: String) async throws -> UIImage {
        try await Task.sleep(for: .seconds(5.0))
        
        let data = try await perfomDataDownload(from: urlString)
        
        guard let uiImage = UIImage(data: data) else {
            throw ApiError.custom(message: "Error converting image from data.")
        }
        
        print("[DownloadImage]: Image Downloaded from the Network.")
        return uiImage
    }
}


